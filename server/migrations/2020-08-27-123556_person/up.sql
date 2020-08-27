CREATE TABLE person (
  id SERIAL PRIMARY KEY,
  esiaID BIGINT NOT NULL,
  alive BOOLEAN NULL,
  birthDate DATE NOT NULL,
  ethAddress CHAR(42) NULL
);

CREATE INDEX esiaID_index ON person(esiaID);
CREATE INDEX alive_index ON person(alive);
CREATE INDEX ethAddress_index ON person(ethAddress);
