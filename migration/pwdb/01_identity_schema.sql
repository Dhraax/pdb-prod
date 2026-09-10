-- ---------------------------------------------------------------------------
--  PWDB persistent identity schema.
--
--  Apply before every character-owned domain schema. This migration is
--  idempotent and never deletes account or character data.
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS pwdb_account (
  account_id  INT         NOT NULL AUTO_INCREMENT,
  cd_key      VARCHAR(16) NOT NULL,
  player_name VARCHAR(64) NULL,
  first_seen  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_seen   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (account_id),
  UNIQUE KEY uq_cd_key (cd_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS pwdb_character (
  character_id   INT         NOT NULL AUTO_INCREMENT,
  character_uuid CHAR(36)    NOT NULL,
  account_id     INT         NOT NULL,
  char_name      VARCHAR(64) NULL,
  created_at     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_login_at  DATETIME    NULL,
  PRIMARY KEY (character_id),
  UNIQUE KEY uq_character_uuid (character_uuid),
  KEY idx_account (account_id),
  CONSTRAINT fk_character_account
    FOREIGN KEY (account_id) REFERENCES pwdb_account(account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
