-- ============================
-- USERS (admin + izvođači + korisnici)
-- ============================
INSERT INTO users (id, username, email, password, first_name, last_name, is_artist, is_active, bio) VALUES
(1,  'admin',          'admin@musichub.local',  '{noop}admin', 'Admin',   'User',   FALSE, TRUE, 'System administrator'),

(2,  'boris_brejcha',  'boris@brejcha.com',     '$2a$10$ABCDEFGHIJKLMNOPQRSTUVWXYZ012345', 'Boris',    'Brejcha', TRUE, TRUE, 'Hi-Tech Minimal pioneer'),
(3,  'deadmau5',       'deadmau5@cube.com',     '$2a$10$ABCDEFGHIJKLMNOPQRSTUVWXYZ012345', 'Joel',     'Zimmerman', TRUE, TRUE, 'Progressive / Electro house'),
(4,  'fisher',         'fisher@tech.house',     '$2a$10$ABCDEFGHIJKLMNOPQRSTUVWXYZ012345', 'Paul',     'Fisher', TRUE, TRUE, 'Tech house bangers'),
(5,  'amelie_lens',    'amelie@lens.be',        '$2a$10$ABCDEFGHIJKLMNOPQRSTUVWXYZ012345', 'Amelie',   'Lens',   TRUE, TRUE, 'Hard techno energy'),
(6,  'carl_cox',       'carl@cox.uk',           '$2a$10$ABCDEFGHIJKLMNOPQRSTUVWXYZ012345', 'Carl',     'Cox',    TRUE, TRUE, 'Techno legend'),
(7,  'deep_berlin',    'deep@berlin.de',        '$2a$10$ABCDEFGHIJKLMNOPQRSTUVWXYZ012345', 'Max',      'Keller', TRUE, TRUE, 'Deep house specialist from Berlin'),
(8,  'charlotte_w',    'charlotte@dewitte.com', '$2a$10$ABCDEFGHIJKLMNOPQRSTUVWXYZ012345', 'Charlotte','de Witte', TRUE, TRUE, 'Belgian techno DJ known for hard techno sound'),

(9,  'mike_raver',     'mike@raver.com',        '$2a$10$ABCDEFGHIJKLMNOPQRSTUVWXYZ012345', 'Mike',     'Raver',  FALSE, TRUE, 'Techno enthusiast and clubber'),
(10, 'lisa_techno',    'lisa@techno.com',       '$2a$10$ABCDEFGHIJKLMNOPQRSTUVWXYZ012345', 'Lisa',     'Techno', FALSE, TRUE, 'Minimal techno lover');

-- ============================
-- GENRES (DJ orijentisani) – kreirao admin (id=1)
-- ============================
INSERT INTO genres (id, name, description, created_by) VALUES
(1,'House Music',       'Four-on-the-floor beat with soulful vocals', 1),
(2,'Tech House',        'Hybrid of techno and house with minimal elements', 1),
(3,'Deep House',        'Soulful, atmospheric house with jazz influences', 1),
(4,'Funky House',       'House music with disco and funk elements', 1),
(5,'Soulful House',     'Vocal-driven house with soul and gospel influences', 1),
(6,'Techno',            'Repetitive electronic music with industrial sounds', 1),
(7,'Minimal Techno',    'Stripped-down techno with minimal elements', 1),
(8,'Hi-Tech Minimal',   'Advanced minimal techno - Boris Brejcha style!', 1),
(9,'Progressive House', 'Building, evolving house with long progressions', 1),
(10,'Melodic Techno',   'Emotional techno with strong melodic elements', 1),
(11,'Afro House',       'House music with African rhythms and percussion', 1),
(12,'Disco House',      'Modern house with classic disco samples', 1),
(13,'Acid House',       'House with squelchy 303 basslines', 1),
(14,'Tribal House',     'House with ethnic percussion and tribal rhythms', 1);

-- ============================
-- ALBUMS (fiksni ID-evi 1–7)
-- ============================
INSERT INTO albums (id, title, description, cover_image, release_year, artist_id) VALUES
-- Boris Brejcha
(1, 'Space Diver',            'Iconic Hi-Tech Minimal album', '/images/space_diver.jpg', 2020, 2),
(2, '22 Layers of Pain',      'Minimal techno masterpiece',   '/images/22_layers.jpg',   2021, 2),
-- Deadmau5
(3, 'Random Album Title',     'Progressive house classic',    '/images/random_album.jpg',2008, 3),
(4, '4x4=12',                 'Commercial breakthrough album','/images/4x4.jpg',         2010, 3),
-- Fisher
(5, 'Losing It EP',           'Tech house anthem collection', '/images/losing_it.jpg',   2018, 4),
-- Amelie Lens
(6, 'Weight Of The Land EP',  'Hard techno energy',           '/images/weight_land.jpg', 2022, 5),
-- Carl Cox
(7, 'All Roads Lead To The Dancefloor','Techno legend returns','/images/all_roads.jpg',  2023, 6);

-- ============================
-- SONGS (fiksni ID-evi 1–16)
-- ============================
INSERT INTO songs (id, title, description, file_path, duration, file_size, cover_image, release_year, allow_download, is_approved, is_premium, play_count, download_count, artist_id, genre_id, album_id) VALUES
-- Boris Brejcha
(1,  'Space Diver',      'Iconic Hi-Tech Minimal track', '/music/space_diver.mp3', 420, 8000000,  '/images/space_diver.jpg', 2020, TRUE,  TRUE,  FALSE, 0, 0, 2, 8, 1),
(2,  'Gravity',          'Driving minimal techno',       '/music/gravity.mp3',     380, 7500000,  '/images/gravity.jpg',     2021, TRUE,  TRUE,  FALSE, 0, 0, 2, 7, 2),
(3,  'Purple Noise',     'Atmospheric Hi-Tech Minimal',  '/music/purple_noise.mp3',450, 8500000,  '/images/purple_noise.jpg',2022, FALSE, TRUE,  FALSE, 0, 0, 2, 8, NULL),
-- Deadmau5
(4,  'Strobe',           'Progressive house anthem',     '/music/strobe.mp3',      600, 12000000, '/images/strobe.jpg',      2009, TRUE,  TRUE,  FALSE, 0, 0, 3, 9, 3),
(5,  'Ghosts n Stuff',   'Electro house classic',        '/music/ghosts.mp3',      320, 6500000,  '/images/ghosts.jpg',      2009, TRUE,  TRUE,  FALSE, 0, 0, 3, 1, 4),
(6,  'I Remember',       'Vocal progressive house',      '/music/i_remember.mp3',  480, 9000000,  '/images/i_remember.jpg',  2008, FALSE, TRUE,  FALSE, 0, 0, 3, 9, 3),
-- Fisher
(7,  'Losing It',        'Tech house global hit',        '/music/losing_it.mp3',   210, 4200000,  '/images/losing_it.jpg',   2018, TRUE,  TRUE,  FALSE, 0, 0, 4, 2, 5),
(8,  'You Little Beauty', 'Groovy tech house',           '/music/you_little.mp3',  240, 4800000,  '/images/you_little.jpg',  2020, TRUE,  TRUE,  FALSE, 0, 0, 4, 2, NULL),
-- Amelie Lens
(9,  'Weight Of The Land','Hard techno weapon',          '/music/weight_land.mp3', 360, 7200000,  '/images/weight_land.jpg', 2022, TRUE,  TRUE,  FALSE, 0, 0, 5, 6, 6),
(10, 'Follow',           'Driving techno track',         '/music/follow.mp3',      340, 6800000,  '/images/follow.jpg',      2021, FALSE, TRUE,  FALSE, 0, 0, 5, 6, NULL),
-- Carl Cox
(11, 'Darkness',         'Legendary techno sound',       '/music/darkness.mp3',    400, 8000000,  '/images/darkness.jpg',    2023, TRUE,  TRUE,  FALSE, 0, 0, 6, 6, 7),
(12, 'Phuture 2000',     'Old school techno vibes',      '/music/phuture.mp3',     380, 7600000,  '/images/phuture.jpg',     2023, TRUE,  TRUE,  FALSE, 0, 0, 6, 6, 7),
-- Deep House
(13, 'Midnight in Berlin','Atmospheric deep house',      '/music/midnight_berlin.mp3',420,8400000,'/images/midnight.jpg',    2023, TRUE,  TRUE,  FALSE, 0, 0, 7, 3, NULL),
(14, 'Soul Connection',  'Soulful house journey',        '/music/soul_connection.mp3',380,7600000,'/images/soul_connection.jpg',2023,FALSE,TRUE,FALSE, 0,0, 7, 5, NULL),
-- Charlotte de Witte
(15, 'Return To Nowhere','Hard techno anthem',           '/music/return_nowhere.mp3',350,7000000,'/images/return.jpg',      2022, TRUE,  TRUE,  FALSE, 0, 0, 8, 6, NULL),
(16, 'Universal Consciousness','Melodic techno track',   '/music/universal.mp3',   370, 7400000, '/images/universal.jpg',   2023, TRUE,  TRUE,  FALSE, 0, 0, 8,10, NULL);

-- ============================
-- FOLLOWS
-- ============================
INSERT INTO user_follows (follower_id, followed_id) VALUES
(9, 2), (9, 3), (9, 4), (9, 5),
(10,2), (10,5), (10,8),
(9, 6), (9, 7), (9, 8);

-- ============================
-- PLAYLISTS (IDs 1–4)
-- ============================
INSERT INTO playlists (id, name, description, is_public, user_id) VALUES
(1,'Techno Power Hour', 'Hard techno for intense sessions', TRUE, 9),
(2,'Minimal Journey',   'Hi-Tech Minimal and minimal techno', TRUE, 10),
(3,'House Classics',    'Essential house music collection', TRUE, 9),
(4,'Workout Techno',    'Energetic tracks for training', FALSE, 10);

-- ============================
-- PLAYLIST SONGS
-- ============================
INSERT INTO playlist_songs (playlist_id, song_id, position) VALUES
(1, 9, 1), (1,10,2), (1,11,3), (1,12,4), (1,15,5), (1,16,6),
(2, 1, 1), (2, 2, 2), (2, 3, 3),
(3, 4, 1), (3, 5, 2), (3, 6, 3), (3, 7, 4), (3, 8, 5), (3,13,6), (3,14,7),
(4, 1, 1), (4, 2, 2), (4, 7, 3), (4, 9, 4);

-- ============================
-- RATINGS
-- ============================
INSERT INTO song_ratings (user_id, song_id, rating) VALUES
(9, 1, 5), (9, 2, 5), (9, 4, 5), (9, 7, 4), (9, 9, 5), (9,11, 4),
(10,1, 5), (10,3, 5), (10,9, 5), (10,10,4), (10,15,5), (10,16,5);

-- ============================
-- COMMENTS
-- ============================
INSERT INTO song_comments (user_id, song_id, comment) VALUES
(9, 1,  'Boris Brejcha is a genius! This track destroys every dancefloor.'),
(10,1,  'The definition of Hi-Tech Minimal. Masterpiece!'),
(9, 4,  'Strobe will forever be the progressive house anthem.'),
(10,9,  'Amelie Lens never disappoints. Pure techno energy!'),
(9, 7,  'Fisher created a tech house revolution with this one.'),
(10,15, 'Charlotte de Witte - the queen of modern techno!');

-- ============================
-- INDEXES (u V2 je OK)
-- ============================
CREATE INDEX idx_songs_artist_id        ON songs(artist_id);
CREATE INDEX idx_songs_genre_id         ON songs(genre_id);
CREATE INDEX idx_songs_approved         ON songs(is_approved);

CREATE INDEX idx_messages_sender        ON messages(sender_id);
CREATE INDEX idx_messages_receiver      ON messages(receiver_id);

CREATE INDEX idx_play_history_user      ON play_history(user_id);
CREATE INDEX idx_play_history_song      ON play_history(song_id);

CREATE INDEX idx_song_ratings_song      ON song_ratings(song_id);
CREATE INDEX idx_user_follows_follower  ON user_follows(follower_id);
CREATE INDEX idx_user_follows_followed  ON user_follows(followed_id);