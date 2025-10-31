ALTER TABLE users ADD COLUMN is_admin BOOLEAN DEFAULT FALSE;

UPDATE users SET is_admin = TRUE WHERE username = 'admin';

UPDATE users SET is_admin = FALSE WHERE username != 'admin';