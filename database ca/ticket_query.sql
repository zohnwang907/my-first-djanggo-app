USE my_databaseca;
-- 1
select allevents.location, allevents.eventname,allevents.descriptions,allevents.startdate,allevents.enddate,tickettype.totalsubtickets,tickettype.typename
FROM allevents
LEFT JOIN tickettype ON allevents.eventID = tickettype.ownereventID;
-- 2
select *
FROM allevents
WHERE
allevents.startdate between '2023-7-1' and '2023-7-08';
-- 3
select tickettype.typename,tickettype.eachprice,tickettype.leftsubtickets
FROM tickettype
WHERE
tickettype.typename='bronze';
-- 4
select booking.costumerName,ordering.ticketnumber,eventname,ordering.tickettype
FROM booking
JOIN ordering ON ordering.orderID=booking.bookingID
JOIN tickettype ON ordering.typeID=tickettype.typeID
WHERE
tickettype.typename='gold'
;
-- 5
SELECT ae.eventname, tt.typename AS ticket_type, SUM(ordering.ticketnumber) AS sold_out_tickets
FROM allevents ae
LEFT JOIN tickettype tt ON ae.eventID = tt.ownereventID
JOIN ordering ON ordering.typeID = tt.typeID
GROUP BY ae.eventname, tt.typename
ORDER BY sold_out_tickets DESC;

-- 6
SELECT *
FROM booking
JOIN ordering ON ordering.orderID=booking.bookingID;
-- 7
SELECT ae.eventname, SUM(totalpayment) AS total_revenue
FROM (
    SELECT b.eventID, b.totalpayment
    FROM booking b
    JOIN ordering o ON b.bookingID = o.orderID
    GROUP BY b.bookingID
) AS sub
JOIN allevents ae ON sub.eventID = ae.eventID
GROUP BY ae.eventname
ORDER BY total_revenue DESC;
