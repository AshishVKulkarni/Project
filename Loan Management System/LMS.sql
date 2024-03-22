/*CREATE TABLE loan_data (
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

COPY loan_data FROM 'data.csv' DELIMITER ',' CSV HEADER;

*/

/*sample data for demonstration*/

drop table if exists borrower
CREATE TABLE borrower (
    borrower_id INT PRIMARY KEY,
    firstname NVARCHAR(50),
    lastname NVARCHAR(50),
    email_address NVARCHAR(100) UNIQUE,
    gender NVARCHAR(10) DEFAULT 'Unknown',
    age INT CHECK (age > 0),
    phone NVARCHAR(20),
    education NVARCHAR(100),
    occupation NVARCHAR(100),
    experience INT,
    salary INT,
    martial_status NVARCHAR(20),
    number_of_children INT,s
   );


INSERT INTO borrower (borrower_id, firstName,lastname,gender,age,email_address,phone,education,occupation,experience,salary,martial_status,number_of_Children)
values(1,'Garry','Brown','Male',21,'g.brown@randatmail.com',369-5608-56,'Lower secondary','Salesman',6,3674,'Single',0),
(2,'Richard','Hawkins','Male',29,'r.hawkins@randatmail.com',286-3103-59,'Upper secondary','Accountant',0,7629,'Married',3),
(3,'Vanessa','Ross','Female',27,'v.ross@randatmail.com',201-6424-22,'Primary','Scientist',13,574,'Married',3),
(4,'Owen','Clark','Male',18,'o.clark@randatmail.com',510-0492-26,'Bachelor','Veterinarian',1,4282,'Single',4),
(5,'Sarah','Morgan','Female',20,'s.morgan@randatmail.com',940-1248-57,'Doctoral','Jeweller',8,8706,'Married',2),
(6,'Lucia','Hunt','Female',30,'l.hunt@randatmail.com',679-6553-82,'Bachelor','Pharmacist',11,3668,'Married',5),
(7,'Luke','Douglas','Male',26,'l.douglas@randatmail.com',495-7242-07,'Primary','Geologist',9,8357,'Married',3),
(8,'Kate','Hall','Female',26,'k.hall@randatmail.com',397-3421-01,'Doctoral','Carpenter',8,8956,'Single',3),
(9,'Savana','Hunt','Female',23,'s.hunt@randatmail.com',615-1233-20,'Upper secondary','Lecturer',7,7135,'Married',5),
(10,'Briony','Barrett','Female',21,'b.barrett@randatmail.com',889-2834-78,'Lower secondary','Mechanic',4,7515,'Single',4),
(11,'Frederick','Thomas','Male',19,'f.thomas@randatmail.com',761-4017-12,'Lower secondary','Jeweller',0,7048,'Single',1),
(12,'Arnold','Parker','Male',23,'a.parker@randatmail.com',320-4976-60,'Primary','Firefighter',5,5226,'Married',4),
(13,'Vanessa','Morrison','Female',24,'v.morrison@randatmail.com',728-7793-20,'Master','Astronomer',6,4733,'Single',1),
(14,'Chester','Johnson','Male',29,'c.johnson@randatmail.com',178-9685-85,'Master','Driver',2,2371,'Married',3),
(15,'John','Brooks','Male',29,'j.brooks@randatmail.com',240-5599-78,'Master','Journalist',14,3938,'Single',3),
(16,'Maximilian','Cole','Male',21,'m.cole@randatmail.com',617-4272-59,'Master','Veterinarian',0,7462,'Single',5),
(17,'Naomi','Harrison','Female',20,'n.harrison@randatmail.com',961-9036-86,'Lower secondary','Mathematician',3,6531,'Single',2),
(18,'Michael','Bailey','Male',25,'m.bailey@randatmail.com',815-4630-09,'Primary','Manager',2,6826,'Married',1),
(19,'George','Hawkins','Male',28,'g.hawkins@randatmail.com',054-6279-87,'Master','Dancer',3,1272,'Married',5),
(20,'Jacob','Gray','Male',18,'j.gray@randatmail.com',356-1888-75,'Primary','Dancer',2,6774,'Single',5),
(21,'Clark','Spencer','Male',26,'c.spencer@randatmail.com',450-3735-25,'Doctoral','Actor',8,6871,'Single',1),
(22,'Fiona','Harris','Female',21,'f.harris@randatmail.com',176-9314-24,'Upper secondary','Photographer',9,7878,'Single',0),
(23,'Carlos','Montgomery','Male',26,'c.montgomery@randatmail.com',380-3829-61,'Master','Carpenter',0,1697,'Single',1),
(24,'Valeria','Johnston','Female',21,'v.johnston@randatmail.com',437-1073-41,'Bachelor','Auditor',3,4273,'Single',1),
(25,'Agata','Mitchell','Female',24,'a.mitchell@randatmail.com',996-1586-63,'Upper secondary','Police Officer',2,2773,'Single',3),
(26,'Violet','Richardson','Female',20,'v.richardson@randatmail.com',387-7711-83,'Master','Teacher',7,5666,'Married',3),
(27,'Ryan','Miller','Male',25,'r.miller@randatmail.com',727-5988-97,'Master','Interpreter',7,9211,'Married',1),
(28,'Eleanor','Payne','Female',22,'e.payne@randatmail.com',261-8126-11,'Lower secondary','Veterinarian',3,2845,'Married',2)


drop table if exists borrower_credit_history
CREATE TABLE borrower_credit_history(
  credit_id INT PRIMARY KEY,
  borrower_id INT,
  credit_score INT,
  FOREIGN KEY (borrower_id) REFERENCES borrower (borrower_id)
);

-- Constraint for credit_score between 300 and 800
ALTER TABLE borrower_credit_history
ADD CONSTRAINT CK_credit_score_range
CHECK (credit_score >= 300 AND credit_score <= 850);

insert into borrower_credit_history(credit_id, borrower_id, credit_score)
values(1,2,351),
(2,4,373),
(3,6,600),
(4,8,807),
(5,10,809),
(6,12,489),
(7,14,628),
(8,16,839),
(9,18,791),
(10,20,329),
(11,22,738),
(12,24,715),
(13,26,576),
(14,28,380),
(15,1,733),
(16,3,706),
(17,5,326),
(18,7,785),
(19,9,354),
(20,11,585),
(21,13,467),
(22,15,703),
(23,17,357),
(24,19,585),
(25,21,537),
(26,23,488),
(27,25,840),
(28,27,424)

--credit history status column
ALTER TABLE borrower_credit_history
add credit_score_status varchar(50)

-- categorization
UPDATE borrower_credit_history
SET credit_score_status = CASE
    WHEN credit_score >= 800 THEN 'Excellent'
    WHEN credit_score >= 700 THEN 'Good'
    WHEN credit_score >= 600 THEN 'Fair'
    ELSE 'Poor'
END;

drop table if EXISTS loanofficer
CREATE TABLE loanofficer (
  loanofficer_id INT PRIMARY KEY,
  firstname VARCHAR(50),
  lastname VARCHAR(50),
  phone NVARCHAR(50),
  email_address NVARCHAR(100) UNIQUE,
  assignedloans INT
);

insert into loanofficer ( loanofficer_id, firstname, lastname, phone,email_address,assignedloans)
values(1,'Marcus','Myers','m.myers@randatmail.com',833-6056-30,9),
(2,'Albert','Higgins','a.higgins@randatmail.com',277-4028-66,2),
(3,'Kristian','Williams','k.williams@randatmail.com',735-7870-09,3),
(4,'Charlie','Watson','c.watson@randatmail.com',283-3027-35,5),
(5,'Mike','Cunningham','m.cunningham@randatmail.com',232-8139-97,6),
(6,'Deanna','Harper','d.harper@randatmail.com',944-5786-92,7),
(7,'Fiona','Andrews','f.andrews@randatmail.com',044-7703-56,2),
(8,'Preston','Barnes','p.barnes@randatmail.com',456-7466-19,7),
(9,'Alfred','Murphy','a.murphy@randatmail.com',579-8266-86,2),
(10,'Alan','Cooper','a.cooper@randatmail.com',752-8692-86,9),
(11,'Darcy','Wilson','d.wilson@randatmail.com',960-0109-97,9),
(12,'Chelsea','Mason','c.mason@randatmail.com',136-5400-83,1),
(13,'Kirsten','Turner','k.turner@randatmail.com',022-1984-82,1),
(14,'Violet','Robinson','v.robinson@randatmail.com',377-5454-46,5),
(15,'Briony','Parker','b.parker@randatmail.com',871-4329-69,4),
(16,'Ryan','Armstrong','r.armstrong@randatmail.com',770-1862-70,8),
(17,'Chester','Brooks','c.brooks@randatmail.com',780-4172-90,2),
(18,'Lily','Watson','l.watson@randatmail.com',114-1488-39,1),
(19,'Lyndon','Anderson','l.anderson@randatmail.com',876-8859-01,5),
(20,'Chloe','Stewart','c.stewart@randatmail.com',358-0293-85,5),
(21,'Marcus','Miller','m.miller@randatmail.com',073-7512-20,3),
(22,'James','Brooks','j.brooks@randatmail.com',827-1031-82,1),
(23,'Sienna','Bennett','s.bennett@randatmail.com',544-3799-89,8),
(24,'Adrian','Bailey','a.bailey@randatmail.com',974-4122-89,0),
(25,'Aston','Hunt','a.hunt@randatmail.com',589-9071-48,0),
(26,'Jessica','Crawford','j.crawford@randatmail.com',161-0629-81,5),
(27,'Alen','Kelly','a.kelly@randatmail.com',674-3877-77,1),
(28,'Tara','Perkins','t.perkins@randatmail.com',253-7671-47,5),
(29,'Walter','Grant','w.grant@randatmail.com',323-4513-95,7),
(30,'Michelle','Carroll','m.carroll@randatmail.com',838-9923-93,7)


drop table if EXISTS LoanApplication
CREATE TABLE LoanApplication (
  loan_id INT PRIMARY KEY,
  borrower_id INT,
  loanOfficer_id INT,
  CONSTRAINT FK_LoanApplication_Borrower FOREIGN KEY (borrower_id)
    REFERENCES Borrower(borrower_id),
  CONSTRAINT FK_LoanApplication_LoanOfficer FOREIGN KEY (loanOfficer_id)
    REFERENCES LoanOfficer(loanOfficer_id)
);

INSERT into LoanApplication(loan_id, borrower_id,loanOfficer_id)
values(1,2,1),
(2,4,3),
(3,6,5),
(4,8,7),
(5,10,9),
(6,12,11),
(7,14,13),
(8,16,15),
(9,18,17),
(10,20,19),
(11,22,21),
(12,24,23),
(13,26,25),
(15,28,27),
(16,1,2),
(17,3,4),
(18,5,6),
(19,7,8),
(20,9,10),
(21,11,12),
(22,13,14),
(23,15,16),
(24,17,18),
(25,19,20),
(26,21,22),
(27,23,24),
(28,25,26),
(14,27,28)


drop table if exists LoanPortfolio
CREATE TABLE LoanPortfolio (
  portfolioId INT PRIMARY KEY,
  loanId INT,
  loanAmount DECIMAL(10, 2),
  interestRate DECIMAL(4, 2),
  collateralType VARCHAR(50),
  loanStatus VARCHAR(50),
  loanStartDate DATE,
  loanEndDate DATE,
  
  CONSTRAINT FK_LoanPortfolio_LoanApplication FOREIGN KEY (loanId)
    REFERENCES LoanApplication(loan_id)
);

--Constraints for loanAmount and interestRate
ALTER TABLE LoanPortfolio
ADD CONSTRAINT CHK_LoanAmount CHECK (loanAmount BETWEEN 20000 AND 100000);

ALTER TABLE LoanPortfolio
ADD CONSTRAINT CHK_InterestRate CHECK (interestRate BETWEEN 10 AND 13);

ALTER TABLE LoanPortfolio
ADD BorrowerID INT,
CONSTRAINT FK_LoanPortfolio_BorrowerID
FOREIGN KEY (BorrowerID) REFERENCES Borrower(borrower_id);


INSERT INTO LoanPortfolio (portfolioId, loanId, loanAmount, interestRate, collateralType, loanStatus, loanStartDate, loanEndDate,BorrowerID)
VALUES 
  (1, 1, 50000.00, 11.50, 'Real Estate', 'Approved', '2022-01-01', '2022-12-31',2),
  (2, 3, 75000.00, 12.25, 'Automobile', 'Pending', '2022-02-01', '2023-01-31',6),
  (3, 5, 30000.00, 10.75, 'Real Estate', 'Approved', '2022-03-01', '2022-12-31',10),
  (4, 7, 40000.00, 11.00, 'Real Estate', 'Rejected', '2022-04-01', '2022-04-01',14),
  (5, 9, 90000.00, 12.50, 'Automobile', 'Approved', '2022-05-01', '2023-04-30',18),
  (6, 11, 55000.00, 10.25, 'Real Estate', 'Approved', '2022-06-01', '2023-05-31',22),
  (7, 13, 65000.00, 11.75, 'Automobile', 'Pending', '2022-07-01', '2022-12-31',26),
  (8, 15, 25000.00, 10.50, 'Real Estate', 'Approved', '2022-08-01', '2022-11-30',28),
  (9, 17, 70000.00, 12.00, 'Automobile', 'Approved', '2022-09-01', '2023-08-31',3),
  (10, 19, 35000.00, 10.75, 'Real Estate', 'Rejected', '2022-10-01', '2022-10-01',7),
  (11, 21, 80000.00, 12.25, 'Automobile', 'Approved', '2022-11-01', '2023-10-31',11),
  (12, 23, 45000.00, 11.00, 'Real Estate', 'Approved', '2022-12-01', '2023-11-30',15),
  (13, 25, 60000.00, 11.50, 'Automobile', 'Pending', '2023-01-01', '2023-12-31',19),
  (14, 27, 20000.00, 10.25, 'Real Estate', 'Approved', '2023-02-01', '2023-09-30',23),
  (15, 2, 85000.00, 12.50, 'Automobile', 'Approved', '2023-03-01', '2024-02-29',4),
  (16, 4, 50000.00, 10.75, 'Real Estate', 'Approved', '2023-04-01', '2024-03-31',8),
  (17, 6, 25000.00, 11.50, 'Real estate', 'Approved', '2023-01-01', '2023-12-31',12),
  (18, 8, 35000.00, 10.75, 'Automobile', 'Approved', '2023-02-01', '2023-12-31',16),
  (19, 10, 28000.00, 12.25, 'Real estate', 'Approved', '2023-03-01', '2023-12-31',20),
  (20, 12, 30000.00, 10.50, 'Automobile', 'Approved', '2023-04-01', '2023-12-31',24),
  (21, 14, 45000.00, 11.25, 'Real estate', 'Approved', '2023-05-01', '2023-12-31',27),
  (22, 16, 65000.00, 12.50, 'Real estate', 'Approved', '2023-06-01', '2023-12-31',1),
  (23, 18, 55000.00, 10.75, 'Real estate', 'Approved', '2023-07-01', '2023-12-31',5),
  (24, 20, 28000.00, 12.00, 'Automobile', 'Rejected', '2023-08-01', '2023-08-01',9),
  (25, 22, 32000.00, 11.00, 'Real estate', 'Approved', '2023-09-01', '2023-12-31',13),
  (26, 24, 28000.00, 11.50, 'Real estate', 'Approved', '2024-04-01', '2024-12-31',17),
  (27, 26, 42000.00, 12.25, 'Real estate', 'Approved', '2024-05-01', '2024-12-31',21),
  (28, 28, 55000.00, 10.50, 'Automobile', 'Rejected', '2024-06-01', '2024-06-01',25)


  drop table if exists paymentSchedule
  CREATE TABLE paymentSchedule (
  paymentId INT PRIMARY KEY,
  loanId INT,
  dueDate DATE,
  paymentAmount DECIMAL(10, 2),
  balance DECIMAL(10, 2),
  paymentStatus VARCHAR(50),
  FOREIGN KEY (loanId) REFERENCES LoanApplication (loan_id)
);

INSERT INTO paymentSchedule (paymentId, loanId, dueDate, paymentAmount, balance, paymentStatus)
SELECT 
  ROW_NUMBER() OVER (ORDER BY lp.loanId) AS paymentId,
  lp.loanId,
  DATEADD(day, 30, lp.loanStartDate) AS dueDate,
  ROUND(lp.loanAmount * (lp.interestRate / 12), 2) AS paymentAmount,
  ROUND(lp.loanAmount * (1 - (lp.interestRate / 12)), 2) AS balance,
  CASE
    WHEN (lp.loanAmount * (1 - (lp.interestRate / 12))) > 0 THEN 'In Process'
    ELSE 'Complete'
  END AS paymentStatus
FROM loanPortfolio lp
ORDER BY lp.loanId
OFFSET 0 ROWS FETCH NEXT 28 ROWS ONLY;


drop table if EXISTS LatePaymentPrediction
CREATE TABLE LatePaymentPrediction (
    PredictionID INT PRIMARY KEY,
    BorrowerID INT,
    LoanID INT,
    LatePaymentPrediction VARCHAR(10),
    FOREIGN KEY (BorrowerID) REFERENCES Borrower(borrower_id),
    FOREIGN KEY (LoanID) REFERENCES LoanPortfolio(portfolioId)
);

INSERT INTO LatePaymentPrediction (PredictionID, BorrowerID, LoanID, LatePaymentPrediction)
SELECT
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS PredictionID,
    b.borrower_id AS BorrowerID,
    lp.portfolioId AS LoanID,
    CASE
        WHEN bch.credit_score < 600 THEN 1
        WHEN bch.credit_score BETWEEN 600 AND 700 AND b.salary < 0.1 * lp.loanAmount THEN 1
        ELSE 0
    END AS LatePaymentPrediction
FROM
    Borrower b
    JOIN borrower_credit_history bch ON b.borrower_id = bch.borrower_id
    JOIN LoanPortfolio lp ON b.borrower_id = lp.BorrowerID
ORDER BY PredictionID;



-- Insert data into BorrowerLoanYears table
DROP TABLE IF EXISTS BorrowerLoanYears;

CREATE TABLE BorrowerLoanYears (
  YearId INT PRIMARY KEY,
  borrower_id INT,
  loanID INT,
  borrower_name VARCHAR(150),
  years DECIMAL(10,2) NULL,
  FOREIGN KEY (borrower_id) REFERENCES Borrower(borrower_id),
  FOREIGN KEY (loanID) REFERENCES LoanPortfolio(portfolioId)
);

INSERT INTO BorrowerLoanYears (YearId, borrower_id, loanID, borrower_name, years)
SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS YearId,
       b.borrower_id,
       lp.loanId,
       CONCAT(b.firstName, ' ', b.lastName),
       lp.loanAmount / (lp.interestRate * 100)
FROM LoanPortfolio lp
JOIN Borrower b ON lp.BorrowerID = b.borrower_id;



CREATE TABLE Avatars
(
    AvatarID INT PRIMARY KEY IDENTITY(1,1),
    ImageName NVARCHAR(255),
    ImageData VARBINARY(MAX)
)


INSERT INTO Avatars (ImageName)
values (1),(2)


CREATE TRIGGER check_borrower_credit_score
ON LoanApplication
AFTER INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  
  IF EXISTS (
    SELECT l.borrower_id
    FROM LoanApplication l
    JOIN inserted i ON l.borrower_id = i.borrower_id
    JOIN borrower_credit_history b ON l.borrower_id = b.borrower_id
    WHERE l.loan_id != i.loan_id
    AND b.credit_score_status = 'Poor'
  )
  BEGIN
    RAISERROR('Borrower Flag warning', 16, 1)
    ROLLBACK TRANSACTION
    RETURN
  END
END



ALTER TABLE LatePaymentPrediction
ADD COLUMN BorrowerName VARCHAR(255);

ALTER TABLE LatePaymentPrediction ADD BorrowerName VARCHAR(255);

UPDATE LatePaymentPrediction
SET BorrowerName = CONCAT(Borrower.FirstName, ' ', Borrower.LastName)
FROM Borrower
WHERE Borrower.borrower_id = LatePaymentPrediction.BorrowerID
AND LatePaymentPrediction.LatePaymentPrediction = 1;

CREATE PROCEDURE GetGenderDistribution
AS
BEGIN
    SELECT gender, COUNT(*) AS TotalCount
    FROM borrower
    GROUP BY gender
END

EXEC GetGenderDistribution



ALTER TABLE Borrower
ADD RowNum INT;

UPDATE Borrower
SET RowNum = ROW_NUMBER() OVER (ORDER BY borrower_id);

SELECT borrower_id, firstName, lastName, RowNum
FROM Borrower;
