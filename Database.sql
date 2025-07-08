-- USERS
-- username and email are already UNIQUE, which is good.
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    preferred_language VARCHAR(50),
    xp INTEGER DEFAULT 0,
    streak INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- LANGUAGES
-- Adding a UNIQUE constraint on 'name' is essential for 'ON CONFLICT (name)'.
CREATE TABLE languages (
    language_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL -- Added UNIQUE constraint
);

-- COURSES
-- Adding a UNIQUE constraint on 'title' to ensure course titles are unique.
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    language_id INTEGER REFERENCES languages(language_id),
    title VARCHAR(100) UNIQUE NOT NULL, -- Added UNIQUE constraint
    description TEXT
);

-- LESSONS
-- Adding a composite UNIQUE constraint on (course_id, order_in_course)
-- to ensure each lesson has a unique order within a given course,
-- and (course_id, name) to ensure lesson names are unique within a course.
CREATE TABLE lessons (
    lesson_id SERIAL PRIMARY KEY,
    course_id INTEGER REFERENCES courses(course_id),
    name VARCHAR(100) NOT NULL,
    order_in_course INTEGER NOT NULL,
    UNIQUE (course_id, order_in_course), -- Added composite UNIQUE constraint
    UNIQUE (course_id, name) -- Added composite UNIQUE constraint
);

-- EXERCISES
-- No common need for a UNIQUE constraint here across all columns.
-- Each exercise should be unique based on its exercise_id.
CREATE TABLE exercises (
    exercise_id SERIAL PRIMARY KEY,
    lesson_id INTEGER REFERENCES lessons(lesson_id),
    question TEXT NOT NULL,
    correct_answer TEXT NOT NULL,
    exercise_type VARCHAR(50) CHECK (exercise_type IN ('multiple-choice', 'translation', 'matching', 'listening', 'speaking'))
);

-- USER PROGRESS
-- The combination of user_id and lesson_id should be unique,
-- meaning a user can only complete a specific lesson once.
CREATE TABLE user_progress (
    progress_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    lesson_id INTEGER REFERENCES lessons(lesson_id),
    xp_earned INTEGER DEFAULT 0,
    completed_at TIMESTAMP,
    UNIQUE (user_id, lesson_id) -- Added composite UNIQUE constraint
);

-- ACHIEVEMENTS
-- Achievement names should be unique.
CREATE TABLE achievements (
    achievement_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- Added UNIQUE constraint
    description TEXT
);

-- USER ACHIEVEMENTS
-- This table already has a PRIMARY KEY (user_id, achievement_id) which
-- implicitly creates a UNIQUE constraint on this combination, so no change needed.
CREATE TABLE user_achievements (
    user_id INTEGER REFERENCES users(user_id),
    achievement_id INTEGER REFERENCES achievements(achievement_id),
    achieved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, achievement_id)
);

-- SHOP ITEMS
-- Shop item names should be unique.
CREATE TABLE shop_items (
    item_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- Added UNIQUE constraint
    cost INTEGER NOT NULL,
    description TEXT
);

-- USER PURCHASES
-- While a user can purchase the same item multiple times,
-- if you wanted to prevent a user from purchasing a *specific* item more than once,
-- you would add a UNIQUE constraint on (user_id, item_id).
-- For a shop where multiple purchases are allowed, no unique constraint beyond the PK is needed here.
CREATE TABLE user_purchases (
    purchase_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    item_id INTEGER REFERENCES shop_items(item_id),
    purchased_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    -- UNIQUE (user_id, item_id) -- Uncomment if a user can only purchase an item once
);