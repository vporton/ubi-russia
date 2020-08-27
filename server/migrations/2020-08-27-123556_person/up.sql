CREATE TABLE persons (
  id BIGSERIAL PRIMARY KEY,
  esiaID BIGINT NOT NULL,
  alive BOOLEAN NOT NULL DEFAULT TRUE,
  birthDate TIMESTAMP NOT NULL,
  ethAddress CHAR(40) NULL
);

CREATE INDEX esiaID_index ON persons(esiaID);
CREATE INDEX alive_index ON persons(alive);
CREATE INDEX ethAddress_index ON persons(ethAddress);
