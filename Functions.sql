-- CALL FUNCTION
CREATE OR REPLACE FUNCTION get_password(p_username VARCHAR(50))
RETURNS VARCHAR(255)
LANGUAGE plpgsql
AS $$
DECLARE
    v_password_hash VARCHAR(255);
BEGIN
    SELECT password_hash INTO v_password_hash
    FROM users
    WHERE username = p_username;

    RETURN v_password_hash;
END;
$$;

-- UPDATE FUNCTION
CREATE OR REPLACE FUNCTION create_user_and_fill_energy(
    p_first_name VARCHAR(50),
    p_last_name VARCHAR(50),
    p_username VARCHAR(50),
    p_email VARCHAR(100),
    p_password_hash VARCHAR(255),
    p_preferred_language VARCHAR(50)
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_id INTEGER;
BEGIN
    INSERT INTO users (first_name, last_name, username, email, password_hash, preferred_language, xp, streak)
    VALUES (p_first_name, p_last_name, p_username, p_email, p_password_hash, p_preferred_language, 0, 0)
    ON CONFLICT (username) DO NOTHING
    RETURNING user_id INTO v_user_id;

    IF v_user_id IS NOT NULL THEN
        INSERT INTO user_energy (user_id, energy_remaining, last_recharged_at)
        VALUES (v_user_id, 5, CURRENT_TIMESTAMP)
        ON CONFLICT (user_id) DO NOTHING;
    END IF;

    RETURN v_user_id;
END;
$$;

-- CALL FUNCTION
CREATE OR REPLACE FUNCTION get_user_profile(p_username VARCHAR(50))
RETURNS TABLE (
    user_id INTEGER,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    username VARCHAR(50),
    email VARCHAR(100),
    preferred_language VARCHAR(50),
    xp INTEGER,
    streak INTEGER,
    created_at TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.user_id,
        u.first_name,
        u.last_name,
        u.username,
        u.email,
        u.preferred_language,
        u.xp,
        u.streak,
        u.created_at
    FROM users u
    WHERE u.username = p_username;
END;
$$;

-- UPDATE FUNCTION
CREATE OR REPLACE FUNCTION update_user_profile(
    p_username VARCHAR(50),
    p_first_name VARCHAR(50),
    p_last_name VARCHAR(50),
    p_email VARCHAR(100),
    p_password_hash VARCHAR(255),
    p_preferred_language VARCHAR(50)
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE users
    SET
        first_name = COALESCE(p_first_name, first_name),
        last_name = COALESCE(p_last_name, last_name),
        email = COALESCE(p_email, email),
        password_hash = COALESCE(p_password_hash, password_hash),
        preferred_language = COALESCE(p_preferred_language, preferred_language)
    WHERE username = p_username;
END;
$$;

-- UPDATE FUNCTION
CREATE OR REPLACE FUNCTION award_achievement(
    p_username VARCHAR(50),
    p_achievement_name VARCHAR(100)
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_id INTEGER;
    v_achievement_id INTEGER;
BEGIN
    SELECT user_id INTO v_user_id FROM users WHERE username = p_username;
    SELECT achievement_id INTO v_achievement_id FROM achievements WHERE name = p_achievement_name;

    IF v_user_id IS NOT NULL AND v_achievement_id IS NOT NULL THEN
        INSERT INTO user_achievements (user_id, achievement_id)
        VALUES (v_user_id, v_achievement_id)
        ON CONFLICT (user_id, achievement_id) DO NOTHING;
    END IF;
END;
$$;

-- CALL FUNCTION
CREATE OR REPLACE FUNCTION get_user_achievements(p_username VARCHAR(50))
RETURNS TABLE (
    username VARCHAR(50),
    achievement_name VARCHAR(100),
    description TEXT,
    achieved_at TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.username,
        a.name AS achievement_name,
        a.description,
        ua.achieved_at
    FROM user_achievements ua
    JOIN users u ON ua.user_id = u.user_id
    JOIN achievements a ON ua.achievement_id = a.achievement_id
    WHERE u.username = p_username
    ORDER BY ua.achieved_at DESC;
END;
$$;

-- CALL FUNCTION
CREATE OR REPLACE FUNCTION get_leaderboard()
RETURNS TABLE (
    username VARCHAR(50),
    xp INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.username,
        u.xp
    FROM users u
    ORDER BY u.xp DESC
    LIMIT 10;
END;
$$;

-- CALL FUNCTION
CREATE OR REPLACE FUNCTION get_user_xp(p_username VARCHAR(50))
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_xp INTEGER;
BEGIN
    SELECT xp INTO v_xp
    FROM users
    WHERE username = p_username;

    RETURN v_xp;
END;
$$;

-- UPDATE FUNCTION
CREATE OR REPLACE FUNCTION increase_streak(p_username VARCHAR(50))
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE users
    SET streak = streak + 1, xp = xp + 10 -- Example: 10 XP for a lesson, adjust as needed
    WHERE username = p_username;
END;
$$;

-- CALL FUNCTION
CREATE OR REPLACE FUNCTION get_user_completed_lessons(p_username VARCHAR(50))
RETURNS TABLE (
    username VARCHAR(50),
    course_title VARCHAR(100),
    lesson_name VARCHAR(100),
    xp_earned INTEGER,
    completed_at TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.username,
        c.title AS course_title,
        l.name AS lesson_name,
        up.xp_earned,
        up.completed_at
    FROM user_progress up
    JOIN users u ON up.user_id = u.user_id
    JOIN lessons l ON up.lesson_id = l.lesson_id
    JOIN courses c ON l.course_id = c.course_id
    WHERE u.username = p_username
    ORDER BY up.completed_at DESC;
END;
$$;

-- CALL FUNCTION
CREATE OR REPLACE FUNCTION get_user_completed_courses(p_username VARCHAR(50), p_course_title VARCHAR(100))
RETURNS TABLE (
    username VARCHAR(50),
    course_title VARCHAR(100),
    total_lessons_in_course BIGINT,
    lessons_completed_in_course BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.username,
        c.title AS course_title,
        (
            SELECT COUNT(l.lesson_id)
            FROM lessons l
            WHERE l.course_id = c.course_id
        ) AS total_lessons_in_course,
        (
            SELECT COUNT(up.lesson_id)
            FROM user_progress up
            WHERE up.user_id = u.user_id
            AND up.lesson_id IN (SELECT lesson_id FROM lessons WHERE course_id = c.course_id)
        ) AS lessons_completed_in_course
    FROM users u, courses c
    WHERE u.username = p_username AND c.title = p_course_title;
END;
$$;

-- UPDATE FUNCTION
CREATE OR REPLACE FUNCTION enroll_user_in_course_by_title(
    p_username VARCHAR(50),
    p_course_title VARCHAR(100)
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_id INTEGER;
    v_course_id INTEGER;
    v_user_course_id INTEGER;
BEGIN
    SELECT user_id INTO v_user_id FROM users WHERE username = p_username;
    SELECT course_id INTO v_course_id FROM courses WHERE title = p_course_title;

    IF v_user_id IS NOT NULL AND v_course_id IS NOT NULL THEN
        INSERT INTO user_courses (user_id, course_id, enrollment_status)
        VALUES (v_user_id, v_course_id, 'enrolled')
        ON CONFLICT (user_id, course_id) DO UPDATE SET enrollment_status = 'enrolled', last_accessed_at = CURRENT_TIMESTAMP
        RETURNING user_course_id INTO v_user_course_id;
    END IF;
    RETURN v_user_course_id;
END;
$$;

-- UPDATE FUNCTION (overloaded, but better to differentiate or combine)
CREATE OR REPLACE FUNCTION enroll_user_in_course_by_id(
    p_user_id INTEGER,
    p_course_id INTEGER,
    p_enrollment_status VARCHAR(50)
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_course_id INTEGER;
BEGIN
    INSERT INTO user_courses (user_id, course_id, enrollment_status)
    VALUES (p_user_id, p_course_id, p_enrollment_status)
    ON CONFLICT (user_id, course_id) DO UPDATE SET enrollment_status = p_enrollment_status, last_accessed_at = CURRENT_TIMESTAMP
    RETURNING user_course_id INTO v_user_course_id;
    RETURN v_user_course_id;
END;
$$;

-- UPDATE FUNCTION
CREATE OR REPLACE FUNCTION add_course(
    p_language_name VARCHAR(50),
    p_title VARCHAR(100),
    p_description TEXT
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_language_id INTEGER;
    v_course_id INTEGER;
BEGIN
    SELECT language_id INTO v_language_id FROM languages WHERE name = p_language_name;

    IF v_language_id IS NOT NULL THEN
        INSERT INTO courses (language_id, title, description)
        VALUES (v_language_id, p_title, p_description)
        ON CONFLICT (title) DO NOTHING
        RETURNING course_id INTO v_course_id;
    END IF;
    RETURN v_course_id;
END;
$$;


-- CALL FUNCTION
CREATE OR REPLACE FUNCTION get_course_list()
RETURNS TABLE (
    course_id INTEGER,
    title VARCHAR(100),
    description TEXT,
    language_name VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.course_id,
        c.title,
        c.description,
        l.name AS language_name
    FROM courses c
    JOIN languages l ON c.language_id = l.language_id;
END;
$$;

-- UPDATE FUNCTION
CREATE OR REPLACE FUNCTION drop_user_course(
    p_user_id INTEGER,
    p_course_id INTEGER
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE user_courses
    SET enrollment_status = 'dropped'
    WHERE user_id = p_user_id
    AND course_id = p_course_id;
END;
$$;

-- UPDATE FUNCTION (Overloaded - differentiating by function name)
CREATE OR REPLACE FUNCTION add_lesson_to_course_by_id(
    p_course_id INTEGER,
    p_name VARCHAR(100),
    p_order_in_course INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_lesson_id INTEGER;
BEGIN
    INSERT INTO lessons (course_id, name, order_in_course)
    VALUES (p_course_id, p_name, p_order_in_course)
    ON CONFLICT (course_id, name) DO NOTHING
    RETURNING lesson_id INTO v_lesson_id;
    RETURN v_lesson_id;
END;
$$;

-- UPDATE FUNCTION (Overloaded - creating a new function for course title)
CREATE OR REPLACE FUNCTION add_lesson_to_course_by_title(
    p_course_title VARCHAR(100),
    p_name VARCHAR(100),
    p_order_in_course INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_course_id INTEGER;
    v_lesson_id INTEGER;
BEGIN
    SELECT course_id INTO v_course_id FROM courses WHERE title = p_course_title;

    IF v_course_id IS NOT NULL THEN
        INSERT INTO lessons (course_id, name, order_in_course)
        VALUES (v_course_id, p_name, p_order_in_course)
        ON CONFLICT (course_id, name) DO NOTHING
        RETURNING lesson_id INTO v_lesson_id;
    END IF;
    RETURN v_lesson_id;
END;
$$;

-- CALL FUNCTION
CREATE OR REPLACE FUNCTION get_lessons_list(p_course_id INTEGER)
RETURNS TABLE (
    lesson_id INTEGER,
    lesson_name VARCHAR(100),
    order_in_course INTEGER,
    course_title VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        l.lesson_id,
        l.name AS lesson_name,
        l.order_in_course,
        c.title AS course_title
    FROM lessons l
    JOIN courses c ON l.course_id = c.course_id
    WHERE l.course_id = p_course_id
    ORDER BY l.order_in_course;
END;
$$;

-- CALL FUNCTION
CREATE OR REPLACE FUNCTION get_exercises(p_lesson_id INTEGER)
RETURNS TABLE (
    exercise_id INTEGER,
    question TEXT,
    correct_answer TEXT,
    exercise_type VARCHAR(50),
    lesson_name VARCHAR(100),
    order_in_lesson INTEGER -- Include in return table
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.exercise_id,
        e.question,
        e.correct_answer,
        e.exercise_type,
        le.name AS lesson_name,
        e.order_in_lesson
    FROM exercises e
    JOIN lessons le ON e.lesson_id = le.lesson_id
    WHERE e.lesson_id = p_lesson_id
    ORDER BY e.order_in_lesson;
END;
$$;

-- UPDATE FUNCTION
CREATE OR REPLACE FUNCTION deduct_energy(p_user_id INTEGER)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE user_energy
    SET energy_remaining = energy_remaining - 1
    WHERE user_id = p_user_id AND energy_remaining > 0;
END;
$$;

-- CALL FUNCTION
CREATE OR REPLACE FUNCTION get_current_energy(p_user_id INTEGER)
RETURNS TABLE (
    username VARCHAR(50),
    energy_remaining INTEGER,
    last_recharged_at TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.username,
        ue.energy_remaining,
        ue.last_recharged_at
    FROM user_energy ue
    JOIN users u ON ue.user_id = u.user_id
    WHERE u.user_id = p_user_id;
END;
$$;

-- UPDATE FUNCTION
CREATE OR REPLACE FUNCTION add_shop_item(
    p_item_name VARCHAR(100),
    p_cost INTEGER,
    p_description TEXT
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_item_id INTEGER;
BEGIN
    INSERT INTO shop_items (name, cost, description)
    VALUES (p_item_name, p_cost, p_description)
    ON CONFLICT (name) DO NOTHING
    RETURNING item_id INTO v_item_id;
    RETURN v_item_id;
END;
$$;

-- CALL FUNCTION (Assuming this is to get a list of items purchased by a user)
CREATE OR REPLACE FUNCTION get_user_purchase_items(p_user_id INTEGER)
RETURNS TABLE (
    username VARCHAR(50),
    item_name VARCHAR(100),
    cost INTEGER,
    purchased_at TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.username,
        si.name AS item_name,
        si.cost,
        up.purchased_at
    FROM user_purchases up
    JOIN users u ON up.user_id = u.user_id
    JOIN shop_items si ON up.item_id = si.item_id
    WHERE u.user_id = p_user_id
    ORDER BY up.purchased_at DESC;
END;
$$;

-- UPDATE FUNCTION
CREATE OR REPLACE FUNCTION add_exercise(
    p_lesson_id INTEGER,
    p_question TEXT,
    p_correct_answer TEXT,
    p_exercise_type VARCHAR(50),
    p_order_in_lesson INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_exercise_id INTEGER;
BEGIN
    INSERT INTO exercises (lesson_id, question, correct_answer, exercise_type, order_in_lesson)
    VALUES (p_lesson_id, p_question, p_correct_answer, p_exercise_type, p_order_in_lesson)
    ON CONFLICT (lesson_id, order_in_lesson) DO NOTHING
    RETURNING exercise_id INTO v_exercise_id;
    RETURN v_exercise_id;
END;
$$;