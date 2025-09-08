-- Erika Coreth SQL code for Final Project
-- GO BIRDS!!!!
-- Appearances for 6 weeks of the 2024-2025 Football Seaon
-- Jordan Mailata did not go to college-no college listed for him (will return NULL)

DROP DATABASE IF EXISTS `eagles_db`;
CREATE DATABASE IF NOT EXISTS `eagles_db`;
USE `eagles_db`;

DROP TABLE IF EXISTS `Colleges`;

CREATE TABLE `Colleges` (
	college_id INT PRIMARY KEY AUTO_INCREMENT,
    college_name VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS `Players`;

CREATE TABLE `Players`(
	player_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    player_position ENUM('QB', 'WR', 'RB', 'TE', 'OL', 'DL', 'LB', 'CB', 'S', 'K', 'P') NOT NULL,
    college_id INT,
    isplayer_active TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT fk_players_college -- name for the foreign key constraint
		FOREIGN KEY (college_id) -- this column in players....
        REFERENCES Colleges(college_id) -- must match an existing college.college_id
        ON UPDATE CASCADE -- If Colleges.college_id changes, update here too
        ON DELETE SET NULL -- if the college is deleted, set this to null
);

DROP TABLE IF EXISTS `Games`;

CREATE TABLE `Games`(
	game_id INT PRIMARY KEY AUTO_INCREMENT,
    opponent VARCHAR(50) NOT NULL,
    location ENUM('HOME', 'AWAY') NOT NULL,
    kickoff DATETIME NOT NULL,
    result ENUM('WIN','LOSS','TIE') NULL
);

DROP TABLE IF EXISTS `Appearances`;

CREATE TABLE `Appearances`( -- junction with compostite PK (no surrogate id)
	game_id INT NOT NULL,
    player_id INT NOT NULL,
    
    PRIMARY KEY(game_id, player_id), -- Composite PK: each player can appear only once per game
    -- foreign key linking to games table
    CONSTRAINT fk_app_game
		FOREIGN KEY(game_id) -- game_id in appearances must match game_id in games
        REFERENCES Games(game_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
        
	-- foreign key linking to players table
	CONSTRAINT fk_app_player
		FOREIGN KEY(player_id) -- player_id in appearances must match player_id in players
        REFERENCES Players(player_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
); 

DROP TABLE IF EXISTS `Contracts`;

CREATE TABLE `Contracts`(
	contract_id INT PRIMARY KEY AUTO_INCREMENT, -- unique id for each contract
    player_id INT NOT NULL, -- links to the players table
    start_date DATE NOT NULL,
    end_date DATE NULL, -- null if ongoing
    salary DECIMAL(10,2) NOT NULL, -- annual salary
    cap_hit DECIMAL(10,2) NOT NULL, -- amount counted toward the teams salary cap
    
    -- foreign key linking to players table
    CONSTRAINT fk_contracts_player
		FOREIGN KEY(player_id) -- player_id in contracts must match player_id in players
        REFERENCES Players(player_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- REAL DATA SEED — Philadelphia Eagles (2024 season)
-- Sources: team schedule/results & initial 53-man roster
  

-- 1) Colleges (only those needed for players below)
INSERT INTO Colleges (college_name, state) VALUES
('Oklahoma','OK'),
('Penn State','PA'),
('Pittsburgh', 'PA'),
('Stanford','CA'),
('Mississippi','MS'),
('Alabama','AL'),
('South Dakota State','SD'),
('Memphis','TN'),
('Clemson','SC'),
('Nebraska','NE'),
('Louisville','KY'),
('Georgia','GA'),
('Florida State','FL'),
('Mississippi State','MS'),
('Toledo','OH'),
('Iowa','IA'),
('Middle Tennessee State','TN'),
('Texas A&M','TX'),
('Old Dominion','VA'),
('Michigan','MI'),
('Wisconsin','WI'),
('Michigan State','MI'),
('Florida','FL'),
('Samford','AL'),
('Louisiana Tech','LA');

-- 2) Players (subset of real 2024 Eagles)
--    Positions use ENUM: QB, WR, RB, TE, OL, DL, LB, CB, S, K, P
INSERT INTO Players (first_name,last_name,player_position,college_id) VALUES
('Jalen','Hurts','QB',       (SELECT college_id FROM Colleges WHERE college_name='Oklahoma')),
('Kenny','Pickett','QB',     (SELECT college_id FROM Colleges WHERE college_name='Pittsburgh')),
('Tanner','McKee','QB',      (SELECT college_id FROM Colleges WHERE college_name='Stanford')),

('Saquon','Barkley','RB',    (SELECT college_id FROM Colleges WHERE college_name='Penn State')), 
('Kenneth','Gainwell','RB',  (SELECT college_id FROM Colleges WHERE college_name='Memphis')),
('Will','Shipley','RB',      (SELECT college_id FROM Colleges WHERE college_name='Clemson')),

('A.J.','Brown','WR',        (SELECT college_id FROM Colleges WHERE college_name='Mississippi')),
('DeVonta','Smith','WR',     (SELECT college_id FROM Colleges WHERE college_name='Alabama')),
('Johnny','Wilson','WR',     (SELECT college_id FROM Colleges WHERE college_name='Florida State')),

('Dallas','Goedert','TE',    (SELECT college_id FROM Colleges WHERE college_name='South Dakota State')),

('Jordan','Mailata','OL',    NULL),
('Landon','Dickerson','OL',  (SELECT college_id FROM Colleges WHERE college_name='Alabama')),
('Cam','Jurgens','OL',       (SELECT college_id FROM Colleges WHERE college_name='Nebraska')),
('Lane','Johnson','OL',      (SELECT college_id FROM Colleges WHERE college_name='Oklahoma')),
('Mekhi','Becton','OL',      (SELECT college_id FROM Colleges WHERE college_name='Louisville')),

('Jalen','Carter','DL',      (SELECT college_id FROM Colleges WHERE college_name='Georgia')),
('Jordan','Davis','DL',      (SELECT college_id FROM Colleges WHERE college_name='Georgia')),
('Milton','Williams','DL',   (SELECT college_id FROM Colleges WHERE college_name='Louisiana Tech')),
('Josh','Sweat','DL',        (SELECT college_id FROM Colleges WHERE college_name='Florida State')),
('Bryce','Huff','DL',        (SELECT college_id FROM Colleges WHERE college_name='Memphis')),

('Nakobe','Dean','LB',       (SELECT college_id FROM Colleges WHERE college_name='Georgia')),
('Zack','Baun','LB',         (SELECT college_id FROM Colleges WHERE college_name='Wisconsin')),
('Jeremiah','Trotter Jr.','LB',(SELECT college_id FROM Colleges WHERE college_name='Clemson')),

('Darius','Slay','CB',       (SELECT college_id FROM Colleges WHERE college_name='Mississippi State')),
('Quinyon','Mitchell','CB',  (SELECT college_id FROM Colleges WHERE college_name='Toledo')),
('Kelee','Ringo','CB',       (SELECT college_id FROM Colleges WHERE college_name='Georgia')),
('Cooper','DeJean','CB',     (SELECT college_id FROM Colleges WHERE college_name='Iowa')),
('James','Bradberry','S',    (SELECT college_id FROM Colleges WHERE college_name='Samford')), -- converted to S late 2024
('C.J.','Gardner-Johnson','S',(SELECT college_id FROM Colleges WHERE college_name='Florida')),
('Reed','Blankenship','S',   (SELECT college_id FROM Colleges WHERE college_name='Middle Tennessee State')),

('Jake','Elliott','K',       (SELECT college_id FROM Colleges WHERE college_name='Memphis')),
('Braden','Mann','P',        (SELECT college_id FROM Colleges WHERE college_name='Texas A&M')),
('Rick','Lovato','OL',       (SELECT college_id FROM Colleges WHERE college_name='Old Dominion')); -- LS fits best under OL



-- 3) 2024 Regular Season schedule + results (W/L), with simple kickoff times
--    Week 1 listed as HOME because Eagles were the designated home team in Brazil.
INSERT INTO Games (opponent, location, kickoff, result) VALUES
('Packers',     'HOME','2024-09-06 20:15:00','WIN'),
('Falcons',     'HOME','2024-09-16 20:15:00','LOSS'),
('Saints',      'AWAY','2024-09-22 13:00:00','WIN'),
('Buccaneers',  'AWAY','2024-09-29 13:00:00','LOSS'),
-- Week 5 BYE
('Browns',      'HOME','2024-10-13 13:00:00','WIN'),
('Giants',      'AWAY','2024-10-20 13:00:00','WIN'),
('Bengals',     'AWAY','2024-10-27 13:00:00','WIN'),
('Jaguars',     'HOME','2024-11-03 13:00:00','WIN'),
('Cowboys',     'AWAY','2024-11-10 13:00:00','WIN'),
('Commanders',  'HOME','2024-11-14 20:15:00','WIN'),
('Rams',        'AWAY','2024-11-24 13:00:00','WIN'),
('Ravens',      'AWAY','2024-12-01 13:00:00','WIN'),
('Panthers',    'HOME','2024-12-08 13:00:00','WIN'),
('Steelers',    'HOME','2024-12-15 13:00:00','WIN'),
('Commanders',  'AWAY','2024-12-22 13:00:00','LOSS'),
('Cowboys',     'HOME','2024-12-29 13:00:00','WIN'),
('Giants',      'HOME','2025-01-05 13:00:00','WIN');

INSERT INTO Contracts (player_id, start_date, end_date, salary, cap_hit) VALUES
((SELECT player_id FROM Players WHERE first_name='Jalen'   AND last_name='Hurts'),          '2024-03-01', NULL,  8500000.00, 6500000.00),
((SELECT player_id FROM Players WHERE first_name='Saquon'  AND last_name='Barkley'),        '2024-03-01', NULL, 10000000.00, 8000000.00),
((SELECT player_id FROM Players WHERE first_name='A.J.'    AND last_name='Brown'),          '2024-03-01', NULL, 12000000.00, 9000000.00),
((SELECT player_id FROM Players WHERE first_name='DeVonta' AND last_name='Smith'),          '2024-03-01', NULL,  8000000.00, 6000000.00),
((SELECT player_id FROM Players WHERE first_name='Dallas'  AND last_name='Goedert'),        '2024-03-01', NULL,  7000000.00, 5000000.00),
((SELECT player_id FROM Players WHERE first_name='Lane'    AND last_name='Johnson'),        '2024-03-01', NULL,  9000000.00, 7000000.00),
((SELECT player_id FROM Players WHERE first_name='Landon'  AND last_name='Dickerson'),      '2024-03-01', NULL,  6500000.00, 5200000.00),
((SELECT player_id FROM Players WHERE first_name='Jordan'  AND last_name='Mailata'),        '2024-03-01', NULL,  7000000.00, 5600000.00),
((SELECT player_id FROM Players WHERE first_name='Cam'     AND last_name='Jurgens'),        '2024-03-01', NULL,  4000000.00, 3200000.00),
((SELECT player_id FROM Players WHERE first_name='Jalen'   AND last_name='Carter'),         '2024-03-01', NULL,  6000000.00, 4500000.00),
((SELECT player_id FROM Players WHERE first_name='Jordan'  AND last_name='Davis'),          '2024-03-01', NULL,  5000000.00, 3800000.00),
((SELECT player_id FROM Players WHERE first_name='Josh'    AND last_name='Sweat'),          '2024-03-01', NULL,  5800000.00, 4200000.00),
((SELECT player_id FROM Players WHERE first_name='Bryce'   AND last_name='Huff'),           '2024-03-01', NULL,  5200000.00, 4000000.00),
((SELECT player_id FROM Players WHERE first_name='Darius'  AND last_name='Slay'),           '2024-03-01', NULL,  7200000.00, 5500000.00),
((SELECT player_id FROM Players WHERE first_name='Quinyon' AND last_name='Mitchell'),       '2024-03-01', NULL,  3000000.00, 2300000.00),
((SELECT player_id FROM Players WHERE first_name='Kelee'   AND last_name='Ringo'),          '2024-03-01', NULL,  2500000.00, 1900000.00),
((SELECT player_id FROM Players WHERE first_name='Cooper'  AND last_name='DeJean'),         '2024-03-01', NULL,  3000000.00, 2200000.00),
((SELECT player_id FROM Players WHERE first_name='C.J.'    AND last_name='Gardner-Johnson'),'2024-03-01', NULL,  4500000.00, 3500000.00),
((SELECT player_id FROM Players WHERE first_name='Reed'    AND last_name='Blankenship'),    '2024-03-01', NULL,  2800000.00, 2100000.00),
((SELECT player_id FROM Players WHERE first_name='Jake'    AND last_name='Elliott'),        '2024-03-01', NULL,  3500000.00, 3000000.00),
((SELECT player_id FROM Players WHERE first_name='Braden'  AND last_name='Mann'),           '2024-03-01', NULL,  1200000.00, 1000000.00),
((SELECT player_id FROM Players WHERE first_name='Nakobe'  AND last_name='Dean'),          '2024-03-01', NULL, 4200000.00, 3200000.00),
((SELECT player_id FROM Players WHERE first_name='Zack'    AND last_name='Baun'),          '2024-03-01', NULL, 3000000.00, 2400000.00),
((SELECT player_id FROM Players WHERE first_name='Jeremiah' AND last_name='Trotter Jr.'),  '2024-03-01', NULL, 1500000.00, 1100000.00),
((SELECT player_id FROM Players WHERE first_name='Kenny'  AND last_name='Pickett'),        '2024-03-01', NULL, 4000000.00, 3000000.00),
((SELECT player_id FROM Players WHERE first_name='Tanner' AND last_name='McKee'),          '2024-03-01', NULL, 1200000.00,  900000.00),
((SELECT player_id FROM Players WHERE first_name='Kenneth' AND last_name='Gainwell'),      '2024-03-01', NULL, 1800000.00, 1400000.00),
((SELECT player_id FROM Players WHERE first_name='Will'    AND last_name='Shipley'),       '2024-03-01', NULL, 1200000.00,  900000.00),
((SELECT player_id FROM Players WHERE first_name='Johnny'  AND last_name='Wilson'),         '2024-03-01', NULL, 1000000.00,  800000.00),
((SELECT player_id FROM Players WHERE first_name='Mekhi'   AND last_name='Becton'),        '2024-03-01', NULL, 5000000.00, 3800000.00),
((SELECT player_id FROM Players WHERE first_name='Rick'    AND last_name='Lovato'),        '2024-03-01', NULL, 1100000.00,  900000.00),
((SELECT player_id FROM Players WHERE first_name='Milton'  AND last_name='Williams'),      '2024-03-01', NULL, 3500000.00, 2700000.00),
((SELECT player_id FROM Players WHERE first_name='James'   AND last_name='Bradberry'),     '2024-03-01', NULL, 3000000.00, 2200000.00);

-- ===== Week 1: Packers, 2024-09-06 =====
INSERT INTO Appearances (game_id, player_id) VALUES
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Jalen'  AND last_name='Hurts')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Saquon' AND last_name='Barkley')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Kenneth' AND last_name='Gainwell')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='A.J.'   AND last_name='Brown')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='DeVonta' AND last_name='Smith')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Dallas' AND last_name='Goedert')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Jordan' AND last_name='Mailata')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Landon' AND last_name='Dickerson')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Cam' AND last_name='Jurgens')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Lane' AND last_name='Johnson')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Jalen' AND last_name='Carter')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Jordan' AND last_name='Davis')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Josh' AND last_name='Sweat')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Darius' AND last_name='Slay')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Reed' AND last_name='Blankenship')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Jake' AND last_name='Elliott')),
((SELECT game_id FROM Games WHERE opponent='Packers' AND DATE(kickoff)='2024-09-06'),
 (SELECT player_id FROM Players WHERE first_name='Braden' AND last_name='Mann'));

-- ===== Week 2: Falcons, 2024-09-16 =====
INSERT INTO Appearances (game_id, player_id) VALUES
((SELECT game_id FROM Games WHERE opponent='Falcons' AND DATE(kickoff)='2024-09-16'),
 (SELECT player_id FROM Players WHERE first_name='Jalen'  AND last_name='Hurts')),
((SELECT game_id FROM Games WHERE opponent='Falcons' AND DATE(kickoff)='2024-09-16'),
 (SELECT player_id FROM Players WHERE first_name='Saquon' AND last_name='Barkley')),
((SELECT game_id FROM Games WHERE opponent='Falcons' AND DATE(kickoff)='2024-09-16'),
 (SELECT player_id FROM Players WHERE first_name='A.J.'   AND last_name='Brown')),
((SELECT game_id FROM Games WHERE opponent='Falcons' AND DATE(kickoff)='2024-09-16'),
 (SELECT player_id FROM Players WHERE first_name='DeVonta' AND last_name='Smith')),
((SELECT game_id FROM Games WHERE opponent='Falcons' AND DATE(kickoff)='2024-09-16'),
 (SELECT player_id FROM Players WHERE first_name='Dallas' AND last_name='Goedert')),
((SELECT game_id FROM Games WHERE opponent='Falcons' AND DATE(kickoff)='2024-09-16'),
 (SELECT player_id FROM Players WHERE first_name='Jordan' AND last_name='Mailata')),
((SELECT game_id FROM Games WHERE opponent='Falcons' AND DATE(kickoff)='2024-09-16'),
 (SELECT player_id FROM Players WHERE first_name='Lane' AND last_name='Johnson')),
((SELECT game_id FROM Games WHERE opponent='Falcons' AND DATE(kickoff)='2024-09-16'),
 (SELECT player_id FROM Players WHERE first_name='Cam' AND last_name='Jurgens')),
((SELECT game_id FROM Games WHERE opponent='Falcons' AND DATE(kickoff)='2024-09-16'),
 (SELECT player_id FROM Players WHERE first_name='Milton' AND last_name='Williams')),
((SELECT game_id FROM Games WHERE opponent='Falcons' AND DATE(kickoff)='2024-09-16'),
 (SELECT player_id FROM Players WHERE first_name='Bryce' AND last_name='Huff')),
((SELECT game_id FROM Games WHERE opponent='Falcons' AND DATE(kickoff)='2024-09-16'),
 (SELECT player_id FROM Players WHERE first_name='Quinyon' AND last_name='Mitchell')),
((SELECT game_id FROM Games WHERE opponent='Falcons' AND DATE(kickoff)='2024-09-16'),
 (SELECT player_id FROM Players WHERE first_name='Reed' AND last_name='Blankenship'));

-- ===== Week 3: Saints, 2024-09-22 =====
INSERT INTO Appearances (game_id, player_id) VALUES
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='Jalen' AND last_name='Hurts')),
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='Saquon' AND last_name='Barkley')),
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='Kenneth' AND last_name='Gainwell')),
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='A.J.' AND last_name='Brown')),
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='DeVonta' AND last_name='Smith')),
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='Dallas' AND last_name='Goedert')),
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='Lane' AND last_name='Johnson')),
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='Cam' AND last_name='Jurgens')),
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='Mekhi' AND last_name='Becton')),
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='Jalen' AND last_name='Carter')),
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='Jordan' AND last_name='Davis')),
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='Josh' AND last_name='Sweat')),
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='C.J.' AND last_name='Gardner-Johnson')),
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='Darius' AND last_name='Slay')),
((SELECT game_id FROM Games WHERE opponent='Saints' AND DATE(kickoff)='2024-09-22'),
 (SELECT player_id FROM Players WHERE first_name='Jake' AND last_name='Elliott'));

-- ===== Week 4: Buccaneers, 2024-09-29 =====
INSERT INTO Appearances (game_id, player_id) VALUES
((SELECT game_id FROM Games WHERE opponent='Buccaneers' AND DATE(kickoff)='2024-09-29'),
 (SELECT player_id FROM Players WHERE first_name='Jalen' AND last_name='Hurts')),
((SELECT game_id FROM Games WHERE opponent='Buccaneers' AND DATE(kickoff)='2024-09-29'),
 (SELECT player_id FROM Players WHERE first_name='Saquon' AND last_name='Barkley')),
((SELECT game_id FROM Games WHERE opponent='Buccaneers' AND DATE(kickoff)='2024-09-29'),
 (SELECT player_id FROM Players WHERE first_name='A.J.' AND last_name='Brown')),
((SELECT game_id FROM Games WHERE opponent='Buccaneers' AND DATE(kickoff)='2024-09-29'),
 (SELECT player_id FROM Players WHERE first_name='DeVonta' AND last_name='Smith')),
((SELECT game_id FROM Games WHERE opponent='Buccaneers' AND DATE(kickoff)='2024-09-29'),
 (SELECT player_id FROM Players WHERE first_name='Dallas' AND last_name='Goedert')),
((SELECT game_id FROM Games WHERE opponent='Buccaneers' AND DATE(kickoff)='2024-09-29'),
 (SELECT player_id FROM Players WHERE first_name='Jordan' AND last_name='Mailata')),
((SELECT game_id FROM Games WHERE opponent='Buccaneers' AND DATE(kickoff)='2024-09-29'),
 (SELECT player_id FROM Players WHERE first_name='Landon' AND last_name='Dickerson')),
((SELECT game_id FROM Games WHERE opponent='Buccaneers' AND DATE(kickoff)='2024-09-29'),
 (SELECT player_id FROM Players WHERE first_name='Cam' AND last_name='Jurgens')),
((SELECT game_id FROM Games WHERE opponent='Buccaneers' AND DATE(kickoff)='2024-09-29'),
 (SELECT player_id FROM Players WHERE first_name='Milton' AND last_name='Williams')); 


-- ===== Week 6: Browns, 2024-10-13 =====
INSERT INTO Appearances (game_id, player_id) VALUES
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='Jalen' AND last_name='Hurts')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='Saquon' AND last_name='Barkley')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='Kenneth' AND last_name='Gainwell')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='A.J.' AND last_name='Brown')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='DeVonta' AND last_name='Smith')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='Dallas' AND last_name='Goedert')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='Jordan' AND last_name='Mailata')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='Landon' AND last_name='Dickerson')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='Cam' AND last_name='Jurgens')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='Lane' AND last_name='Johnson')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='Jalen' AND last_name='Carter')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='Jordan' AND last_name='Davis')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='Kelee' AND last_name='Ringo')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='Reed' AND last_name='Blankenship')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='Jake' AND last_name='Elliott')),
((SELECT game_id FROM Games WHERE opponent='Browns' AND DATE(kickoff)='2024-10-13'),
 (SELECT player_id FROM Players WHERE first_name='Braden' AND last_name='Mann'));


-- Views

-- all players
CREATE VIEW `All Players` AS
	SELECT
    concat(p.first_name, ' ', p.last_name) AS `Player Name`,
    p.player_position AS `Position`,
    concat(c.college_name, ' ',c.state) AS `College and Location`
FROM Players p
LEFT JOIN Colleges c ON c.college_id = p.college_id
ORDER BY p.last_name, p.first_name;

-- aggregate view
CREATE VIEW `Salary by Position` AS
	SELECT
    p.player_position AS `Position`,
    COUNT(p.player_id) AS `Players Count`,
    ROUND(COALESCE(AVG(c.salary), 0), 2) AS `Avg Salary`,
    ROUND(COALESCE(SUM(c.cap_hit), 0), 2) AS `Total cap hit`
FROM Players p
LEFT JOIN Contracts c ON c.player_id = p.player_id
GROUP BY p.player_position
ORDER BY p.player_position;

-- GET FUNCTIONS

DELIMITER $$

CREATE PROCEDURE getCollegesList()
BEGIN
	SELECT * FROM Colleges;
END$$

CREATE PROCEDURE getPlayerList()
BEGIN
	SELECT * FROM Players;
END$$

CREATE PROCEDURE getGamesList()
BEGIN
	SELECT * FROM Games;
END$$

CREATE PROCEDURE getAppearancesList()
BEGIN
	SELECT * FROM Appearances;
END$$

CREATE PROCEDURE getContractsList()
BEGIN
	SELECT * FROM Contracts;
END$$

DELIMITER ;


-- add a player

DROP PROCEDURE IF EXISTS addPlayer;

DELIMITER $$

CREATE PROCEDURE addPlayer(IN playFName VARCHAR(50), playLName VARCHAR(50), playPos ENUM('QB','WR','RB','TE','OL','DL','LB','CB','S','K','P'))
BEGIN
	INSERT INTO Players (first_name, last_name, player_position)
    VALUES (playFName, playLName, playPos);
    
    -- returns the new row
    SELECT player_id, first_name, last_name, player_position
    FROM Players;
END$$

DELIMITER ;


-- update active status 

DROP PROCEDURE IF EXISTS updateStatus; 
DELIMITER $$

CREATE PROCEDURE updateStatus(
    IN playFName VARCHAR(50),
    IN playLName VARCHAR(50)
)
BEGIN
    DECLARE play_id INT;

    -- Find the player_id
    SELECT player_id
      INTO play_id
      FROM Players
     WHERE first_name = playFName
       AND last_name  = playLName;

    -- Update using the PRIMARY KEY
    UPDATE Players
       SET isplayer_active = 0
     WHERE player_id = play_id;

    -- Return the updated row
    SELECT player_id, first_name, last_name, player_position, college_id, isplayer_active
      FROM Players
     WHERE player_id = play_id;
END$$

DELIMITER ;

-- delete a row

DROP PROCEDURE IF EXISTS deletePlayer;
DELIMITER $$

CREATE PROCEDURE deletePlayer(IN playFName VARCHAR(50), playLName VARCHAR(50))

BEGIN
    DECLARE playid INT;

    -- Find the player's id 
    SELECT player_id
      INTO playid
      FROM Players
     WHERE first_name = playFName
       AND last_name  = playLName;
       
       DELETE FROM Players WHERE player_id = playid;
END$$

DELIMITER ;

-- Advanced Feature

DROP PROCEDURE IF EXISTS getExport;
DELIMITER $$

CREATE PROCEDURE getExport(IN p_dataset VARCHAR(50))
BEGIN
  IF p_dataset = 'all_players' THEN
    SELECT
      `Player Name`          AS player_name,
      `Position`             AS position,
      `College and Location` AS college_location
    FROM `All Players`;

  ELSEIF p_dataset = 'salary_by_position' THEN
    SELECT
      `Position`       AS position,
      `Players Count`  AS players_count,
      `Avg Salary`     AS avg_salary,
      `Total cap hit`  AS total_cap_hit
    FROM `Salary by Position`;
  END IF;
END$$

DELIMITER ;


CALL getExport('all_players');         -- roster export
CALL getExport('salary_by_position');  -- salary export



-- DEMO: Baseline views

SELECT * FROM `All Players`;
SELECT * FROM `Salary by Position`;


-- DEMO: Call every stored procedure once


-- Add a new player (INSERT)
CALL addPlayer('Erika','Coreth','QB');

-- Update a player to inactive (UPDATE)
CALL updateStatus('Jalen','Hurts');

-- Delete an existing player (DELETE) 
CALL deletePlayer('Braden','Mann');

-- get procedures
CALL getCollegesList();
CALL getPlayerList();
CALL getGamesList();
CALL getAppearancesList();
CALL getContractsList();


-- DEMO: Views after changes

SELECT * FROM `All Players`;
SELECT * FROM `Salary by Position`;






     


    








