-- This script assumes your tables have been created with the updated schema.

-- 🌐 LANGUAGES
INSERT INTO languages (name) VALUES
('English'),
('Spanish'),
('French'),
('German'),
('Japanese'),
('Thai')
ON CONFLICT (name) DO NOTHING;

-- 👤 USERS
INSERT INTO users (first_name, last_name, username, email, password_hash, preferred_language, xp, streak) VALUES
('Alice', 'Smith', 'alice', 'alice@example.com', 'hash1', 'Spanish', 300, 5),
('Bob', 'Johnson', 'bob', 'bob@example.com', 'hash2', 'French', 120, 2),
('Carla', 'Davis', 'carla', 'carla@example.com', 'hash3', 'German', 500, 10),
('Danny', 'White', 'danny', 'danny@example.com', 'hash4', 'Thai', 250, 3),
('Emma', 'Brown', 'emma', 'emma@example.com', 'hash5', 'Japanese', 0, 0),
('Felix', 'Green', 'felix', 'felix@example.com', 'hash6', 'Spanish', 75, 1),
('George', 'Black', 'george', 'george@example.com', 'hash7', 'English', 610, 12),
('Hannah', 'King', 'hannah', 'hannah@example.com', 'hash8', 'German', 200, 4),
('Irene', 'Lee', 'irene', 'irene@example.com', 'hash9', 'French', 320, 5),
('Jack', 'Chen', 'jack', 'jack@example.com', 'hash10', 'Thai', 420, 6)
ON CONFLICT (username) DO NOTHING;

-- 📚 COURSES
INSERT INTO courses (language_id, title, description) VALUES
((SELECT language_id FROM languages WHERE name = 'Spanish'), 'Spanish Basics', 'Learn greetings, food, and travel in Spanish.'),
((SELECT language_id FROM languages WHERE name = 'French'), 'French Basics', 'Essential phrases and grammar in French.'),
((SELECT language_id FROM languages WHERE name = 'German'), 'German Basics', 'Kickstart your German journey.'),
((SELECT language_id FROM languages WHERE name = 'Japanese'), 'Japanese Hiragana', 'Master Hiragana characters and simple words.'),
((SELECT language_id FROM languages WHERE name = 'Thai'), 'Thai for Beginners', 'Start speaking Thai with core vocabulary.')
ON CONFLICT (title) DO NOTHING;

-- 📘 LESSONS
INSERT INTO lessons (course_id, name, order_in_course) VALUES
((SELECT course_id FROM courses WHERE title = 'Spanish Basics'), 'Greetings', 1),
((SELECT course_id FROM courses WHERE title = 'Spanish Basics'), 'Food', 2),
((SELECT course_id FROM courses WHERE title = 'Spanish Basics'), 'Travel', 3),
((SELECT course_id FROM courses WHERE title = 'French Basics'), 'Basics 1', 1),
((SELECT course_id FROM courses WHERE title = 'French Basics'), 'Basics 2', 2),
((SELECT course_id FROM courses WHERE title = 'German Basics'), 'Intro A', 1),
((SELECT course_id FROM courses WHERE title = 'Japanese Hiragana'), 'Hiragana A', 1),
((SELECT course_id FROM courses WHERE title = 'Japanese Hiragana'), 'Hiragana B', 2),
((SELECT course_id FROM courses WHERE title = 'Thai for Beginners'), 'Common Phrases', 1),
((SELECT course_id FROM courses WHERE title = 'Thai for Beginners'), 'Numbers', 2)
ON CONFLICT (course_id, name) DO NOTHING;

-- ✍️ EXERCISES (UPDATED to include order_in_lesson)
INSERT INTO exercises (lesson_id, question, correct_answer, exercise_type, order_in_lesson) VALUES
((SELECT lesson_id FROM lessons WHERE name = 'Greetings' AND course_id = (SELECT course_id FROM courses WHERE title = 'Spanish Basics')), 'Translate "Hello"', 'Hola', 'translation', 1),
((SELECT lesson_id FROM lessons WHERE name = 'Greetings' AND course_id = (SELECT course_id FROM courses WHERE title = 'Spanish Basics')), 'Translate "Goodbye"', 'Adiós', 'translation', 2),
((SELECT lesson_id FROM lessons WHERE name = 'Food' AND course_id = (SELECT course_id FROM courses WHERE title = 'Spanish Basics')), 'Match "apple" with...', 'manzana', 'matching', 1),
((SELECT lesson_id FROM lessons WHERE name = 'Food' AND course_id = (SELECT course_id FROM courses WHERE title = 'Spanish Basics')), 'Translate "I eat rice"', 'Yo como arroz', 'translation', 2),
((SELECT lesson_id FROM lessons WHERE name = 'Travel' AND course_id = (SELECT course_id FROM courses WHERE title = 'Spanish Basics')), 'Translate "I want to travel"', 'Quiero viajar', 'translation', 1),
((SELECT lesson_id FROM lessons WHERE name = 'Basics 1' AND course_id = (SELECT course_id FROM courses WHERE title = 'French Basics')), 'Choose correct translation: "Bonjour"', 'Hello', 'multiple-choice', 1),
((SELECT lesson_id FROM lessons WHERE name = 'Basics 2' AND course_id = (SELECT course_id FROM courses WHERE title = 'French Basics')), 'Listen and type: "Merci"', 'Merci', 'listening', 1),
((SELECT lesson_id FROM lessons WHERE name = 'Intro A' AND course_id = (SELECT course_id FROM courses WHERE title = 'German Basics')), 'Translate "Ich bin müde"', 'I am tired', 'translation', 1),
((SELECT lesson_id FROM lessons WHERE name = 'Hiragana A' AND course_id = (SELECT course_id FROM courses WHERE title = 'Japanese Hiragana')), 'What is "あ"', 'a', 'multiple-choice', 1),
((SELECT lesson_id FROM lessons WHERE name = 'Hiragana B' AND course_id = (SELECT course_id FROM courses WHERE title = 'Japanese Hiragana')), 'Match: お → o', 'o', 'matching', 1),
((SELECT lesson_id FROM lessons WHERE name = 'Common Phrases' AND course_id = (SELECT course_id FROM courses WHERE title = 'Thai for Beginners')), 'Translate "Hello"', 'สวัสดี', 'translation', 1),
((SELECT lesson_id FROM lessons WHERE name = 'Numbers' AND course_id = (SELECT course_id FROM courses WHERE title = 'Thai for Beginners')), 'Translate "Three"', 'สาม', 'translation', 1)
ON CONFLICT (lesson_id, order_in_lesson) DO NOTHING; -- Added ON CONFLICT for safety and uniqueness

-- 📚 USER COURSES
-- Enroll users in some initial courses
INSERT INTO user_courses (user_id, course_id, enrollment_status) VALUES
((SELECT user_id FROM users WHERE username = 'alice'), (SELECT course_id FROM courses WHERE title = 'Spanish Basics'), 'enrolled'),
((SELECT user_id FROM users WHERE username = 'bob'), (SELECT course_id FROM courses WHERE title = 'French Basics'), 'enrolled'),
((SELECT user_id FROM users WHERE username = 'carla'), (SELECT course_id FROM courses WHERE title = 'German Basics'), 'enrolled'),
((SELECT user_id FROM users WHERE username = 'danny'), (SELECT course_id FROM courses WHERE title = 'Thai for Beginners'), 'enrolled'),
((SELECT user_id FROM users WHERE username = 'emma'), (SELECT course_id FROM courses WHERE title = 'Japanese Hiragana'), 'enrolled'),
((SELECT user_id FROM users WHERE username = 'felix'), (SELECT course_id FROM courses WHERE title = 'Spanish Basics'), 'enrolled'),
((SELECT user_id FROM users WHERE username = 'george'), (SELECT course_id FROM courses WHERE title = 'French Basics'), 'enrolled'),
((SELECT user_id FROM users WHERE username = 'hannah'), (SELECT course_id FROM courses WHERE title = 'German Basics'), 'enrolled'),
((SELECT user_id FROM users WHERE username = 'irene'), (SELECT course_id FROM courses WHERE title = 'French Basics'), 'enrolled'),
((SELECT user_id FROM users WHERE username = 'jack'), (SELECT course_id FROM courses WHERE title = 'Thai for Beginners'), 'enrolled')
ON CONFLICT (user_id, course_id) DO NOTHING;

-- 📈 USER PROGRESS
INSERT INTO user_progress (user_id, lesson_id, xp_earned, completed_at) VALUES
((SELECT user_id FROM users WHERE username = 'alice'), (SELECT lesson_id FROM lessons WHERE name = 'Greetings' AND course_id = (SELECT course_id FROM courses WHERE title = 'Spanish Basics')), 20, CURRENT_DATE - INTERVAL '1 day'),
((SELECT user_id FROM users WHERE username = 'alice'), (SELECT lesson_id FROM lessons WHERE name = 'Food' AND course_id = (SELECT course_id FROM courses WHERE title = 'Spanish Basics')), 30, CURRENT_DATE - INTERVAL '1 day'),
((SELECT user_id FROM users WHERE username = 'bob'), (SELECT lesson_id FROM lessons WHERE name = 'Basics 1' AND course_id = (SELECT course_id FROM courses WHERE title = 'French Basics')), 50, CURRENT_DATE - INTERVAL '2 days'),
((SELECT user_id FROM users WHERE username = 'carla'), (SELECT lesson_id FROM lessons WHERE name = 'Intro A' AND course_id = (SELECT course_id FROM courses WHERE title = 'German Basics')), 40, CURRENT_DATE - INTERVAL '3 days'),
((SELECT user_id FROM users WHERE username = 'danny'), (SELECT lesson_id FROM lessons WHERE name = 'Travel' AND course_id = (SELECT course_id FROM courses WHERE title = 'Spanish Basics')), 20, CURRENT_DATE - INTERVAL '1 day'), -- Danny also did a Spanish lesson
((SELECT user_id FROM users WHERE username = 'emma'), (SELECT lesson_id FROM lessons WHERE name = 'Hiragana A' AND course_id = (SELECT course_id FROM courses WHERE title = 'Japanese Hiragana')), 15, CURRENT_DATE - INTERVAL '2 days'),
((SELECT user_id FROM users WHERE username = 'felix'), (SELECT lesson_id FROM lessons WHERE name = 'Hiragana B' AND course_id = (SELECT course_id FROM courses WHERE title = 'Japanese Hiragana')), 10, CURRENT_DATE - INTERVAL '1 day'), -- Felix did a Japanese lesson
((SELECT user_id FROM users WHERE username = 'george'), (SELECT lesson_id FROM lessons WHERE name = 'Basics 2' AND course_id = (SELECT course_id FROM courses WHERE title = 'French Basics')), 35, CURRENT_DATE - INTERVAL '4 days'),
((SELECT user_id FROM users WHERE username = 'hannah'), (SELECT lesson_id FROM lessons WHERE name = 'Common Phrases' AND course_id = (SELECT course_id FROM courses WHERE title = 'Thai for Beginners')), 25, CURRENT_DATE - INTERVAL '1 day'),
((SELECT user_id FROM users WHERE username = 'irene'), (SELECT lesson_id FROM lessons WHERE name = 'Numbers' AND course_id = (SELECT course_id FROM courses WHERE title = 'Thai for Beginners')), 30, CURRENT_DATE - INTERVAL '2 days')
ON CONFLICT (user_id, lesson_id) DO NOTHING;
-- 🏆 ACHIEVEMENTS
INSERT INTO achievements (name, description) VALUES
('First Lesson', 'Completed your first lesson!'),
('10 XP Club', 'Earned 10 XP in a single day.'),
('3-Day Streak', 'Practiced for 3 days in a row.'),
('Fluent Start', 'Completed your first course.'),
('Shopper', 'Made your first shop purchase.')
ON CONFLICT (name) DO NOTHING;

-- 🏅 USER ACHIEVEMENTS
INSERT INTO user_achievements (user_id, achievement_id) VALUES
((SELECT user_id FROM users WHERE username = 'alice'), (SELECT achievement_id FROM achievements WHERE name = 'First Lesson')),
((SELECT user_id FROM users WHERE username = 'alice'), (SELECT achievement_id FROM achievements WHERE name = '10 XP Club')),
((SELECT user_id FROM users WHERE username = 'bob'), (SELECT achievement_id FROM achievements WHERE name = 'First Lesson')),
((SELECT user_id FROM users WHERE username = 'carla'), (SELECT achievement_id FROM achievements WHERE name = 'First Lesson')),
((SELECT user_id FROM users WHERE username = 'carla'), (SELECT achievement_id FROM achievements WHERE name = '3-Day Streak')),
((SELECT user_id FROM users WHERE username = 'danny'), (SELECT achievement_id FROM achievements WHERE name = 'Shopper')),
((SELECT user_id FROM users WHERE username = 'emma'), (SELECT achievement_id FROM achievements WHERE name = '10 XP Club')),
((SELECT user_id FROM users WHERE username = 'felix'), (SELECT achievement_id FROM achievements WHERE name = 'First Lesson')),
((SELECT user_id FROM users WHERE username = 'george'), (SELECT achievement_id FROM achievements WHERE name = 'First Lesson')),
((SELECT user_id FROM users WHERE username = 'hannah'), (SELECT achievement_id FROM achievements WHERE name = 'Fluent Start'))
ON CONFLICT (user_id, achievement_id) DO NOTHING;

-- 🛍️ SHOP ITEMS
INSERT INTO shop_items (name, cost, description) VALUES
('Streak Freeze', 100, 'Prevents your streak from breaking.'),
('Double XP', 50, 'Earn double XP for 30 minutes.'),
('Heart Refill', 30, 'Refill all your hearts.'),
('Bonus Skill: Idioms', 200, 'Unlock fun idioms lesson.'),
('Theme: Dark Mode', 150, 'Dark mode for your UI.')
ON CONFLICT (name) DO NOTHING;

-- 💸 USER PURCHASES
INSERT INTO user_purchases (user_id, item_id) VALUES
((SELECT user_id FROM users WHERE username = 'alice'), (SELECT item_id FROM shop_items WHERE name = 'Streak Freeze')),
((SELECT user_id FROM users WHERE username = 'alice'), (SELECT item_id FROM shop_items WHERE name = 'Double XP')),
((SELECT user_id FROM users WHERE username = 'bob'), (SELECT item_id FROM shop_items WHERE name = 'Heart Refill')),
((SELECT user_id FROM users WHERE username = 'carla'), (SELECT item_id FROM shop_items WHERE name = 'Streak Freeze')),
((SELECT user_id FROM users WHERE username = 'danny'), (SELECT item_id FROM shop_items WHERE name = 'Bonus Skill: Idioms')),
((SELECT user_id FROM users WHERE username = 'emma'), (SELECT item_id FROM shop_items WHERE name = 'Double XP')),
((SELECT user_id FROM users WHERE username = 'felix'), (SELECT item_id FROM shop_items WHERE name = 'Theme: Dark Mode')),
((SELECT user_id FROM users WHERE username = 'george'), (SELECT item_id FROM shop_items WHERE name = 'Streak Freeze')),
((SELECT user_id FROM users WHERE username = 'hannah'), (SELECT item_id FROM shop_items WHERE name = 'Double XP')),
((SELECT user_id FROM users WHERE username = 'irene'), (SELECT item_id FROM shop_items WHERE name = 'Heart Refill'))
ON CONFLICT DO NOTHING; -- No specific ON CONFLICT for multiple item purchases if allowed. Keep commented out if not unique.

-- 🔥 USER ENERGY
-- Initialize energy for all users
INSERT INTO user_energy (user_id, energy_remaining, last_recharged_at) VALUES
((SELECT user_id FROM users WHERE username = 'alice'), 3, CURRENT_TIMESTAMP - INTERVAL '2 hours'),
((SELECT user_id FROM users WHERE username = 'bob'), 5, CURRENT_TIMESTAMP - INTERVAL '10 minutes'),
((SELECT user_id FROM users WHERE username = 'carla'), 0, CURRENT_TIMESTAMP - INTERVAL '5 hours'),
((SELECT user_id FROM users WHERE username = 'danny'), 2, CURRENT_TIMESTAMP - INTERVAL '1 hour'),
((SELECT user_id FROM users WHERE username = 'emma'), 4, CURRENT_TIMESTAMP - INTERVAL '20 minutes'),
((SELECT user_id FROM users WHERE username = 'felix'), 5, CURRENT_TIMESTAMP - INTERVAL '15 minutes'),
((SELECT user_id FROM users WHERE username = 'george'), 1, CURRENT_TIMESTAMP - INTERVAL '3 hours'),
((SELECT user_id FROM users WHERE username = 'hannah'), 2, CURRENT_TIMESTAMP - INTERVAL '90 minutes'),
((SELECT user_id FROM users WHERE username = 'irene'), 5, CURRENT_TIMESTAMP - INTERVAL '5 minutes'),
((SELECT user_id FROM users WHERE username = 'jack'), 0, CURRENT_TIMESTAMP - INTERVAL '6 hours')
ON CONFLICT (user_id) DO NOTHING;