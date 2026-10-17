CREATE TABLE MerchantFees (
    FeeID INT IDENTITY(1,1) PRIMARY KEY,
    MerchantID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    FeeType VARCHAR(20) NOT NULL,
    FeeRate DECIMAL(5,4) NOT NULL,
    FixedAmount DECIMAL(18,2) NOT NULL,
    MinAmount DECIMAL(18,2) NOT NULL,
    MaxAmount DECIMAL(18,2) NOT NULL,
    IsActive BIT NOT NULL,
    CreatedAt DATETIME2 DEFAULT SYSDATETIME() NOT NULL,
    CONSTRAINT FK_MerchantFees_Merchants FOREIGN KEY (MerchantID) REFERENCES Merchants(MerchantID),
    CONSTRAINT FK_MerchantFees_PaymentMethods FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID)
);

CREATE TABLE Settlements (
    SettlementID BIGINT IDENTITY(1,1) PRIMARY KEY,
    MerchantID INT NOT NULL,
    CurrencyID INT NOT NULL,
    TotalAmount DECIMAL(18,2) NOT NULL,
    FeeAmount DECIMAL(18,2) NOT NULL,
    NetAmount DECIMAL(18,2) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    SettlementDate DATE NOT NULL,
    CreatedAt DATETIME2 DEFAULT SYSDATETIME() NOT NULL,
    CONSTRAINT FK_Settlements_Merchants FOREIGN KEY (MerchantID) REFERENCES Merchants(MerchantID),
    CONSTRAINT FK_Settlements_Currencies FOREIGN KEY (CurrencyID) REFERENCES Currencies(CurrencyID)
);