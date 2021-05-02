CREATE TABLE Author ( 
ID BIGINT IDENTITY,
[FirstName] NVARCHAR (255), 
[LastName] NVARCHAR  (255), 
[BirthDay] DATE,
PRIMARY KEY (ID) ) 

GO 

CREATE TABLE Books ( 
[AuthorID] BIGINT not null FOREIGN KEY REFERENCES Author(ID), 
[ISBN13] BIGINT not null, 
[Title] NVARCHAR (255) not null, 
[Language] NVARCHAR (255) not null, 
[Release_Date] DATE not null,
[Price] BIGINT not null, 
PRIMARY KEY (ISBN13) )
 
GO

CREATE TABLE Stores ( 
[StoreID] BIGINT IDENTITY, 
[Postal_Code] BIGINT, 
[Address] NVARCHAR (255), 
[City] NVARCHAR (255), 
[Store_Name] NVARCHAR (255), 
PRIMARY KEY (StoreID) ) 

GO

CREATE TABLE StockBalance (
[Store_ID] BIGINT not null FOREIGN KEY REFERENCES Stores (StoreID), 
[ISBN] BIGINT not null FOREIGN KEY REFERENCES Books (ISBN13)
PRIMARY KEY ( ISBN, Store_ID),
[Quantity_Books] BIGINT not null ) 

GO 

CREATE TABLE Customer ( 
ID BIGINT IDENTITY, 
PRIMARY KEY (ID), 
[User_Name] NVARCHAR (255), 
[Password] NVARCHAR (255), 
[FirstName] NVARCHAR (255), 
[LastName] NVARCHAR (255), 
[Email_Address] NVARCHAR (255) )

GO
 
CREATE TABLE Orders ( 
ID BIGINT IDENTITY, 
PRIMARY KEY (ID), 
[StoreID] BIGINT not null FOREIGN KEY REFERENCES Stores (StoreID), 
[Customer_ID] BIGINT not null FOREIGN KEY REFERENCES customer (ID),
[Date] DATE, 
[SellerID] BIGINT, 
[shipping_Fee] BIGINT, 
[Address] NVARCHAR (255), 
[City] NVARCHAR (255), 
[Region] NVARCHAR (255), 
[Postal_Code] BIGINT, 
[Country] NVARCHAR (255) ) 

GO

CREATE TABLE Publisher (
ID BIGINT not null IDENTITY FOREIGN KEY REFERENCES Books(ISBN13), 
[Name] NVARCHAR (255), 
[Description] NVARCHAR (255), 
[Telephone_number] BIGINT, 
[Email] NVARCHAR (255),
PRIMARY KEY (ID) )

GO 

CREATE TABLE OrderDetails (
[ProductID] BIGINT not null FOREIGN KEY REFERENCES Books(ISBN13), 
[OrderID] BIGINT not null FOREIGN KEY REFERENCES Orders (ID), 
[Product_Price] BIGINT, 
[Product_Quantity] BIGINT, 
[Discount_Code] BIGINT,
PRIMARY KEY (ProductID, OrderID) )

GO

INSERT INTO Stores
([Postal_Code], [Address], [City], [Store_Name])
VALUES
(44212, 'Kongevigatan 2', 'Kungälv', 'Direkten'),
(76248, 'Jortgatan 3', 'Stenugnsund', 'Willys'),
(44235, 'Sveagatan 3', 'Göteborg', 'Coop');

GO

INSERT INTO Author
([FirstName], [LastName],[BirthDay])
VALUES
('John', 'Doe', '2000-01-01'),
('Donald', 'Trump', '1999-01-02'),
('Juize', 'Dre', '1996-01-03'),
('Ben', 'Affleck', '1980-01-04');

GO

INSERT INTO Books
([AuthorID], [ISBN13], [Title], [Language], [Release_Date], [Price])
VALUES
(1, 1234567890123, 'Kapten Kalsong', 'Engelska', '2002-01-03', 400),
(1, 2234567890123, 'Batman', 'Engelska', '2002-01-03', 400),
(2, 3234567890123, 'Superman', 'Engelska', '2002-01-03', 250),
(3, 4234567890123, 'Darkseid', 'Engelska', '2002-01-03', 600),
(4, 5234567890123, 'Flash', 'Engelska', '2002-01-03', 200),
(2, 6234567890123, 'Thanos', 'Engelska', '2002-01-03', 500),
(4, 7234567890123, 'Spiderman', 'Engelska', '2002-01-03', 300),
(3, 8234567890123, 'Wolverine', 'Engelska', '2002-01-03', 300),
(4, 9234567890123, 'Magneto', 'Engelska', '2002-01-03', 100),
(1, 0234567890123, 'Scarlet', 'Engelska', '2002-01-03', 50);

GO

-- Butik 1 --
INSERT INTO StockBalance
([ISBN], [Store_ID], [Quantity_Books])
VALUES
(1234567890123, 1, 40),
(2234567890123, 1, 60),
(3234567890123, 1, 30),
(4234567890123, 1, 70),
(5234567890123, 1, 40),
(6234567890123, 1, 70),
(7234567890123, 1, 20),
(8234567890123, 1, 10),
(9234567890123, 1, 20),
(0234567890123, 1, 40)

GO

-- Butik 2 --
INSERT INTO StockBalance
([ISBN], [Store_ID], [Quantity_Books])
VALUES
(1234567890123, 2, 45),
(2234567890123, 2, 40),
(3234567890123, 2, 20),
(4234567890123, 2, 70),
(5234567890123, 2, 30),
(6234567890123, 2, 50),
(7234567890123, 2, 20),
(8234567890123, 2, 10),
(9234567890123, 2, 20),
(0234567890123, 2, 40)

GO

-- Butik 3 --
INSERT INTO StockBalance
([ISBN], [Store_ID], [Quantity_Books])
VALUES
(1234567890123, 3, 20),
(2234567890123, 3, 30),
(3234567890123, 3, 40),
(4234567890123, 3, 50),
(5234567890123, 3, 60),
(6234567890123, 3, 20),
(7234567890123, 3, 30),
(8234567890123, 3, 40),
(9234567890123, 3, 50),
(0234567890123, 3, 20)

GO

CREATE VIEW [TitlesPerAuthor] AS
SELECT CONCAT(FirstName, ' ', LastName) AS [Name],
CAST((DATEDIFF(m, BirthDay, GETDATE())/12) AS VARCHAR) AS Age,
COUNT( Distinct ISBN13) AS Titles,
SUM(Price * Quantity_Books) AS StockValue
FROM Author
JOIN Books ON Books.AuthorID = Author.ID
JOIN StockBalance ON Books.ISBN13 = Stockbalance.ISBN
JOIN Stores ON Stores.StoreID = StockBalance.Store_ID

GROUP BY [ID], [FirstName],[LastName],[BirthDay]