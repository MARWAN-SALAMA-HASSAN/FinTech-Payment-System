CREATE TABLE PaymentMethods (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    MethodType VARCHAR(20) NOT NULL,
    Provider VARCHAR(50) NOT NULL,
    CardLast4 VARCHAR(4) NOT NULL,
    ExpiryMonth INT NOT NULL,
    ExpiryYear INT NOT NULL,
    Token VARCHAR(255) NOT NULL,
    IsDefault BIT NOT NULL,
    IsActive BIT NOT NULL,
    CreatedAt DATETIME2 DEFAULT SYSDATETIME() NOT NULL,
    CONSTRAINT FK_PaymentMethods_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Payments (
    PaymentID BIGINT IDENTITY(1,1) PRIMARY KEY,
    PaymentReference VARCHAR(50) NOT NULL UNIQUE,
    CustomerID INT NOT NULL,
    MerchantID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    CurrencyID INT NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    Description VARCHAR(255),
    IPaddress VARCHAR(45) NOT NULL,
    UserAgent VARCHAR(255) NOT NULL,
    CreatedAt DATETIME2 DEFAULT SYSDATETIME() NOT NULL,
    UpdatedAt DATETIME2 DEFAULT SYSDATETIME() NOT NULL,
    CONSTRAINT FK_Payments_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Payments_Merchants FOREIGN KEY (MerchantID) REFERENCES Merchants(MerchantID),
    CONSTRAINT FK_Payments_PaymentMethods FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID),
    CONSTRAINT FK_Payments_Currencies FOREIGN KEY (CurrencyID) REFERENCES Currencies(CurrencyID)
);

CREATE TABLE PaymentAttempts (
    PaymentAttemptID BIGINT IDENTITY(1,1) PRIMARY KEY,
    PaymentID BIGINT NOT NULL,
    AttemptNumber INT NOT NULL,
    Status VARCHAR(20) NOT NULL,
    GatewayResponse VARCHAR(255) NOT NULL,
    ErrorCode VARCHAR(50) NOT NULL,
    ErrorMessage VARCHAR(255) NOT NULL,
    AttemptedAt DATETIME2 DEFAULT SYSDATETIME() NOT NULL,
    CONSTRAINT FK_PaymentAttempts_Payments FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID)
);

CREATE TABLE Transactions (
    TransactionID BIGINT IDENTITY(1,1) PRIMARY KEY,
    PaymentAttemptID BIGINT NOT NULL,
    TransactionType VARCHAR(20) NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    FeeAmount DECIMAL(18,2) NOT NULL,
    NetAmount DECIMAL(18,2) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    ProviderRef VARCHAR(100) NOT NULL,
    ResponseCode VARCHAR(50) NOT NULL,
    ProcessedAt DATETIME2 DEFAULT SYSDATETIME() NOT NULL,
    CONSTRAINT FK_Transactions_PaymentAttempts FOREIGN KEY (PaymentAttemptID) REFERENCES PaymentAttempts(PaymentAttemptID)
);