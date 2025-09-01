IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'AssetManagementSystemDB')
BEGIN
    CREATE DATABASE AssetManagementSystemDB;
END
GO
USE AssetManagementSystemDB;
GO

CREATE TABLE landlord
(landlord_id INT IDENTITY PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50),
email VARCHAR(100) UNIQUE NOT NULL,
telephone VARCHAR(20) UNIQUE NOT NULL,
password_hash VARCHAR(255) NOT NULL);

CREATE TABLE property_type
(property_type_id INT IDENTITY PRIMARY KEY,
property_type_description VARCHAR(100) NOT NULL);

CREATE TABLE tenant
(tenant_id INT IDENTITY PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50),
email VARCHAR(100) UNIQUE NOT NULL,
telephone VARCHAR(20) UNIQUE NOT NULL);

CREATE TABLE expense_type
(expense_type_id INT IDENTITY PRIMARY KEY,
expense_type_description VARCHAR(200) NOT NULL);

CREATE TABLE property
(property_id INT IDENTITY PRIMARY KEY,
property_address VARCHAR(100) UNIQUE NOT NULL,
city VARCHAR(50) NOT NULL,
postcode VARCHAR(10) NOT NULL,
property_type_id INT FOREIGN KEY REFERENCES property_type(property_type_id),
landlord_id INT FOREIGN KEY REFERENCES landlord(landlord_id));

CREATE TABLE payment
(payment_id INT IDENTITY PRIMARY KEY,
payment_frequency VARCHAR(50) NOT NULL);

CREATE TABLE payment_method
(payment_method_id INT IDENTITY PRIMARY KEY,
method VARCHAR(50) NOT NULL);

CREATE TABLE expense
(expense_id INT IDENTITY PRIMARY KEY,
expense_description VARCHAR(200) NOT NULL,
expense_amount MONEY NOT NULL,
expense_date SMALLDATETIME NOT NULL,
expense_type_id INT FOREIGN KEY REFERENCES expense_type(expense_type_id),
property_id INT FOREIGN KEY REFERENCES property(property_id));

CREATE TABLE contract
(contract_id INT IDENTITY PRIMARY KEY,
date_signed DATE NOT NULL,
start_date DATE NOT NULL,
expiry_date DATE NOT NULL,
first_payment_date DATE NOT NULL,
weekly_rental_amount MONEY NOT NULL,
payment_id INT FOREIGN KEY REFERENCES payment(payment_id),
property_id INT FOREIGN KEY REFERENCES property(property_id),
payment_method_id INT FOREIGN KEY REFERENCES payment_method(payment_method_id));

CREATE TABLE tenant_payment
(tenant_payment INT IDENTITY PRIMARY KEY,
payment_date SMALLDATETIME NOT NULL,
payment_amount MONEY NOT NULL,
tenant_id INT FOREIGN KEY REFERENCES tenant(tenant_id),
contract_id INT FOREIGN KEY REFERENCES contract(contract_id),
payment_method_id INT FOREIGN KEY REFERENCES payment_method(payment_method_id));

CREATE TABLE tenant_contract
(contract_id INT FOREIGN KEY REFERENCES contract(contract_id),
tenant_id INT FOREIGN KEY REFERENCES tenant(tenant_id));
