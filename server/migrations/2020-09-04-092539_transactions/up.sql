CREATE TABLE ethereum_transactions (
  id BIGSERIAL PRIMARY KEY,
  issued TIMESTAMP NOT NULL,
  transactionId CHAR(64) NOT NULL,
  gasPrice BIGINT NOT NULL,
  contractAddress CHAR(40) NOT NULL,
  userAddress CHAR(40) NOT NULL,
  startTime TIMESTAMP NOT NULL,
  esiaID BIGINT NOT NULL
);

CREATE INDEX transact_order ON ethereum_transactions(userAddress, id);
CREATE INDEX transactionId ON ethereum_transactions(transactionId);
CREATE INDEX issued ON ethereum_transactions(issued);
