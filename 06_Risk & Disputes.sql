CREATE TABLE Refunds (
    RefundID BIGINT IDENTITY(1,1) PRIMARY KEY,
    TransactionID BIGINT NOT NULL,
    PaymentID BIGINT NOT NULL,
    RefundAmount DECIMAL(18,2) NOT NULL,
    RefundReason VARCHAR(255) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    ProcessedAt DATETIME2 DEFAULT SYSDATETIME() NOT NULL,
    CONSTRAINT FK_Refunds_Transactions FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID),
    CONSTRAINT FK_Refunds_Payments FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID)
);

CREATE TABLE Disputes (
    DisputeID BIGINT IDENTITY(1,1) PRIMARY KEY,
    PaymentID BIGINT NOT NULL,
    TransactionID BIGINT NOT NULL,
    DisputeReason VARCHAR(255) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    OpenedAt DATETIME2 DEFAULT SYSDATETIME() NOT NULL,
    ClosedAt DATETIME2,
    Resolution VARCHAR(255),
    CONSTRAINT FK_Disputes_Payments FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID),
    CONSTRAINT FK_Disputes_Transactions FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID)
);

CREATE TABLE FraudRules (
    RuleID INT IDENTITY(1,1) PRIMARY KEY,
    RuleName VARCHAR(100) NOT NULL,
    RuleType VARCHAR(50) NOT NULL,
    Condition VARCHAR(255) NOT NULL,
    Action VARCHAR(50) NOT NULL,
    IsActive BIT NOT NULL,
    CreatedAt DATETIME2 DEFAULT SYSDATETIME() NOT NULL
);

CREATE TABLE FraudAlerts (
    AlertID BIGINT IDENTITY(1,1) PRIMARY KEY,
    PaymentID BIGINT NOT NULL,
    RuleID INT NOT NULL,
    RiskScore DECIMAL(5,2) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    CreatedAt DATETIME2 DEFAULT SYSDATETIME() NOT NULL,
    ResolvedAt DATETIME2,
    CONSTRAINT FK_FraudAlerts_Payments FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID),
    CONSTRAINT FK_FraudAlerts_FraudRules FOREIGN KEY (RuleID) REFERENCES FraudRules(RuleID)
);