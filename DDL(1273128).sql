Drop Database TourAndTravelMangementSystem
Create Database TourAndTravelMangementSystem

on primary
(
		Name='TourAndTravelMangementSystem_Data_1',
		FileName='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\TourAndTravelMangementSystem_Data_1.mdf',
		Size=25mb,
		Maxsize=100mb,
		Filegrowth=5%
)
Log on
(
		Name='TravelAndTour_Log_1',
		FileName='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Data\TourAndTravelMangementSystem_Log_1.ldf',
		Size=2mb,
		Maxsize=50mb,
		Filegrowth=1mb
)
Go
Use TourAndTravelMangementSystem

-----Company Agent----
Drop Table CompanyAgent
Create Table CompanyAgent(
AgentID int Primary Key not null,
AgentName Varchar(30)
);
----Customer---
drop Table Customer
Create Table Customer(
CustomerID varchar(30) primary key not null,
CustomerName varchar(30),
CustomerAddress varchar(100)
);
----Booking---
Drop Table Booking
Create Table Booking(
BookingID int primary key not null,
BookingStatus varchar(30),
DateofBooking Date Not null,
customerID varchar(30) references Customer(customerID),
AgentID int references CompanyAgent(AgentID),
);
---Services---
Drop Table Services
Create Table [Services](
ServiceID int primary key not null,
ServiceDetails varchar(30),
ResturantDetails varchar(30),
TransportMode varchar(30),
BookingID int references Booking(BookingID),
);
----Payments---
Drop table Payments
Create table Payments(
PaymentID int primary key not null,
PaymentAmount money,
paymentDate Date Not null,
PaymentMode Char(30)Not null,
BookingID int references Booking(BookingID),
);
go
----view----
Create view BookingView AS
Select Booking.BookingStatus, Customer.CustomerName, Booking.DateofBooking, Booking.BookingID
From Booking
JOIN Customer ON Booking.customerID = Customer.customerID
Go
Select * From BookingView
Where BookingStatus = 'pending'
Go
------stored procedure----
Create Procedure UpdateBookingStatus
    @BookingID Int,
    @Bookingstatus Varchar(20)
as
Begin
    Update Booking
    Set @Bookingstatus = @Bookingstatus
    Where @BookingID = @BookingID

End
Exec UpdateBookingStatus 6, 'confirmed'
Go
--------In Parameter-----
Create Procedure InsertCustomer
    @customerID varchar(30),
    @CustomerName varchar(30),
    @CustomerAddress Varchar(100)
as
Begin
    Insert into Customer(CustomerID,CustomerName,CustomerAddress)
    values (@CustomerID, @CustomerName ,@CustomerAddress)
end
Exec InsertCustomer 'Farhan008','Farhan Ahmed','19/6 Aruapara Abulzolil road'
Go
-------Out Parameter-----
Create Procedure GetTotalRevenue
as
Begin
    Select SUM(PaymentAmount) as TotalRevenue
    From Payments
End
Exec GetTotalRevenue 
GO
-----Delete store procedure--
DROP Procedure UpdateBookingStatus
Go
---Trigger----
Create Trigger UpdateBookingModified
On Booking
After Update
As
Begin
    Update Booking
    Set BookingStatus = Getdate()
    Where bookingID IN (Select bookingID From deleted)
End
Go
------AfterDeleteTrigger-----
Create Trigger archive_deleted_Customer
ON Customer
After Delete
As
Begin
    Insert Into Customer_archive 
		(CustomerID,  CustomerName, CustomerAddress)
	Select CustomerID, CustomerName, CustomerAddress
		From Deleted
END;

DELETE Customer
WHERE CustomerName = 'Elon Musk';
Go
-------Raise Error-----
Create Trigger dbo.Customer
	On Customer
	Instead Of Update
	As
	Begin
		Declare @CustomerID varchar(30), @CustomerName varchar(30), @CustomerAddress varchar(30)
		Select  @CustomerID=c.CustomerID,
				@CustomerName= c.CustomerName,
				@CustomerAddress = c.CustomerAddress
			
		From Customer as c
		if UPDATE(CustomerID)
		Begin
			Raiserror('Your input cannot be updated.', 16 ,1)
			ROllback
		End
		Else
		Begin
		  Update [Customer]
		  Set @CustomerID = @CustomerID
		  Where CustomerID = @CustomerID
		End
	End
GO
--------Scalar-value function------
Create Function get_customer_total_payment  (@CustomerID varchar(30))
Returns Money
As
Begin
    Declare @total_payment Money
    Select @total_payment = sum(PaymentAmount)
    From payments
    Where @CustomerID = @CustomerID
    Return @total_payment
End


GO
------Table Value Function---
Create Function get_customer_payments (@CustomerID varchar(30))
Returns Table
AS
Return (
    Select paymentid, PaymentAmount, paymentDate
    From payments
    Where @CustomerID = @CustomerID
)
GO
SELECT * FROM get_customer_payments(1)
Go
------Multi-Statement Table Valued Functions---
Create Function get_customer_payment_tour_details (@CustomerID Varchar(30))
Returns @result table (paymentid int, PaymentAmount money, paymentdate Date)
as
Begin
    Insert into @result
    select p.paymentid, p.PaymentAmount, p.paymentDate
    From payments p
    INNER JOIN Customer ON p.PaymentID = p.PaymentID
    Where Customer.CustomerID = @CustomerID
    Return
end
go
