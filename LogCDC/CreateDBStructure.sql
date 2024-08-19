CREATE TABLE Person (
    PersonID int NOT NULL PRIMARY KEY,
    LastName varchar(50) NOT NULL,
    FirstName varchar(50) NOT NULL,
    DateOfBirth date NOT NULL,
    Email varchar(50) NOT NULL,
    PhoneNumber varchar(50) NOT NULL,
    Address varchar(50) NOT NULL
);

CREATE TABLE Branch (
    BranchID int NOT NULL PRIMARY KEY,
    BranchName varchar(50) NOT NULL,
    Address varchar(50) NOT NULL,
    PhoneNumber varchar(50) NOT NULL
);

CREATE TABLE Customer (
    CustomerID int NOT NULL PRIMARY KEY,
    CustomerType varchar(50) NOT NULL,
    PersonID int NOT NULL UNIQUE,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

CREATE TABLE Employee (
    EmployeeID int NOT NULL PRIMARY KEY,
    Position varchar(50) NOT NULL,
    PersonID int NOT NULL,
    BranchID int NOT NULL,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);

CREATE TABLE Account (
    AccountID int NOT NULL PRIMARY KEY,
    AccountType varchar(50) NOT NULL,
    AccountBalance decimal NOT NULL,
    AccountOpened date NOT NULL,
    AccountClosed date,
    CustomerID int NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Loan (
    LoanID int NOT NULL PRIMARY KEY,
    LoanType varchar(50) NOT NULL,
    LoanAmount decimal NOT NULL,
    LoanInterestRate decimal NOT NULL,
    LoanTerm int NOT NULL,
    LoanStartDate date NOT NULL,
    LoanEndDate date NOT NULL,
    LoanStatus varchar(50) NOT NULL,
    CustomerID int NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
    );

CREATE TABLE LoanPayment (
    LoanPaymentID int NOT NULL PRIMARY KEY,
    PaymentAmount decimal(10, 2) NOT NULL,
    PaymentDate date NOT NULL,
    PaidAmount decimal(10, 2) NOT NULL,
    LoanID int NOT NULL,
    FOREIGN KEY (LoanID) REFERENCES Loan(LoanID)
);

CREATE TABLE Transactions (
    TransactionID int NOT NULL PRIMARY KEY,
    TransactionType varchar(50) NOT NULL,
    TransactionAmount decimal(10, 2) NOT NULL,
    TransactionDate date NOT NULL,
    AccountID int NOT NULL,
    EmployeeID int NOT NULL,
    LoanPaymentID int NOT NULL,
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (LoanPaymentID) REFERENCES LoanPayment(LoanPaymentID)
);