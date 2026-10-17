CREATE TABLE Currencies (
    CurrencyID INT IDENTITY(1,1) PRIMARY KEY,
    CurrencyCode VARCHAR(3) NOT NULL UNIQUE,
    CurrencyName VARCHAR(50) NOT NULL,
    Symbol VARCHAR(5) NOT NULL,
    IsActive BIT NOT NULL
);

CREATE TABLE ExchangeRates (
    RateID BIGINT IDENTITY(1,1) PRIMARY KEY,
    FromCurrencyID INT NOT NULL,
    ToCurrencyID INT NOT NULL,
    Rate DECIMAL(18,6) NOT NULL,
    EffectiveDate DATE NOT NULL,
    CreatedAt DATETIME2 DEFAULT SYSDATETIME() NOT NULL,
    CONSTRAINT FK_ExchangeRates_FromCurrency FOREIGN KEY (FromCurrencyID) REFERENCES Currencies(CurrencyID),
    CONSTRAINT FK_ExchangeRates_ToCurrency FOREIGN KEY (ToCurrencyID) REFERENCES Currencies(CurrencyID)
);