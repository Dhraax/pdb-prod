-- ---------------------------------------------------------------------------
--  CNR character-owned persistent state.
--
--  Apply after the PWDB identity schema and before the disposable CNR
--  catalogue schema. This migration is idempotent and never deletes player
--  progress or preferences.
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS cnr_tradeskill (
  character_id INT         NOT NULL,
  skill_name   VARCHAR(32) NOT NULL,
  skill_level  INT         NOT NULL DEFAULT 1,
  skill_xp     INT         NOT NULL DEFAULT 0,
  updated_at   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (character_id, skill_name),
  CONSTRAINT fk_tradeskill_character
    FOREIGN KEY (character_id) REFERENCES pwdb_character(character_id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS cnr_character_setting (
  character_id  INT         NOT NULL,
  setting_name  VARCHAR(32) NOT NULL,
  setting_value INT         NOT NULL DEFAULT 0,
  PRIMARY KEY (character_id, setting_name),
  CONSTRAINT fk_setting_character
    FOREIGN KEY (character_id) REFERENCES pwdb_character(character_id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
