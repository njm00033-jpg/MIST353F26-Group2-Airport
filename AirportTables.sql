
/*
Group 2 Airline Database
MIST 353
SQL Server
*/

-- DROP TABLES

IF OBJECT_ID('UserFlightManagement', 'U') IS NOT NULL
    DROP TABLE UserFlightManagement;

IF OBJECT_ID('Ticket', 'U') IS NOT NULL
    DROP TABLE Ticket;

IF OBJECT_ID('FlightSchedule', 'U') IS NOT NULL
    DROP TABLE FlightSchedule;

IF OBJECT_ID('Flight', 'U') IS NOT NULL
    DROP TABLE Flight;

IF OBJECT_ID('Passenger', 'U') IS NOT NULL
    DROP TABLE Passenger;

IF OBJECT_ID('AppUser', 'U') IS NOT NULL
    DROP TABLE AppUser;

IF OBJECT_ID('Gate', 'U') IS NOT NULL
    DROP TABLE Gate;

IF OBJECT_ID('Airplane', 'U') IS NOT NULL
    DROP TABLE Airplane;

IF OBJECT_ID('Airport', 'U') IS NOT NULL
    DROP TABLE Airport;


-- CREATE AIRPORT TABLE

CREATE TABLE Airport (
    AirportID INT PRIMARY KEY,
    AirportName VARCHAR(100) NOT NULL,
    AirportCity VARCHAR(50) NOT NULL,
    AirportState VARCHAR(50),
    AirportCountry VARCHAR(50) NOT NULL
);


-- CREATE GATE TABLE

CREATE TABLE Gate (
    GateID INT PRIMARY KEY,
    GateCode VARCHAR(10) NOT NULL,
    Terminal VARCHAR(20) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    AirportID INT NOT NULL,

    CONSTRAINT FK_Gate_Airport
        FOREIGN KEY (AirportID)
        REFERENCES Airport(AirportID),

    CONSTRAINT CHK_Gate_Status
        CHECK (Status IN ('Available', 'Occupied', 'Closed')),

    CONSTRAINT UQ_Gate_Airport_Code
        UNIQUE (AirportID, Terminal, GateCode)
);


-- CREATE AIRPLANE TABLE

CREATE TABLE Airplane (
    AirplaneID INT PRIMARY KEY,
    AirplaneModel VARCHAR(50) NOT NULL,
    AirplaneManufacturer VARCHAR(50) NOT NULL,
    AirplaneSeatCapacity INT NOT NULL,

    CONSTRAINT CHK_Airplane_Capacity
        CHECK (AirplaneSeatCapacity > 0)
);


-- CREATE USER TABLE

CREATE TABLE AppUser (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(100) NOT NULL,
    UserEmail VARCHAR(100) NOT NULL UNIQUE,
    UserRole VARCHAR(30) NOT NULL,
    UserActiveStatus BIT NOT NULL DEFAULT 1
);


-- CREATE PASSENGER TABLE

CREATE TABLE Passenger (
    PassengerID INT PRIMARY KEY,
    PassengerFirstName VARCHAR(50) NOT NULL,
    PassengerLastName VARCHAR(50) NOT NULL,
    PassengerEmail VARCHAR(100) NOT NULL,
    PassengerPhone VARCHAR(20),
    PassengerDoB DATE NOT NULL
);


-- CREATE FLIGHT TABLE

CREATE TABLE Flight (
    FlightID INT PRIMARY KEY,
    FlightStatus VARCHAR(20) NOT NULL,
    GateID INT NOT NULL,
    AirplaneID INT NOT NULL,

    CONSTRAINT FK_Flight_Gate
        FOREIGN KEY (GateID)
        REFERENCES Gate(GateID),

    CONSTRAINT FK_Flight_Airplane
        FOREIGN KEY (AirplaneID)
        REFERENCES Airplane(AirplaneID),

    CONSTRAINT CHK_Flight_Status
        CHECK (FlightStatus IN
            ('Scheduled', 'Delayed', 'Cancelled'))
);


-- CREATE FLIGHT SCHEDULE TABLE

CREATE TABLE FlightSchedule (
    FlightScheduleID INT PRIMARY KEY,
    FlightID INT NOT NULL,
    DepartureAirportID INT NOT NULL,
    ArrivalAirportID INT NOT NULL,
    DepartureDate DATE NOT NULL,
    DepartureTime TIME NOT NULL,
    ArrivalDate DATE NOT NULL,
    ArrivalTime TIME NOT NULL,

    CONSTRAINT FK_Schedule_Flight
        FOREIGN KEY (FlightID)
        REFERENCES Flight(FlightID),

    CONSTRAINT FK_Schedule_DepartureAirport
        FOREIGN KEY (DepartureAirportID)
        REFERENCES Airport(AirportID),

    CONSTRAINT FK_Schedule_ArrivalAirport
        FOREIGN KEY (ArrivalAirportID)
        REFERENCES Airport(AirportID),

    CONSTRAINT CHK_Schedule_Airports
        CHECK (DepartureAirportID <> ArrivalAirportID),

    CONSTRAINT CHK_Schedule_Times
        CHECK (
            ArrivalDate > DepartureDate
            OR (
                ArrivalDate = DepartureDate
                AND ArrivalTime > DepartureTime
            )
        )
);


-- CREATE TICKET TABLE

CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY,
    FlightScheduleID INT NOT NULL,
    PassengerID INT NOT NULL,
    TicketSeatNumber VARCHAR(10) NOT NULL,
    TicketPurchaseDate DATE NOT NULL,

    CONSTRAINT FK_Ticket_FlightSchedule
        FOREIGN KEY (FlightScheduleID)
        REFERENCES FlightSchedule(FlightScheduleID),

    CONSTRAINT FK_Ticket_Passenger
        FOREIGN KEY (PassengerID)
        REFERENCES Passenger(PassengerID),

    CONSTRAINT UQ_Ticket_Schedule_Seat
        UNIQUE (FlightScheduleID, TicketSeatNumber)
);


-- CREATE USER FLIGHT MANAGEMENT TABLE

CREATE TABLE UserFlightManagement (
    UserID INT NOT NULL,
    FlightID INT NOT NULL,

    PRIMARY KEY (UserID, FlightID),

    CONSTRAINT FK_Management_User
        FOREIGN KEY (UserID)
        REFERENCES AppUser(UserID),

    CONSTRAINT FK_Management_Flight
        FOREIGN KEY (FlightID)
        REFERENCES Flight(FlightID)
);
