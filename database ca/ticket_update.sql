USE my_databaseca;

-- 1
START TRANSACTION;
select *
from tickettype
join allevents on allevents.eventID=tickettype.ownereventID;
-- update the leftsubtickets in tickettype
UPDATE  tickettype
SET leftsubtickets = leftsubtickets + 100,
	totalsubtickets = totalsubtickets + 100
WHERE typeID=2 and typename = 'adult';
-- update the totalticket in allevents
UPDATE allevents 
SET totalticket = totalticket + 100 
WHERE eventID = (
    SELECT ownereventID FROM tickettype WHERE typename = 'adult'
);
select *
from tickettype
join allevents on allevents.eventID=tickettype.ownereventID;
rollback;

-- 2
START TRANSACTION; 
select customers.customerFName , customers.customerLName , booking.bookingID , booking.ticketNumber, booking.paymentstatue , booking.totalpayment as booking_payment , payorget_refund.paidcard as paid_card , card.money as left_monet , booking.bookingtime , booking.choice , ordering.ticketnumber , ordering.tickettype , tickettype.leftsubtickets
from customers
join booking on booking.reserverID=customers.customerID
join ordering on ordering.orderID=booking.bookingID
join tickettype on tickettype.typeID=ordering.typeID
join allevents on allevents.eventID = tickettype.ownereventID
join payorget_refund on payorget_refund.paidbooking=booking.bookingID
join card on card.cardNumber=payorget_refund.paidcard;
INSERT INTO customers(customerID,customerFName,customerLName,age,email,postcode)
VALUES(4,'Ian','Cooper',20,'122312121@outlook.com','EX55YY');
INSERT INTO card(cardNumber,safecode,enddate,cardType,onwerID,money)
VALUES(456322534,234,'2028-04-06','credit card',4,1400.5);
-- create the booking of Ian Cooper
INSERT INTO booking (bookingID,costumerName, ticketNumber, paymentstatue, totalpayment, eventname, eventID, bookingtime, reserverID, choice)
VALUES ('4','Ian Cooper', 3, 'unpaid',0, 'food festival', (
    SELECT eventID
    FROM allevents
    WHERE eventname = 'food festival'
), '2023-7-4', 4, 'email');
-- create the ordering of Ian Cooper
INSERT INTO ordering (tickettype,ticketnumber,orderID,typeID)
VALUES('adult',2,4,(
		select typeID
        FROM tickettype
        where typename='adult'
        ));
INSERT INTO ordering (tickettype,ticketnumber,orderID,typeID)
VALUES('children',1,4,(
		select typeID
        FROM tickettype
        where typename='children'
        ));
INSERT INTO payorget_refund(paidcard,discode,paidbooking)
VALUES(456322534,'FOOD10',4);
UPDATE booking
SET paymentstatue = 'paid', 
totalpayment = (((
				SELECT ordering.ticketnumber * eachprice AS result1
				FROM ordering
				JOIN tickettype ON tickettype.typeID=ordering.typeID
				WHERE tickettype.typename='adult' and tickettype.ownereventID=2 and ordering.orderID=4
				)+(SELECT ordering.ticketnumber * eachprice AS result2
				FROM ordering
				JOIN tickettype ON tickettype.typeID=ordering.typeID
				WHERE tickettype.typename='children' and tickettype.ownereventID=2 and ordering.orderID=4))
				*(SELECT (1-discount) AS discount1
				FROM discountcode
				WHERE codeforevent='FOOD10' and ownerevent=2
				)) 
WHERE booking.bookingID=4
;
UPDATE card
SET money = money - (select booking.totalpayment
						from booking
                        join payorget_refund on payorget_refund.paidbooking=booking.bookingID
                        where booking.bookingID=4 and payorget_refund.paidcard=456322534
						)
where card.onwerID=4 and card.cardNumber=456322534;
UPDATE tickettype
SET leftsubtickets = leftsubtickets - 2
WHERE typename = 'adult' AND ownereventID = (
    SELECT eventID
    FROM allevents
    WHERE eventname = 'food festival'
);
UPDATE tickettype
SET leftsubtickets = leftsubtickets - 1
WHERE typename = 'children' AND ownereventID = (
    SELECT eventID
    FROM allevents
    WHERE eventname = 'food festival'
);
select customers.customerFName , customers.customerLName , booking.bookingID , booking.ticketNumber, booking.paymentstatue , booking.totalpayment as booking_payment , payorget_refund.paidcard as paid_card , card.money as left_monet , booking.bookingtime , booking.choice , ordering.ticketnumber , ordering.tickettype , tickettype.leftsubtickets
from customers
join booking on booking.reserverID=customers.customerID
join ordering on ordering.orderID=booking.bookingID
join tickettype on tickettype.typeID=ordering.typeID
join allevents on allevents.eventID = tickettype.ownereventID
join payorget_refund on payorget_refund.paidbooking=booking.bookingID
join card on card.cardNumber=payorget_refund.paidcard;

DELETE
FROM payorget_refund
where discode='FOOD10';
DELETE
FROM discountcode
where codeforevent='FOOD10' and ownerevent = 2;

rollback;

-- 3
START TRANSACTION; 
 select *
from booking 
join payorget_refund on payorget_refund.paidbooking=booking.bookingID
join card on card.cardNumber=payorget_refund.paidcard;
UPDATE card
SET money = money + (select booking.totalpayment
						from booking
                        join payorget_refund on payorget_refund.paidbooking=booking.bookingID
                        where booking.bookingID=1)
where card.cardNumber=(select payorget_refund.paidcard
						from payorget_refund
                        join booking on booking.bookingID=payorget_refund.paidbooking
                        where booking.bookingID=1)
;
UPDATE booking b
SET paymentstatue = 'refunded',
	totalpayment = 0
WHERE b.costumerName = 'Joe Smiths' and bookingID=1
;
UPDATE tickettype
SET leftsubtickets = leftsubtickets+(select ticketnumber
									from ordering
									where ordering.orderID=(select bookingID
															from booking
															where bookingID=1) )
where tickettype.typeID = (select ordering.typeID
						from ordering
                        where ordering.orderID=(select bookingID
												from booking 
                                                where bookingID=1))
;
DELETE
FROM ordering
where ordering.orderID=(select bookingID
						from booking
                        where bookingID=1);
 select *
from booking 
join payorget_refund on payorget_refund.paidbooking=booking.bookingID
join card on card.cardNumber=payorget_refund.paidcard;
rollback;



-- 4
START TRANSACTION; 
select *
from discountcode;
INSERT INTO discountcode (codeforevent, discount, ownerevent)
VALUES ('SUMMER20', 0.2, (
    SELECT eventID
    FROM allevents
    WHERE eventname = 'concert'
));
select *
from discountcode;
rollback;