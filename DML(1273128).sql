use TourAndTravelMangementSystem
Insert into CompanyAgent(AgentID,AgentName)
values(2001,'Rafi'),
	  (2002,'Nijam'),
	  (2003,'Alif'),
	  (2004,'Sujad'),
	  (2005,'Tahomim'),
	  (2006,'Nahid'),
	  (2007,'jakir');
Select* From CompanyAgent;
go
Insert into Customer(CustomerID,CustomerName,CustomerAddress)
	  Values('ElonMusk001','Elon Musk','1835 73rd Ave NE, Medina,Washington,USA'),
			('Bill Gates002','Bill Gates','3500 Deer Creek Road, Palo Alto, CA 94304 United States.'),
			('Sachin Tendulkar003','Sachin Tendulkar','19-A, Perry Cross Road, Bandra (West), Mumbai, Maharashtra,India'),
			('Mohammed bin Salman Al Saud004','Mohammed bin Salman Al Saud','Riyadh 11586. Kingdom of Saudi Arabia.'),
			('Shakib Al Hasan005','Shakib Al Hasan',' 18/5 Ahsanullah Road, Badamtoli, , Dhaka, Dhaka Division,Bangladesh'),
			('Vladimir Putin006','Vladimir Putin','Black Sea coast near Gelendzhik, Krasnodar Krai, Russia.'),
			('Cillian Murphy007','Cillian Murphy',' Lisa Richards Agency 108 Leeson Street Upper Dublin 4. D04 E3E7 Ireland');
GO
Select*From Customer
Insert into Booking(BookingID,BookingStatus,DateofBooking,customerID,AgentID)
Values(1,'confirmed','2020-03-05','ElonMusk001',2001),
	  (2,'confirmed','2020-05-07','Bill Gates002',2002),
	  (3,'cancelled','2020-07-16','Sachin Tendulkar003',2003),
	  (4,'pending','2021-01-12','Mohammed bin Salman Al Saud004',2004),
	  (5,'confirmed','2021-03-17','Shakib Al Hasan005',2005),
	  (6,'cancelled','2021-04-13','Vladimir Putin006',2006),
	  (7,'pending','2021-09-27','Cillian Murphy007',2007);
Go
Insert into [Services](ServiceID,ServiceDetails,ResturantDetails,TransportMode,BookingID)
		Values(10,'Deluxe','American','Air',1),
			  (20,'Deluxe','American','Driving',2),
			  (30,'Regular','Indian','Air',3),
			  (40,'Economy','Bangla','Ship',4),
			  (50,'Deluxe','Mexican','Air',5),
			  (60,'Regular','Thai','Train',6),
			  (70,'Delux','Italian','Ship',7);
Go
Insert into Payments(PaymentID,PaymentAmount,paymentDate,PaymentMode,BookingID)
values(11,50000,'2020-03-05','CreditCard',1),
	  (12,40000,'2020-05-07','CreditCard',2),
	  (13,30000,'2020-07-16','Cash',3),
	  (14,50000,'2021-01-12','Internet Banking',4),
	  (15,35000,'2021-03-17','DebitCard',5),
	  (16,45000,'2021-04-13','Check',6),
	  (17,55000,'2021-09-27','EMI',7);
Go

Go
select*From CompanyAgent
select*From Customer
Select*From Booking
Select*From [Services]
Select*From Payments
-----To Calculate the total recived payment for total number off booking.
Select SUM(Payments.PaymentAmount) as TotalReceived
From Payments
Go
------Cheak Booking Status----
Select Booking.BookingStatus
From Booking
Where Booking.BookingID = 4
Go
-----Cheak Service And Payments Details----
Select [Services].BookingID,[Services].ServiceID,[Services].ServiceDetails,
Payments.PaymentMode from [Services] left join Payments
on [Services].BookingID = Payments.BookingID
order by BookingID,ServiceID asc;
Go
------Add New Booking---
Insert Into Booking(BookingID,BookingStatus,DateofBooking,customerID,AgentID)
values(8,'confirmed','2021-09-27','Hridoy Sheikh008',2009);
GO
-----Update Booking--
Update Booking
Set BookingStatus = 'confirmed'
Where bookingID = 6
Go
---Case Function---
Select [Services].ServiceDetails,
Case
When [Services].ServiceDetails ='Deluxe' Then '5star'
when[Services].ServiceDetails = 'Regular' Then '2star'
Else '3star'
End as Comments from [Services] 
------Useing Subquery to Find out Who Going In Air-----
Select Customer.CustomerName
From Customer
Where customerID IN 
(Select CustomerID From Booking
JOIN [Services] ON Booking.BookingID = [Services].BookingID Where [Services].TransportMode = 'Air');
GO
----Delete Booking----
Delete From Booking
WHERE BookingStatus = 'cancelled'

----Calculate Total Revenue-----
Select SUM(Payments.PaymentAmount) as TotalRevenue
From Payments
------Calculate Booking----
Select COUNT(*) as TotalBooking
From Booking
------summey query------
Select Customer.CustomerName, COUNT(Booking.BookingID) as NumberOfBookings
From Customer
JOIN Booking ON Customer.customerID = Booking.customerID
Group by Customer.CustomerName
Go
-----CTE----
With BookingID as(
    Select CustomerID, bookingID
    From Booking
    Where BookingStatus = 'cancelled'
)
Delete From Payments
Where BookingID IN (Select BookingID From Booking)
Go
------ Merge -------
Create Table Candidate(
	ID Int Primary Key NOT NULL,
	Name Varchar(50)
);

Insert Into Candidate(ID,Name) 
Values (1,'Raihan'),(2,'Koli'),(3,'Kulsum');

Create Table Person(
	ID Int Primary Key NOT NULL,
	Name Varchar(50),
	Age Int
);
Insert Into Person(ID,Name,Age) 
Values (1,'Raihan', 22),(2,'Koli', 24),(3,'Kulsum', 27);

Merge Into Person As P
Using Candidate As C On P.ID=C.ID
when Matched Then
Update Set P.Name=C.Name
When Not Matched THEN 
Insert (ID,Name,Age)
VALUES (C.ID,C.Name,22);

Select * From Person;
Go