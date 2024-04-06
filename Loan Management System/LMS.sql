
CREATE TABLE loan_data (
    loan_id INT PRIMARY KEY,
    firstName VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    email_address VARCHAR(100),
    phone VARCHAR(15),
    education VARCHAR(50),
    occupation VARCHAR(50),
    experience INT,
    salary DECIMAL(10, 2),
    martial_status VARCHAR(20),
    number_of_Children INT
);

-- import (Kaggle sourced)
COPY loan_data FROM 'data.csv' DELIMITER ',' CSV HEADER;

-- borrower table
DROP TABLE IF EXISTS borrower;
CREATE TABLE borrower (
    borrower_id INT PRIMARY KEY,
    firstName VARCHAR(50),
    lastname VARCHAR(50),
    email_address VARCHAR(100) UNIQUE,
    gender VARCHAR(10) DEFAULT 'Unknown',
    age INT CHECK (age > 0),
    phone VARCHAR(20),
    education VARCHAR(100),
    occupation VARCHAR(100),
    experience INT,
    salary INT,
    martial_status VARCHAR(20),
    number_of_children INT
);

-- Inserting data into the borrower table
INSERT INTO borrower (borrower_id, firstName, lastname, email_address, gender, age, phone, education, occupation, experience, salary, martial_status, number_of_children)
VALUES
    ---;
  

ALTER TABLE borrower_credit_history
ADD credit_score_status VARCHAR(50);

UPDATE borrower_credit_history
SET credit_score_status = CASE
    WHEN credit_score >= 800 THEN 'Excellent'
    WHEN credit_score >= 700 THEN 'Good'
    WHEN credit_score >= 600 THEN 'Fair'
    ELSE 'Poor'
END;


DROP TABLE IF EXISTS LoanApplication;
CREATE TABLE LoanApplication (
    loan_id INT PRIMARY KEY,
    borrower_id INT,
    loanOfficer_id INT,
    CONSTRAINT FK_LoanApplication_Borrower FOREIGN KEY (borrower_id) REFERENCES Borrower(borrower_id),
    CONSTRAINT FK_LoanApplication_LoanOfficer FOREIGN KEY (loanOfficer_id) REFERENCES LoanOfficer(loanofficer_id)
);


INSERT INTO LoanApplication (loan_id, borrower_id, loanOfficer_id)
VALUES---;
    
DROP TABLE IF EXISTS LoanPortfolio;
CREATE TABLE LoanPortfolio (
    portfolioId INT PRIMARY KEY,
    loanId INT,
    loanAmount DECIMAL(10, 2),
    interestRate DECIMAL(4, 2),
    collateralType VARCHAR(50),
    loanStatus VARCHAR(50),
    loanStartDate DATE,
    loanEndDate DATE,
    BorrowerID INT,
    CONSTRAINT FK_LoanPortfolio_LoanApplication FOREIGN KEY (loanId) REFERENCES LoanApplication(loan_id),
    CONSTRAINT CHK_LoanAmount CHECK (loanAmount BETWEEN 20000 AND 100000),
    CONSTRAINT CHK_InterestRate CHECK (interestRate BETWEEN 10 AND 13),
    CONSTRAINT FK_LoanPortfolio_BorrowerID FOREIGN KEY (BorrowerID) REFERENCES Borrower(borrower_id)
);


INSERT INTO LoanPortfolio (portfolioId, loanId, loanAmount, interestRate, collateralType, loanStatus, loanStartDate, loanEndDate, BorrowerID)
VALUES
    -- ;


ALTER TABLE LatePaymentPrediction
ADD BorrowerName VARCHAR(255);


UPDATE LatePaymentPrediction
SET BorrowerName = CONCAT(Borrower.firstName, ' ', Borrower.lastName)
FROM Borrower
WHERE Borrower.borrower_id = LatePaymentPrediction.BorrowerID
AND LatePaymentPrediction.LatePaymentPrediction = 1;


CREATE PROCEDURE GetGenderDistribution
AS
BEGIN
    SELECT gender, COUNT(*) AS TotalCount
    FROM borrower
    GROUP BY gender
END;

EXEC GetGenderDistribution;
