-- 🌐 LANGUAGES
INSERT INTO languages (name) VALUES
('English'),
('Spanish'),
('French'),
('German'),
('Japanese'),
('Thai');

-- 👤 USERS
INSERT INTO users (username, email, password_hash, preferred_language, xp, streak) VALUES
('alice', 'alice@example.com', 'hash1', 'Spanish', 300, 5),
('bob', 'bob@example.com', 'hash2', 'French', 120, 2),
('carla', 'carla@example.com', 'hash3', 'German', 500, 10),
('danny', 'danny@example.com', 'hash4', 'Thai', 250, 3),
('emma', 'emma@example.com', 'hash5', 'Japanese', 0, 0),
('felix', 'felix@example.com', 'hash6', 'Spanish', 75, 1),
('george', 'george@example.com', 'hash7', 'English', 610, 12),
('hannah', 'hannah@example.com', 'hash8', 'German', 200, 4),
('irene', 'irene@example.com', 'hash9', 'French', 320, 5),
('jack', 'jack@example.com', 'hash10', 'Thai', 420, 6);

-- 📚 COURSES
INSERT INTO courses (language_id, title, description) VALUES
(2, 'Spanish Basics', 'Learn greetings, food, and travel in Spanish.'),
(3, 'French Basics', 'Essential phrases and grammar in French.'),
(4, 'German Basics', 'Kickstart your German journey.'),
(5, 'Japanese Hiragana', 'Master Hiragana characters and simple words.'),
(6, 'Thai for Beginners', 'Start speaking Thai with core vocabulary.');

-- 📘 LESSONS
INSERT INTO lessons (course_id, name, order_in_course) VALUES
(1, 'Greetings', 1),
(1, 'Food', 2),
(1, 'Travel', 3),
(2, 'Basics 1', 1),
(2, 'Basics 2', 2),
(3, 'Intro A', 1),
(4, 'Hiragana A', 1),
(4, 'Hiragana B', 2),
(5, 'Common Phrases', 1),
(5, 'Numbers', 2);

-- ✍️ EXERCISES
INSERT INTO exercises (lesson_id, question, correct_answer, exercise_type) VALUES
(1, 'Translate "Hello"', 'Hola', 'translation'),
(1, 'Translate "Goodbye"', 'Adiós', 'translation'),
(2, 'Match "apple" with...', 'manzana', 'matching'),
(2, 'Translate "I eat rice"', 'Yo como arroz', 'translation'),
(3, 'Translate "I want to travel"', 'Quiero viajar', 'translation'),
(4, 'Choose correct translation: "Bonjour"', 'Hello', 'multiple-choice'),
(5, 'Listen and type: "Merci"', 'Merci', 'listening'),
(6, 'Translate "Ich bin müde"', 'I am tired', 'translation'),
(7, 'What is "あ"', 'a', 'multiple-choice'),
(8, 'Match: お → o', 'o', 'matching'),
(9, 'Translate "Hello"', 'สวัสดี', 'translation'),
(10, 'Translate "Three"', 'สาม', 'translation');

-- 📈 USER PROGRESS
INSERT INTO user_progress (user_id, lesson_id, xp_earned, completed_at) VALUES
(1, 1, 20, CURRENT_DATE - INTERVAL '1 day'),
(1, 2, 30, CURRENT_DATE - INTERVAL '1 day'),
(2, 4, 50, CURRENT_DATE - INTERVAL '2 days'),
(3, 6, 40, CURRENT_DATE - INTERVAL '3 days'),
(4, 3, 20, CURRENT_DATE - INTERVAL '1 day'),
(5, 7, 15, CURRENT_DATE - INTERVAL '2 days'),
(6, 8, 10, CURRENT_DATE - INTERVAL '1 day'),
(7, 5, 35, CURRENT_DATE - INTERVAL '4 days'),
(8, 9, 25, CURRENT_DATE - INTERVAL '1 day'),
(9, 10, 30, CURRENT_DATE - INTERVAL '2 days');

-- 🏆 ACHIEVEMENTS
INSERT INTO achievements (name, description) VALUES
('First Lesson', 'Completed your first lesson!'),
('10 XP Club', 'Earned 10 XP in a single day.'),
('3-Day Streak', 'Practiced for 3 days in a row.'),
('Fluent Start', 'Completed your first course.'),
('Shopper', 'Made your first shop purchase.');

-- 🏅 USER ACHIEVEMENTS
INSERT INTO user_achievements (user_id, achievement_id) VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 1),
(3, 3),
(4, 5),
(5, 2),
(6, 1),
(7, 1),
(8, 4);

-- 🛍️ SHOP ITEMS
INSERT INTO shop_items (name, cost, description) VALUES
('Streak Freeze', 100, 'Prevents your streak from breaking.'),
('Double XP', 50, 'Earn double XP for 30 minutes.'),
('Heart Refill', 30, 'Refill all your hearts.'),
('Bonus Skill: Idioms', 200, 'Unlock fun idioms lesson.'),
('Theme: Dark Mode', 150, 'Dark mode for your UI.');

-- 💸 USER PURCHASES
INSERT INTO user_purchases (user_id, item_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 1),
(4, 4),
(5, 2),
(6, 5),
(7, 1),
(8, 2),
(9, 3);

INSERT INTO user_energy (user_id, energy_remaining, last_recharged_at) VALUES
(1, 3, CURRENT_TIMESTAMP - INTERVAL '2 hours'),
(2, 5, CURRENT_TIMESTAMP - INTERVAL '10 minutes'),
(3, 0, CURRENT_TIMESTAMP - INTERVAL '5 hours'),
(4, 2, CURRENT_TIMESTAMP - INTERVAL '1 hour'),
(5, 4, CURRENT_TIMESTAMP - INTERVAL '20 minutes'),
(6, 5, CURRENT_TIMESTAMP - INTERVAL '15 minutes'),
(7, 1, CURRENT_TIMESTAMP - INTERVAL '3 hours'),
(8, 2, CURRENT_TIMESTAMP - INTERVAL '90 minutes'),
(9, 5, CURRENT_TIMESTAMP - INTERVAL '5 minutes'),
(10, 0, CURRENT_TIMESTAMP - INTERVAL '6 hours');
