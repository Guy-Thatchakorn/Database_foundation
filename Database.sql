-- USERS
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
CREATE TABLE languages (
    language_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- COURSES
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    language_id INTEGER REFERENCES languages(language_id),
    title VARCHAR(100) NOT NULL,
    description TEXT
);

-- LESSONS
CREATE TABLE lessons (
    lesson_id SERIAL PRIMARY KEY,
    course_id INTEGER REFERENCES courses(course_id),
    name VARCHAR(100) NOT NULL,
    order_in_course INTEGER NOT NULL
);

-- EXERCISES
CREATE TABLE exercises (
    exercise_id SERIAL PRIMARY KEY,
    lesson_id INTEGER REFERENCES lessons(lesson_id),
    question TEXT NOT NULL,
    correct_answer TEXT NOT NULL,
    exercise_type VARCHAR(50) CHECK (exercise_type IN ('multiple-choice', 'translation', 'matching', 'listening', 'speaking'))
);

-- USER PROGRESS
CREATE TABLE user_progress (
    progress_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    lesson_id INTEGER REFERENCES lessons(lesson_id),
    xp_earned INTEGER DEFAULT 0,
    completed_at TIMESTAMP
);

-- ACHIEVEMENTS
CREATE TABLE achievements (
    achievement_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- USER ACHIEVEMENTS
CREATE TABLE user_achievements (
    user_id INTEGER REFERENCES users(user_id),
    achievement_id INTEGER REFERENCES achievements(achievement_id),
    achieved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, achievement_id)
);

-- SHOP ITEMS
CREATE TABLE shop_items (
    item_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cost INTEGER NOT NULL,
    description TEXT
);

-- USER PURCHASES
CREATE TABLE user_purchases (
    purchase_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    item_id INTEGER REFERENCES shop_items(item_id),
    purchased_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
