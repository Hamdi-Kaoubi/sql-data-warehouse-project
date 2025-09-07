/*
===============================================
Create Database and Schemas
===============================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists.
    If the database exists, it is dropeed and recreated. Additionally, the script sets up three schemas
    within the database: 'bronze', 'silver' and gold.
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists.
    All the data in the database will be permanently deleted. proceed with caution
    and ensure you have proper backups before running this script.

*/

use master;
go

--drop and recreate the 'DataWarehouse' database:
if exists (select 1 from syst.databases where name = 'DataWarehouse')
begin
  alter database DataWarehouse set single_user with rollback immediate;
  drop database DataWarehouse;
end;
go

 --Create Databes "DataWarehouse": 
create database DataWarehouse;
go

use DataWarehouse;
go

--Create Schemas:
create schema brone;
go
create schema silver;
go
create schema gold;
go
