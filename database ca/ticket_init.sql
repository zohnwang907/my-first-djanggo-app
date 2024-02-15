
USE my_databaseca;


DROP TABLE IF EXISTS customers;
CREATE TABLE IF NOT EXISTS  customers(
customerID INT PRIMARY KEY,
customerFName VARCHAR(50),
customerLName VARCHAR(50),
age INT,
email VARCHAR(50),
postcode VARCHAR(255)
); 
insert into `customers`(`customerID`,`customerFName`,`customerLName`,`age`,`email`,`postcode`)values
(1, 'Joe', 'Smiths', 18, '07400@outlook.com', 'EX4TT'),
(2, 'Ethan', 'Miller', 21, '074122@outlook.com', 'EX4HY'),
(3, 'Ava', 'Johnson', 29, '111222@outlook.com', 'EX3GG');

DROP TABLE IF EXISTS card;
CREATE TABLE IF NOT EXISTS card(
cardNumber INT(10) PRIMARY KEY,
safecode INT,
enddate DATE,
cardType VARCHAR(50),
onwerID INT,
money decimal(20,2),
FOREIGN KEY(onwerID) REFERENCES `customers` (`customerID`)
);
insert into `card`(`cardNumber`,`safecode`,`enddate`,`cardType`,`onwerID`,`money`)VALUES
(345559876, 345, '2029-06-29','credit card',1,1000.5),
(453625676, 567, '2029-09-25','debit card',2,2000.4),
(453613313, 323, '2029-07-30','debit card',3,1589.4);

DROP TABLE IF EXISTS `booking`;
CREATE TABLE IF NOT EXISTS booking(
bookingID INT PRIMARY KEY,
costumerName VARCHAR(55),
ticketNumber INT,
paymentstatue VARCHAR(10),
totalpayment DECIMAL(5,2),
eventname VARCHAR(55),
eventID INT,
bookingtime DATE,
reserverID INT,
choice VARCHAR(55),
FOREIGN KEY(reserverID) REFERENCES `customers`(`customerID`)
);
insert into `booking`(`bookingID`,`costumerName`,`ticketNumber`,`paymentstatue`,`totalpayment`,`eventname`,`eventID`,`bookingtime`,`reserverID`,`choice`)VALUES
(1,'Joe Smiths',1,'yes',7.0,'show',1,'2023-11-28',1,'email'),
(2,'Ethan Miller',1,'yes',6.0,'food festival',2,'2023-06-07',2,'email'),
(3,'Ava Johnson',1,'yes',5.0,'concert','3','2023-07-01',3,'email');

DROP TABLE IF EXISTS `allevents`;
CREATE TABLE IF NOT EXISTS allevents(
eventID INT PRIMARY KEY,
eventname VARCHAR(55),
startdate DATE,
enddate DATE,
totalticket INT,
location VARCHAR(255),
descriptions VARCHAR(255)
);
insert into `allevents`(`eventID`,`eventname`,`startdate`,`enddate`,`totalticket`,`location`,`descriptions`)VALUES
(1,'show','2023-12-08','2023-12-09',5,'EX44TT','show for public'),
(2,'food festival','2023-07-09','2023-07-09',6,'EX44AE','for public'),
(3,'concert','2023-07-08','2023-07-08',5,'EX44TT','concert for public');


DROP TABLE IF EXISTS `tickettype`;
CREATE TABLE IF NOT EXISTS tickettype(
typeID INT AUTO_INCREMENT PRIMARY KEY,
typename VARCHAR(50),
eachprice INT,
totalsubtickets INT,
leftsubtickets INT,
ownereventID INT,
FOREIGN KEY(ownereventID) REFERENCES allevents(eventID)
);
insert into `tickettype`(`typename`,`eachprice`,`totalsubtickets`,`leftsubtickets`,`ownereventID`)VALUES
('normal',7,5,4,1),
('adult',6,4,3,2),
('children',4,2,2,2),
('gold',5,2,1,3),
('silver',4,2,2,3),
('bronze',3,1,1,3);

DROP TABLE IF EXISTS `ordering`;
CREATE TABLE IF NOT EXISTS ordering(
tickettype VARCHAR(55),
ticketnumber INT,
orderID INT,
typeID INT,
FOREIGN KEY(orderID) REFERENCES booking(bookingID),
FOREIGN KEY(typeID) REFERENCES tickettype(typeID)
);
insert into `ordering`(`tickettype`,`ticketnumber`,`orderID`,`typeID`)VALUES
('normal',1,1,1),
('adult',1,2,2),
('gold',1,3,4);


DROP TABLE IF EXISTS `discountcode`;
CREATE TABLE IF NOT EXISTS discountcode(
codeforevent VARCHAR(50) primary key,
discount decimal(5,2),
ownerevent INT,
FOREIGN KEY(ownerevent) REFERENCES allevents(eventID)
);
insert into `discountcode`(`codeforevent`,`discount`,`ownerevent`)VALUES
('show1',0.1,1),
('FOOD10',0.1,2),
('concert11',0.1,3);

DROP TABLE IF EXISTS `payorget_refund`;
CREATE TABLE IF NOT EXISTS payorget_refund(
paidcard INT(10),
discode VARCHAR(50),
paidbooking INT,
FOREIGN KEY(paidcard) REFERENCES card(cardNumber),
FOREIGN KEY(discode) REFERENCES discountcode(codeforevent),
FOREIGN KEY(paidbooking) REFERENCES booking(bookingID)
);
insert into payorget_refund (paidcard,paidbooking)VALUES
(345559876,1),
(453625676,2),
(453613313,3);
