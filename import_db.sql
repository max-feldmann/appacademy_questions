DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;


PRAGMA foreign_keys = ON;  -- turn on the foreign key constraints to ensure data integrity

-- Users

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) NOT NULL
);

INSERT INTO
    users (fname, lname)
    VALUES
    ("Max", "Feldmann"), ("Bruno", "Weninger"), ("Marie", "Söllner");

-- Questions

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
    questions(title, body, author_id)
    SELECT
        "Maxs Question", "Who the Fred is Fuck?", 1
    FROM
        users
    WHERE
        users.fname = "Max" AND users.lname = "Feldmann";

INSERT INTO
    questions(title, body, author_id)
    SELECT
        "Brunos Question", "Who the Fuck is Max?", users.id
    FROM
        users
    WHERE
        users.fname = "Bruno" AND users.lname = "Weninger";

INSERT INTO
    questions(title, body, author_id)
    SELECT
        "Maries Question", "What the hell does Max want?", users.id
    FROM
        users
    WHERE
        users.fname = "Marie" AND users.lname = "Söllner";


-- Replies

CREATE TABLE replies (

    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    parent_reply_id INTEGER,
    author_id INTEGER NOT NULL,
    subject_question_id INTEGER NOT NULL,

    FOREIGN KEY (subject_question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
    FOREIGN KEY (author_id) REFERENCES users(id)

);

INSERT INTO 
    replies(body, parent_reply_id, author_id, subject_question_id)
    VALUES
        (
            "Fred is a techno shithead!",
            NULL,
            (SELECT id FROM users WHERE fname = "Marie" AND lname = "Söllner"),
            (SELECT id FROM questions WHERE title = "Maxs Question")
        )
;

INSERT INTO
    replies(body, parent_reply_id, author_id, subject_question_id)
    VALUES
        (
            "What the F*** is a techno shithead?",
            (SELECT id FROM replies WHERE body ="Fred is a techno shithead!"),
            (SELECT id FROM users WHERE fname = "Bruno" AND lname = "Weninger"),
            (SELECT id FROM questions WHERE title = "Maxs Question")
        )
;

INSERT INTO
    replies(body, parent_reply_id, author_id, subject_question_id)
    VALUES
        (
            "I guess it means a drug addict ;)",
            (SELECT id FROM replies WHERE body ="What the F*** is a techno shithead?"),
            (SELECT id FROM users WHERE fname = "Marie" AND lname = "Söllner"),
            (SELECT id FROM questions WHERE title = "Maxs Question")
        )
;

-- Question Follows

CREATE TABLE question_follows(

    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)

);

INSERT INTO
    question_follows(user_id, question_id)
    VALUES
    ((SELECT id FROM users WHERE fname = "Max" AND lname = "Feldmann"),
    (SELECT id FROM questions WHERE title = "Maxs Question")),

    ((SELECT id FROM users WHERE fname = "Marie" AND lname = "Söllner"),
    (SELECT id FROM questions WHERE title = "Maxs Question")),

    ((SELECT id FROM users WHERE fname = "Bruno" AND lname = "Weninger"),
    (SELECT id FROM questions WHERE title = "Maxs Question"))
;

 -- Question Likes Table

CREATE TABLE question_likes(

    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)

);

INSERT INTO 
    question_likes(user_id, question_id)
    VALUES
    ((SELECT id FROM users WHERE fname = "Marie" AND lname = "Söllner"),
    (SELECT id FROM questions WHERE title = "Maxs Question")),

    ((SELECT id FROM users WHERE fname = "Bruno" AND lname = "Weninger"),
    (SELECT id FROM questions WHERE title = "Maxs Question"))
;