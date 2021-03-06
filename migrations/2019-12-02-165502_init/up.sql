-- Your SQL goes here

CREATE SEQUENCE IF NOT EXISTS serial_seq
  INCREMENT 1
  MAXVALUE 2147483647
  START 3645
  CACHE 1;

CREATE TABLE users (
  id INTEGER PRIMARY KEY DEFAULT nextval('serial_seq'),
  uname VARCHAR UNIQUE NOT NULL,
  psw_hash VARCHAR NOT NULL,
  join_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_seen TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  avatar VARCHAR NOT NULL DEFAULT '',
  email VARCHAR NOT NULL DEFAULT '',
  link VARCHAR NOT NULL DEFAULT '',
  intro TEXT NOT NULL DEFAULT '',
  location VARCHAR NOT NULL DEFAULT '',
  nickname VARCHAR NOT NULL DEFAULT '',
  permission SMALLINT NOT NULL DEFAULT 3,
  auth_from VARCHAR NOT NULL DEFAULT '',
  email_confirmed BOOLEAN NOT NULL DEFAULT FALSE,
  karma INTEGER NOT NULL DEFAULT 100,
  is_pro BOOLEAN NOT NULL DEFAULT FALSE,
  can_push BOOLEAN NOT NULL DEFAULT FALSE,
  push_email VARCHAR NOT NULL DEFAULT '',
  UNIQUE (uname, email)
);

CREATE TABLE blogs (
  id INTEGER PRIMARY KEY DEFAULT nextval('serial_seq'),
  aname VARCHAR UNIQUE NOT NULL,
  avatar VARCHAR NOT NULL DEFAULT '',
  intro VARCHAR NOT NULL DEFAULT '',
  topic VARCHAR NOT NULL DEFAULT '',
  blog_link VARCHAR NOT NULL DEFAULT '',
  blog_host VARCHAR NOT NULL DEFAULT '',
  tw_link VARCHAR NOT NULL DEFAULT '',
  gh_link VARCHAR NOT NULL DEFAULT '',
  other_link VARCHAR NOT NULL DEFAULT '',
  is_top BOOLEAN NOT NULL DEFAULT FALSE,
  karma INTEGER NOT NULL DEFAULT 1,
  UNIQUE (aname, blog_link)
);

CREATE TABLE items (
  id INTEGER PRIMARY KEY DEFAULT nextval('serial_seq'),
  title VARCHAR NOT NULL,
  slug VARCHAR UNIQUE NOT NULL,
  content TEXT NOT NULL DEFAULT '',
  logo VARCHAR NOT NULL DEFAULT '',
  author VARCHAR NOT NULL,
  ty VARCHAR NOT NULL, -- article|media|event|book| etc..
  lang VARCHAR NOT NULL DEFAULT 'English',
  topic VARCHAR NOT NULL DEFAULT '',
  link VARCHAR UNIQUE NOT NULL,
  link_host VARCHAR NOT NULL DEFAULT '',
  origin_link VARCHAR NOT NULL DEFAULT '',
  post_by VARCHAR NOT NULL DEFAULT '',
  post_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  pub_at DATE NOT NULL DEFAULT CURRENT_DATE,
  is_top BOOLEAN NOT NULL DEFAULT FALSE,
  vote INTEGER NOT NULL DEFAULT 1,
  UNIQUE (title, author, link)  -- ?
);

CREATE INDEX items_author_idx ON items (author);

CREATE TABLE issues (
  id INTEGER PRIMARY KEY DEFAULT nextval('serial_seq'),
  title VARCHAR UNIQUE NOT NULL,
  slug VARCHAR UNIQUE NOT NULL,
  content TEXT NOT NULL DEFAULT '',
  topic VARCHAR NOT NULL,
  author VARCHAR NOT NULL,
  post_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  vote INTEGER NOT NULL DEFAULT 1,
  is_closed BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE issuelabels (
  issue_id INTEGER NOT NULL REFERENCES issues (id) ON UPDATE CASCADE ON DELETE CASCADE,
  label VARCHAR NOT NULL,
  label_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (issue_id, label)
);

CREATE TABLE comments (
  id INTEGER PRIMARY KEY DEFAULT nextval('serial_seq'),
  content TEXT NOT NULL DEFAULT '',
  author VARCHAR NOT NULL,
  post_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  vote INTEGER NOT NULL DEFAULT 1,
  is_closed BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE issuecomments (
  issue_id INTEGER NOT NULL REFERENCES issues (id) ON UPDATE CASCADE ON DELETE CASCADE,
  comment_id INTEGER NOT NULL REFERENCES comments (id) ON UPDATE CASCADE ON DELETE CASCADE,
  PRIMARY KEY (issue_id, comment_id)
);

CREATE TABLE itemcomments (
  item_id INTEGER NOT NULL REFERENCES items (id) ON UPDATE CASCADE ON DELETE CASCADE,
  comment_id INTEGER NOT NULL REFERENCES comments (id) ON UPDATE CASCADE ON DELETE CASCADE,
  PRIMARY KEY (item_id, comment_id)
);

-- TODO
CREATE TABLE itemlinks (
  item_id VARCHAR NOT NULL REFERENCES items (id) ON UPDATE CASCADE ON DELETE CASCADE,
  link VARCHAR NOT NULL,
  link_ty VARCHAR NOT NULL, -- trans | comment ...
  link_host VARCHAR NOT NULL,
  link_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (item_id, link)
);

CREATE TABLE itemtrans (
  origin_slug VARCHAR NOT NULL REFERENCES items (slug) ON UPDATE CASCADE ON DELETE CASCADE,
  trans_slug VARCHAR NOT NULL REFERENCES items (slug) ON UPDATE CASCADE ON DELETE CASCADE,
  trans_lang VARCHAR NOT NULL, -- language
  trans_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (origin_slug, trans_slug)
);

CREATE TABLE voteitems (
  uname VARCHAR NOT NULL REFERENCES users (uname) ON UPDATE CASCADE ON DELETE CASCADE,
  item_id INTEGER NOT NULL REFERENCES items (id) ON UPDATE CASCADE ON DELETE CASCADE,
  vote_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  vote_as SMALLINT NOT NULL DEFAULT 1 CHECK (vote_as = 1 OR vote_as = -1),
  PRIMARY KEY (uname, item_id)
);

CREATE TABLE votecomments (
  uname VARCHAR NOT NULL REFERENCES users (uname) ON UPDATE CASCADE ON DELETE CASCADE,
  comment_id INTEGER NOT NULL REFERENCES comments (id) ON UPDATE CASCADE ON DELETE CASCADE,
  vote_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  vote_as SMALLINT NOT NULL DEFAULT 1 CHECK (vote_as = 1 OR vote_as = -1),
  PRIMARY KEY (uname, comment_id)
);

CREATE TABLE background_jobs (
  id BIGSERIAL PRIMARY KEY,
  job_type TEXT NOT NULL,
  data JSONB NOT NULL,
  retries INTEGER NOT NULL DEFAULT 0,
  last_retry TIMESTAMP NOT NULL DEFAULT '1970-01-01',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
