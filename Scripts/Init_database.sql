use master
go

-- ===========================================
-- CREATING  DATABASE AND SCHEMA 
-- ===========================================

-- This script is intended to:
-- 1. Create a new database to support the application/data requirements.
-- 2. Define logical schemas within the database for modular organization.
--    Each schema will represent a specific functional area.

-- WARNING:
-- Before executing this script, ensure the database does **not already exist**
-- to avoid conflicts or accidental overwrites.

--Creating the new DATABASE named Datawarehouse

CREATE DATABASE Datawarehouse;
GO

USE Datawarehouse;

--Creating the three schemas BRONZE,SILVER,GOLD

--BRONZE SCHEMA

CREATE SCHEMA Bronze;
GO


--SILVER SCHEMA

CREATE SCHEMA Silver;
GO

--GOLD SCHEMA

CREATE SCHEMA Gold;
GO
