-- DATABASE INITIALIZATION -----------------------------------------------------
--
-- The following code performs the initial setup of the PostgreSQL database with
-- required objects for the anchor database.
--
--------------------------------------------------------------------------------
-- create schema
CREATE SCHEMA IF NOT EXISTS dbo;
-- set schema search path
SET search_path = dbo;
-- drop universal function that generates checksum values
-- DROP FUNCTION IF EXISTS dbo.generateChecksum(text);
-- create universal function that generates checksum values
CREATE OR REPLACE FUNCTION dbo.generateChecksum(
    value text
) RETURNS bytea AS '
    BEGIN
        return cast(
            substring(
                MD5(value) for 16
            ) as bytea
        );
    END;
' LANGUAGE plpgsql;
-- KNOTS --------------------------------------------------------------------------------------------------------------
--
-- Knots are used to store finite sets of values, normally used to describe states
-- of entities (through knotted attributes) or relationships (through knotted ties).
-- Knots have their own surrogate identities and are therefore immutable.
-- Values can be added to the set over time though.
-- Knots should have values that are mutually exclusive and exhaustive.
-- Knots are unfolded when using equivalence.
--
-- KNOT TRIGGERS ---------------------------------------------------------------------------------------------------
--
-- The following triggers enable calculation and storing checksum values.
--
-- ANCHORS AND ATTRIBUTES ---------------------------------------------------------------------------------------------
--
-- Anchors are used to store the identities of entities.
-- Anchors are immutable.
-- Attributes are used to store values for properties of entities.
-- Attributes are mutable, their values may change over one or more types of time.
-- Attributes have four flavors: static, historized, knotted static, and knotted historized.
-- Anchors may have zero or more adjoined attributes.
--
-- Anchor table -------------------------------------------------------------------------------------------------------
-- DC_DIMcustomer table (with 7 attributes)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DC_DIMcustomer;
CREATE TABLE IF NOT EXISTS dbo._DC_DIMcustomer (
    DC_ID serial not null, 
    DC_Dummy boolean null,
    constraint pkDC_DIMcustomer primary key (
        DC_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DC_DIMcustomer CLUSTER ON pkDC_DIMcustomer;
-- DROP VIEW IF EXISTS dbo.DC_DIMcustomer;
CREATE OR REPLACE VIEW dbo.DC_DIMcustomer AS SELECT 
    DC_ID,
    DC_Dummy
FROM dbo._DC_DIMcustomer;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DC_REG_DIMcustomer_Region table (on DC_DIMcustomer)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DC_REG_DIMcustomer_Region;
CREATE TABLE IF NOT EXISTS dbo._DC_REG_DIMcustomer_Region (
    DC_REG_DC_ID int not null,
    DC_REG_DIMcustomer_Region Char(12) not null,
    constraint fkDC_REG_DIMcustomer_Region foreign key (
        DC_REG_DC_ID
    ) references dbo._DC_DIMcustomer(DC_ID),
    constraint pkDC_REG_DIMcustomer_Region primary key (
        DC_REG_DC_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DC_REG_DIMcustomer_Region CLUSTER ON pkDC_REG_DIMcustomer_Region;
-- DROP VIEW IF EXISTS dbo.DC_REG_DIMcustomer_Region;
CREATE OR REPLACE VIEW dbo.DC_REG_DIMcustomer_Region AS SELECT
    DC_REG_DC_ID,
    DC_REG_DIMcustomer_Region
FROM dbo._DC_REG_DIMcustomer_Region;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DC_ADD_DIMcustomer_Address table (on DC_DIMcustomer)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DC_ADD_DIMcustomer_Address;
CREATE TABLE IF NOT EXISTS dbo._DC_ADD_DIMcustomer_Address (
    DC_ADD_DC_ID int not null,
    DC_ADD_DIMcustomer_Address Varchar(25) not null,
    constraint fkDC_ADD_DIMcustomer_Address foreign key (
        DC_ADD_DC_ID
    ) references dbo._DC_DIMcustomer(DC_ID),
    constraint pkDC_ADD_DIMcustomer_Address primary key (
        DC_ADD_DC_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DC_ADD_DIMcustomer_Address CLUSTER ON pkDC_ADD_DIMcustomer_Address;
-- DROP VIEW IF EXISTS dbo.DC_ADD_DIMcustomer_Address;
CREATE OR REPLACE VIEW dbo.DC_ADD_DIMcustomer_Address AS SELECT
    DC_ADD_DC_ID,
    DC_ADD_DIMcustomer_Address
FROM dbo._DC_ADD_DIMcustomer_Address;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DC_CIT_DIMcustomer_City table (on DC_DIMcustomer)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DC_CIT_DIMcustomer_City;
CREATE TABLE IF NOT EXISTS dbo._DC_CIT_DIMcustomer_City (
    DC_CIT_DC_ID int not null,
    DC_CIT_DIMcustomer_City Char(10) not null,
    constraint fkDC_CIT_DIMcustomer_City foreign key (
        DC_CIT_DC_ID
    ) references dbo._DC_DIMcustomer(DC_ID),
    constraint pkDC_CIT_DIMcustomer_City primary key (
        DC_CIT_DC_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DC_CIT_DIMcustomer_City CLUSTER ON pkDC_CIT_DIMcustomer_City;
-- DROP VIEW IF EXISTS dbo.DC_CIT_DIMcustomer_City;
CREATE OR REPLACE VIEW dbo.DC_CIT_DIMcustomer_City AS SELECT
    DC_CIT_DC_ID,
    DC_CIT_DIMcustomer_City
FROM dbo._DC_CIT_DIMcustomer_City;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DC_PHN_DIMcustomer_Phone table (on DC_DIMcustomer)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DC_PHN_DIMcustomer_Phone;
CREATE TABLE IF NOT EXISTS dbo._DC_PHN_DIMcustomer_Phone (
    DC_PHN_DC_ID int not null,
    DC_PHN_DIMcustomer_Phone char(15) not null,
    constraint fkDC_PHN_DIMcustomer_Phone foreign key (
        DC_PHN_DC_ID
    ) references dbo._DC_DIMcustomer(DC_ID),
    constraint pkDC_PHN_DIMcustomer_Phone primary key (
        DC_PHN_DC_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DC_PHN_DIMcustomer_Phone CLUSTER ON pkDC_PHN_DIMcustomer_Phone;
-- DROP VIEW IF EXISTS dbo.DC_PHN_DIMcustomer_Phone;
CREATE OR REPLACE VIEW dbo.DC_PHN_DIMcustomer_Phone AS SELECT
    DC_PHN_DC_ID,
    DC_PHN_DIMcustomer_Phone
FROM dbo._DC_PHN_DIMcustomer_Phone;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DC_NAT_DIMcustomer_Nation table (on DC_DIMcustomer)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DC_NAT_DIMcustomer_Nation;
CREATE TABLE IF NOT EXISTS dbo._DC_NAT_DIMcustomer_Nation (
    DC_NAT_DC_ID int not null,
    DC_NAT_DIMcustomer_Nation Char(15) not null,
    constraint fkDC_NAT_DIMcustomer_Nation foreign key (
        DC_NAT_DC_ID
    ) references dbo._DC_DIMcustomer(DC_ID),
    constraint pkDC_NAT_DIMcustomer_Nation primary key (
        DC_NAT_DC_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DC_NAT_DIMcustomer_Nation CLUSTER ON pkDC_NAT_DIMcustomer_Nation;
-- DROP VIEW IF EXISTS dbo.DC_NAT_DIMcustomer_Nation;
CREATE OR REPLACE VIEW dbo.DC_NAT_DIMcustomer_Nation AS SELECT
    DC_NAT_DC_ID,
    DC_NAT_DIMcustomer_Nation
FROM dbo._DC_NAT_DIMcustomer_Nation;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DC_NAM_DIMcustomer_Name table (on DC_DIMcustomer)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DC_NAM_DIMcustomer_Name;
CREATE TABLE IF NOT EXISTS dbo._DC_NAM_DIMcustomer_Name (
    DC_NAM_DC_ID int not null,
    DC_NAM_DIMcustomer_Name Varchar(25) not null,
    constraint fkDC_NAM_DIMcustomer_Name foreign key (
        DC_NAM_DC_ID
    ) references dbo._DC_DIMcustomer(DC_ID),
    constraint pkDC_NAM_DIMcustomer_Name primary key (
        DC_NAM_DC_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DC_NAM_DIMcustomer_Name CLUSTER ON pkDC_NAM_DIMcustomer_Name;
-- DROP VIEW IF EXISTS dbo.DC_NAM_DIMcustomer_Name;
CREATE OR REPLACE VIEW dbo.DC_NAM_DIMcustomer_Name AS SELECT
    DC_NAM_DC_ID,
    DC_NAM_DIMcustomer_Name
FROM dbo._DC_NAM_DIMcustomer_Name;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DC_SEG_DIMcustomer_Mktsegment table (on DC_DIMcustomer)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DC_SEG_DIMcustomer_Mktsegment;
CREATE TABLE IF NOT EXISTS dbo._DC_SEG_DIMcustomer_Mktsegment (
    DC_SEG_DC_ID int not null,
    DC_SEG_DIMcustomer_Mktsegment Char(10) not null,
    constraint fkDC_SEG_DIMcustomer_Mktsegment foreign key (
        DC_SEG_DC_ID
    ) references dbo._DC_DIMcustomer(DC_ID),
    constraint pkDC_SEG_DIMcustomer_Mktsegment primary key (
        DC_SEG_DC_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DC_SEG_DIMcustomer_Mktsegment CLUSTER ON pkDC_SEG_DIMcustomer_Mktsegment;
-- DROP VIEW IF EXISTS dbo.DC_SEG_DIMcustomer_Mktsegment;
CREATE OR REPLACE VIEW dbo.DC_SEG_DIMcustomer_Mktsegment AS SELECT
    DC_SEG_DC_ID,
    DC_SEG_DIMcustomer_Mktsegment
FROM dbo._DC_SEG_DIMcustomer_Mktsegment;
-- Anchor table -------------------------------------------------------------------------------------------------------
-- DS_DIMsupplier table (with 6 attributes)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DS_DIMsupplier;
CREATE TABLE IF NOT EXISTS dbo._DS_DIMsupplier (
    DS_ID serial not null, 
    DS_Dummy boolean null,
    constraint pkDS_DIMsupplier primary key (
        DS_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DS_DIMsupplier CLUSTER ON pkDS_DIMsupplier;
-- DROP VIEW IF EXISTS dbo.DS_DIMsupplier;
CREATE OR REPLACE VIEW dbo.DS_DIMsupplier AS SELECT 
    DS_ID,
    DS_Dummy
FROM dbo._DS_DIMsupplier;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DS_REG_DIMsupplier_Region table (on DS_DIMsupplier)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DS_REG_DIMsupplier_Region;
CREATE TABLE IF NOT EXISTS dbo._DS_REG_DIMsupplier_Region (
    DS_REG_DS_ID int not null,
    DS_REG_DIMsupplier_Region Char(12) not null,
    constraint fkDS_REG_DIMsupplier_Region foreign key (
        DS_REG_DS_ID
    ) references dbo._DS_DIMsupplier(DS_ID),
    constraint pkDS_REG_DIMsupplier_Region primary key (
        DS_REG_DS_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DS_REG_DIMsupplier_Region CLUSTER ON pkDS_REG_DIMsupplier_Region;
-- DROP VIEW IF EXISTS dbo.DS_REG_DIMsupplier_Region;
CREATE OR REPLACE VIEW dbo.DS_REG_DIMsupplier_Region AS SELECT
    DS_REG_DS_ID,
    DS_REG_DIMsupplier_Region
FROM dbo._DS_REG_DIMsupplier_Region;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DS_CIT_DIMsupplier_City table (on DS_DIMsupplier)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DS_CIT_DIMsupplier_City;
CREATE TABLE IF NOT EXISTS dbo._DS_CIT_DIMsupplier_City (
    DS_CIT_DS_ID int not null,
    DS_CIT_DIMsupplier_City Char(10) not null,
    constraint fkDS_CIT_DIMsupplier_City foreign key (
        DS_CIT_DS_ID
    ) references dbo._DS_DIMsupplier(DS_ID),
    constraint pkDS_CIT_DIMsupplier_City primary key (
        DS_CIT_DS_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DS_CIT_DIMsupplier_City CLUSTER ON pkDS_CIT_DIMsupplier_City;
-- DROP VIEW IF EXISTS dbo.DS_CIT_DIMsupplier_City;
CREATE OR REPLACE VIEW dbo.DS_CIT_DIMsupplier_City AS SELECT
    DS_CIT_DS_ID,
    DS_CIT_DIMsupplier_City
FROM dbo._DS_CIT_DIMsupplier_City;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DS_NAT_DIMsupplier_Nation table (on DS_DIMsupplier)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DS_NAT_DIMsupplier_Nation;
CREATE TABLE IF NOT EXISTS dbo._DS_NAT_DIMsupplier_Nation (
    DS_NAT_DS_ID int not null,
    DS_NAT_DIMsupplier_Nation Char(15) not null,
    constraint fkDS_NAT_DIMsupplier_Nation foreign key (
        DS_NAT_DS_ID
    ) references dbo._DS_DIMsupplier(DS_ID),
    constraint pkDS_NAT_DIMsupplier_Nation primary key (
        DS_NAT_DS_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DS_NAT_DIMsupplier_Nation CLUSTER ON pkDS_NAT_DIMsupplier_Nation;
-- DROP VIEW IF EXISTS dbo.DS_NAT_DIMsupplier_Nation;
CREATE OR REPLACE VIEW dbo.DS_NAT_DIMsupplier_Nation AS SELECT
    DS_NAT_DS_ID,
    DS_NAT_DIMsupplier_Nation
FROM dbo._DS_NAT_DIMsupplier_Nation;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DS_PHN_DIMsupplier_Phone table (on DS_DIMsupplier)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DS_PHN_DIMsupplier_Phone;
CREATE TABLE IF NOT EXISTS dbo._DS_PHN_DIMsupplier_Phone (
    DS_PHN_DS_ID int not null,
    DS_PHN_DIMsupplier_Phone char(15) not null,
    constraint fkDS_PHN_DIMsupplier_Phone foreign key (
        DS_PHN_DS_ID
    ) references dbo._DS_DIMsupplier(DS_ID),
    constraint pkDS_PHN_DIMsupplier_Phone primary key (
        DS_PHN_DS_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DS_PHN_DIMsupplier_Phone CLUSTER ON pkDS_PHN_DIMsupplier_Phone;
-- DROP VIEW IF EXISTS dbo.DS_PHN_DIMsupplier_Phone;
CREATE OR REPLACE VIEW dbo.DS_PHN_DIMsupplier_Phone AS SELECT
    DS_PHN_DS_ID,
    DS_PHN_DIMsupplier_Phone
FROM dbo._DS_PHN_DIMsupplier_Phone;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DS_ADD_DIMsupplier_Address table (on DS_DIMsupplier)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DS_ADD_DIMsupplier_Address;
CREATE TABLE IF NOT EXISTS dbo._DS_ADD_DIMsupplier_Address (
    DS_ADD_DS_ID int not null,
    DS_ADD_DIMsupplier_Address Varchar(25) not null,
    constraint fkDS_ADD_DIMsupplier_Address foreign key (
        DS_ADD_DS_ID
    ) references dbo._DS_DIMsupplier(DS_ID),
    constraint pkDS_ADD_DIMsupplier_Address primary key (
        DS_ADD_DS_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DS_ADD_DIMsupplier_Address CLUSTER ON pkDS_ADD_DIMsupplier_Address;
-- DROP VIEW IF EXISTS dbo.DS_ADD_DIMsupplier_Address;
CREATE OR REPLACE VIEW dbo.DS_ADD_DIMsupplier_Address AS SELECT
    DS_ADD_DS_ID,
    DS_ADD_DIMsupplier_Address
FROM dbo._DS_ADD_DIMsupplier_Address;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DS_NAM_DIMsupplier_Name table (on DS_DIMsupplier)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DS_NAM_DIMsupplier_Name;
CREATE TABLE IF NOT EXISTS dbo._DS_NAM_DIMsupplier_Name (
    DS_NAM_DS_ID int not null,
    DS_NAM_DIMsupplier_Name Char(25) not null,
    constraint fkDS_NAM_DIMsupplier_Name foreign key (
        DS_NAM_DS_ID
    ) references dbo._DS_DIMsupplier(DS_ID),
    constraint pkDS_NAM_DIMsupplier_Name primary key (
        DS_NAM_DS_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DS_NAM_DIMsupplier_Name CLUSTER ON pkDS_NAM_DIMsupplier_Name;
-- DROP VIEW IF EXISTS dbo.DS_NAM_DIMsupplier_Name;
CREATE OR REPLACE VIEW dbo.DS_NAM_DIMsupplier_Name AS SELECT
    DS_NAM_DS_ID,
    DS_NAM_DIMsupplier_Name
FROM dbo._DS_NAM_DIMsupplier_Name;
-- Anchor table -------------------------------------------------------------------------------------------------------
-- DD_DIMdate1 table (with 16 attributes)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_DIMdate1;
CREATE TABLE IF NOT EXISTS dbo._DD_DIMdate1 (
    DD_ID serial not null, 
    DD_Dummy boolean null,
    constraint pkDD_DIMdate1 primary key (
        DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_DIMdate1 CLUSTER ON pkDD_DIMdate1;
-- DROP VIEW IF EXISTS dbo.DD_DIMdate1;
CREATE OR REPLACE VIEW dbo.DD_DIMdate1 AS SELECT 
    DD_ID,
    DD_Dummy
FROM dbo._DD_DIMdate1;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_DAT_DIMdate1_Date table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_DAT_DIMdate1_Date;
CREATE TABLE IF NOT EXISTS dbo._DD_DAT_DIMdate1_Date (
    DD_DAT_DD_ID int not null,
    DD_DAT_DIMdate1_Date Varchar(18) not null,
    constraint fkDD_DAT_DIMdate1_Date foreign key (
        DD_DAT_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_DAT_DIMdate1_Date primary key (
        DD_DAT_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_DAT_DIMdate1_Date CLUSTER ON pkDD_DAT_DIMdate1_Date;
-- DROP VIEW IF EXISTS dbo.DD_DAT_DIMdate1_Date;
CREATE OR REPLACE VIEW dbo.DD_DAT_DIMdate1_Date AS SELECT
    DD_DAT_DD_ID,
    DD_DAT_DIMdate1_Date
FROM dbo._DD_DAT_DIMdate1_Date;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_YMN_DIMdate1_Yearmonthnum table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_YMN_DIMdate1_Yearmonthnum;
CREATE TABLE IF NOT EXISTS dbo._DD_YMN_DIMdate1_Yearmonthnum (
    DD_YMN_DD_ID int not null,
    DD_YMN_DIMdate1_Yearmonthnum Numeric(14) not null,
    constraint fkDD_YMN_DIMdate1_Yearmonthnum foreign key (
        DD_YMN_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_YMN_DIMdate1_Yearmonthnum primary key (
        DD_YMN_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_YMN_DIMdate1_Yearmonthnum CLUSTER ON pkDD_YMN_DIMdate1_Yearmonthnum;
-- DROP VIEW IF EXISTS dbo.DD_YMN_DIMdate1_Yearmonthnum;
CREATE OR REPLACE VIEW dbo.DD_YMN_DIMdate1_Yearmonthnum AS SELECT
    DD_YMN_DD_ID,
    DD_YMN_DIMdate1_Yearmonthnum
FROM dbo._DD_YMN_DIMdate1_Yearmonthnum;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_MTH_DIMdate1_Month table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_MTH_DIMdate1_Month;
CREATE TABLE IF NOT EXISTS dbo._DD_MTH_DIMdate1_Month (
    DD_MTH_DD_ID int not null,
    DD_MTH_DIMdate1_Month Varchar(9) not null,
    constraint fkDD_MTH_DIMdate1_Month foreign key (
        DD_MTH_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_MTH_DIMdate1_Month primary key (
        DD_MTH_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_MTH_DIMdate1_Month CLUSTER ON pkDD_MTH_DIMdate1_Month;
-- DROP VIEW IF EXISTS dbo.DD_MTH_DIMdate1_Month;
CREATE OR REPLACE VIEW dbo.DD_MTH_DIMdate1_Month AS SELECT
    DD_MTH_DD_ID,
    DD_MTH_DIMdate1_Month
FROM dbo._DD_MTH_DIMdate1_Month;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_DOW_DIMdate1_Dayofweek table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_DOW_DIMdate1_Dayofweek;
CREATE TABLE IF NOT EXISTS dbo._DD_DOW_DIMdate1_Dayofweek (
    DD_DOW_DD_ID int not null,
    DD_DOW_DIMdate1_Dayofweek Varchar(9) not null,
    constraint fkDD_DOW_DIMdate1_Dayofweek foreign key (
        DD_DOW_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_DOW_DIMdate1_Dayofweek primary key (
        DD_DOW_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_DOW_DIMdate1_Dayofweek CLUSTER ON pkDD_DOW_DIMdate1_Dayofweek;
-- DROP VIEW IF EXISTS dbo.DD_DOW_DIMdate1_Dayofweek;
CREATE OR REPLACE VIEW dbo.DD_DOW_DIMdate1_Dayofweek AS SELECT
    DD_DOW_DD_ID,
    DD_DOW_DIMdate1_Dayofweek
FROM dbo._DD_DOW_DIMdate1_Dayofweek;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_DNW_DIMdate1_Daynuminweek table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_DNW_DIMdate1_Daynuminweek;
CREATE TABLE IF NOT EXISTS dbo._DD_DNW_DIMdate1_Daynuminweek (
    DD_DNW_DD_ID int not null,
    DD_DNW_DIMdate1_Daynuminweek Numeric(7) not null,
    constraint fkDD_DNW_DIMdate1_Daynuminweek foreign key (
        DD_DNW_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_DNW_DIMdate1_Daynuminweek primary key (
        DD_DNW_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_DNW_DIMdate1_Daynuminweek CLUSTER ON pkDD_DNW_DIMdate1_Daynuminweek;
-- DROP VIEW IF EXISTS dbo.DD_DNW_DIMdate1_Daynuminweek;
CREATE OR REPLACE VIEW dbo.DD_DNW_DIMdate1_Daynuminweek AS SELECT
    DD_DNW_DD_ID,
    DD_DNW_DIMdate1_Daynuminweek
FROM dbo._DD_DNW_DIMdate1_Daynuminweek;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_YMM_DIMdate1_Yearmonth table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_YMM_DIMdate1_Yearmonth;
CREATE TABLE IF NOT EXISTS dbo._DD_YMM_DIMdate1_Yearmonth (
    DD_YMM_DD_ID int not null,
    DD_YMM_DIMdate1_Yearmonth Varchar(7) not null,
    constraint fkDD_YMM_DIMdate1_Yearmonth foreign key (
        DD_YMM_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_YMM_DIMdate1_Yearmonth primary key (
        DD_YMM_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_YMM_DIMdate1_Yearmonth CLUSTER ON pkDD_YMM_DIMdate1_Yearmonth;
-- DROP VIEW IF EXISTS dbo.DD_YMM_DIMdate1_Yearmonth;
CREATE OR REPLACE VIEW dbo.DD_YMM_DIMdate1_Yearmonth AS SELECT
    DD_YMM_DD_ID,
    DD_YMM_DIMdate1_Yearmonth
FROM dbo._DD_YMM_DIMdate1_Yearmonth;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_YRS_DIMdate1_Year table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_YRS_DIMdate1_Year;
CREATE TABLE IF NOT EXISTS dbo._DD_YRS_DIMdate1_Year (
    DD_YRS_DD_ID int not null,
    DD_YRS_DIMdate1_Year smallint not null,
    constraint fkDD_YRS_DIMdate1_Year foreign key (
        DD_YRS_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_YRS_DIMdate1_Year primary key (
        DD_YRS_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_YRS_DIMdate1_Year CLUSTER ON pkDD_YRS_DIMdate1_Year;
-- DROP VIEW IF EXISTS dbo.DD_YRS_DIMdate1_Year;
CREATE OR REPLACE VIEW dbo.DD_YRS_DIMdate1_Year AS SELECT
    DD_YRS_DD_ID,
    DD_YRS_DIMdate1_Year
FROM dbo._DD_YRS_DIMdate1_Year;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_DNM_DIMdate1_Daynuminmonth table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_DNM_DIMdate1_Daynuminmonth;
CREATE TABLE IF NOT EXISTS dbo._DD_DNM_DIMdate1_Daynuminmonth (
    DD_DNM_DD_ID int not null,
    DD_DNM_DIMdate1_Daynuminmonth Numeric(31) not null,
    constraint fkDD_DNM_DIMdate1_Daynuminmonth foreign key (
        DD_DNM_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_DNM_DIMdate1_Daynuminmonth primary key (
        DD_DNM_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_DNM_DIMdate1_Daynuminmonth CLUSTER ON pkDD_DNM_DIMdate1_Daynuminmonth;
-- DROP VIEW IF EXISTS dbo.DD_DNM_DIMdate1_Daynuminmonth;
CREATE OR REPLACE VIEW dbo.DD_DNM_DIMdate1_Daynuminmonth AS SELECT
    DD_DNM_DD_ID,
    DD_DNM_DIMdate1_Daynuminmonth
FROM dbo._DD_DNM_DIMdate1_Daynuminmonth;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_DNY_DIMdate1_Daynuminyear table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_DNY_DIMdate1_Daynuminyear;
CREATE TABLE IF NOT EXISTS dbo._DD_DNY_DIMdate1_Daynuminyear (
    DD_DNY_DD_ID int not null,
    DD_DNY_DIMdate1_Daynuminyear Numeric(31) not null,
    constraint fkDD_DNY_DIMdate1_Daynuminyear foreign key (
        DD_DNY_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_DNY_DIMdate1_Daynuminyear primary key (
        DD_DNY_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_DNY_DIMdate1_Daynuminyear CLUSTER ON pkDD_DNY_DIMdate1_Daynuminyear;
-- DROP VIEW IF EXISTS dbo.DD_DNY_DIMdate1_Daynuminyear;
CREATE OR REPLACE VIEW dbo.DD_DNY_DIMdate1_Daynuminyear AS SELECT
    DD_DNY_DD_ID,
    DD_DNY_DIMdate1_Daynuminyear
FROM dbo._DD_DNY_DIMdate1_Daynuminyear;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_DMY_DIMdate1_Monthnuminyear table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_DMY_DIMdate1_Monthnuminyear;
CREATE TABLE IF NOT EXISTS dbo._DD_DMY_DIMdate1_Monthnuminyear (
    DD_DMY_DD_ID int not null,
    DD_DMY_DIMdate1_Monthnuminyear Numeric(12) not null,
    constraint fkDD_DMY_DIMdate1_Monthnuminyear foreign key (
        DD_DMY_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_DMY_DIMdate1_Monthnuminyear primary key (
        DD_DMY_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_DMY_DIMdate1_Monthnuminyear CLUSTER ON pkDD_DMY_DIMdate1_Monthnuminyear;
-- DROP VIEW IF EXISTS dbo.DD_DMY_DIMdate1_Monthnuminyear;
CREATE OR REPLACE VIEW dbo.DD_DMY_DIMdate1_Monthnuminyear AS SELECT
    DD_DMY_DD_ID,
    DD_DMY_DIMdate1_Monthnuminyear
FROM dbo._DD_DMY_DIMdate1_Monthnuminyear;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_WNY_DIMdate1_Weeknuminyear table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_WNY_DIMdate1_Weeknuminyear;
CREATE TABLE IF NOT EXISTS dbo._DD_WNY_DIMdate1_Weeknuminyear (
    DD_WNY_DD_ID int not null,
    DD_WNY_DIMdate1_Weeknuminyear Numeric(53) not null,
    constraint fkDD_WNY_DIMdate1_Weeknuminyear foreign key (
        DD_WNY_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_WNY_DIMdate1_Weeknuminyear primary key (
        DD_WNY_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_WNY_DIMdate1_Weeknuminyear CLUSTER ON pkDD_WNY_DIMdate1_Weeknuminyear;
-- DROP VIEW IF EXISTS dbo.DD_WNY_DIMdate1_Weeknuminyear;
CREATE OR REPLACE VIEW dbo.DD_WNY_DIMdate1_Weeknuminyear AS SELECT
    DD_WNY_DD_ID,
    DD_WNY_DIMdate1_Weeknuminyear
FROM dbo._DD_WNY_DIMdate1_Weeknuminyear;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_SSA_DIMdate1_Sellingseason table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_SSA_DIMdate1_Sellingseason;
CREATE TABLE IF NOT EXISTS dbo._DD_SSA_DIMdate1_Sellingseason (
    DD_SSA_DD_ID int not null,
    DD_SSA_DIMdate1_Sellingseason Varchar(12) not null,
    constraint fkDD_SSA_DIMdate1_Sellingseason foreign key (
        DD_SSA_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_SSA_DIMdate1_Sellingseason primary key (
        DD_SSA_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_SSA_DIMdate1_Sellingseason CLUSTER ON pkDD_SSA_DIMdate1_Sellingseason;
-- DROP VIEW IF EXISTS dbo.DD_SSA_DIMdate1_Sellingseason;
CREATE OR REPLACE VIEW dbo.DD_SSA_DIMdate1_Sellingseason AS SELECT
    DD_SSA_DD_ID,
    DD_SSA_DIMdate1_Sellingseason
FROM dbo._DD_SSA_DIMdate1_Sellingseason;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_LFL_DIMdate1_Lastdayinweekfl table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_LFL_DIMdate1_Lastdayinweekfl;
CREATE TABLE IF NOT EXISTS dbo._DD_LFL_DIMdate1_Lastdayinweekfl (
    DD_LFL_DD_ID int not null,
    DD_LFL_DIMdate1_Lastdayinweekfl char(1) not null,
    constraint fkDD_LFL_DIMdate1_Lastdayinweekfl foreign key (
        DD_LFL_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_LFL_DIMdate1_Lastdayinweekfl primary key (
        DD_LFL_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_LFL_DIMdate1_Lastdayinweekfl CLUSTER ON pkDD_LFL_DIMdate1_Lastdayinweekfl;
-- DROP VIEW IF EXISTS dbo.DD_LFL_DIMdate1_Lastdayinweekfl;
CREATE OR REPLACE VIEW dbo.DD_LFL_DIMdate1_Lastdayinweekfl AS SELECT
    DD_LFL_DD_ID,
    DD_LFL_DIMdate1_Lastdayinweekfl
FROM dbo._DD_LFL_DIMdate1_Lastdayinweekfl;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_LDL_DIMdate1_Lastdayinmonthfl table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_LDL_DIMdate1_Lastdayinmonthfl;
CREATE TABLE IF NOT EXISTS dbo._DD_LDL_DIMdate1_Lastdayinmonthfl (
    DD_LDL_DD_ID int not null,
    DD_LDL_DIMdate1_Lastdayinmonthfl char(1) not null,
    constraint fkDD_LDL_DIMdate1_Lastdayinmonthfl foreign key (
        DD_LDL_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_LDL_DIMdate1_Lastdayinmonthfl primary key (
        DD_LDL_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_LDL_DIMdate1_Lastdayinmonthfl CLUSTER ON pkDD_LDL_DIMdate1_Lastdayinmonthfl;
-- DROP VIEW IF EXISTS dbo.DD_LDL_DIMdate1_Lastdayinmonthfl;
CREATE OR REPLACE VIEW dbo.DD_LDL_DIMdate1_Lastdayinmonthfl AS SELECT
    DD_LDL_DD_ID,
    DD_LDL_DIMdate1_Lastdayinmonthfl
FROM dbo._DD_LDL_DIMdate1_Lastdayinmonthfl;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_HOF_DIMdate1_Holydayfl table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_HOF_DIMdate1_Holydayfl;
CREATE TABLE IF NOT EXISTS dbo._DD_HOF_DIMdate1_Holydayfl (
    DD_HOF_DD_ID int not null,
    DD_HOF_DIMdate1_Holydayfl char(1) not null,
    constraint fkDD_HOF_DIMdate1_Holydayfl foreign key (
        DD_HOF_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_HOF_DIMdate1_Holydayfl primary key (
        DD_HOF_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_HOF_DIMdate1_Holydayfl CLUSTER ON pkDD_HOF_DIMdate1_Holydayfl;
-- DROP VIEW IF EXISTS dbo.DD_HOF_DIMdate1_Holydayfl;
CREATE OR REPLACE VIEW dbo.DD_HOF_DIMdate1_Holydayfl AS SELECT
    DD_HOF_DD_ID,
    DD_HOF_DIMdate1_Holydayfl
FROM dbo._DD_HOF_DIMdate1_Holydayfl;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DD_WDF_DIMdate1_Weekdayfl table (on DD_DIMdate1)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DD_WDF_DIMdate1_Weekdayfl;
CREATE TABLE IF NOT EXISTS dbo._DD_WDF_DIMdate1_Weekdayfl (
    DD_WDF_DD_ID int not null,
    DD_WDF_DIMdate1_Weekdayfl char(1) not null,
    constraint fkDD_WDF_DIMdate1_Weekdayfl foreign key (
        DD_WDF_DD_ID
    ) references dbo._DD_DIMdate1(DD_ID),
    constraint pkDD_WDF_DIMdate1_Weekdayfl primary key (
        DD_WDF_DD_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DD_WDF_DIMdate1_Weekdayfl CLUSTER ON pkDD_WDF_DIMdate1_Weekdayfl;
-- DROP VIEW IF EXISTS dbo.DD_WDF_DIMdate1_Weekdayfl;
CREATE OR REPLACE VIEW dbo.DD_WDF_DIMdate1_Weekdayfl AS SELECT
    DD_WDF_DD_ID,
    DD_WDF_DIMdate1_Weekdayfl
FROM dbo._DD_WDF_DIMdate1_Weekdayfl;
-- Anchor table -------------------------------------------------------------------------------------------------------
-- DP_DIMpart table (with 8 attributes)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DP_DIMpart;
CREATE TABLE IF NOT EXISTS dbo._DP_DIMpart (
    DP_ID serial not null, 
    DP_Dummy boolean null,
    constraint pkDP_DIMpart primary key (
        DP_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DP_DIMpart CLUSTER ON pkDP_DIMpart;
-- DROP VIEW IF EXISTS dbo.DP_DIMpart;
CREATE OR REPLACE VIEW dbo.DP_DIMpart AS SELECT 
    DP_ID,
    DP_Dummy
FROM dbo._DP_DIMpart;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DP_NAM_DIMpart_Name table (on DP_DIMpart)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DP_NAM_DIMpart_Name;
CREATE TABLE IF NOT EXISTS dbo._DP_NAM_DIMpart_Name (
    DP_NAM_DP_ID int not null,
    DP_NAM_DIMpart_Name varchar(22) not null,
    constraint fkDP_NAM_DIMpart_Name foreign key (
        DP_NAM_DP_ID
    ) references dbo._DP_DIMpart(DP_ID),
    constraint pkDP_NAM_DIMpart_Name primary key (
        DP_NAM_DP_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DP_NAM_DIMpart_Name CLUSTER ON pkDP_NAM_DIMpart_Name;
-- DROP VIEW IF EXISTS dbo.DP_NAM_DIMpart_Name;
CREATE OR REPLACE VIEW dbo.DP_NAM_DIMpart_Name AS SELECT
    DP_NAM_DP_ID,
    DP_NAM_DIMpart_Name
FROM dbo._DP_NAM_DIMpart_Name;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DP_MTG_DIMpart_Mfgr table (on DP_DIMpart)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DP_MTG_DIMpart_Mfgr;
CREATE TABLE IF NOT EXISTS dbo._DP_MTG_DIMpart_Mfgr (
    DP_MTG_DP_ID int not null,
    DP_MTG_DIMpart_Mfgr Varchar(6) not null,
    constraint fkDP_MTG_DIMpart_Mfgr foreign key (
        DP_MTG_DP_ID
    ) references dbo._DP_DIMpart(DP_ID),
    constraint pkDP_MTG_DIMpart_Mfgr primary key (
        DP_MTG_DP_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DP_MTG_DIMpart_Mfgr CLUSTER ON pkDP_MTG_DIMpart_Mfgr;
-- DROP VIEW IF EXISTS dbo.DP_MTG_DIMpart_Mfgr;
CREATE OR REPLACE VIEW dbo.DP_MTG_DIMpart_Mfgr AS SELECT
    DP_MTG_DP_ID,
    DP_MTG_DIMpart_Mfgr
FROM dbo._DP_MTG_DIMpart_Mfgr;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DP_CAT_DIMpart_Category table (on DP_DIMpart)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DP_CAT_DIMpart_Category;
CREATE TABLE IF NOT EXISTS dbo._DP_CAT_DIMpart_Category (
    DP_CAT_DP_ID int not null,
    DP_CAT_DIMpart_Category Varchar(7) not null,
    constraint fkDP_CAT_DIMpart_Category foreign key (
        DP_CAT_DP_ID
    ) references dbo._DP_DIMpart(DP_ID),
    constraint pkDP_CAT_DIMpart_Category primary key (
        DP_CAT_DP_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DP_CAT_DIMpart_Category CLUSTER ON pkDP_CAT_DIMpart_Category;
-- DROP VIEW IF EXISTS dbo.DP_CAT_DIMpart_Category;
CREATE OR REPLACE VIEW dbo.DP_CAT_DIMpart_Category AS SELECT
    DP_CAT_DP_ID,
    DP_CAT_DIMpart_Category
FROM dbo._DP_CAT_DIMpart_Category;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DP_BRA_DIMpart_Brand1 table (on DP_DIMpart)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DP_BRA_DIMpart_Brand1;
CREATE TABLE IF NOT EXISTS dbo._DP_BRA_DIMpart_Brand1 (
    DP_BRA_DP_ID int not null,
    DP_BRA_DIMpart_Brand1 Varchar(9) not null,
    constraint fkDP_BRA_DIMpart_Brand1 foreign key (
        DP_BRA_DP_ID
    ) references dbo._DP_DIMpart(DP_ID),
    constraint pkDP_BRA_DIMpart_Brand1 primary key (
        DP_BRA_DP_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DP_BRA_DIMpart_Brand1 CLUSTER ON pkDP_BRA_DIMpart_Brand1;
-- DROP VIEW IF EXISTS dbo.DP_BRA_DIMpart_Brand1;
CREATE OR REPLACE VIEW dbo.DP_BRA_DIMpart_Brand1 AS SELECT
    DP_BRA_DP_ID,
    DP_BRA_DIMpart_Brand1
FROM dbo._DP_BRA_DIMpart_Brand1;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DP_COL_DIMpart_Color table (on DP_DIMpart)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DP_COL_DIMpart_Color;
CREATE TABLE IF NOT EXISTS dbo._DP_COL_DIMpart_Color (
    DP_COL_DP_ID int not null,
    DP_COL_DIMpart_Color Varchar(11) not null,
    constraint fkDP_COL_DIMpart_Color foreign key (
        DP_COL_DP_ID
    ) references dbo._DP_DIMpart(DP_ID),
    constraint pkDP_COL_DIMpart_Color primary key (
        DP_COL_DP_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DP_COL_DIMpart_Color CLUSTER ON pkDP_COL_DIMpart_Color;
-- DROP VIEW IF EXISTS dbo.DP_COL_DIMpart_Color;
CREATE OR REPLACE VIEW dbo.DP_COL_DIMpart_Color AS SELECT
    DP_COL_DP_ID,
    DP_COL_DIMpart_Color
FROM dbo._DP_COL_DIMpart_Color;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DP_TYP_DIMpart_Type table (on DP_DIMpart)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DP_TYP_DIMpart_Type;
CREATE TABLE IF NOT EXISTS dbo._DP_TYP_DIMpart_Type (
    DP_TYP_DP_ID int not null,
    DP_TYP_DIMpart_Type Varchar(25) not null,
    constraint fkDP_TYP_DIMpart_Type foreign key (
        DP_TYP_DP_ID
    ) references dbo._DP_DIMpart(DP_ID),
    constraint pkDP_TYP_DIMpart_Type primary key (
        DP_TYP_DP_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DP_TYP_DIMpart_Type CLUSTER ON pkDP_TYP_DIMpart_Type;
-- DROP VIEW IF EXISTS dbo.DP_TYP_DIMpart_Type;
CREATE OR REPLACE VIEW dbo.DP_TYP_DIMpart_Type AS SELECT
    DP_TYP_DP_ID,
    DP_TYP_DIMpart_Type
FROM dbo._DP_TYP_DIMpart_Type;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DP_SIZ_DIMpart_Size table (on DP_DIMpart)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DP_SIZ_DIMpart_Size;
CREATE TABLE IF NOT EXISTS dbo._DP_SIZ_DIMpart_Size (
    DP_SIZ_DP_ID int not null,
    DP_SIZ_DIMpart_Size Numeric(50) not null,
    constraint fkDP_SIZ_DIMpart_Size foreign key (
        DP_SIZ_DP_ID
    ) references dbo._DP_DIMpart(DP_ID),
    constraint pkDP_SIZ_DIMpart_Size primary key (
        DP_SIZ_DP_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DP_SIZ_DIMpart_Size CLUSTER ON pkDP_SIZ_DIMpart_Size;
-- DROP VIEW IF EXISTS dbo.DP_SIZ_DIMpart_Size;
CREATE OR REPLACE VIEW dbo.DP_SIZ_DIMpart_Size AS SELECT
    DP_SIZ_DP_ID,
    DP_SIZ_DIMpart_Size
FROM dbo._DP_SIZ_DIMpart_Size;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DP_CON_DIMpart_Container table (on DP_DIMpart)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DP_CON_DIMpart_Container;
CREATE TABLE IF NOT EXISTS dbo._DP_CON_DIMpart_Container (
    DP_CON_DP_ID int not null,
    DP_CON_DIMpart_Container Char(10) not null,
    constraint fkDP_CON_DIMpart_Container foreign key (
        DP_CON_DP_ID
    ) references dbo._DP_DIMpart(DP_ID),
    constraint pkDP_CON_DIMpart_Container primary key (
        DP_CON_DP_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DP_CON_DIMpart_Container CLUSTER ON pkDP_CON_DIMpart_Container;
-- DROP VIEW IF EXISTS dbo.DP_CON_DIMpart_Container;
CREATE OR REPLACE VIEW dbo.DP_CON_DIMpart_Container AS SELECT
    DP_CON_DP_ID,
    DP_CON_DIMpart_Container
FROM dbo._DP_CON_DIMpart_Container;
-- Anchor table -------------------------------------------------------------------------------------------------------
-- FL_FACTlineorder table (with 11 attributes)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._FL_FACTlineorder;
CREATE TABLE IF NOT EXISTS dbo._FL_FACTlineorder (
    FL_ID serial not null, 
    FL_Dummy boolean null,
    constraint pkFL_FACTlineorder primary key (
        FL_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._FL_FACTlineorder CLUSTER ON pkFL_FACTlineorder;
-- DROP VIEW IF EXISTS dbo.FL_FACTlineorder;
CREATE OR REPLACE VIEW dbo.FL_FACTlineorder AS SELECT 
    FL_ID,
    FL_Dummy
FROM dbo._FL_FACTlineorder;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- FL_SHP_FACTlineorder_Shippriority table (on FL_FACTlineorder)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._FL_SHP_FACTlineorder_Shippriority;
CREATE TABLE IF NOT EXISTS dbo._FL_SHP_FACTlineorder_Shippriority (
    FL_SHP_FL_ID int not null,
    FL_SHP_FACTlineorder_Shippriority Char(1) not null,
    constraint fkFL_SHP_FACTlineorder_Shippriority foreign key (
        FL_SHP_FL_ID
    ) references dbo._FL_FACTlineorder(FL_ID),
    constraint pkFL_SHP_FACTlineorder_Shippriority primary key (
        FL_SHP_FL_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._FL_SHP_FACTlineorder_Shippriority CLUSTER ON pkFL_SHP_FACTlineorder_Shippriority;
-- DROP VIEW IF EXISTS dbo.FL_SHP_FACTlineorder_Shippriority;
CREATE OR REPLACE VIEW dbo.FL_SHP_FACTlineorder_Shippriority AS SELECT
    FL_SHP_FL_ID,
    FL_SHP_FACTlineorder_Shippriority
FROM dbo._FL_SHP_FACTlineorder_Shippriority;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- FL_OPY_FACTlineorder_Orderpriority table (on FL_FACTlineorder)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._FL_OPY_FACTlineorder_Orderpriority;
CREATE TABLE IF NOT EXISTS dbo._FL_OPY_FACTlineorder_Orderpriority (
    FL_OPY_FL_ID int not null,
    FL_OPY_FACTlineorder_Orderpriority Char(15) not null,
    constraint fkFL_OPY_FACTlineorder_Orderpriority foreign key (
        FL_OPY_FL_ID
    ) references dbo._FL_FACTlineorder(FL_ID),
    constraint pkFL_OPY_FACTlineorder_Orderpriority primary key (
        FL_OPY_FL_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._FL_OPY_FACTlineorder_Orderpriority CLUSTER ON pkFL_OPY_FACTlineorder_Orderpriority;
-- DROP VIEW IF EXISTS dbo.FL_OPY_FACTlineorder_Orderpriority;
CREATE OR REPLACE VIEW dbo.FL_OPY_FACTlineorder_Orderpriority AS SELECT
    FL_OPY_FL_ID,
    FL_OPY_FACTlineorder_Orderpriority
FROM dbo._FL_OPY_FACTlineorder_Orderpriority;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- FL_LNB_FACTlineorder_Linenumber table (on FL_FACTlineorder)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._FL_LNB_FACTlineorder_Linenumber;
CREATE TABLE IF NOT EXISTS dbo._FL_LNB_FACTlineorder_Linenumber (
    FL_LNB_FL_ID int not null,
    FL_LNB_FACTlineorder_Linenumber numeric(7) not null,
    constraint fkFL_LNB_FACTlineorder_Linenumber foreign key (
        FL_LNB_FL_ID
    ) references dbo._FL_FACTlineorder(FL_ID),
    constraint pkFL_LNB_FACTlineorder_Linenumber primary key (
        FL_LNB_FL_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._FL_LNB_FACTlineorder_Linenumber CLUSTER ON pkFL_LNB_FACTlineorder_Linenumber;
-- DROP VIEW IF EXISTS dbo.FL_LNB_FACTlineorder_Linenumber;
CREATE OR REPLACE VIEW dbo.FL_LNB_FACTlineorder_Linenumber AS SELECT
    FL_LNB_FL_ID,
    FL_LNB_FACTlineorder_Linenumber
FROM dbo._FL_LNB_FACTlineorder_Linenumber;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- FL_TXA_FACTlineorder_Tax table (on FL_FACTlineorder)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._FL_TXA_FACTlineorder_Tax;
CREATE TABLE IF NOT EXISTS dbo._FL_TXA_FACTlineorder_Tax (
    FL_TXA_FL_ID int not null,
    FL_TXA_FACTlineorder_Tax numeric(8) not null,
    constraint fkFL_TXA_FACTlineorder_Tax foreign key (
        FL_TXA_FL_ID
    ) references dbo._FL_FACTlineorder(FL_ID),
    constraint pkFL_TXA_FACTlineorder_Tax primary key (
        FL_TXA_FL_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._FL_TXA_FACTlineorder_Tax CLUSTER ON pkFL_TXA_FACTlineorder_Tax;
-- DROP VIEW IF EXISTS dbo.FL_TXA_FACTlineorder_Tax;
CREATE OR REPLACE VIEW dbo.FL_TXA_FACTlineorder_Tax AS SELECT
    FL_TXA_FL_ID,
    FL_TXA_FACTlineorder_Tax
FROM dbo._FL_TXA_FACTlineorder_Tax;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- FL_QTY_FACTlineorder_Quantity table (on FL_FACTlineorder)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._FL_QTY_FACTlineorder_Quantity;
CREATE TABLE IF NOT EXISTS dbo._FL_QTY_FACTlineorder_Quantity (
    FL_QTY_FL_ID int not null,
    FL_QTY_FACTlineorder_Quantity Numeric(50) not null,
    constraint fkFL_QTY_FACTlineorder_Quantity foreign key (
        FL_QTY_FL_ID
    ) references dbo._FL_FACTlineorder(FL_ID),
    constraint pkFL_QTY_FACTlineorder_Quantity primary key (
        FL_QTY_FL_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._FL_QTY_FACTlineorder_Quantity CLUSTER ON pkFL_QTY_FACTlineorder_Quantity;
-- DROP VIEW IF EXISTS dbo.FL_QTY_FACTlineorder_Quantity;
CREATE OR REPLACE VIEW dbo.FL_QTY_FACTlineorder_Quantity AS SELECT
    FL_QTY_FL_ID,
    FL_QTY_FACTlineorder_Quantity
FROM dbo._FL_QTY_FACTlineorder_Quantity;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- FL_EPR_FACTlineorder_Extendedprice table (on FL_FACTlineorder)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._FL_EPR_FACTlineorder_Extendedprice;
CREATE TABLE IF NOT EXISTS dbo._FL_EPR_FACTlineorder_Extendedprice (
    FL_EPR_FL_ID int not null,
    FL_EPR_FACTlineorder_Extendedprice numeric(200) not null,
    constraint fkFL_EPR_FACTlineorder_Extendedprice foreign key (
        FL_EPR_FL_ID
    ) references dbo._FL_FACTlineorder(FL_ID),
    constraint pkFL_EPR_FACTlineorder_Extendedprice primary key (
        FL_EPR_FL_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._FL_EPR_FACTlineorder_Extendedprice CLUSTER ON pkFL_EPR_FACTlineorder_Extendedprice;
-- DROP VIEW IF EXISTS dbo.FL_EPR_FACTlineorder_Extendedprice;
CREATE OR REPLACE VIEW dbo.FL_EPR_FACTlineorder_Extendedprice AS SELECT
    FL_EPR_FL_ID,
    FL_EPR_FACTlineorder_Extendedprice
FROM dbo._FL_EPR_FACTlineorder_Extendedprice;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- FL_OTP_FACTlineorder_Ordtotalprice table (on FL_FACTlineorder)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._FL_OTP_FACTlineorder_Ordtotalprice;
CREATE TABLE IF NOT EXISTS dbo._FL_OTP_FACTlineorder_Ordtotalprice (
    FL_OTP_FL_ID int not null,
    FL_OTP_FACTlineorder_Ordtotalprice Numeric(200) not null,
    constraint fkFL_OTP_FACTlineorder_Ordtotalprice foreign key (
        FL_OTP_FL_ID
    ) references dbo._FL_FACTlineorder(FL_ID),
    constraint pkFL_OTP_FACTlineorder_Ordtotalprice primary key (
        FL_OTP_FL_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._FL_OTP_FACTlineorder_Ordtotalprice CLUSTER ON pkFL_OTP_FACTlineorder_Ordtotalprice;
-- DROP VIEW IF EXISTS dbo.FL_OTP_FACTlineorder_Ordtotalprice;
CREATE OR REPLACE VIEW dbo.FL_OTP_FACTlineorder_Ordtotalprice AS SELECT
    FL_OTP_FL_ID,
    FL_OTP_FACTlineorder_Ordtotalprice
FROM dbo._FL_OTP_FACTlineorder_Ordtotalprice;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- FL_DSC_FACTlineorder_Discount table (on FL_FACTlineorder)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._FL_DSC_FACTlineorder_Discount;
CREATE TABLE IF NOT EXISTS dbo._FL_DSC_FACTlineorder_Discount (
    FL_DSC_FL_ID int not null,
    FL_DSC_FACTlineorder_Discount Numeric(10) not null,
    constraint fkFL_DSC_FACTlineorder_Discount foreign key (
        FL_DSC_FL_ID
    ) references dbo._FL_FACTlineorder(FL_ID),
    constraint pkFL_DSC_FACTlineorder_Discount primary key (
        FL_DSC_FL_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._FL_DSC_FACTlineorder_Discount CLUSTER ON pkFL_DSC_FACTlineorder_Discount;
-- DROP VIEW IF EXISTS dbo.FL_DSC_FACTlineorder_Discount;
CREATE OR REPLACE VIEW dbo.FL_DSC_FACTlineorder_Discount AS SELECT
    FL_DSC_FL_ID,
    FL_DSC_FACTlineorder_Discount
FROM dbo._FL_DSC_FACTlineorder_Discount;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- FL_SCT_FACTlineorder_Supplycost table (on FL_FACTlineorder)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._FL_SCT_FACTlineorder_Supplycost;
CREATE TABLE IF NOT EXISTS dbo._FL_SCT_FACTlineorder_Supplycost (
    FL_SCT_FL_ID int not null,
    FL_SCT_FACTlineorder_Supplycost Numeric(200) not null,
    constraint fkFL_SCT_FACTlineorder_Supplycost foreign key (
        FL_SCT_FL_ID
    ) references dbo._FL_FACTlineorder(FL_ID),
    constraint pkFL_SCT_FACTlineorder_Supplycost primary key (
        FL_SCT_FL_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._FL_SCT_FACTlineorder_Supplycost CLUSTER ON pkFL_SCT_FACTlineorder_Supplycost;
-- DROP VIEW IF EXISTS dbo.FL_SCT_FACTlineorder_Supplycost;
CREATE OR REPLACE VIEW dbo.FL_SCT_FACTlineorder_Supplycost AS SELECT
    FL_SCT_FL_ID,
    FL_SCT_FACTlineorder_Supplycost
FROM dbo._FL_SCT_FACTlineorder_Supplycost;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- FL_SHM_FACTlineorder_Shipmode table (on FL_FACTlineorder)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._FL_SHM_FACTlineorder_Shipmode;
CREATE TABLE IF NOT EXISTS dbo._FL_SHM_FACTlineorder_Shipmode (
    FL_SHM_FL_ID int not null,
    FL_SHM_FACTlineorder_Shipmode char(10) not null,
    constraint fkFL_SHM_FACTlineorder_Shipmode foreign key (
        FL_SHM_FL_ID
    ) references dbo._FL_FACTlineorder(FL_ID),
    constraint pkFL_SHM_FACTlineorder_Shipmode primary key (
        FL_SHM_FL_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._FL_SHM_FACTlineorder_Shipmode CLUSTER ON pkFL_SHM_FACTlineorder_Shipmode;
-- DROP VIEW IF EXISTS dbo.FL_SHM_FACTlineorder_Shipmode;
CREATE OR REPLACE VIEW dbo.FL_SHM_FACTlineorder_Shipmode AS SELECT
    FL_SHM_FL_ID,
    FL_SHM_FACTlineorder_Shipmode
FROM dbo._FL_SHM_FACTlineorder_Shipmode;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- FL_RVN_FACTlineorder_Revenue table (on FL_FACTlineorder)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._FL_RVN_FACTlineorder_Revenue;
CREATE TABLE IF NOT EXISTS dbo._FL_RVN_FACTlineorder_Revenue (
    FL_RVN_FL_ID int not null,
    FL_RVN_FACTlineorder_Revenue numeric not null,
    constraint fkFL_RVN_FACTlineorder_Revenue foreign key (
        FL_RVN_FL_ID
    ) references dbo._FL_FACTlineorder(FL_ID),
    constraint pkFL_RVN_FACTlineorder_Revenue primary key (
        FL_RVN_FL_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._FL_RVN_FACTlineorder_Revenue CLUSTER ON pkFL_RVN_FACTlineorder_Revenue;
-- DROP VIEW IF EXISTS dbo.FL_RVN_FACTlineorder_Revenue;
CREATE OR REPLACE VIEW dbo.FL_RVN_FACTlineorder_Revenue AS SELECT
    FL_RVN_FL_ID,
    FL_RVN_FACTlineorder_Revenue
FROM dbo._FL_RVN_FACTlineorder_Revenue;
-- Anchor table -------------------------------------------------------------------------------------------------------
-- DA_Dimdate2 table (with 16 attributes)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_Dimdate2;
CREATE TABLE IF NOT EXISTS dbo._DA_Dimdate2 (
    DA_ID serial not null, 
    DA_Dummy boolean null,
    constraint pkDA_Dimdate2 primary key (
        DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_Dimdate2 CLUSTER ON pkDA_Dimdate2;
-- DROP VIEW IF EXISTS dbo.DA_Dimdate2;
CREATE OR REPLACE VIEW dbo.DA_Dimdate2 AS SELECT 
    DA_ID,
    DA_Dummy
FROM dbo._DA_Dimdate2;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_DNM_Dimdate2_Daynuminmonth table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_DNM_Dimdate2_Daynuminmonth;
CREATE TABLE IF NOT EXISTS dbo._DA_DNM_Dimdate2_Daynuminmonth (
    DA_DNM_DA_ID int not null,
    DA_DNM_Dimdate2_Daynuminmonth integer not null,
    constraint fkDA_DNM_Dimdate2_Daynuminmonth foreign key (
        DA_DNM_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_DNM_Dimdate2_Daynuminmonth primary key (
        DA_DNM_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_DNM_Dimdate2_Daynuminmonth CLUSTER ON pkDA_DNM_Dimdate2_Daynuminmonth;
-- DROP VIEW IF EXISTS dbo.DA_DNM_Dimdate2_Daynuminmonth;
CREATE OR REPLACE VIEW dbo.DA_DNM_Dimdate2_Daynuminmonth AS SELECT
    DA_DNM_DA_ID,
    DA_DNM_Dimdate2_Daynuminmonth
FROM dbo._DA_DNM_Dimdate2_Daynuminmonth;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_WNY_Dimdate2_Weeknuminyear table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_WNY_Dimdate2_Weeknuminyear;
CREATE TABLE IF NOT EXISTS dbo._DA_WNY_Dimdate2_Weeknuminyear (
    DA_WNY_DA_ID int not null,
    DA_WNY_Dimdate2_Weeknuminyear integer not null,
    constraint fkDA_WNY_Dimdate2_Weeknuminyear foreign key (
        DA_WNY_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_WNY_Dimdate2_Weeknuminyear primary key (
        DA_WNY_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_WNY_Dimdate2_Weeknuminyear CLUSTER ON pkDA_WNY_Dimdate2_Weeknuminyear;
-- DROP VIEW IF EXISTS dbo.DA_WNY_Dimdate2_Weeknuminyear;
CREATE OR REPLACE VIEW dbo.DA_WNY_Dimdate2_Weeknuminyear AS SELECT
    DA_WNY_DA_ID,
    DA_WNY_Dimdate2_Weeknuminyear
FROM dbo._DA_WNY_Dimdate2_Weeknuminyear;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_SSS_Dimdate2_Sellingseasons table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_SSS_Dimdate2_Sellingseasons;
CREATE TABLE IF NOT EXISTS dbo._DA_SSS_Dimdate2_Sellingseasons (
    DA_SSS_DA_ID int not null,
    DA_SSS_Dimdate2_Sellingseasons text not null,
    constraint fkDA_SSS_Dimdate2_Sellingseasons foreign key (
        DA_SSS_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_SSS_Dimdate2_Sellingseasons primary key (
        DA_SSS_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_SSS_Dimdate2_Sellingseasons CLUSTER ON pkDA_SSS_Dimdate2_Sellingseasons;
-- DROP VIEW IF EXISTS dbo.DA_SSS_Dimdate2_Sellingseasons;
CREATE OR REPLACE VIEW dbo.DA_SSS_Dimdate2_Sellingseasons AS SELECT
    DA_SSS_DA_ID,
    DA_SSS_Dimdate2_Sellingseasons
FROM dbo._DA_SSS_Dimdate2_Sellingseasons;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_LDF_Dimdate2_Lastdayinweekfl table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_LDF_Dimdate2_Lastdayinweekfl;
CREATE TABLE IF NOT EXISTS dbo._DA_LDF_Dimdate2_Lastdayinweekfl (
    DA_LDF_DA_ID int not null,
    DA_LDF_Dimdate2_Lastdayinweekfl char(1) not null,
    constraint fkDA_LDF_Dimdate2_Lastdayinweekfl foreign key (
        DA_LDF_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_LDF_Dimdate2_Lastdayinweekfl primary key (
        DA_LDF_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_LDF_Dimdate2_Lastdayinweekfl CLUSTER ON pkDA_LDF_Dimdate2_Lastdayinweekfl;
-- DROP VIEW IF EXISTS dbo.DA_LDF_Dimdate2_Lastdayinweekfl;
CREATE OR REPLACE VIEW dbo.DA_LDF_Dimdate2_Lastdayinweekfl AS SELECT
    DA_LDF_DA_ID,
    DA_LDF_Dimdate2_Lastdayinweekfl
FROM dbo._DA_LDF_Dimdate2_Lastdayinweekfl;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_DAT_Dimdate2_Date table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_DAT_Dimdate2_Date;
CREATE TABLE IF NOT EXISTS dbo._DA_DAT_Dimdate2_Date (
    DA_DAT_DA_ID int not null,
    DA_DAT_Dimdate2_Date varchar(18) not null,
    constraint fkDA_DAT_Dimdate2_Date foreign key (
        DA_DAT_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_DAT_Dimdate2_Date primary key (
        DA_DAT_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_DAT_Dimdate2_Date CLUSTER ON pkDA_DAT_Dimdate2_Date;
-- DROP VIEW IF EXISTS dbo.DA_DAT_Dimdate2_Date;
CREATE OR REPLACE VIEW dbo.DA_DAT_Dimdate2_Date AS SELECT
    DA_DAT_DA_ID,
    DA_DAT_Dimdate2_Date
FROM dbo._DA_DAT_Dimdate2_Date;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_DOW_Dimdate2_Dayofweek table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_DOW_Dimdate2_Dayofweek;
CREATE TABLE IF NOT EXISTS dbo._DA_DOW_Dimdate2_Dayofweek (
    DA_DOW_DA_ID int not null,
    DA_DOW_Dimdate2_Dayofweek varchar(9) not null,
    constraint fkDA_DOW_Dimdate2_Dayofweek foreign key (
        DA_DOW_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_DOW_Dimdate2_Dayofweek primary key (
        DA_DOW_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_DOW_Dimdate2_Dayofweek CLUSTER ON pkDA_DOW_Dimdate2_Dayofweek;
-- DROP VIEW IF EXISTS dbo.DA_DOW_Dimdate2_Dayofweek;
CREATE OR REPLACE VIEW dbo.DA_DOW_Dimdate2_Dayofweek AS SELECT
    DA_DOW_DA_ID,
    DA_DOW_Dimdate2_Dayofweek
FROM dbo._DA_DOW_Dimdate2_Dayofweek;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_YRS_Dimdate2_Year table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_YRS_Dimdate2_Year;
CREATE TABLE IF NOT EXISTS dbo._DA_YRS_Dimdate2_Year (
    DA_YRS_DA_ID int not null,
    DA_YRS_Dimdate2_Year integer not null,
    constraint fkDA_YRS_Dimdate2_Year foreign key (
        DA_YRS_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_YRS_Dimdate2_Year primary key (
        DA_YRS_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_YRS_Dimdate2_Year CLUSTER ON pkDA_YRS_Dimdate2_Year;
-- DROP VIEW IF EXISTS dbo.DA_YRS_Dimdate2_Year;
CREATE OR REPLACE VIEW dbo.DA_YRS_Dimdate2_Year AS SELECT
    DA_YRS_DA_ID,
    DA_YRS_Dimdate2_Year
FROM dbo._DA_YRS_Dimdate2_Year;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_YMN_Dimdate2_Yearmonthnum table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_YMN_Dimdate2_Yearmonthnum;
CREATE TABLE IF NOT EXISTS dbo._DA_YMN_Dimdate2_Yearmonthnum (
    DA_YMN_DA_ID int not null,
    DA_YMN_Dimdate2_Yearmonthnum Integer not null,
    constraint fkDA_YMN_Dimdate2_Yearmonthnum foreign key (
        DA_YMN_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_YMN_Dimdate2_Yearmonthnum primary key (
        DA_YMN_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_YMN_Dimdate2_Yearmonthnum CLUSTER ON pkDA_YMN_Dimdate2_Yearmonthnum;
-- DROP VIEW IF EXISTS dbo.DA_YMN_Dimdate2_Yearmonthnum;
CREATE OR REPLACE VIEW dbo.DA_YMN_Dimdate2_Yearmonthnum AS SELECT
    DA_YMN_DA_ID,
    DA_YMN_Dimdate2_Yearmonthnum
FROM dbo._DA_YMN_Dimdate2_Yearmonthnum;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_MMM_Dimdate2_Month table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_MMM_Dimdate2_Month;
CREATE TABLE IF NOT EXISTS dbo._DA_MMM_Dimdate2_Month (
    DA_MMM_DA_ID int not null,
    DA_MMM_Dimdate2_Month varchar(9) not null,
    constraint fkDA_MMM_Dimdate2_Month foreign key (
        DA_MMM_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_MMM_Dimdate2_Month primary key (
        DA_MMM_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_MMM_Dimdate2_Month CLUSTER ON pkDA_MMM_Dimdate2_Month;
-- DROP VIEW IF EXISTS dbo.DA_MMM_Dimdate2_Month;
CREATE OR REPLACE VIEW dbo.DA_MMM_Dimdate2_Month AS SELECT
    DA_MMM_DA_ID,
    DA_MMM_Dimdate2_Month
FROM dbo._DA_MMM_Dimdate2_Month;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_DNW_Dimdate2_Daynuminweek table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_DNW_Dimdate2_Daynuminweek;
CREATE TABLE IF NOT EXISTS dbo._DA_DNW_Dimdate2_Daynuminweek (
    DA_DNW_DA_ID int not null,
    DA_DNW_Dimdate2_Daynuminweek integer not null,
    constraint fkDA_DNW_Dimdate2_Daynuminweek foreign key (
        DA_DNW_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_DNW_Dimdate2_Daynuminweek primary key (
        DA_DNW_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_DNW_Dimdate2_Daynuminweek CLUSTER ON pkDA_DNW_Dimdate2_Daynuminweek;
-- DROP VIEW IF EXISTS dbo.DA_DNW_Dimdate2_Daynuminweek;
CREATE OR REPLACE VIEW dbo.DA_DNW_Dimdate2_Daynuminweek AS SELECT
    DA_DNW_DA_ID,
    DA_DNW_Dimdate2_Daynuminweek
FROM dbo._DA_DNW_Dimdate2_Daynuminweek;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_YMM_Dimdate2_Yearmonth table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_YMM_Dimdate2_Yearmonth;
CREATE TABLE IF NOT EXISTS dbo._DA_YMM_Dimdate2_Yearmonth (
    DA_YMM_DA_ID int not null,
    DA_YMM_Dimdate2_Yearmonth varchar(7) not null,
    constraint fkDA_YMM_Dimdate2_Yearmonth foreign key (
        DA_YMM_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_YMM_Dimdate2_Yearmonth primary key (
        DA_YMM_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_YMM_Dimdate2_Yearmonth CLUSTER ON pkDA_YMM_Dimdate2_Yearmonth;
-- DROP VIEW IF EXISTS dbo.DA_YMM_Dimdate2_Yearmonth;
CREATE OR REPLACE VIEW dbo.DA_YMM_Dimdate2_Yearmonth AS SELECT
    DA_YMM_DA_ID,
    DA_YMM_Dimdate2_Yearmonth
FROM dbo._DA_YMM_Dimdate2_Yearmonth;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_MNY_Dimdate2_Monthnuminyear table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_MNY_Dimdate2_Monthnuminyear;
CREATE TABLE IF NOT EXISTS dbo._DA_MNY_Dimdate2_Monthnuminyear (
    DA_MNY_DA_ID int not null,
    DA_MNY_Dimdate2_Monthnuminyear integer not null,
    constraint fkDA_MNY_Dimdate2_Monthnuminyear foreign key (
        DA_MNY_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_MNY_Dimdate2_Monthnuminyear primary key (
        DA_MNY_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_MNY_Dimdate2_Monthnuminyear CLUSTER ON pkDA_MNY_Dimdate2_Monthnuminyear;
-- DROP VIEW IF EXISTS dbo.DA_MNY_Dimdate2_Monthnuminyear;
CREATE OR REPLACE VIEW dbo.DA_MNY_Dimdate2_Monthnuminyear AS SELECT
    DA_MNY_DA_ID,
    DA_MNY_Dimdate2_Monthnuminyear
FROM dbo._DA_MNY_Dimdate2_Monthnuminyear;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_DNY_Dimdate2_Daynuminyear table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_DNY_Dimdate2_Daynuminyear;
CREATE TABLE IF NOT EXISTS dbo._DA_DNY_Dimdate2_Daynuminyear (
    DA_DNY_DA_ID int not null,
    DA_DNY_Dimdate2_Daynuminyear integer not null,
    constraint fkDA_DNY_Dimdate2_Daynuminyear foreign key (
        DA_DNY_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_DNY_Dimdate2_Daynuminyear primary key (
        DA_DNY_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_DNY_Dimdate2_Daynuminyear CLUSTER ON pkDA_DNY_Dimdate2_Daynuminyear;
-- DROP VIEW IF EXISTS dbo.DA_DNY_Dimdate2_Daynuminyear;
CREATE OR REPLACE VIEW dbo.DA_DNY_Dimdate2_Daynuminyear AS SELECT
    DA_DNY_DA_ID,
    DA_DNY_Dimdate2_Daynuminyear
FROM dbo._DA_DNY_Dimdate2_Daynuminyear;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_LIF_Dimdate2_Lastdayinmonthfl table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_LIF_Dimdate2_Lastdayinmonthfl;
CREATE TABLE IF NOT EXISTS dbo._DA_LIF_Dimdate2_Lastdayinmonthfl (
    DA_LIF_DA_ID int not null,
    DA_LIF_Dimdate2_Lastdayinmonthfl char(1) not null,
    constraint fkDA_LIF_Dimdate2_Lastdayinmonthfl foreign key (
        DA_LIF_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_LIF_Dimdate2_Lastdayinmonthfl primary key (
        DA_LIF_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_LIF_Dimdate2_Lastdayinmonthfl CLUSTER ON pkDA_LIF_Dimdate2_Lastdayinmonthfl;
-- DROP VIEW IF EXISTS dbo.DA_LIF_Dimdate2_Lastdayinmonthfl;
CREATE OR REPLACE VIEW dbo.DA_LIF_Dimdate2_Lastdayinmonthfl AS SELECT
    DA_LIF_DA_ID,
    DA_LIF_Dimdate2_Lastdayinmonthfl
FROM dbo._DA_LIF_Dimdate2_Lastdayinmonthfl;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_HFL_Dimdate2_HolydayFL table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_HFL_Dimdate2_HolydayFL;
CREATE TABLE IF NOT EXISTS dbo._DA_HFL_Dimdate2_HolydayFL (
    DA_HFL_DA_ID int not null,
    DA_HFL_Dimdate2_HolydayFL char(1) not null,
    constraint fkDA_HFL_Dimdate2_HolydayFL foreign key (
        DA_HFL_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_HFL_Dimdate2_HolydayFL primary key (
        DA_HFL_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_HFL_Dimdate2_HolydayFL CLUSTER ON pkDA_HFL_Dimdate2_HolydayFL;
-- DROP VIEW IF EXISTS dbo.DA_HFL_Dimdate2_HolydayFL;
CREATE OR REPLACE VIEW dbo.DA_HFL_Dimdate2_HolydayFL AS SELECT
    DA_HFL_DA_ID,
    DA_HFL_Dimdate2_HolydayFL
FROM dbo._DA_HFL_Dimdate2_HolydayFL;
-- Static attribute table ---------------------------------------------------------------------------------------------
-- DA_WDF_Dimdate2_Weekdayfl table (on DA_Dimdate2)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DA_WDF_Dimdate2_Weekdayfl;
CREATE TABLE IF NOT EXISTS dbo._DA_WDF_Dimdate2_Weekdayfl (
    DA_WDF_DA_ID int not null,
    DA_WDF_Dimdate2_Weekdayfl char(1) not null,
    constraint fkDA_WDF_Dimdate2_Weekdayfl foreign key (
        DA_WDF_DA_ID
    ) references dbo._DA_Dimdate2(DA_ID),
    constraint pkDA_WDF_Dimdate2_Weekdayfl primary key (
        DA_WDF_DA_ID
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DA_WDF_Dimdate2_Weekdayfl CLUSTER ON pkDA_WDF_Dimdate2_Weekdayfl;
-- DROP VIEW IF EXISTS dbo.DA_WDF_Dimdate2_Weekdayfl;
CREATE OR REPLACE VIEW dbo.DA_WDF_Dimdate2_Weekdayfl AS SELECT
    DA_WDF_DA_ID,
    DA_WDF_Dimdate2_Weekdayfl
FROM dbo._DA_WDF_Dimdate2_Weekdayfl;
-- TIES ---------------------------------------------------------------------------------------------------------------
--
-- Ties are used to represent relationships between entities.
-- They come in four flavors: static, historized, knotted static, and knotted historized.
-- Ties have cardinality, constraining how members may participate in the relationship.
-- Every entity that is a member in a tie has a specified role in the relationship.
-- Ties must have at least two anchor roles and zero or more knot roles.
--
-- Static tie table ---------------------------------------------------------------------------------------------------
-- DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2 table (having 6 roles)
-----------------------------------------------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS dbo._DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2;
CREATE TABLE IF NOT EXISTS dbo._DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2 (
    DP_ID_ispof int not null, 
    FL_ID_isordby int not null, 
    DD_ID_is1 int not null, 
    DC_ID_isCustrOf int not null, 
    DS_ID_isSuppBy int not null, 
    DA_ID_is2 int not null, 
    constraint DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2_fkDP_ispof foreign key (
        DP_ID_ispof
    ) references dbo._DP_DIMpart(DP_ID), 
    constraint DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2_fkFL_isordby foreign key (
        FL_ID_isordby
    ) references dbo._FL_FACTlineorder(FL_ID), 
    constraint DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2_fkDD_is1 foreign key (
        DD_ID_is1
    ) references dbo._DD_DIMdate1(DD_ID), 
    constraint DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2_fkDC_isCustrOf foreign key (
        DC_ID_isCustrOf
    ) references dbo._DC_DIMcustomer(DC_ID), 
    constraint DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2_fkDS_isSuppBy foreign key (
        DS_ID_isSuppBy
    ) references dbo._DS_DIMsupplier(DS_ID), 
    constraint DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2_fkDA_is2 foreign key (
        DA_ID_is2
    ) references dbo._DA_Dimdate2(DA_ID), 
    constraint pkDP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2 primary key (
        DP_ID_ispof,
        FL_ID_isordby,
        DD_ID_is1,
        DC_ID_isCustrOf,
        DS_ID_isSuppBy,
        DA_ID_is2
    )
);
ALTER TABLE IF EXISTS ONLY dbo._DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2 CLUSTER ON pkDP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2;
-- DROP VIEW IF EXISTS dbo.DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2;
CREATE OR REPLACE VIEW dbo.DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2 AS SELECT
    DP_ID_ispof,
    FL_ID_isordby,
    DD_ID_is1,
    DC_ID_isCustrOf,
    DS_ID_isSuppBy,
    DA_ID_is2
FROM dbo._DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2;
-- KEY GENERATORS -----------------------------------------------------------------------------------------------------
--
-- These stored procedures can be used to generate identities of entities.
-- Corresponding anchors must have an incrementing identity column.
--
-- Key Generation Stored Procedure ------------------------------------------------------------------------------------
-- kDC_DIMcustomer identity by surrogate key generation stored procedure
-----------------------------------------------------------------------------------------------------------------------
--DROP FUNCTION IF EXISTS dbo.kDC_DIMcustomer(
-- bigint
--);
CREATE OR REPLACE FUNCTION dbo.kDC_DIMcustomer(
    requestedNumberOfIdentities bigint
) RETURNS void AS '
    BEGIN
        IF requestedNumberOfIdentities > 0
        THEN
            WITH RECURSIVE idGenerator (idNumber) AS (
                SELECT
                    1
                UNION ALL
                SELECT
                    idNumber + 1
                FROM
                    idGenerator
                WHERE
                    idNumber < requestedNumberOfIdentities
            )
            INSERT INTO dbo.DC_DIMcustomer (
                DC_Dummy
            )
            SELECT
                null
            FROM
                idGenerator;
        END IF;
    END;
' LANGUAGE plpgsql;
-- Key Generation Stored Procedure ------------------------------------------------------------------------------------
-- kDS_DIMsupplier identity by surrogate key generation stored procedure
-----------------------------------------------------------------------------------------------------------------------
--DROP FUNCTION IF EXISTS dbo.kDS_DIMsupplier(
-- bigint
--);
CREATE OR REPLACE FUNCTION dbo.kDS_DIMsupplier(
    requestedNumberOfIdentities bigint
) RETURNS void AS '
    BEGIN
        IF requestedNumberOfIdentities > 0
        THEN
            WITH RECURSIVE idGenerator (idNumber) AS (
                SELECT
                    1
                UNION ALL
                SELECT
                    idNumber + 1
                FROM
                    idGenerator
                WHERE
                    idNumber < requestedNumberOfIdentities
            )
            INSERT INTO dbo.DS_DIMsupplier (
                DS_Dummy
            )
            SELECT
                null
            FROM
                idGenerator;
        END IF;
    END;
' LANGUAGE plpgsql;
-- Key Generation Stored Procedure ------------------------------------------------------------------------------------
-- kDD_DIMdate1 identity by surrogate key generation stored procedure
-----------------------------------------------------------------------------------------------------------------------
--DROP FUNCTION IF EXISTS dbo.kDD_DIMdate1(
-- bigint
--);
CREATE OR REPLACE FUNCTION dbo.kDD_DIMdate1(
    requestedNumberOfIdentities bigint
) RETURNS void AS '
    BEGIN
        IF requestedNumberOfIdentities > 0
        THEN
            WITH RECURSIVE idGenerator (idNumber) AS (
                SELECT
                    1
                UNION ALL
                SELECT
                    idNumber + 1
                FROM
                    idGenerator
                WHERE
                    idNumber < requestedNumberOfIdentities
            )
            INSERT INTO dbo.DD_DIMdate1 (
                DD_Dummy
            )
            SELECT
                null
            FROM
                idGenerator;
        END IF;
    END;
' LANGUAGE plpgsql;
-- Key Generation Stored Procedure ------------------------------------------------------------------------------------
-- kDP_DIMpart identity by surrogate key generation stored procedure
-----------------------------------------------------------------------------------------------------------------------
--DROP FUNCTION IF EXISTS dbo.kDP_DIMpart(
-- bigint
--);
CREATE OR REPLACE FUNCTION dbo.kDP_DIMpart(
    requestedNumberOfIdentities bigint
) RETURNS void AS '
    BEGIN
        IF requestedNumberOfIdentities > 0
        THEN
            WITH RECURSIVE idGenerator (idNumber) AS (
                SELECT
                    1
                UNION ALL
                SELECT
                    idNumber + 1
                FROM
                    idGenerator
                WHERE
                    idNumber < requestedNumberOfIdentities
            )
            INSERT INTO dbo.DP_DIMpart (
                DP_Dummy
            )
            SELECT
                null
            FROM
                idGenerator;
        END IF;
    END;
' LANGUAGE plpgsql;
-- Key Generation Stored Procedure ------------------------------------------------------------------------------------
-- kFL_FACTlineorder identity by surrogate key generation stored procedure
-----------------------------------------------------------------------------------------------------------------------
--DROP FUNCTION IF EXISTS dbo.kFL_FACTlineorder(
-- bigint
--);
CREATE OR REPLACE FUNCTION dbo.kFL_FACTlineorder(
    requestedNumberOfIdentities bigint
) RETURNS void AS '
    BEGIN
        IF requestedNumberOfIdentities > 0
        THEN
            WITH RECURSIVE idGenerator (idNumber) AS (
                SELECT
                    1
                UNION ALL
                SELECT
                    idNumber + 1
                FROM
                    idGenerator
                WHERE
                    idNumber < requestedNumberOfIdentities
            )
            INSERT INTO dbo.FL_FACTlineorder (
                FL_Dummy
            )
            SELECT
                null
            FROM
                idGenerator;
        END IF;
    END;
' LANGUAGE plpgsql;
-- Key Generation Stored Procedure ------------------------------------------------------------------------------------
-- kDA_Dimdate2 identity by surrogate key generation stored procedure
-----------------------------------------------------------------------------------------------------------------------
--DROP FUNCTION IF EXISTS dbo.kDA_Dimdate2(
-- bigint
--);
CREATE OR REPLACE FUNCTION dbo.kDA_Dimdate2(
    requestedNumberOfIdentities bigint
) RETURNS void AS '
    BEGIN
        IF requestedNumberOfIdentities > 0
        THEN
            WITH RECURSIVE idGenerator (idNumber) AS (
                SELECT
                    1
                UNION ALL
                SELECT
                    idNumber + 1
                FROM
                    idGenerator
                WHERE
                    idNumber < requestedNumberOfIdentities
            )
            INSERT INTO dbo.DA_Dimdate2 (
                DA_Dummy
            )
            SELECT
                null
            FROM
                idGenerator;
        END IF;
    END;
' LANGUAGE plpgsql;
-- ATTRIBUTE REWINDERS ------------------------------------------------------------------------------------------------
--
-- These table valued functions rewind an attribute table to the given
-- point in changing time. It does not pick a temporal perspective and
-- instead shows all rows that have been in effect before that point
-- in time.
--
-- changingTimepoint the point in changing time to rewind to
--
-- ANCHOR TEMPORAL PERSPECTIVES ---------------------------------------------------------------------------------------
--
-- These functions simplify temporal querying by providing a temporal
-- perspective of each anchor. There are four types of perspectives: latest,
-- point-in-time, difference, and now. They also denormalize the anchor, its attributes,
-- and referenced knots from sixth to third normal form.
--
-- The latest perspective shows the latest available information for each anchor.
-- The now perspective shows the information as it is right now.
-- The point-in-time perspective lets you travel through the information to the given timepoint.
--
-- changingTimepoint the point in changing time to travel to
--
-- The difference perspective shows changes between the two given timepoints, and for
-- changes in all or a selection of attributes.
--
-- intervalStart the start of the interval for finding changes
-- intervalEnd the end of the interval for finding changes
-- selection a list of mnemonics for tracked attributes, ie 'MNE MON ICS', or null for all
--
-- Under equivalence all these views default to equivalent = 0, however, corresponding
-- prepended-e perspectives are provided in order to select a specific equivalent.
--
-- equivalent the equivalent for which to retrieve data
--
-- DROP ANCHOR TEMPORAL PERSPECTIVES ----------------------------------------------------------------------------------
/*
DROP FUNCTION IF EXISTS dbo.dDC_DIMcustomer(
    timestamp without time zone, 
    timestamp without time zone, 
    text
);
DROP VIEW IF EXISTS dbo.nDC_DIMcustomer;
DROP FUNCTION IF EXISTS dbo.pDC_DIMcustomer(
    timestamp without time zone
);
DROP VIEW IF EXISTS dbo.lDC_DIMcustomer;
DROP FUNCTION IF EXISTS dbo.dDS_DIMsupplier(
    timestamp without time zone, 
    timestamp without time zone, 
    text
);
DROP VIEW IF EXISTS dbo.nDS_DIMsupplier;
DROP FUNCTION IF EXISTS dbo.pDS_DIMsupplier(
    timestamp without time zone
);
DROP VIEW IF EXISTS dbo.lDS_DIMsupplier;
DROP FUNCTION IF EXISTS dbo.dDD_DIMdate1(
    timestamp without time zone, 
    timestamp without time zone, 
    text
);
DROP VIEW IF EXISTS dbo.nDD_DIMdate1;
DROP FUNCTION IF EXISTS dbo.pDD_DIMdate1(
    timestamp without time zone
);
DROP VIEW IF EXISTS dbo.lDD_DIMdate1;
DROP FUNCTION IF EXISTS dbo.dDP_DIMpart(
    timestamp without time zone, 
    timestamp without time zone, 
    text
);
DROP VIEW IF EXISTS dbo.nDP_DIMpart;
DROP FUNCTION IF EXISTS dbo.pDP_DIMpart(
    timestamp without time zone
);
DROP VIEW IF EXISTS dbo.lDP_DIMpart;
DROP FUNCTION IF EXISTS dbo.dFL_FACTlineorder(
    timestamp without time zone, 
    timestamp without time zone, 
    text
);
DROP VIEW IF EXISTS dbo.nFL_FACTlineorder;
DROP FUNCTION IF EXISTS dbo.pFL_FACTlineorder(
    timestamp without time zone
);
DROP VIEW IF EXISTS dbo.lFL_FACTlineorder;
DROP FUNCTION IF EXISTS dbo.dDA_Dimdate2(
    timestamp without time zone, 
    timestamp without time zone, 
    text
);
DROP VIEW IF EXISTS dbo.nDA_Dimdate2;
DROP FUNCTION IF EXISTS dbo.pDA_Dimdate2(
    timestamp without time zone
);
DROP VIEW IF EXISTS dbo.lDA_Dimdate2;
*/
-- Latest perspective -------------------------------------------------------------------------------------------------
-- lDC_DIMcustomer viewed by the latest available information (may include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dbo.lDC_DIMcustomer AS
SELECT
    DC.DC_ID,
    REG.DC_REG_DC_ID,
    REG.DC_REG_DIMcustomer_Region,
    ADD.DC_ADD_DC_ID,
    ADD.DC_ADD_DIMcustomer_Address,
    CIT.DC_CIT_DC_ID,
    CIT.DC_CIT_DIMcustomer_City,
    PHN.DC_PHN_DC_ID,
    PHN.DC_PHN_DIMcustomer_Phone,
    NAT.DC_NAT_DC_ID,
    NAT.DC_NAT_DIMcustomer_Nation,
    NAM.DC_NAM_DC_ID,
    NAM.DC_NAM_DIMcustomer_Name,
    SEG.DC_SEG_DC_ID,
    SEG.DC_SEG_DIMcustomer_Mktsegment
FROM
    dbo.DC_DIMcustomer DC
LEFT JOIN
    dbo.DC_REG_DIMcustomer_Region REG
ON
    REG.DC_REG_DC_ID = DC.DC_ID
LEFT JOIN
    dbo.DC_ADD_DIMcustomer_Address ADD
ON
    ADD.DC_ADD_DC_ID = DC.DC_ID
LEFT JOIN
    dbo.DC_CIT_DIMcustomer_City CIT
ON
    CIT.DC_CIT_DC_ID = DC.DC_ID
LEFT JOIN
    dbo.DC_PHN_DIMcustomer_Phone PHN
ON
    PHN.DC_PHN_DC_ID = DC.DC_ID
LEFT JOIN
    dbo.DC_NAT_DIMcustomer_Nation NAT
ON
    NAT.DC_NAT_DC_ID = DC.DC_ID
LEFT JOIN
    dbo.DC_NAM_DIMcustomer_Name NAM
ON
    NAM.DC_NAM_DC_ID = DC.DC_ID
LEFT JOIN
    dbo.DC_SEG_DIMcustomer_Mktsegment SEG
ON
    SEG.DC_SEG_DC_ID = DC.DC_ID;
-- Latest perspective -------------------------------------------------------------------------------------------------
-- lDS_DIMsupplier viewed by the latest available information (may include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dbo.lDS_DIMsupplier AS
SELECT
    DS.DS_ID,
    REG.DS_REG_DS_ID,
    REG.DS_REG_DIMsupplier_Region,
    CIT.DS_CIT_DS_ID,
    CIT.DS_CIT_DIMsupplier_City,
    NAT.DS_NAT_DS_ID,
    NAT.DS_NAT_DIMsupplier_Nation,
    PHN.DS_PHN_DS_ID,
    PHN.DS_PHN_DIMsupplier_Phone,
    ADD.DS_ADD_DS_ID,
    ADD.DS_ADD_DIMsupplier_Address,
    NAM.DS_NAM_DS_ID,
    NAM.DS_NAM_DIMsupplier_Name
FROM
    dbo.DS_DIMsupplier DS
LEFT JOIN
    dbo.DS_REG_DIMsupplier_Region REG
ON
    REG.DS_REG_DS_ID = DS.DS_ID
LEFT JOIN
    dbo.DS_CIT_DIMsupplier_City CIT
ON
    CIT.DS_CIT_DS_ID = DS.DS_ID
LEFT JOIN
    dbo.DS_NAT_DIMsupplier_Nation NAT
ON
    NAT.DS_NAT_DS_ID = DS.DS_ID
LEFT JOIN
    dbo.DS_PHN_DIMsupplier_Phone PHN
ON
    PHN.DS_PHN_DS_ID = DS.DS_ID
LEFT JOIN
    dbo.DS_ADD_DIMsupplier_Address ADD
ON
    ADD.DS_ADD_DS_ID = DS.DS_ID
LEFT JOIN
    dbo.DS_NAM_DIMsupplier_Name NAM
ON
    NAM.DS_NAM_DS_ID = DS.DS_ID;
-- Latest perspective -------------------------------------------------------------------------------------------------
-- lDD_DIMdate1 viewed by the latest available information (may include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dbo.lDD_DIMdate1 AS
SELECT
    DD.DD_ID,
    DAT.DD_DAT_DD_ID,
    DAT.DD_DAT_DIMdate1_Date,
    YMN.DD_YMN_DD_ID,
    YMN.DD_YMN_DIMdate1_Yearmonthnum,
    MTH.DD_MTH_DD_ID,
    MTH.DD_MTH_DIMdate1_Month,
    DOW.DD_DOW_DD_ID,
    DOW.DD_DOW_DIMdate1_Dayofweek,
    DNW.DD_DNW_DD_ID,
    DNW.DD_DNW_DIMdate1_Daynuminweek,
    YMM.DD_YMM_DD_ID,
    YMM.DD_YMM_DIMdate1_Yearmonth,
    YRS.DD_YRS_DD_ID,
    YRS.DD_YRS_DIMdate1_Year,
    DNM.DD_DNM_DD_ID,
    DNM.DD_DNM_DIMdate1_Daynuminmonth,
    DNY.DD_DNY_DD_ID,
    DNY.DD_DNY_DIMdate1_Daynuminyear,
    DMY.DD_DMY_DD_ID,
    DMY.DD_DMY_DIMdate1_Monthnuminyear,
    WNY.DD_WNY_DD_ID,
    WNY.DD_WNY_DIMdate1_Weeknuminyear,
    SSA.DD_SSA_DD_ID,
    SSA.DD_SSA_DIMdate1_Sellingseason,
    LFL.DD_LFL_DD_ID,
    LFL.DD_LFL_DIMdate1_Lastdayinweekfl,
    LDL.DD_LDL_DD_ID,
    LDL.DD_LDL_DIMdate1_Lastdayinmonthfl,
    HOF.DD_HOF_DD_ID,
    HOF.DD_HOF_DIMdate1_Holydayfl,
    WDF.DD_WDF_DD_ID,
    WDF.DD_WDF_DIMdate1_Weekdayfl
FROM
    dbo.DD_DIMdate1 DD
LEFT JOIN
    dbo.DD_DAT_DIMdate1_Date DAT
ON
    DAT.DD_DAT_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_YMN_DIMdate1_Yearmonthnum YMN
ON
    YMN.DD_YMN_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_MTH_DIMdate1_Month MTH
ON
    MTH.DD_MTH_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_DOW_DIMdate1_Dayofweek DOW
ON
    DOW.DD_DOW_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_DNW_DIMdate1_Daynuminweek DNW
ON
    DNW.DD_DNW_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_YMM_DIMdate1_Yearmonth YMM
ON
    YMM.DD_YMM_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_YRS_DIMdate1_Year YRS
ON
    YRS.DD_YRS_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_DNM_DIMdate1_Daynuminmonth DNM
ON
    DNM.DD_DNM_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_DNY_DIMdate1_Daynuminyear DNY
ON
    DNY.DD_DNY_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_DMY_DIMdate1_Monthnuminyear DMY
ON
    DMY.DD_DMY_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_WNY_DIMdate1_Weeknuminyear WNY
ON
    WNY.DD_WNY_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_SSA_DIMdate1_Sellingseason SSA
ON
    SSA.DD_SSA_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_LFL_DIMdate1_Lastdayinweekfl LFL
ON
    LFL.DD_LFL_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_LDL_DIMdate1_Lastdayinmonthfl LDL
ON
    LDL.DD_LDL_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_HOF_DIMdate1_Holydayfl HOF
ON
    HOF.DD_HOF_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_WDF_DIMdate1_Weekdayfl WDF
ON
    WDF.DD_WDF_DD_ID = DD.DD_ID;
-- Latest perspective -------------------------------------------------------------------------------------------------
-- lDP_DIMpart viewed by the latest available information (may include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dbo.lDP_DIMpart AS
SELECT
    DP.DP_ID,
    NAM.DP_NAM_DP_ID,
    NAM.DP_NAM_DIMpart_Name,
    MTG.DP_MTG_DP_ID,
    MTG.DP_MTG_DIMpart_Mfgr,
    CAT.DP_CAT_DP_ID,
    CAT.DP_CAT_DIMpart_Category,
    BRA.DP_BRA_DP_ID,
    BRA.DP_BRA_DIMpart_Brand1,
    COL.DP_COL_DP_ID,
    COL.DP_COL_DIMpart_Color,
    TYP.DP_TYP_DP_ID,
    TYP.DP_TYP_DIMpart_Type,
    SIZ.DP_SIZ_DP_ID,
    SIZ.DP_SIZ_DIMpart_Size,
    CON.DP_CON_DP_ID,
    CON.DP_CON_DIMpart_Container
FROM
    dbo.DP_DIMpart DP
LEFT JOIN
    dbo.DP_NAM_DIMpart_Name NAM
ON
    NAM.DP_NAM_DP_ID = DP.DP_ID
LEFT JOIN
    dbo.DP_MTG_DIMpart_Mfgr MTG
ON
    MTG.DP_MTG_DP_ID = DP.DP_ID
LEFT JOIN
    dbo.DP_CAT_DIMpart_Category CAT
ON
    CAT.DP_CAT_DP_ID = DP.DP_ID
LEFT JOIN
    dbo.DP_BRA_DIMpart_Brand1 BRA
ON
    BRA.DP_BRA_DP_ID = DP.DP_ID
LEFT JOIN
    dbo.DP_COL_DIMpart_Color COL
ON
    COL.DP_COL_DP_ID = DP.DP_ID
LEFT JOIN
    dbo.DP_TYP_DIMpart_Type TYP
ON
    TYP.DP_TYP_DP_ID = DP.DP_ID
LEFT JOIN
    dbo.DP_SIZ_DIMpart_Size SIZ
ON
    SIZ.DP_SIZ_DP_ID = DP.DP_ID
LEFT JOIN
    dbo.DP_CON_DIMpart_Container CON
ON
    CON.DP_CON_DP_ID = DP.DP_ID;
-- Latest perspective -------------------------------------------------------------------------------------------------
-- lFL_FACTlineorder viewed by the latest available information (may include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dbo.lFL_FACTlineorder AS
SELECT
    FL.FL_ID,
    SHP.FL_SHP_FL_ID,
    SHP.FL_SHP_FACTlineorder_Shippriority,
    OPY.FL_OPY_FL_ID,
    OPY.FL_OPY_FACTlineorder_Orderpriority,
    LNB.FL_LNB_FL_ID,
    LNB.FL_LNB_FACTlineorder_Linenumber,
    TXA.FL_TXA_FL_ID,
    TXA.FL_TXA_FACTlineorder_Tax,
    QTY.FL_QTY_FL_ID,
    QTY.FL_QTY_FACTlineorder_Quantity,
    EPR.FL_EPR_FL_ID,
    EPR.FL_EPR_FACTlineorder_Extendedprice,
    OTP.FL_OTP_FL_ID,
    OTP.FL_OTP_FACTlineorder_Ordtotalprice,
    DSC.FL_DSC_FL_ID,
    DSC.FL_DSC_FACTlineorder_Discount,
    SCT.FL_SCT_FL_ID,
    SCT.FL_SCT_FACTlineorder_Supplycost,
    SHM.FL_SHM_FL_ID,
    SHM.FL_SHM_FACTlineorder_Shipmode,
    RVN.FL_RVN_FL_ID,
    RVN.FL_RVN_FACTlineorder_Revenue
FROM
    dbo.FL_FACTlineorder FL
LEFT JOIN
    dbo.FL_SHP_FACTlineorder_Shippriority SHP
ON
    SHP.FL_SHP_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_OPY_FACTlineorder_Orderpriority OPY
ON
    OPY.FL_OPY_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_LNB_FACTlineorder_Linenumber LNB
ON
    LNB.FL_LNB_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_TXA_FACTlineorder_Tax TXA
ON
    TXA.FL_TXA_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_QTY_FACTlineorder_Quantity QTY
ON
    QTY.FL_QTY_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_EPR_FACTlineorder_Extendedprice EPR
ON
    EPR.FL_EPR_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_OTP_FACTlineorder_Ordtotalprice OTP
ON
    OTP.FL_OTP_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_DSC_FACTlineorder_Discount DSC
ON
    DSC.FL_DSC_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_SCT_FACTlineorder_Supplycost SCT
ON
    SCT.FL_SCT_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_SHM_FACTlineorder_Shipmode SHM
ON
    SHM.FL_SHM_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_RVN_FACTlineorder_Revenue RVN
ON
    RVN.FL_RVN_FL_ID = FL.FL_ID;
-- Latest perspective -------------------------------------------------------------------------------------------------
-- lDA_Dimdate2 viewed by the latest available information (may include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dbo.lDA_Dimdate2 AS
SELECT
    DA.DA_ID,
    DNM.DA_DNM_DA_ID,
    DNM.DA_DNM_Dimdate2_Daynuminmonth,
    WNY.DA_WNY_DA_ID,
    WNY.DA_WNY_Dimdate2_Weeknuminyear,
    SSS.DA_SSS_DA_ID,
    SSS.DA_SSS_Dimdate2_Sellingseasons,
    LDF.DA_LDF_DA_ID,
    LDF.DA_LDF_Dimdate2_Lastdayinweekfl,
    DAT.DA_DAT_DA_ID,
    DAT.DA_DAT_Dimdate2_Date,
    DOW.DA_DOW_DA_ID,
    DOW.DA_DOW_Dimdate2_Dayofweek,
    YRS.DA_YRS_DA_ID,
    YRS.DA_YRS_Dimdate2_Year,
    YMN.DA_YMN_DA_ID,
    YMN.DA_YMN_Dimdate2_Yearmonthnum,
    MMM.DA_MMM_DA_ID,
    MMM.DA_MMM_Dimdate2_Month,
    DNW.DA_DNW_DA_ID,
    DNW.DA_DNW_Dimdate2_Daynuminweek,
    YMM.DA_YMM_DA_ID,
    YMM.DA_YMM_Dimdate2_Yearmonth,
    MNY.DA_MNY_DA_ID,
    MNY.DA_MNY_Dimdate2_Monthnuminyear,
    DNY.DA_DNY_DA_ID,
    DNY.DA_DNY_Dimdate2_Daynuminyear,
    LIF.DA_LIF_DA_ID,
    LIF.DA_LIF_Dimdate2_Lastdayinmonthfl,
    HFL.DA_HFL_DA_ID,
    HFL.DA_HFL_Dimdate2_HolydayFL,
    WDF.DA_WDF_DA_ID,
    WDF.DA_WDF_Dimdate2_Weekdayfl
FROM
    dbo.DA_Dimdate2 DA
LEFT JOIN
    dbo.DA_DNM_Dimdate2_Daynuminmonth DNM
ON
    DNM.DA_DNM_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_WNY_Dimdate2_Weeknuminyear WNY
ON
    WNY.DA_WNY_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_SSS_Dimdate2_Sellingseasons SSS
ON
    SSS.DA_SSS_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_LDF_Dimdate2_Lastdayinweekfl LDF
ON
    LDF.DA_LDF_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_DAT_Dimdate2_Date DAT
ON
    DAT.DA_DAT_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_DOW_Dimdate2_Dayofweek DOW
ON
    DOW.DA_DOW_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_YRS_Dimdate2_Year YRS
ON
    YRS.DA_YRS_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_YMN_Dimdate2_Yearmonthnum YMN
ON
    YMN.DA_YMN_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_MMM_Dimdate2_Month MMM
ON
    MMM.DA_MMM_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_DNW_Dimdate2_Daynuminweek DNW
ON
    DNW.DA_DNW_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_YMM_Dimdate2_Yearmonth YMM
ON
    YMM.DA_YMM_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_MNY_Dimdate2_Monthnuminyear MNY
ON
    MNY.DA_MNY_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_DNY_Dimdate2_Daynuminyear DNY
ON
    DNY.DA_DNY_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_LIF_Dimdate2_Lastdayinmonthfl LIF
ON
    LIF.DA_LIF_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_HFL_Dimdate2_HolydayFL HFL
ON
    HFL.DA_HFL_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_WDF_Dimdate2_Weekdayfl WDF
ON
    WDF.DA_WDF_DA_ID = DA.DA_ID;
-- Point-in-time perspective ------------------------------------------------------------------------------------------
-- pDC_DIMcustomer viewed as it was on the given timepoint
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION dbo.pDC_DIMcustomer (
    changingTimepoint timestamp without time zone
)
RETURNS TABLE (
    DC_ID int,
    DC_REG_DC_ID int,
    DC_REG_DIMcustomer_Region Char(12),
    DC_ADD_DC_ID int,
    DC_ADD_DIMcustomer_Address Varchar(25),
    DC_CIT_DC_ID int,
    DC_CIT_DIMcustomer_City Char(10),
    DC_PHN_DC_ID int,
    DC_PHN_DIMcustomer_Phone char(15),
    DC_NAT_DC_ID int,
    DC_NAT_DIMcustomer_Nation Char(15),
    DC_NAM_DC_ID int,
    DC_NAM_DIMcustomer_Name Varchar(25),
    DC_SEG_DC_ID int,
    DC_SEG_DIMcustomer_Mktsegment Char(10)
) AS '
SELECT
    DC.DC_ID,
    REG.DC_REG_DC_ID,
    REG.DC_REG_DIMcustomer_Region,
    ADD.DC_ADD_DC_ID,
    ADD.DC_ADD_DIMcustomer_Address,
    CIT.DC_CIT_DC_ID,
    CIT.DC_CIT_DIMcustomer_City,
    PHN.DC_PHN_DC_ID,
    PHN.DC_PHN_DIMcustomer_Phone,
    NAT.DC_NAT_DC_ID,
    NAT.DC_NAT_DIMcustomer_Nation,
    NAM.DC_NAM_DC_ID,
    NAM.DC_NAM_DIMcustomer_Name,
    SEG.DC_SEG_DC_ID,
    SEG.DC_SEG_DIMcustomer_Mktsegment
FROM
    dbo.DC_DIMcustomer DC
LEFT JOIN
    dbo.DC_REG_DIMcustomer_Region REG
ON
    REG.DC_REG_DC_ID = DC.DC_ID
LEFT JOIN
    dbo.DC_ADD_DIMcustomer_Address ADD
ON
    ADD.DC_ADD_DC_ID = DC.DC_ID
LEFT JOIN
    dbo.DC_CIT_DIMcustomer_City CIT
ON
    CIT.DC_CIT_DC_ID = DC.DC_ID
LEFT JOIN
    dbo.DC_PHN_DIMcustomer_Phone PHN
ON
    PHN.DC_PHN_DC_ID = DC.DC_ID
LEFT JOIN
    dbo.DC_NAT_DIMcustomer_Nation NAT
ON
    NAT.DC_NAT_DC_ID = DC.DC_ID
LEFT JOIN
    dbo.DC_NAM_DIMcustomer_Name NAM
ON
    NAM.DC_NAM_DC_ID = DC.DC_ID
LEFT JOIN
    dbo.DC_SEG_DIMcustomer_Mktsegment SEG
ON
    SEG.DC_SEG_DC_ID = DC.DC_ID;
' LANGUAGE SQL;
-- Point-in-time perspective ------------------------------------------------------------------------------------------
-- pDS_DIMsupplier viewed as it was on the given timepoint
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION dbo.pDS_DIMsupplier (
    changingTimepoint timestamp without time zone
)
RETURNS TABLE (
    DS_ID int,
    DS_REG_DS_ID int,
    DS_REG_DIMsupplier_Region Char(12),
    DS_CIT_DS_ID int,
    DS_CIT_DIMsupplier_City Char(10),
    DS_NAT_DS_ID int,
    DS_NAT_DIMsupplier_Nation Char(15),
    DS_PHN_DS_ID int,
    DS_PHN_DIMsupplier_Phone char(15),
    DS_ADD_DS_ID int,
    DS_ADD_DIMsupplier_Address Varchar(25),
    DS_NAM_DS_ID int,
    DS_NAM_DIMsupplier_Name Char(25)
) AS '
SELECT
    DS.DS_ID,
    REG.DS_REG_DS_ID,
    REG.DS_REG_DIMsupplier_Region,
    CIT.DS_CIT_DS_ID,
    CIT.DS_CIT_DIMsupplier_City,
    NAT.DS_NAT_DS_ID,
    NAT.DS_NAT_DIMsupplier_Nation,
    PHN.DS_PHN_DS_ID,
    PHN.DS_PHN_DIMsupplier_Phone,
    ADD.DS_ADD_DS_ID,
    ADD.DS_ADD_DIMsupplier_Address,
    NAM.DS_NAM_DS_ID,
    NAM.DS_NAM_DIMsupplier_Name
FROM
    dbo.DS_DIMsupplier DS
LEFT JOIN
    dbo.DS_REG_DIMsupplier_Region REG
ON
    REG.DS_REG_DS_ID = DS.DS_ID
LEFT JOIN
    dbo.DS_CIT_DIMsupplier_City CIT
ON
    CIT.DS_CIT_DS_ID = DS.DS_ID
LEFT JOIN
    dbo.DS_NAT_DIMsupplier_Nation NAT
ON
    NAT.DS_NAT_DS_ID = DS.DS_ID
LEFT JOIN
    dbo.DS_PHN_DIMsupplier_Phone PHN
ON
    PHN.DS_PHN_DS_ID = DS.DS_ID
LEFT JOIN
    dbo.DS_ADD_DIMsupplier_Address ADD
ON
    ADD.DS_ADD_DS_ID = DS.DS_ID
LEFT JOIN
    dbo.DS_NAM_DIMsupplier_Name NAM
ON
    NAM.DS_NAM_DS_ID = DS.DS_ID;
' LANGUAGE SQL;
-- Point-in-time perspective ------------------------------------------------------------------------------------------
-- pDD_DIMdate1 viewed as it was on the given timepoint
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION dbo.pDD_DIMdate1 (
    changingTimepoint timestamp without time zone
)
RETURNS TABLE (
    DD_ID int,
    DD_DAT_DD_ID int,
    DD_DAT_DIMdate1_Date Varchar(18),
    DD_YMN_DD_ID int,
    DD_YMN_DIMdate1_Yearmonthnum Numeric(14),
    DD_MTH_DD_ID int,
    DD_MTH_DIMdate1_Month Varchar(9),
    DD_DOW_DD_ID int,
    DD_DOW_DIMdate1_Dayofweek Varchar(9),
    DD_DNW_DD_ID int,
    DD_DNW_DIMdate1_Daynuminweek Numeric(7),
    DD_YMM_DD_ID int,
    DD_YMM_DIMdate1_Yearmonth Varchar(7),
    DD_YRS_DD_ID int,
    DD_YRS_DIMdate1_Year smallint,
    DD_DNM_DD_ID int,
    DD_DNM_DIMdate1_Daynuminmonth Numeric(31),
    DD_DNY_DD_ID int,
    DD_DNY_DIMdate1_Daynuminyear Numeric(31),
    DD_DMY_DD_ID int,
    DD_DMY_DIMdate1_Monthnuminyear Numeric(12),
    DD_WNY_DD_ID int,
    DD_WNY_DIMdate1_Weeknuminyear Numeric(53),
    DD_SSA_DD_ID int,
    DD_SSA_DIMdate1_Sellingseason Varchar(12),
    DD_LFL_DD_ID int,
    DD_LFL_DIMdate1_Lastdayinweekfl char(1),
    DD_LDL_DD_ID int,
    DD_LDL_DIMdate1_Lastdayinmonthfl char(1),
    DD_HOF_DD_ID int,
    DD_HOF_DIMdate1_Holydayfl char(1),
    DD_WDF_DD_ID int,
    DD_WDF_DIMdate1_Weekdayfl char(1)
) AS '
SELECT
    DD.DD_ID,
    DAT.DD_DAT_DD_ID,
    DAT.DD_DAT_DIMdate1_Date,
    YMN.DD_YMN_DD_ID,
    YMN.DD_YMN_DIMdate1_Yearmonthnum,
    MTH.DD_MTH_DD_ID,
    MTH.DD_MTH_DIMdate1_Month,
    DOW.DD_DOW_DD_ID,
    DOW.DD_DOW_DIMdate1_Dayofweek,
    DNW.DD_DNW_DD_ID,
    DNW.DD_DNW_DIMdate1_Daynuminweek,
    YMM.DD_YMM_DD_ID,
    YMM.DD_YMM_DIMdate1_Yearmonth,
    YRS.DD_YRS_DD_ID,
    YRS.DD_YRS_DIMdate1_Year,
    DNM.DD_DNM_DD_ID,
    DNM.DD_DNM_DIMdate1_Daynuminmonth,
    DNY.DD_DNY_DD_ID,
    DNY.DD_DNY_DIMdate1_Daynuminyear,
    DMY.DD_DMY_DD_ID,
    DMY.DD_DMY_DIMdate1_Monthnuminyear,
    WNY.DD_WNY_DD_ID,
    WNY.DD_WNY_DIMdate1_Weeknuminyear,
    SSA.DD_SSA_DD_ID,
    SSA.DD_SSA_DIMdate1_Sellingseason,
    LFL.DD_LFL_DD_ID,
    LFL.DD_LFL_DIMdate1_Lastdayinweekfl,
    LDL.DD_LDL_DD_ID,
    LDL.DD_LDL_DIMdate1_Lastdayinmonthfl,
    HOF.DD_HOF_DD_ID,
    HOF.DD_HOF_DIMdate1_Holydayfl,
    WDF.DD_WDF_DD_ID,
    WDF.DD_WDF_DIMdate1_Weekdayfl
FROM
    dbo.DD_DIMdate1 DD
LEFT JOIN
    dbo.DD_DAT_DIMdate1_Date DAT
ON
    DAT.DD_DAT_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_YMN_DIMdate1_Yearmonthnum YMN
ON
    YMN.DD_YMN_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_MTH_DIMdate1_Month MTH
ON
    MTH.DD_MTH_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_DOW_DIMdate1_Dayofweek DOW
ON
    DOW.DD_DOW_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_DNW_DIMdate1_Daynuminweek DNW
ON
    DNW.DD_DNW_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_YMM_DIMdate1_Yearmonth YMM
ON
    YMM.DD_YMM_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_YRS_DIMdate1_Year YRS
ON
    YRS.DD_YRS_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_DNM_DIMdate1_Daynuminmonth DNM
ON
    DNM.DD_DNM_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_DNY_DIMdate1_Daynuminyear DNY
ON
    DNY.DD_DNY_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_DMY_DIMdate1_Monthnuminyear DMY
ON
    DMY.DD_DMY_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_WNY_DIMdate1_Weeknuminyear WNY
ON
    WNY.DD_WNY_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_SSA_DIMdate1_Sellingseason SSA
ON
    SSA.DD_SSA_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_LFL_DIMdate1_Lastdayinweekfl LFL
ON
    LFL.DD_LFL_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_LDL_DIMdate1_Lastdayinmonthfl LDL
ON
    LDL.DD_LDL_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_HOF_DIMdate1_Holydayfl HOF
ON
    HOF.DD_HOF_DD_ID = DD.DD_ID
LEFT JOIN
    dbo.DD_WDF_DIMdate1_Weekdayfl WDF
ON
    WDF.DD_WDF_DD_ID = DD.DD_ID;
' LANGUAGE SQL;
-- Point-in-time perspective ------------------------------------------------------------------------------------------
-- pDP_DIMpart viewed as it was on the given timepoint
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION dbo.pDP_DIMpart (
    changingTimepoint timestamp without time zone
)
RETURNS TABLE (
    DP_ID int,
    DP_NAM_DP_ID int,
    DP_NAM_DIMpart_Name varchar(22),
    DP_MTG_DP_ID int,
    DP_MTG_DIMpart_Mfgr Varchar(6),
    DP_CAT_DP_ID int,
    DP_CAT_DIMpart_Category Varchar(7),
    DP_BRA_DP_ID int,
    DP_BRA_DIMpart_Brand1 Varchar(9),
    DP_COL_DP_ID int,
    DP_COL_DIMpart_Color Varchar(11),
    DP_TYP_DP_ID int,
    DP_TYP_DIMpart_Type Varchar(25),
    DP_SIZ_DP_ID int,
    DP_SIZ_DIMpart_Size Numeric(50),
    DP_CON_DP_ID int,
    DP_CON_DIMpart_Container Char(10)
) AS '
SELECT
    DP.DP_ID,
    NAM.DP_NAM_DP_ID,
    NAM.DP_NAM_DIMpart_Name,
    MTG.DP_MTG_DP_ID,
    MTG.DP_MTG_DIMpart_Mfgr,
    CAT.DP_CAT_DP_ID,
    CAT.DP_CAT_DIMpart_Category,
    BRA.DP_BRA_DP_ID,
    BRA.DP_BRA_DIMpart_Brand1,
    COL.DP_COL_DP_ID,
    COL.DP_COL_DIMpart_Color,
    TYP.DP_TYP_DP_ID,
    TYP.DP_TYP_DIMpart_Type,
    SIZ.DP_SIZ_DP_ID,
    SIZ.DP_SIZ_DIMpart_Size,
    CON.DP_CON_DP_ID,
    CON.DP_CON_DIMpart_Container
FROM
    dbo.DP_DIMpart DP
LEFT JOIN
    dbo.DP_NAM_DIMpart_Name NAM
ON
    NAM.DP_NAM_DP_ID = DP.DP_ID
LEFT JOIN
    dbo.DP_MTG_DIMpart_Mfgr MTG
ON
    MTG.DP_MTG_DP_ID = DP.DP_ID
LEFT JOIN
    dbo.DP_CAT_DIMpart_Category CAT
ON
    CAT.DP_CAT_DP_ID = DP.DP_ID
LEFT JOIN
    dbo.DP_BRA_DIMpart_Brand1 BRA
ON
    BRA.DP_BRA_DP_ID = DP.DP_ID
LEFT JOIN
    dbo.DP_COL_DIMpart_Color COL
ON
    COL.DP_COL_DP_ID = DP.DP_ID
LEFT JOIN
    dbo.DP_TYP_DIMpart_Type TYP
ON
    TYP.DP_TYP_DP_ID = DP.DP_ID
LEFT JOIN
    dbo.DP_SIZ_DIMpart_Size SIZ
ON
    SIZ.DP_SIZ_DP_ID = DP.DP_ID
LEFT JOIN
    dbo.DP_CON_DIMpart_Container CON
ON
    CON.DP_CON_DP_ID = DP.DP_ID;
' LANGUAGE SQL;
-- Point-in-time perspective ------------------------------------------------------------------------------------------
-- pFL_FACTlineorder viewed as it was on the given timepoint
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION dbo.pFL_FACTlineorder (
    changingTimepoint timestamp without time zone
)
RETURNS TABLE (
    FL_ID int,
    FL_SHP_FL_ID int,
    FL_SHP_FACTlineorder_Shippriority Char(1),
    FL_OPY_FL_ID int,
    FL_OPY_FACTlineorder_Orderpriority Char(15),
    FL_LNB_FL_ID int,
    FL_LNB_FACTlineorder_Linenumber numeric(7),
    FL_TXA_FL_ID int,
    FL_TXA_FACTlineorder_Tax numeric(8),
    FL_QTY_FL_ID int,
    FL_QTY_FACTlineorder_Quantity Numeric(50),
    FL_EPR_FL_ID int,
    FL_EPR_FACTlineorder_Extendedprice numeric(200),
    FL_OTP_FL_ID int,
    FL_OTP_FACTlineorder_Ordtotalprice Numeric(200),
    FL_DSC_FL_ID int,
    FL_DSC_FACTlineorder_Discount Numeric(10),
    FL_SCT_FL_ID int,
    FL_SCT_FACTlineorder_Supplycost Numeric(200),
    FL_SHM_FL_ID int,
    FL_SHM_FACTlineorder_Shipmode char(10),
    FL_RVN_FL_ID int,
    FL_RVN_FACTlineorder_Revenue numeric
) AS '
SELECT
    FL.FL_ID,
    SHP.FL_SHP_FL_ID,
    SHP.FL_SHP_FACTlineorder_Shippriority,
    OPY.FL_OPY_FL_ID,
    OPY.FL_OPY_FACTlineorder_Orderpriority,
    LNB.FL_LNB_FL_ID,
    LNB.FL_LNB_FACTlineorder_Linenumber,
    TXA.FL_TXA_FL_ID,
    TXA.FL_TXA_FACTlineorder_Tax,
    QTY.FL_QTY_FL_ID,
    QTY.FL_QTY_FACTlineorder_Quantity,
    EPR.FL_EPR_FL_ID,
    EPR.FL_EPR_FACTlineorder_Extendedprice,
    OTP.FL_OTP_FL_ID,
    OTP.FL_OTP_FACTlineorder_Ordtotalprice,
    DSC.FL_DSC_FL_ID,
    DSC.FL_DSC_FACTlineorder_Discount,
    SCT.FL_SCT_FL_ID,
    SCT.FL_SCT_FACTlineorder_Supplycost,
    SHM.FL_SHM_FL_ID,
    SHM.FL_SHM_FACTlineorder_Shipmode,
    RVN.FL_RVN_FL_ID,
    RVN.FL_RVN_FACTlineorder_Revenue
FROM
    dbo.FL_FACTlineorder FL
LEFT JOIN
    dbo.FL_SHP_FACTlineorder_Shippriority SHP
ON
    SHP.FL_SHP_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_OPY_FACTlineorder_Orderpriority OPY
ON
    OPY.FL_OPY_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_LNB_FACTlineorder_Linenumber LNB
ON
    LNB.FL_LNB_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_TXA_FACTlineorder_Tax TXA
ON
    TXA.FL_TXA_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_QTY_FACTlineorder_Quantity QTY
ON
    QTY.FL_QTY_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_EPR_FACTlineorder_Extendedprice EPR
ON
    EPR.FL_EPR_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_OTP_FACTlineorder_Ordtotalprice OTP
ON
    OTP.FL_OTP_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_DSC_FACTlineorder_Discount DSC
ON
    DSC.FL_DSC_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_SCT_FACTlineorder_Supplycost SCT
ON
    SCT.FL_SCT_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_SHM_FACTlineorder_Shipmode SHM
ON
    SHM.FL_SHM_FL_ID = FL.FL_ID
LEFT JOIN
    dbo.FL_RVN_FACTlineorder_Revenue RVN
ON
    RVN.FL_RVN_FL_ID = FL.FL_ID;
' LANGUAGE SQL;
-- Point-in-time perspective ------------------------------------------------------------------------------------------
-- pDA_Dimdate2 viewed as it was on the given timepoint
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION dbo.pDA_Dimdate2 (
    changingTimepoint timestamp without time zone
)
RETURNS TABLE (
    DA_ID int,
    DA_DNM_DA_ID int,
    DA_DNM_Dimdate2_Daynuminmonth integer,
    DA_WNY_DA_ID int,
    DA_WNY_Dimdate2_Weeknuminyear integer,
    DA_SSS_DA_ID int,
    DA_SSS_Dimdate2_Sellingseasons text,
    DA_LDF_DA_ID int,
    DA_LDF_Dimdate2_Lastdayinweekfl char(1),
    DA_DAT_DA_ID int,
    DA_DAT_Dimdate2_Date varchar(18),
    DA_DOW_DA_ID int,
    DA_DOW_Dimdate2_Dayofweek varchar(9),
    DA_YRS_DA_ID int,
    DA_YRS_Dimdate2_Year integer,
    DA_YMN_DA_ID int,
    DA_YMN_Dimdate2_Yearmonthnum Integer,
    DA_MMM_DA_ID int,
    DA_MMM_Dimdate2_Month varchar(9),
    DA_DNW_DA_ID int,
    DA_DNW_Dimdate2_Daynuminweek integer,
    DA_YMM_DA_ID int,
    DA_YMM_Dimdate2_Yearmonth varchar(7),
    DA_MNY_DA_ID int,
    DA_MNY_Dimdate2_Monthnuminyear integer,
    DA_DNY_DA_ID int,
    DA_DNY_Dimdate2_Daynuminyear integer,
    DA_LIF_DA_ID int,
    DA_LIF_Dimdate2_Lastdayinmonthfl char(1),
    DA_HFL_DA_ID int,
    DA_HFL_Dimdate2_HolydayFL char(1),
    DA_WDF_DA_ID int,
    DA_WDF_Dimdate2_Weekdayfl char(1)
) AS '
SELECT
    DA.DA_ID,
    DNM.DA_DNM_DA_ID,
    DNM.DA_DNM_Dimdate2_Daynuminmonth,
    WNY.DA_WNY_DA_ID,
    WNY.DA_WNY_Dimdate2_Weeknuminyear,
    SSS.DA_SSS_DA_ID,
    SSS.DA_SSS_Dimdate2_Sellingseasons,
    LDF.DA_LDF_DA_ID,
    LDF.DA_LDF_Dimdate2_Lastdayinweekfl,
    DAT.DA_DAT_DA_ID,
    DAT.DA_DAT_Dimdate2_Date,
    DOW.DA_DOW_DA_ID,
    DOW.DA_DOW_Dimdate2_Dayofweek,
    YRS.DA_YRS_DA_ID,
    YRS.DA_YRS_Dimdate2_Year,
    YMN.DA_YMN_DA_ID,
    YMN.DA_YMN_Dimdate2_Yearmonthnum,
    MMM.DA_MMM_DA_ID,
    MMM.DA_MMM_Dimdate2_Month,
    DNW.DA_DNW_DA_ID,
    DNW.DA_DNW_Dimdate2_Daynuminweek,
    YMM.DA_YMM_DA_ID,
    YMM.DA_YMM_Dimdate2_Yearmonth,
    MNY.DA_MNY_DA_ID,
    MNY.DA_MNY_Dimdate2_Monthnuminyear,
    DNY.DA_DNY_DA_ID,
    DNY.DA_DNY_Dimdate2_Daynuminyear,
    LIF.DA_LIF_DA_ID,
    LIF.DA_LIF_Dimdate2_Lastdayinmonthfl,
    HFL.DA_HFL_DA_ID,
    HFL.DA_HFL_Dimdate2_HolydayFL,
    WDF.DA_WDF_DA_ID,
    WDF.DA_WDF_Dimdate2_Weekdayfl
FROM
    dbo.DA_Dimdate2 DA
LEFT JOIN
    dbo.DA_DNM_Dimdate2_Daynuminmonth DNM
ON
    DNM.DA_DNM_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_WNY_Dimdate2_Weeknuminyear WNY
ON
    WNY.DA_WNY_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_SSS_Dimdate2_Sellingseasons SSS
ON
    SSS.DA_SSS_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_LDF_Dimdate2_Lastdayinweekfl LDF
ON
    LDF.DA_LDF_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_DAT_Dimdate2_Date DAT
ON
    DAT.DA_DAT_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_DOW_Dimdate2_Dayofweek DOW
ON
    DOW.DA_DOW_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_YRS_Dimdate2_Year YRS
ON
    YRS.DA_YRS_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_YMN_Dimdate2_Yearmonthnum YMN
ON
    YMN.DA_YMN_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_MMM_Dimdate2_Month MMM
ON
    MMM.DA_MMM_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_DNW_Dimdate2_Daynuminweek DNW
ON
    DNW.DA_DNW_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_YMM_Dimdate2_Yearmonth YMM
ON
    YMM.DA_YMM_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_MNY_Dimdate2_Monthnuminyear MNY
ON
    MNY.DA_MNY_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_DNY_Dimdate2_Daynuminyear DNY
ON
    DNY.DA_DNY_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_LIF_Dimdate2_Lastdayinmonthfl LIF
ON
    LIF.DA_LIF_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_HFL_Dimdate2_HolydayFL HFL
ON
    HFL.DA_HFL_DA_ID = DA.DA_ID
LEFT JOIN
    dbo.DA_WDF_Dimdate2_Weekdayfl WDF
ON
    WDF.DA_WDF_DA_ID = DA.DA_ID;
' LANGUAGE SQL;
-- Now perspective ----------------------------------------------------------------------------------------------------
-- nDC_DIMcustomer viewed as it currently is (cannot include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dbo.nDC_DIMcustomer AS
SELECT
    *
FROM
    dbo.pDC_DIMcustomer(LOCALTIMESTAMP);
-- Now perspective ----------------------------------------------------------------------------------------------------
-- nDS_DIMsupplier viewed as it currently is (cannot include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dbo.nDS_DIMsupplier AS
SELECT
    *
FROM
    dbo.pDS_DIMsupplier(LOCALTIMESTAMP);
-- Now perspective ----------------------------------------------------------------------------------------------------
-- nDD_DIMdate1 viewed as it currently is (cannot include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dbo.nDD_DIMdate1 AS
SELECT
    *
FROM
    dbo.pDD_DIMdate1(LOCALTIMESTAMP);
-- Now perspective ----------------------------------------------------------------------------------------------------
-- nDP_DIMpart viewed as it currently is (cannot include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dbo.nDP_DIMpart AS
SELECT
    *
FROM
    dbo.pDP_DIMpart(LOCALTIMESTAMP);
-- Now perspective ----------------------------------------------------------------------------------------------------
-- nFL_FACTlineorder viewed as it currently is (cannot include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dbo.nFL_FACTlineorder AS
SELECT
    *
FROM
    dbo.pFL_FACTlineorder(LOCALTIMESTAMP);
-- Now perspective ----------------------------------------------------------------------------------------------------
-- nDA_Dimdate2 viewed as it currently is (cannot include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dbo.nDA_Dimdate2 AS
SELECT
    *
FROM
    dbo.pDA_Dimdate2(LOCALTIMESTAMP);
-- ATTRIBUTE TRIGGERS -------------------------------------------------------------------------------------------------
--
-- The following triggers on the attributes make them behave like tables.
-- They will ensure that such operations are propagated to the underlying tables
-- in a consistent way. Default values are used for some columns if not provided
-- by the corresponding SQL statements.
--
-- For idempotent attributes, only changes that represent a value different from
-- the previous or following value are stored. Others are silently ignored in
-- order to avoid unnecessary temporal duplicates.
--
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDC_REG_DIMcustomer_Region ON dbo.DC_REG_DIMcustomer_Region;
-- DROP FUNCTION IF EXISTS dbo.tcbDC_REG_DIMcustomer_Region();
CREATE OR REPLACE FUNCTION dbo.tcbDC_REG_DIMcustomer_Region() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DC_REG_DIMcustomer_Region (
            DC_REG_DC_ID int not null,
            DC_REG_DIMcustomer_Region Char(12) not null,
            DC_REG_Version bigint not null,
            DC_REG_StatementType char(1) not null,
            primary key(
                DC_REG_Version,
                DC_REG_DC_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDC_REG_DIMcustomer_Region
BEFORE INSERT ON dbo.DC_REG_DIMcustomer_Region
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDC_REG_DIMcustomer_Region();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDC_REG_DIMcustomer_Region ON dbo.DC_REG_DIMcustomer_Region;
-- DROP FUNCTION IF EXISTS dbo.tciDC_REG_DIMcustomer_Region();
CREATE OR REPLACE FUNCTION dbo.tciDC_REG_DIMcustomer_Region() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DC_REG_DIMcustomer_Region
        SELECT
            NEW.DC_REG_DC_ID,
            NEW.DC_REG_DIMcustomer_Region,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDC_REG_DIMcustomer_Region
INSTEAD OF INSERT ON dbo.DC_REG_DIMcustomer_Region
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDC_REG_DIMcustomer_Region();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDC_REG_DIMcustomer_Region ON dbo.DC_REG_DIMcustomer_Region;
-- DROP FUNCTION IF EXISTS dbo.tcaDC_REG_DIMcustomer_Region();
CREATE OR REPLACE FUNCTION dbo.tcaDC_REG_DIMcustomer_Region() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DC_REG_Version) INTO maxVersion
    FROM
        _tmp_DC_REG_DIMcustomer_Region;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DC_REG_DIMcustomer_Region
        SET
            DC_REG_StatementType =
                CASE
                    WHEN REG.DC_REG_DC_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DC_REG_DIMcustomer_Region v
        LEFT JOIN
            dbo._DC_REG_DIMcustomer_Region REG
        ON
            REG.DC_REG_DC_ID = v.DC_REG_DC_ID
        AND
            REG.DC_REG_DIMcustomer_Region = v.DC_REG_DIMcustomer_Region
        WHERE
            v.DC_REG_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DC_REG_DIMcustomer_Region (
            DC_REG_DC_ID,
            DC_REG_DIMcustomer_Region
        )
        SELECT
            DC_REG_DC_ID,
            DC_REG_DIMcustomer_Region
        FROM
            _tmp_DC_REG_DIMcustomer_Region
        WHERE
            DC_REG_Version = currentVersion
        AND
            DC_REG_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DC_REG_DIMcustomer_Region;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDC_REG_DIMcustomer_Region
AFTER INSERT ON dbo.DC_REG_DIMcustomer_Region
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDC_REG_DIMcustomer_Region();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDC_ADD_DIMcustomer_Address ON dbo.DC_ADD_DIMcustomer_Address;
-- DROP FUNCTION IF EXISTS dbo.tcbDC_ADD_DIMcustomer_Address();
CREATE OR REPLACE FUNCTION dbo.tcbDC_ADD_DIMcustomer_Address() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DC_ADD_DIMcustomer_Address (
            DC_ADD_DC_ID int not null,
            DC_ADD_DIMcustomer_Address Varchar(25) not null,
            DC_ADD_Version bigint not null,
            DC_ADD_StatementType char(1) not null,
            primary key(
                DC_ADD_Version,
                DC_ADD_DC_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDC_ADD_DIMcustomer_Address
BEFORE INSERT ON dbo.DC_ADD_DIMcustomer_Address
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDC_ADD_DIMcustomer_Address();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDC_ADD_DIMcustomer_Address ON dbo.DC_ADD_DIMcustomer_Address;
-- DROP FUNCTION IF EXISTS dbo.tciDC_ADD_DIMcustomer_Address();
CREATE OR REPLACE FUNCTION dbo.tciDC_ADD_DIMcustomer_Address() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DC_ADD_DIMcustomer_Address
        SELECT
            NEW.DC_ADD_DC_ID,
            NEW.DC_ADD_DIMcustomer_Address,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDC_ADD_DIMcustomer_Address
INSTEAD OF INSERT ON dbo.DC_ADD_DIMcustomer_Address
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDC_ADD_DIMcustomer_Address();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDC_ADD_DIMcustomer_Address ON dbo.DC_ADD_DIMcustomer_Address;
-- DROP FUNCTION IF EXISTS dbo.tcaDC_ADD_DIMcustomer_Address();
CREATE OR REPLACE FUNCTION dbo.tcaDC_ADD_DIMcustomer_Address() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DC_ADD_Version) INTO maxVersion
    FROM
        _tmp_DC_ADD_DIMcustomer_Address;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DC_ADD_DIMcustomer_Address
        SET
            DC_ADD_StatementType =
                CASE
                    WHEN ADD.DC_ADD_DC_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DC_ADD_DIMcustomer_Address v
        LEFT JOIN
            dbo._DC_ADD_DIMcustomer_Address ADD
        ON
            ADD.DC_ADD_DC_ID = v.DC_ADD_DC_ID
        AND
            ADD.DC_ADD_DIMcustomer_Address = v.DC_ADD_DIMcustomer_Address
        WHERE
            v.DC_ADD_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DC_ADD_DIMcustomer_Address (
            DC_ADD_DC_ID,
            DC_ADD_DIMcustomer_Address
        )
        SELECT
            DC_ADD_DC_ID,
            DC_ADD_DIMcustomer_Address
        FROM
            _tmp_DC_ADD_DIMcustomer_Address
        WHERE
            DC_ADD_Version = currentVersion
        AND
            DC_ADD_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DC_ADD_DIMcustomer_Address;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDC_ADD_DIMcustomer_Address
AFTER INSERT ON dbo.DC_ADD_DIMcustomer_Address
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDC_ADD_DIMcustomer_Address();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDC_CIT_DIMcustomer_City ON dbo.DC_CIT_DIMcustomer_City;
-- DROP FUNCTION IF EXISTS dbo.tcbDC_CIT_DIMcustomer_City();
CREATE OR REPLACE FUNCTION dbo.tcbDC_CIT_DIMcustomer_City() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DC_CIT_DIMcustomer_City (
            DC_CIT_DC_ID int not null,
            DC_CIT_DIMcustomer_City Char(10) not null,
            DC_CIT_Version bigint not null,
            DC_CIT_StatementType char(1) not null,
            primary key(
                DC_CIT_Version,
                DC_CIT_DC_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDC_CIT_DIMcustomer_City
BEFORE INSERT ON dbo.DC_CIT_DIMcustomer_City
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDC_CIT_DIMcustomer_City();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDC_CIT_DIMcustomer_City ON dbo.DC_CIT_DIMcustomer_City;
-- DROP FUNCTION IF EXISTS dbo.tciDC_CIT_DIMcustomer_City();
CREATE OR REPLACE FUNCTION dbo.tciDC_CIT_DIMcustomer_City() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DC_CIT_DIMcustomer_City
        SELECT
            NEW.DC_CIT_DC_ID,
            NEW.DC_CIT_DIMcustomer_City,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDC_CIT_DIMcustomer_City
INSTEAD OF INSERT ON dbo.DC_CIT_DIMcustomer_City
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDC_CIT_DIMcustomer_City();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDC_CIT_DIMcustomer_City ON dbo.DC_CIT_DIMcustomer_City;
-- DROP FUNCTION IF EXISTS dbo.tcaDC_CIT_DIMcustomer_City();
CREATE OR REPLACE FUNCTION dbo.tcaDC_CIT_DIMcustomer_City() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DC_CIT_Version) INTO maxVersion
    FROM
        _tmp_DC_CIT_DIMcustomer_City;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DC_CIT_DIMcustomer_City
        SET
            DC_CIT_StatementType =
                CASE
                    WHEN CIT.DC_CIT_DC_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DC_CIT_DIMcustomer_City v
        LEFT JOIN
            dbo._DC_CIT_DIMcustomer_City CIT
        ON
            CIT.DC_CIT_DC_ID = v.DC_CIT_DC_ID
        AND
            CIT.DC_CIT_DIMcustomer_City = v.DC_CIT_DIMcustomer_City
        WHERE
            v.DC_CIT_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DC_CIT_DIMcustomer_City (
            DC_CIT_DC_ID,
            DC_CIT_DIMcustomer_City
        )
        SELECT
            DC_CIT_DC_ID,
            DC_CIT_DIMcustomer_City
        FROM
            _tmp_DC_CIT_DIMcustomer_City
        WHERE
            DC_CIT_Version = currentVersion
        AND
            DC_CIT_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DC_CIT_DIMcustomer_City;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDC_CIT_DIMcustomer_City
AFTER INSERT ON dbo.DC_CIT_DIMcustomer_City
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDC_CIT_DIMcustomer_City();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDC_PHN_DIMcustomer_Phone ON dbo.DC_PHN_DIMcustomer_Phone;
-- DROP FUNCTION IF EXISTS dbo.tcbDC_PHN_DIMcustomer_Phone();
CREATE OR REPLACE FUNCTION dbo.tcbDC_PHN_DIMcustomer_Phone() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DC_PHN_DIMcustomer_Phone (
            DC_PHN_DC_ID int not null,
            DC_PHN_DIMcustomer_Phone char(15) not null,
            DC_PHN_Version bigint not null,
            DC_PHN_StatementType char(1) not null,
            primary key(
                DC_PHN_Version,
                DC_PHN_DC_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDC_PHN_DIMcustomer_Phone
BEFORE INSERT ON dbo.DC_PHN_DIMcustomer_Phone
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDC_PHN_DIMcustomer_Phone();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDC_PHN_DIMcustomer_Phone ON dbo.DC_PHN_DIMcustomer_Phone;
-- DROP FUNCTION IF EXISTS dbo.tciDC_PHN_DIMcustomer_Phone();
CREATE OR REPLACE FUNCTION dbo.tciDC_PHN_DIMcustomer_Phone() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DC_PHN_DIMcustomer_Phone
        SELECT
            NEW.DC_PHN_DC_ID,
            NEW.DC_PHN_DIMcustomer_Phone,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDC_PHN_DIMcustomer_Phone
INSTEAD OF INSERT ON dbo.DC_PHN_DIMcustomer_Phone
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDC_PHN_DIMcustomer_Phone();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDC_PHN_DIMcustomer_Phone ON dbo.DC_PHN_DIMcustomer_Phone;
-- DROP FUNCTION IF EXISTS dbo.tcaDC_PHN_DIMcustomer_Phone();
CREATE OR REPLACE FUNCTION dbo.tcaDC_PHN_DIMcustomer_Phone() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DC_PHN_Version) INTO maxVersion
    FROM
        _tmp_DC_PHN_DIMcustomer_Phone;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DC_PHN_DIMcustomer_Phone
        SET
            DC_PHN_StatementType =
                CASE
                    WHEN PHN.DC_PHN_DC_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DC_PHN_DIMcustomer_Phone v
        LEFT JOIN
            dbo._DC_PHN_DIMcustomer_Phone PHN
        ON
            PHN.DC_PHN_DC_ID = v.DC_PHN_DC_ID
        AND
            PHN.DC_PHN_DIMcustomer_Phone = v.DC_PHN_DIMcustomer_Phone
        WHERE
            v.DC_PHN_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DC_PHN_DIMcustomer_Phone (
            DC_PHN_DC_ID,
            DC_PHN_DIMcustomer_Phone
        )
        SELECT
            DC_PHN_DC_ID,
            DC_PHN_DIMcustomer_Phone
        FROM
            _tmp_DC_PHN_DIMcustomer_Phone
        WHERE
            DC_PHN_Version = currentVersion
        AND
            DC_PHN_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DC_PHN_DIMcustomer_Phone;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDC_PHN_DIMcustomer_Phone
AFTER INSERT ON dbo.DC_PHN_DIMcustomer_Phone
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDC_PHN_DIMcustomer_Phone();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDC_NAT_DIMcustomer_Nation ON dbo.DC_NAT_DIMcustomer_Nation;
-- DROP FUNCTION IF EXISTS dbo.tcbDC_NAT_DIMcustomer_Nation();
CREATE OR REPLACE FUNCTION dbo.tcbDC_NAT_DIMcustomer_Nation() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DC_NAT_DIMcustomer_Nation (
            DC_NAT_DC_ID int not null,
            DC_NAT_DIMcustomer_Nation Char(15) not null,
            DC_NAT_Version bigint not null,
            DC_NAT_StatementType char(1) not null,
            primary key(
                DC_NAT_Version,
                DC_NAT_DC_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDC_NAT_DIMcustomer_Nation
BEFORE INSERT ON dbo.DC_NAT_DIMcustomer_Nation
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDC_NAT_DIMcustomer_Nation();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDC_NAT_DIMcustomer_Nation ON dbo.DC_NAT_DIMcustomer_Nation;
-- DROP FUNCTION IF EXISTS dbo.tciDC_NAT_DIMcustomer_Nation();
CREATE OR REPLACE FUNCTION dbo.tciDC_NAT_DIMcustomer_Nation() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DC_NAT_DIMcustomer_Nation
        SELECT
            NEW.DC_NAT_DC_ID,
            NEW.DC_NAT_DIMcustomer_Nation,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDC_NAT_DIMcustomer_Nation
INSTEAD OF INSERT ON dbo.DC_NAT_DIMcustomer_Nation
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDC_NAT_DIMcustomer_Nation();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDC_NAT_DIMcustomer_Nation ON dbo.DC_NAT_DIMcustomer_Nation;
-- DROP FUNCTION IF EXISTS dbo.tcaDC_NAT_DIMcustomer_Nation();
CREATE OR REPLACE FUNCTION dbo.tcaDC_NAT_DIMcustomer_Nation() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DC_NAT_Version) INTO maxVersion
    FROM
        _tmp_DC_NAT_DIMcustomer_Nation;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DC_NAT_DIMcustomer_Nation
        SET
            DC_NAT_StatementType =
                CASE
                    WHEN NAT.DC_NAT_DC_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DC_NAT_DIMcustomer_Nation v
        LEFT JOIN
            dbo._DC_NAT_DIMcustomer_Nation NAT
        ON
            NAT.DC_NAT_DC_ID = v.DC_NAT_DC_ID
        AND
            NAT.DC_NAT_DIMcustomer_Nation = v.DC_NAT_DIMcustomer_Nation
        WHERE
            v.DC_NAT_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DC_NAT_DIMcustomer_Nation (
            DC_NAT_DC_ID,
            DC_NAT_DIMcustomer_Nation
        )
        SELECT
            DC_NAT_DC_ID,
            DC_NAT_DIMcustomer_Nation
        FROM
            _tmp_DC_NAT_DIMcustomer_Nation
        WHERE
            DC_NAT_Version = currentVersion
        AND
            DC_NAT_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DC_NAT_DIMcustomer_Nation;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDC_NAT_DIMcustomer_Nation
AFTER INSERT ON dbo.DC_NAT_DIMcustomer_Nation
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDC_NAT_DIMcustomer_Nation();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDC_NAM_DIMcustomer_Name ON dbo.DC_NAM_DIMcustomer_Name;
-- DROP FUNCTION IF EXISTS dbo.tcbDC_NAM_DIMcustomer_Name();
CREATE OR REPLACE FUNCTION dbo.tcbDC_NAM_DIMcustomer_Name() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DC_NAM_DIMcustomer_Name (
            DC_NAM_DC_ID int not null,
            DC_NAM_DIMcustomer_Name Varchar(25) not null,
            DC_NAM_Version bigint not null,
            DC_NAM_StatementType char(1) not null,
            primary key(
                DC_NAM_Version,
                DC_NAM_DC_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDC_NAM_DIMcustomer_Name
BEFORE INSERT ON dbo.DC_NAM_DIMcustomer_Name
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDC_NAM_DIMcustomer_Name();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDC_NAM_DIMcustomer_Name ON dbo.DC_NAM_DIMcustomer_Name;
-- DROP FUNCTION IF EXISTS dbo.tciDC_NAM_DIMcustomer_Name();
CREATE OR REPLACE FUNCTION dbo.tciDC_NAM_DIMcustomer_Name() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DC_NAM_DIMcustomer_Name
        SELECT
            NEW.DC_NAM_DC_ID,
            NEW.DC_NAM_DIMcustomer_Name,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDC_NAM_DIMcustomer_Name
INSTEAD OF INSERT ON dbo.DC_NAM_DIMcustomer_Name
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDC_NAM_DIMcustomer_Name();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDC_NAM_DIMcustomer_Name ON dbo.DC_NAM_DIMcustomer_Name;
-- DROP FUNCTION IF EXISTS dbo.tcaDC_NAM_DIMcustomer_Name();
CREATE OR REPLACE FUNCTION dbo.tcaDC_NAM_DIMcustomer_Name() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DC_NAM_Version) INTO maxVersion
    FROM
        _tmp_DC_NAM_DIMcustomer_Name;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DC_NAM_DIMcustomer_Name
        SET
            DC_NAM_StatementType =
                CASE
                    WHEN NAM.DC_NAM_DC_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DC_NAM_DIMcustomer_Name v
        LEFT JOIN
            dbo._DC_NAM_DIMcustomer_Name NAM
        ON
            NAM.DC_NAM_DC_ID = v.DC_NAM_DC_ID
        AND
            NAM.DC_NAM_DIMcustomer_Name = v.DC_NAM_DIMcustomer_Name
        WHERE
            v.DC_NAM_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DC_NAM_DIMcustomer_Name (
            DC_NAM_DC_ID,
            DC_NAM_DIMcustomer_Name
        )
        SELECT
            DC_NAM_DC_ID,
            DC_NAM_DIMcustomer_Name
        FROM
            _tmp_DC_NAM_DIMcustomer_Name
        WHERE
            DC_NAM_Version = currentVersion
        AND
            DC_NAM_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DC_NAM_DIMcustomer_Name;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDC_NAM_DIMcustomer_Name
AFTER INSERT ON dbo.DC_NAM_DIMcustomer_Name
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDC_NAM_DIMcustomer_Name();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDC_SEG_DIMcustomer_Mktsegment ON dbo.DC_SEG_DIMcustomer_Mktsegment;
-- DROP FUNCTION IF EXISTS dbo.tcbDC_SEG_DIMcustomer_Mktsegment();
CREATE OR REPLACE FUNCTION dbo.tcbDC_SEG_DIMcustomer_Mktsegment() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DC_SEG_DIMcustomer_Mktsegment (
            DC_SEG_DC_ID int not null,
            DC_SEG_DIMcustomer_Mktsegment Char(10) not null,
            DC_SEG_Version bigint not null,
            DC_SEG_StatementType char(1) not null,
            primary key(
                DC_SEG_Version,
                DC_SEG_DC_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDC_SEG_DIMcustomer_Mktsegment
BEFORE INSERT ON dbo.DC_SEG_DIMcustomer_Mktsegment
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDC_SEG_DIMcustomer_Mktsegment();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDC_SEG_DIMcustomer_Mktsegment ON dbo.DC_SEG_DIMcustomer_Mktsegment;
-- DROP FUNCTION IF EXISTS dbo.tciDC_SEG_DIMcustomer_Mktsegment();
CREATE OR REPLACE FUNCTION dbo.tciDC_SEG_DIMcustomer_Mktsegment() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DC_SEG_DIMcustomer_Mktsegment
        SELECT
            NEW.DC_SEG_DC_ID,
            NEW.DC_SEG_DIMcustomer_Mktsegment,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDC_SEG_DIMcustomer_Mktsegment
INSTEAD OF INSERT ON dbo.DC_SEG_DIMcustomer_Mktsegment
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDC_SEG_DIMcustomer_Mktsegment();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDC_SEG_DIMcustomer_Mktsegment ON dbo.DC_SEG_DIMcustomer_Mktsegment;
-- DROP FUNCTION IF EXISTS dbo.tcaDC_SEG_DIMcustomer_Mktsegment();
CREATE OR REPLACE FUNCTION dbo.tcaDC_SEG_DIMcustomer_Mktsegment() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DC_SEG_Version) INTO maxVersion
    FROM
        _tmp_DC_SEG_DIMcustomer_Mktsegment;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DC_SEG_DIMcustomer_Mktsegment
        SET
            DC_SEG_StatementType =
                CASE
                    WHEN SEG.DC_SEG_DC_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DC_SEG_DIMcustomer_Mktsegment v
        LEFT JOIN
            dbo._DC_SEG_DIMcustomer_Mktsegment SEG
        ON
            SEG.DC_SEG_DC_ID = v.DC_SEG_DC_ID
        AND
            SEG.DC_SEG_DIMcustomer_Mktsegment = v.DC_SEG_DIMcustomer_Mktsegment
        WHERE
            v.DC_SEG_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DC_SEG_DIMcustomer_Mktsegment (
            DC_SEG_DC_ID,
            DC_SEG_DIMcustomer_Mktsegment
        )
        SELECT
            DC_SEG_DC_ID,
            DC_SEG_DIMcustomer_Mktsegment
        FROM
            _tmp_DC_SEG_DIMcustomer_Mktsegment
        WHERE
            DC_SEG_Version = currentVersion
        AND
            DC_SEG_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DC_SEG_DIMcustomer_Mktsegment;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDC_SEG_DIMcustomer_Mktsegment
AFTER INSERT ON dbo.DC_SEG_DIMcustomer_Mktsegment
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDC_SEG_DIMcustomer_Mktsegment();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDS_REG_DIMsupplier_Region ON dbo.DS_REG_DIMsupplier_Region;
-- DROP FUNCTION IF EXISTS dbo.tcbDS_REG_DIMsupplier_Region();
CREATE OR REPLACE FUNCTION dbo.tcbDS_REG_DIMsupplier_Region() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DS_REG_DIMsupplier_Region (
            DS_REG_DS_ID int not null,
            DS_REG_DIMsupplier_Region Char(12) not null,
            DS_REG_Version bigint not null,
            DS_REG_StatementType char(1) not null,
            primary key(
                DS_REG_Version,
                DS_REG_DS_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDS_REG_DIMsupplier_Region
BEFORE INSERT ON dbo.DS_REG_DIMsupplier_Region
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDS_REG_DIMsupplier_Region();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDS_REG_DIMsupplier_Region ON dbo.DS_REG_DIMsupplier_Region;
-- DROP FUNCTION IF EXISTS dbo.tciDS_REG_DIMsupplier_Region();
CREATE OR REPLACE FUNCTION dbo.tciDS_REG_DIMsupplier_Region() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DS_REG_DIMsupplier_Region
        SELECT
            NEW.DS_REG_DS_ID,
            NEW.DS_REG_DIMsupplier_Region,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDS_REG_DIMsupplier_Region
INSTEAD OF INSERT ON dbo.DS_REG_DIMsupplier_Region
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDS_REG_DIMsupplier_Region();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDS_REG_DIMsupplier_Region ON dbo.DS_REG_DIMsupplier_Region;
-- DROP FUNCTION IF EXISTS dbo.tcaDS_REG_DIMsupplier_Region();
CREATE OR REPLACE FUNCTION dbo.tcaDS_REG_DIMsupplier_Region() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DS_REG_Version) INTO maxVersion
    FROM
        _tmp_DS_REG_DIMsupplier_Region;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DS_REG_DIMsupplier_Region
        SET
            DS_REG_StatementType =
                CASE
                    WHEN REG.DS_REG_DS_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DS_REG_DIMsupplier_Region v
        LEFT JOIN
            dbo._DS_REG_DIMsupplier_Region REG
        ON
            REG.DS_REG_DS_ID = v.DS_REG_DS_ID
        AND
            REG.DS_REG_DIMsupplier_Region = v.DS_REG_DIMsupplier_Region
        WHERE
            v.DS_REG_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DS_REG_DIMsupplier_Region (
            DS_REG_DS_ID,
            DS_REG_DIMsupplier_Region
        )
        SELECT
            DS_REG_DS_ID,
            DS_REG_DIMsupplier_Region
        FROM
            _tmp_DS_REG_DIMsupplier_Region
        WHERE
            DS_REG_Version = currentVersion
        AND
            DS_REG_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DS_REG_DIMsupplier_Region;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDS_REG_DIMsupplier_Region
AFTER INSERT ON dbo.DS_REG_DIMsupplier_Region
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDS_REG_DIMsupplier_Region();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDS_CIT_DIMsupplier_City ON dbo.DS_CIT_DIMsupplier_City;
-- DROP FUNCTION IF EXISTS dbo.tcbDS_CIT_DIMsupplier_City();
CREATE OR REPLACE FUNCTION dbo.tcbDS_CIT_DIMsupplier_City() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DS_CIT_DIMsupplier_City (
            DS_CIT_DS_ID int not null,
            DS_CIT_DIMsupplier_City Char(10) not null,
            DS_CIT_Version bigint not null,
            DS_CIT_StatementType char(1) not null,
            primary key(
                DS_CIT_Version,
                DS_CIT_DS_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDS_CIT_DIMsupplier_City
BEFORE INSERT ON dbo.DS_CIT_DIMsupplier_City
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDS_CIT_DIMsupplier_City();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDS_CIT_DIMsupplier_City ON dbo.DS_CIT_DIMsupplier_City;
-- DROP FUNCTION IF EXISTS dbo.tciDS_CIT_DIMsupplier_City();
CREATE OR REPLACE FUNCTION dbo.tciDS_CIT_DIMsupplier_City() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DS_CIT_DIMsupplier_City
        SELECT
            NEW.DS_CIT_DS_ID,
            NEW.DS_CIT_DIMsupplier_City,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDS_CIT_DIMsupplier_City
INSTEAD OF INSERT ON dbo.DS_CIT_DIMsupplier_City
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDS_CIT_DIMsupplier_City();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDS_CIT_DIMsupplier_City ON dbo.DS_CIT_DIMsupplier_City;
-- DROP FUNCTION IF EXISTS dbo.tcaDS_CIT_DIMsupplier_City();
CREATE OR REPLACE FUNCTION dbo.tcaDS_CIT_DIMsupplier_City() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DS_CIT_Version) INTO maxVersion
    FROM
        _tmp_DS_CIT_DIMsupplier_City;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DS_CIT_DIMsupplier_City
        SET
            DS_CIT_StatementType =
                CASE
                    WHEN CIT.DS_CIT_DS_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DS_CIT_DIMsupplier_City v
        LEFT JOIN
            dbo._DS_CIT_DIMsupplier_City CIT
        ON
            CIT.DS_CIT_DS_ID = v.DS_CIT_DS_ID
        AND
            CIT.DS_CIT_DIMsupplier_City = v.DS_CIT_DIMsupplier_City
        WHERE
            v.DS_CIT_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DS_CIT_DIMsupplier_City (
            DS_CIT_DS_ID,
            DS_CIT_DIMsupplier_City
        )
        SELECT
            DS_CIT_DS_ID,
            DS_CIT_DIMsupplier_City
        FROM
            _tmp_DS_CIT_DIMsupplier_City
        WHERE
            DS_CIT_Version = currentVersion
        AND
            DS_CIT_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DS_CIT_DIMsupplier_City;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDS_CIT_DIMsupplier_City
AFTER INSERT ON dbo.DS_CIT_DIMsupplier_City
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDS_CIT_DIMsupplier_City();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDS_NAT_DIMsupplier_Nation ON dbo.DS_NAT_DIMsupplier_Nation;
-- DROP FUNCTION IF EXISTS dbo.tcbDS_NAT_DIMsupplier_Nation();
CREATE OR REPLACE FUNCTION dbo.tcbDS_NAT_DIMsupplier_Nation() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DS_NAT_DIMsupplier_Nation (
            DS_NAT_DS_ID int not null,
            DS_NAT_DIMsupplier_Nation Char(15) not null,
            DS_NAT_Version bigint not null,
            DS_NAT_StatementType char(1) not null,
            primary key(
                DS_NAT_Version,
                DS_NAT_DS_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDS_NAT_DIMsupplier_Nation
BEFORE INSERT ON dbo.DS_NAT_DIMsupplier_Nation
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDS_NAT_DIMsupplier_Nation();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDS_NAT_DIMsupplier_Nation ON dbo.DS_NAT_DIMsupplier_Nation;
-- DROP FUNCTION IF EXISTS dbo.tciDS_NAT_DIMsupplier_Nation();
CREATE OR REPLACE FUNCTION dbo.tciDS_NAT_DIMsupplier_Nation() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DS_NAT_DIMsupplier_Nation
        SELECT
            NEW.DS_NAT_DS_ID,
            NEW.DS_NAT_DIMsupplier_Nation,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDS_NAT_DIMsupplier_Nation
INSTEAD OF INSERT ON dbo.DS_NAT_DIMsupplier_Nation
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDS_NAT_DIMsupplier_Nation();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDS_NAT_DIMsupplier_Nation ON dbo.DS_NAT_DIMsupplier_Nation;
-- DROP FUNCTION IF EXISTS dbo.tcaDS_NAT_DIMsupplier_Nation();
CREATE OR REPLACE FUNCTION dbo.tcaDS_NAT_DIMsupplier_Nation() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DS_NAT_Version) INTO maxVersion
    FROM
        _tmp_DS_NAT_DIMsupplier_Nation;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DS_NAT_DIMsupplier_Nation
        SET
            DS_NAT_StatementType =
                CASE
                    WHEN NAT.DS_NAT_DS_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DS_NAT_DIMsupplier_Nation v
        LEFT JOIN
            dbo._DS_NAT_DIMsupplier_Nation NAT
        ON
            NAT.DS_NAT_DS_ID = v.DS_NAT_DS_ID
        AND
            NAT.DS_NAT_DIMsupplier_Nation = v.DS_NAT_DIMsupplier_Nation
        WHERE
            v.DS_NAT_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DS_NAT_DIMsupplier_Nation (
            DS_NAT_DS_ID,
            DS_NAT_DIMsupplier_Nation
        )
        SELECT
            DS_NAT_DS_ID,
            DS_NAT_DIMsupplier_Nation
        FROM
            _tmp_DS_NAT_DIMsupplier_Nation
        WHERE
            DS_NAT_Version = currentVersion
        AND
            DS_NAT_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DS_NAT_DIMsupplier_Nation;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDS_NAT_DIMsupplier_Nation
AFTER INSERT ON dbo.DS_NAT_DIMsupplier_Nation
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDS_NAT_DIMsupplier_Nation();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDS_PHN_DIMsupplier_Phone ON dbo.DS_PHN_DIMsupplier_Phone;
-- DROP FUNCTION IF EXISTS dbo.tcbDS_PHN_DIMsupplier_Phone();
CREATE OR REPLACE FUNCTION dbo.tcbDS_PHN_DIMsupplier_Phone() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DS_PHN_DIMsupplier_Phone (
            DS_PHN_DS_ID int not null,
            DS_PHN_DIMsupplier_Phone char(15) not null,
            DS_PHN_Version bigint not null,
            DS_PHN_StatementType char(1) not null,
            primary key(
                DS_PHN_Version,
                DS_PHN_DS_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDS_PHN_DIMsupplier_Phone
BEFORE INSERT ON dbo.DS_PHN_DIMsupplier_Phone
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDS_PHN_DIMsupplier_Phone();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDS_PHN_DIMsupplier_Phone ON dbo.DS_PHN_DIMsupplier_Phone;
-- DROP FUNCTION IF EXISTS dbo.tciDS_PHN_DIMsupplier_Phone();
CREATE OR REPLACE FUNCTION dbo.tciDS_PHN_DIMsupplier_Phone() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DS_PHN_DIMsupplier_Phone
        SELECT
            NEW.DS_PHN_DS_ID,
            NEW.DS_PHN_DIMsupplier_Phone,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDS_PHN_DIMsupplier_Phone
INSTEAD OF INSERT ON dbo.DS_PHN_DIMsupplier_Phone
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDS_PHN_DIMsupplier_Phone();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDS_PHN_DIMsupplier_Phone ON dbo.DS_PHN_DIMsupplier_Phone;
-- DROP FUNCTION IF EXISTS dbo.tcaDS_PHN_DIMsupplier_Phone();
CREATE OR REPLACE FUNCTION dbo.tcaDS_PHN_DIMsupplier_Phone() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DS_PHN_Version) INTO maxVersion
    FROM
        _tmp_DS_PHN_DIMsupplier_Phone;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DS_PHN_DIMsupplier_Phone
        SET
            DS_PHN_StatementType =
                CASE
                    WHEN PHN.DS_PHN_DS_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DS_PHN_DIMsupplier_Phone v
        LEFT JOIN
            dbo._DS_PHN_DIMsupplier_Phone PHN
        ON
            PHN.DS_PHN_DS_ID = v.DS_PHN_DS_ID
        AND
            PHN.DS_PHN_DIMsupplier_Phone = v.DS_PHN_DIMsupplier_Phone
        WHERE
            v.DS_PHN_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DS_PHN_DIMsupplier_Phone (
            DS_PHN_DS_ID,
            DS_PHN_DIMsupplier_Phone
        )
        SELECT
            DS_PHN_DS_ID,
            DS_PHN_DIMsupplier_Phone
        FROM
            _tmp_DS_PHN_DIMsupplier_Phone
        WHERE
            DS_PHN_Version = currentVersion
        AND
            DS_PHN_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DS_PHN_DIMsupplier_Phone;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDS_PHN_DIMsupplier_Phone
AFTER INSERT ON dbo.DS_PHN_DIMsupplier_Phone
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDS_PHN_DIMsupplier_Phone();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDS_ADD_DIMsupplier_Address ON dbo.DS_ADD_DIMsupplier_Address;
-- DROP FUNCTION IF EXISTS dbo.tcbDS_ADD_DIMsupplier_Address();
CREATE OR REPLACE FUNCTION dbo.tcbDS_ADD_DIMsupplier_Address() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DS_ADD_DIMsupplier_Address (
            DS_ADD_DS_ID int not null,
            DS_ADD_DIMsupplier_Address Varchar(25) not null,
            DS_ADD_Version bigint not null,
            DS_ADD_StatementType char(1) not null,
            primary key(
                DS_ADD_Version,
                DS_ADD_DS_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDS_ADD_DIMsupplier_Address
BEFORE INSERT ON dbo.DS_ADD_DIMsupplier_Address
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDS_ADD_DIMsupplier_Address();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDS_ADD_DIMsupplier_Address ON dbo.DS_ADD_DIMsupplier_Address;
-- DROP FUNCTION IF EXISTS dbo.tciDS_ADD_DIMsupplier_Address();
CREATE OR REPLACE FUNCTION dbo.tciDS_ADD_DIMsupplier_Address() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DS_ADD_DIMsupplier_Address
        SELECT
            NEW.DS_ADD_DS_ID,
            NEW.DS_ADD_DIMsupplier_Address,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDS_ADD_DIMsupplier_Address
INSTEAD OF INSERT ON dbo.DS_ADD_DIMsupplier_Address
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDS_ADD_DIMsupplier_Address();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDS_ADD_DIMsupplier_Address ON dbo.DS_ADD_DIMsupplier_Address;
-- DROP FUNCTION IF EXISTS dbo.tcaDS_ADD_DIMsupplier_Address();
CREATE OR REPLACE FUNCTION dbo.tcaDS_ADD_DIMsupplier_Address() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DS_ADD_Version) INTO maxVersion
    FROM
        _tmp_DS_ADD_DIMsupplier_Address;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DS_ADD_DIMsupplier_Address
        SET
            DS_ADD_StatementType =
                CASE
                    WHEN ADD.DS_ADD_DS_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DS_ADD_DIMsupplier_Address v
        LEFT JOIN
            dbo._DS_ADD_DIMsupplier_Address ADD
        ON
            ADD.DS_ADD_DS_ID = v.DS_ADD_DS_ID
        AND
            ADD.DS_ADD_DIMsupplier_Address = v.DS_ADD_DIMsupplier_Address
        WHERE
            v.DS_ADD_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DS_ADD_DIMsupplier_Address (
            DS_ADD_DS_ID,
            DS_ADD_DIMsupplier_Address
        )
        SELECT
            DS_ADD_DS_ID,
            DS_ADD_DIMsupplier_Address
        FROM
            _tmp_DS_ADD_DIMsupplier_Address
        WHERE
            DS_ADD_Version = currentVersion
        AND
            DS_ADD_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DS_ADD_DIMsupplier_Address;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDS_ADD_DIMsupplier_Address
AFTER INSERT ON dbo.DS_ADD_DIMsupplier_Address
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDS_ADD_DIMsupplier_Address();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDS_NAM_DIMsupplier_Name ON dbo.DS_NAM_DIMsupplier_Name;
-- DROP FUNCTION IF EXISTS dbo.tcbDS_NAM_DIMsupplier_Name();
CREATE OR REPLACE FUNCTION dbo.tcbDS_NAM_DIMsupplier_Name() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DS_NAM_DIMsupplier_Name (
            DS_NAM_DS_ID int not null,
            DS_NAM_DIMsupplier_Name Char(25) not null,
            DS_NAM_Version bigint not null,
            DS_NAM_StatementType char(1) not null,
            primary key(
                DS_NAM_Version,
                DS_NAM_DS_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDS_NAM_DIMsupplier_Name
BEFORE INSERT ON dbo.DS_NAM_DIMsupplier_Name
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDS_NAM_DIMsupplier_Name();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDS_NAM_DIMsupplier_Name ON dbo.DS_NAM_DIMsupplier_Name;
-- DROP FUNCTION IF EXISTS dbo.tciDS_NAM_DIMsupplier_Name();
CREATE OR REPLACE FUNCTION dbo.tciDS_NAM_DIMsupplier_Name() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DS_NAM_DIMsupplier_Name
        SELECT
            NEW.DS_NAM_DS_ID,
            NEW.DS_NAM_DIMsupplier_Name,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDS_NAM_DIMsupplier_Name
INSTEAD OF INSERT ON dbo.DS_NAM_DIMsupplier_Name
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDS_NAM_DIMsupplier_Name();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDS_NAM_DIMsupplier_Name ON dbo.DS_NAM_DIMsupplier_Name;
-- DROP FUNCTION IF EXISTS dbo.tcaDS_NAM_DIMsupplier_Name();
CREATE OR REPLACE FUNCTION dbo.tcaDS_NAM_DIMsupplier_Name() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DS_NAM_Version) INTO maxVersion
    FROM
        _tmp_DS_NAM_DIMsupplier_Name;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DS_NAM_DIMsupplier_Name
        SET
            DS_NAM_StatementType =
                CASE
                    WHEN NAM.DS_NAM_DS_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DS_NAM_DIMsupplier_Name v
        LEFT JOIN
            dbo._DS_NAM_DIMsupplier_Name NAM
        ON
            NAM.DS_NAM_DS_ID = v.DS_NAM_DS_ID
        AND
            NAM.DS_NAM_DIMsupplier_Name = v.DS_NAM_DIMsupplier_Name
        WHERE
            v.DS_NAM_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DS_NAM_DIMsupplier_Name (
            DS_NAM_DS_ID,
            DS_NAM_DIMsupplier_Name
        )
        SELECT
            DS_NAM_DS_ID,
            DS_NAM_DIMsupplier_Name
        FROM
            _tmp_DS_NAM_DIMsupplier_Name
        WHERE
            DS_NAM_Version = currentVersion
        AND
            DS_NAM_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DS_NAM_DIMsupplier_Name;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDS_NAM_DIMsupplier_Name
AFTER INSERT ON dbo.DS_NAM_DIMsupplier_Name
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDS_NAM_DIMsupplier_Name();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_DAT_DIMdate1_Date ON dbo.DD_DAT_DIMdate1_Date;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_DAT_DIMdate1_Date();
CREATE OR REPLACE FUNCTION dbo.tcbDD_DAT_DIMdate1_Date() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_DAT_DIMdate1_Date (
            DD_DAT_DD_ID int not null,
            DD_DAT_DIMdate1_Date Varchar(18) not null,
            DD_DAT_Version bigint not null,
            DD_DAT_StatementType char(1) not null,
            primary key(
                DD_DAT_Version,
                DD_DAT_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_DAT_DIMdate1_Date
BEFORE INSERT ON dbo.DD_DAT_DIMdate1_Date
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_DAT_DIMdate1_Date();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_DAT_DIMdate1_Date ON dbo.DD_DAT_DIMdate1_Date;
-- DROP FUNCTION IF EXISTS dbo.tciDD_DAT_DIMdate1_Date();
CREATE OR REPLACE FUNCTION dbo.tciDD_DAT_DIMdate1_Date() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_DAT_DIMdate1_Date
        SELECT
            NEW.DD_DAT_DD_ID,
            NEW.DD_DAT_DIMdate1_Date,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_DAT_DIMdate1_Date
INSTEAD OF INSERT ON dbo.DD_DAT_DIMdate1_Date
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_DAT_DIMdate1_Date();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_DAT_DIMdate1_Date ON dbo.DD_DAT_DIMdate1_Date;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_DAT_DIMdate1_Date();
CREATE OR REPLACE FUNCTION dbo.tcaDD_DAT_DIMdate1_Date() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_DAT_Version) INTO maxVersion
    FROM
        _tmp_DD_DAT_DIMdate1_Date;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_DAT_DIMdate1_Date
        SET
            DD_DAT_StatementType =
                CASE
                    WHEN DAT.DD_DAT_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_DAT_DIMdate1_Date v
        LEFT JOIN
            dbo._DD_DAT_DIMdate1_Date DAT
        ON
            DAT.DD_DAT_DD_ID = v.DD_DAT_DD_ID
        AND
            DAT.DD_DAT_DIMdate1_Date = v.DD_DAT_DIMdate1_Date
        WHERE
            v.DD_DAT_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_DAT_DIMdate1_Date (
            DD_DAT_DD_ID,
            DD_DAT_DIMdate1_Date
        )
        SELECT
            DD_DAT_DD_ID,
            DD_DAT_DIMdate1_Date
        FROM
            _tmp_DD_DAT_DIMdate1_Date
        WHERE
            DD_DAT_Version = currentVersion
        AND
            DD_DAT_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_DAT_DIMdate1_Date;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_DAT_DIMdate1_Date
AFTER INSERT ON dbo.DD_DAT_DIMdate1_Date
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_DAT_DIMdate1_Date();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_YMN_DIMdate1_Yearmonthnum ON dbo.DD_YMN_DIMdate1_Yearmonthnum;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_YMN_DIMdate1_Yearmonthnum();
CREATE OR REPLACE FUNCTION dbo.tcbDD_YMN_DIMdate1_Yearmonthnum() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_YMN_DIMdate1_Yearmonthnum (
            DD_YMN_DD_ID int not null,
            DD_YMN_DIMdate1_Yearmonthnum Numeric(14) not null,
            DD_YMN_Version bigint not null,
            DD_YMN_StatementType char(1) not null,
            primary key(
                DD_YMN_Version,
                DD_YMN_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_YMN_DIMdate1_Yearmonthnum
BEFORE INSERT ON dbo.DD_YMN_DIMdate1_Yearmonthnum
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_YMN_DIMdate1_Yearmonthnum();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_YMN_DIMdate1_Yearmonthnum ON dbo.DD_YMN_DIMdate1_Yearmonthnum;
-- DROP FUNCTION IF EXISTS dbo.tciDD_YMN_DIMdate1_Yearmonthnum();
CREATE OR REPLACE FUNCTION dbo.tciDD_YMN_DIMdate1_Yearmonthnum() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_YMN_DIMdate1_Yearmonthnum
        SELECT
            NEW.DD_YMN_DD_ID,
            NEW.DD_YMN_DIMdate1_Yearmonthnum,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_YMN_DIMdate1_Yearmonthnum
INSTEAD OF INSERT ON dbo.DD_YMN_DIMdate1_Yearmonthnum
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_YMN_DIMdate1_Yearmonthnum();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_YMN_DIMdate1_Yearmonthnum ON dbo.DD_YMN_DIMdate1_Yearmonthnum;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_YMN_DIMdate1_Yearmonthnum();
CREATE OR REPLACE FUNCTION dbo.tcaDD_YMN_DIMdate1_Yearmonthnum() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_YMN_Version) INTO maxVersion
    FROM
        _tmp_DD_YMN_DIMdate1_Yearmonthnum;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_YMN_DIMdate1_Yearmonthnum
        SET
            DD_YMN_StatementType =
                CASE
                    WHEN YMN.DD_YMN_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_YMN_DIMdate1_Yearmonthnum v
        LEFT JOIN
            dbo._DD_YMN_DIMdate1_Yearmonthnum YMN
        ON
            YMN.DD_YMN_DD_ID = v.DD_YMN_DD_ID
        AND
            YMN.DD_YMN_DIMdate1_Yearmonthnum = v.DD_YMN_DIMdate1_Yearmonthnum
        WHERE
            v.DD_YMN_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_YMN_DIMdate1_Yearmonthnum (
            DD_YMN_DD_ID,
            DD_YMN_DIMdate1_Yearmonthnum
        )
        SELECT
            DD_YMN_DD_ID,
            DD_YMN_DIMdate1_Yearmonthnum
        FROM
            _tmp_DD_YMN_DIMdate1_Yearmonthnum
        WHERE
            DD_YMN_Version = currentVersion
        AND
            DD_YMN_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_YMN_DIMdate1_Yearmonthnum;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_YMN_DIMdate1_Yearmonthnum
AFTER INSERT ON dbo.DD_YMN_DIMdate1_Yearmonthnum
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_YMN_DIMdate1_Yearmonthnum();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_MTH_DIMdate1_Month ON dbo.DD_MTH_DIMdate1_Month;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_MTH_DIMdate1_Month();
CREATE OR REPLACE FUNCTION dbo.tcbDD_MTH_DIMdate1_Month() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_MTH_DIMdate1_Month (
            DD_MTH_DD_ID int not null,
            DD_MTH_DIMdate1_Month Varchar(9) not null,
            DD_MTH_Version bigint not null,
            DD_MTH_StatementType char(1) not null,
            primary key(
                DD_MTH_Version,
                DD_MTH_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_MTH_DIMdate1_Month
BEFORE INSERT ON dbo.DD_MTH_DIMdate1_Month
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_MTH_DIMdate1_Month();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_MTH_DIMdate1_Month ON dbo.DD_MTH_DIMdate1_Month;
-- DROP FUNCTION IF EXISTS dbo.tciDD_MTH_DIMdate1_Month();
CREATE OR REPLACE FUNCTION dbo.tciDD_MTH_DIMdate1_Month() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_MTH_DIMdate1_Month
        SELECT
            NEW.DD_MTH_DD_ID,
            NEW.DD_MTH_DIMdate1_Month,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_MTH_DIMdate1_Month
INSTEAD OF INSERT ON dbo.DD_MTH_DIMdate1_Month
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_MTH_DIMdate1_Month();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_MTH_DIMdate1_Month ON dbo.DD_MTH_DIMdate1_Month;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_MTH_DIMdate1_Month();
CREATE OR REPLACE FUNCTION dbo.tcaDD_MTH_DIMdate1_Month() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_MTH_Version) INTO maxVersion
    FROM
        _tmp_DD_MTH_DIMdate1_Month;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_MTH_DIMdate1_Month
        SET
            DD_MTH_StatementType =
                CASE
                    WHEN MTH.DD_MTH_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_MTH_DIMdate1_Month v
        LEFT JOIN
            dbo._DD_MTH_DIMdate1_Month MTH
        ON
            MTH.DD_MTH_DD_ID = v.DD_MTH_DD_ID
        AND
            MTH.DD_MTH_DIMdate1_Month = v.DD_MTH_DIMdate1_Month
        WHERE
            v.DD_MTH_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_MTH_DIMdate1_Month (
            DD_MTH_DD_ID,
            DD_MTH_DIMdate1_Month
        )
        SELECT
            DD_MTH_DD_ID,
            DD_MTH_DIMdate1_Month
        FROM
            _tmp_DD_MTH_DIMdate1_Month
        WHERE
            DD_MTH_Version = currentVersion
        AND
            DD_MTH_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_MTH_DIMdate1_Month;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_MTH_DIMdate1_Month
AFTER INSERT ON dbo.DD_MTH_DIMdate1_Month
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_MTH_DIMdate1_Month();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_DOW_DIMdate1_Dayofweek ON dbo.DD_DOW_DIMdate1_Dayofweek;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_DOW_DIMdate1_Dayofweek();
CREATE OR REPLACE FUNCTION dbo.tcbDD_DOW_DIMdate1_Dayofweek() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_DOW_DIMdate1_Dayofweek (
            DD_DOW_DD_ID int not null,
            DD_DOW_DIMdate1_Dayofweek Varchar(9) not null,
            DD_DOW_Version bigint not null,
            DD_DOW_StatementType char(1) not null,
            primary key(
                DD_DOW_Version,
                DD_DOW_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_DOW_DIMdate1_Dayofweek
BEFORE INSERT ON dbo.DD_DOW_DIMdate1_Dayofweek
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_DOW_DIMdate1_Dayofweek();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_DOW_DIMdate1_Dayofweek ON dbo.DD_DOW_DIMdate1_Dayofweek;
-- DROP FUNCTION IF EXISTS dbo.tciDD_DOW_DIMdate1_Dayofweek();
CREATE OR REPLACE FUNCTION dbo.tciDD_DOW_DIMdate1_Dayofweek() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_DOW_DIMdate1_Dayofweek
        SELECT
            NEW.DD_DOW_DD_ID,
            NEW.DD_DOW_DIMdate1_Dayofweek,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_DOW_DIMdate1_Dayofweek
INSTEAD OF INSERT ON dbo.DD_DOW_DIMdate1_Dayofweek
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_DOW_DIMdate1_Dayofweek();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_DOW_DIMdate1_Dayofweek ON dbo.DD_DOW_DIMdate1_Dayofweek;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_DOW_DIMdate1_Dayofweek();
CREATE OR REPLACE FUNCTION dbo.tcaDD_DOW_DIMdate1_Dayofweek() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_DOW_Version) INTO maxVersion
    FROM
        _tmp_DD_DOW_DIMdate1_Dayofweek;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_DOW_DIMdate1_Dayofweek
        SET
            DD_DOW_StatementType =
                CASE
                    WHEN DOW.DD_DOW_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_DOW_DIMdate1_Dayofweek v
        LEFT JOIN
            dbo._DD_DOW_DIMdate1_Dayofweek DOW
        ON
            DOW.DD_DOW_DD_ID = v.DD_DOW_DD_ID
        AND
            DOW.DD_DOW_DIMdate1_Dayofweek = v.DD_DOW_DIMdate1_Dayofweek
        WHERE
            v.DD_DOW_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_DOW_DIMdate1_Dayofweek (
            DD_DOW_DD_ID,
            DD_DOW_DIMdate1_Dayofweek
        )
        SELECT
            DD_DOW_DD_ID,
            DD_DOW_DIMdate1_Dayofweek
        FROM
            _tmp_DD_DOW_DIMdate1_Dayofweek
        WHERE
            DD_DOW_Version = currentVersion
        AND
            DD_DOW_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_DOW_DIMdate1_Dayofweek;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_DOW_DIMdate1_Dayofweek
AFTER INSERT ON dbo.DD_DOW_DIMdate1_Dayofweek
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_DOW_DIMdate1_Dayofweek();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_DNW_DIMdate1_Daynuminweek ON dbo.DD_DNW_DIMdate1_Daynuminweek;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_DNW_DIMdate1_Daynuminweek();
CREATE OR REPLACE FUNCTION dbo.tcbDD_DNW_DIMdate1_Daynuminweek() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_DNW_DIMdate1_Daynuminweek (
            DD_DNW_DD_ID int not null,
            DD_DNW_DIMdate1_Daynuminweek Numeric(7) not null,
            DD_DNW_Version bigint not null,
            DD_DNW_StatementType char(1) not null,
            primary key(
                DD_DNW_Version,
                DD_DNW_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_DNW_DIMdate1_Daynuminweek
BEFORE INSERT ON dbo.DD_DNW_DIMdate1_Daynuminweek
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_DNW_DIMdate1_Daynuminweek();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_DNW_DIMdate1_Daynuminweek ON dbo.DD_DNW_DIMdate1_Daynuminweek;
-- DROP FUNCTION IF EXISTS dbo.tciDD_DNW_DIMdate1_Daynuminweek();
CREATE OR REPLACE FUNCTION dbo.tciDD_DNW_DIMdate1_Daynuminweek() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_DNW_DIMdate1_Daynuminweek
        SELECT
            NEW.DD_DNW_DD_ID,
            NEW.DD_DNW_DIMdate1_Daynuminweek,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_DNW_DIMdate1_Daynuminweek
INSTEAD OF INSERT ON dbo.DD_DNW_DIMdate1_Daynuminweek
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_DNW_DIMdate1_Daynuminweek();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_DNW_DIMdate1_Daynuminweek ON dbo.DD_DNW_DIMdate1_Daynuminweek;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_DNW_DIMdate1_Daynuminweek();
CREATE OR REPLACE FUNCTION dbo.tcaDD_DNW_DIMdate1_Daynuminweek() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_DNW_Version) INTO maxVersion
    FROM
        _tmp_DD_DNW_DIMdate1_Daynuminweek;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_DNW_DIMdate1_Daynuminweek
        SET
            DD_DNW_StatementType =
                CASE
                    WHEN DNW.DD_DNW_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_DNW_DIMdate1_Daynuminweek v
        LEFT JOIN
            dbo._DD_DNW_DIMdate1_Daynuminweek DNW
        ON
            DNW.DD_DNW_DD_ID = v.DD_DNW_DD_ID
        AND
            DNW.DD_DNW_DIMdate1_Daynuminweek = v.DD_DNW_DIMdate1_Daynuminweek
        WHERE
            v.DD_DNW_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_DNW_DIMdate1_Daynuminweek (
            DD_DNW_DD_ID,
            DD_DNW_DIMdate1_Daynuminweek
        )
        SELECT
            DD_DNW_DD_ID,
            DD_DNW_DIMdate1_Daynuminweek
        FROM
            _tmp_DD_DNW_DIMdate1_Daynuminweek
        WHERE
            DD_DNW_Version = currentVersion
        AND
            DD_DNW_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_DNW_DIMdate1_Daynuminweek;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_DNW_DIMdate1_Daynuminweek
AFTER INSERT ON dbo.DD_DNW_DIMdate1_Daynuminweek
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_DNW_DIMdate1_Daynuminweek();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_YMM_DIMdate1_Yearmonth ON dbo.DD_YMM_DIMdate1_Yearmonth;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_YMM_DIMdate1_Yearmonth();
CREATE OR REPLACE FUNCTION dbo.tcbDD_YMM_DIMdate1_Yearmonth() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_YMM_DIMdate1_Yearmonth (
            DD_YMM_DD_ID int not null,
            DD_YMM_DIMdate1_Yearmonth Varchar(7) not null,
            DD_YMM_Version bigint not null,
            DD_YMM_StatementType char(1) not null,
            primary key(
                DD_YMM_Version,
                DD_YMM_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_YMM_DIMdate1_Yearmonth
BEFORE INSERT ON dbo.DD_YMM_DIMdate1_Yearmonth
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_YMM_DIMdate1_Yearmonth();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_YMM_DIMdate1_Yearmonth ON dbo.DD_YMM_DIMdate1_Yearmonth;
-- DROP FUNCTION IF EXISTS dbo.tciDD_YMM_DIMdate1_Yearmonth();
CREATE OR REPLACE FUNCTION dbo.tciDD_YMM_DIMdate1_Yearmonth() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_YMM_DIMdate1_Yearmonth
        SELECT
            NEW.DD_YMM_DD_ID,
            NEW.DD_YMM_DIMdate1_Yearmonth,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_YMM_DIMdate1_Yearmonth
INSTEAD OF INSERT ON dbo.DD_YMM_DIMdate1_Yearmonth
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_YMM_DIMdate1_Yearmonth();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_YMM_DIMdate1_Yearmonth ON dbo.DD_YMM_DIMdate1_Yearmonth;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_YMM_DIMdate1_Yearmonth();
CREATE OR REPLACE FUNCTION dbo.tcaDD_YMM_DIMdate1_Yearmonth() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_YMM_Version) INTO maxVersion
    FROM
        _tmp_DD_YMM_DIMdate1_Yearmonth;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_YMM_DIMdate1_Yearmonth
        SET
            DD_YMM_StatementType =
                CASE
                    WHEN YMM.DD_YMM_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_YMM_DIMdate1_Yearmonth v
        LEFT JOIN
            dbo._DD_YMM_DIMdate1_Yearmonth YMM
        ON
            YMM.DD_YMM_DD_ID = v.DD_YMM_DD_ID
        AND
            YMM.DD_YMM_DIMdate1_Yearmonth = v.DD_YMM_DIMdate1_Yearmonth
        WHERE
            v.DD_YMM_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_YMM_DIMdate1_Yearmonth (
            DD_YMM_DD_ID,
            DD_YMM_DIMdate1_Yearmonth
        )
        SELECT
            DD_YMM_DD_ID,
            DD_YMM_DIMdate1_Yearmonth
        FROM
            _tmp_DD_YMM_DIMdate1_Yearmonth
        WHERE
            DD_YMM_Version = currentVersion
        AND
            DD_YMM_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_YMM_DIMdate1_Yearmonth;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_YMM_DIMdate1_Yearmonth
AFTER INSERT ON dbo.DD_YMM_DIMdate1_Yearmonth
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_YMM_DIMdate1_Yearmonth();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_YRS_DIMdate1_Year ON dbo.DD_YRS_DIMdate1_Year;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_YRS_DIMdate1_Year();
CREATE OR REPLACE FUNCTION dbo.tcbDD_YRS_DIMdate1_Year() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_YRS_DIMdate1_Year (
            DD_YRS_DD_ID int not null,
            DD_YRS_DIMdate1_Year smallint not null,
            DD_YRS_Version bigint not null,
            DD_YRS_StatementType char(1) not null,
            primary key(
                DD_YRS_Version,
                DD_YRS_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_YRS_DIMdate1_Year
BEFORE INSERT ON dbo.DD_YRS_DIMdate1_Year
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_YRS_DIMdate1_Year();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_YRS_DIMdate1_Year ON dbo.DD_YRS_DIMdate1_Year;
-- DROP FUNCTION IF EXISTS dbo.tciDD_YRS_DIMdate1_Year();
CREATE OR REPLACE FUNCTION dbo.tciDD_YRS_DIMdate1_Year() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_YRS_DIMdate1_Year
        SELECT
            NEW.DD_YRS_DD_ID,
            NEW.DD_YRS_DIMdate1_Year,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_YRS_DIMdate1_Year
INSTEAD OF INSERT ON dbo.DD_YRS_DIMdate1_Year
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_YRS_DIMdate1_Year();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_YRS_DIMdate1_Year ON dbo.DD_YRS_DIMdate1_Year;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_YRS_DIMdate1_Year();
CREATE OR REPLACE FUNCTION dbo.tcaDD_YRS_DIMdate1_Year() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_YRS_Version) INTO maxVersion
    FROM
        _tmp_DD_YRS_DIMdate1_Year;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_YRS_DIMdate1_Year
        SET
            DD_YRS_StatementType =
                CASE
                    WHEN YRS.DD_YRS_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_YRS_DIMdate1_Year v
        LEFT JOIN
            dbo._DD_YRS_DIMdate1_Year YRS
        ON
            YRS.DD_YRS_DD_ID = v.DD_YRS_DD_ID
        AND
            YRS.DD_YRS_DIMdate1_Year = v.DD_YRS_DIMdate1_Year
        WHERE
            v.DD_YRS_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_YRS_DIMdate1_Year (
            DD_YRS_DD_ID,
            DD_YRS_DIMdate1_Year
        )
        SELECT
            DD_YRS_DD_ID,
            DD_YRS_DIMdate1_Year
        FROM
            _tmp_DD_YRS_DIMdate1_Year
        WHERE
            DD_YRS_Version = currentVersion
        AND
            DD_YRS_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_YRS_DIMdate1_Year;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_YRS_DIMdate1_Year
AFTER INSERT ON dbo.DD_YRS_DIMdate1_Year
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_YRS_DIMdate1_Year();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_DNM_DIMdate1_Daynuminmonth ON dbo.DD_DNM_DIMdate1_Daynuminmonth;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_DNM_DIMdate1_Daynuminmonth();
CREATE OR REPLACE FUNCTION dbo.tcbDD_DNM_DIMdate1_Daynuminmonth() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_DNM_DIMdate1_Daynuminmonth (
            DD_DNM_DD_ID int not null,
            DD_DNM_DIMdate1_Daynuminmonth Numeric(31) not null,
            DD_DNM_Version bigint not null,
            DD_DNM_StatementType char(1) not null,
            primary key(
                DD_DNM_Version,
                DD_DNM_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_DNM_DIMdate1_Daynuminmonth
BEFORE INSERT ON dbo.DD_DNM_DIMdate1_Daynuminmonth
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_DNM_DIMdate1_Daynuminmonth();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_DNM_DIMdate1_Daynuminmonth ON dbo.DD_DNM_DIMdate1_Daynuminmonth;
-- DROP FUNCTION IF EXISTS dbo.tciDD_DNM_DIMdate1_Daynuminmonth();
CREATE OR REPLACE FUNCTION dbo.tciDD_DNM_DIMdate1_Daynuminmonth() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_DNM_DIMdate1_Daynuminmonth
        SELECT
            NEW.DD_DNM_DD_ID,
            NEW.DD_DNM_DIMdate1_Daynuminmonth,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_DNM_DIMdate1_Daynuminmonth
INSTEAD OF INSERT ON dbo.DD_DNM_DIMdate1_Daynuminmonth
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_DNM_DIMdate1_Daynuminmonth();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_DNM_DIMdate1_Daynuminmonth ON dbo.DD_DNM_DIMdate1_Daynuminmonth;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_DNM_DIMdate1_Daynuminmonth();
CREATE OR REPLACE FUNCTION dbo.tcaDD_DNM_DIMdate1_Daynuminmonth() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_DNM_Version) INTO maxVersion
    FROM
        _tmp_DD_DNM_DIMdate1_Daynuminmonth;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_DNM_DIMdate1_Daynuminmonth
        SET
            DD_DNM_StatementType =
                CASE
                    WHEN DNM.DD_DNM_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_DNM_DIMdate1_Daynuminmonth v
        LEFT JOIN
            dbo._DD_DNM_DIMdate1_Daynuminmonth DNM
        ON
            DNM.DD_DNM_DD_ID = v.DD_DNM_DD_ID
        AND
            DNM.DD_DNM_DIMdate1_Daynuminmonth = v.DD_DNM_DIMdate1_Daynuminmonth
        WHERE
            v.DD_DNM_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_DNM_DIMdate1_Daynuminmonth (
            DD_DNM_DD_ID,
            DD_DNM_DIMdate1_Daynuminmonth
        )
        SELECT
            DD_DNM_DD_ID,
            DD_DNM_DIMdate1_Daynuminmonth
        FROM
            _tmp_DD_DNM_DIMdate1_Daynuminmonth
        WHERE
            DD_DNM_Version = currentVersion
        AND
            DD_DNM_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_DNM_DIMdate1_Daynuminmonth;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_DNM_DIMdate1_Daynuminmonth
AFTER INSERT ON dbo.DD_DNM_DIMdate1_Daynuminmonth
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_DNM_DIMdate1_Daynuminmonth();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_DNY_DIMdate1_Daynuminyear ON dbo.DD_DNY_DIMdate1_Daynuminyear;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_DNY_DIMdate1_Daynuminyear();
CREATE OR REPLACE FUNCTION dbo.tcbDD_DNY_DIMdate1_Daynuminyear() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_DNY_DIMdate1_Daynuminyear (
            DD_DNY_DD_ID int not null,
            DD_DNY_DIMdate1_Daynuminyear Numeric(31) not null,
            DD_DNY_Version bigint not null,
            DD_DNY_StatementType char(1) not null,
            primary key(
                DD_DNY_Version,
                DD_DNY_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_DNY_DIMdate1_Daynuminyear
BEFORE INSERT ON dbo.DD_DNY_DIMdate1_Daynuminyear
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_DNY_DIMdate1_Daynuminyear();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_DNY_DIMdate1_Daynuminyear ON dbo.DD_DNY_DIMdate1_Daynuminyear;
-- DROP FUNCTION IF EXISTS dbo.tciDD_DNY_DIMdate1_Daynuminyear();
CREATE OR REPLACE FUNCTION dbo.tciDD_DNY_DIMdate1_Daynuminyear() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_DNY_DIMdate1_Daynuminyear
        SELECT
            NEW.DD_DNY_DD_ID,
            NEW.DD_DNY_DIMdate1_Daynuminyear,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_DNY_DIMdate1_Daynuminyear
INSTEAD OF INSERT ON dbo.DD_DNY_DIMdate1_Daynuminyear
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_DNY_DIMdate1_Daynuminyear();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_DNY_DIMdate1_Daynuminyear ON dbo.DD_DNY_DIMdate1_Daynuminyear;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_DNY_DIMdate1_Daynuminyear();
CREATE OR REPLACE FUNCTION dbo.tcaDD_DNY_DIMdate1_Daynuminyear() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_DNY_Version) INTO maxVersion
    FROM
        _tmp_DD_DNY_DIMdate1_Daynuminyear;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_DNY_DIMdate1_Daynuminyear
        SET
            DD_DNY_StatementType =
                CASE
                    WHEN DNY.DD_DNY_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_DNY_DIMdate1_Daynuminyear v
        LEFT JOIN
            dbo._DD_DNY_DIMdate1_Daynuminyear DNY
        ON
            DNY.DD_DNY_DD_ID = v.DD_DNY_DD_ID
        AND
            DNY.DD_DNY_DIMdate1_Daynuminyear = v.DD_DNY_DIMdate1_Daynuminyear
        WHERE
            v.DD_DNY_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_DNY_DIMdate1_Daynuminyear (
            DD_DNY_DD_ID,
            DD_DNY_DIMdate1_Daynuminyear
        )
        SELECT
            DD_DNY_DD_ID,
            DD_DNY_DIMdate1_Daynuminyear
        FROM
            _tmp_DD_DNY_DIMdate1_Daynuminyear
        WHERE
            DD_DNY_Version = currentVersion
        AND
            DD_DNY_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_DNY_DIMdate1_Daynuminyear;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_DNY_DIMdate1_Daynuminyear
AFTER INSERT ON dbo.DD_DNY_DIMdate1_Daynuminyear
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_DNY_DIMdate1_Daynuminyear();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_DMY_DIMdate1_Monthnuminyear ON dbo.DD_DMY_DIMdate1_Monthnuminyear;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_DMY_DIMdate1_Monthnuminyear();
CREATE OR REPLACE FUNCTION dbo.tcbDD_DMY_DIMdate1_Monthnuminyear() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_DMY_DIMdate1_Monthnuminyear (
            DD_DMY_DD_ID int not null,
            DD_DMY_DIMdate1_Monthnuminyear Numeric(12) not null,
            DD_DMY_Version bigint not null,
            DD_DMY_StatementType char(1) not null,
            primary key(
                DD_DMY_Version,
                DD_DMY_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_DMY_DIMdate1_Monthnuminyear
BEFORE INSERT ON dbo.DD_DMY_DIMdate1_Monthnuminyear
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_DMY_DIMdate1_Monthnuminyear();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_DMY_DIMdate1_Monthnuminyear ON dbo.DD_DMY_DIMdate1_Monthnuminyear;
-- DROP FUNCTION IF EXISTS dbo.tciDD_DMY_DIMdate1_Monthnuminyear();
CREATE OR REPLACE FUNCTION dbo.tciDD_DMY_DIMdate1_Monthnuminyear() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_DMY_DIMdate1_Monthnuminyear
        SELECT
            NEW.DD_DMY_DD_ID,
            NEW.DD_DMY_DIMdate1_Monthnuminyear,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_DMY_DIMdate1_Monthnuminyear
INSTEAD OF INSERT ON dbo.DD_DMY_DIMdate1_Monthnuminyear
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_DMY_DIMdate1_Monthnuminyear();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_DMY_DIMdate1_Monthnuminyear ON dbo.DD_DMY_DIMdate1_Monthnuminyear;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_DMY_DIMdate1_Monthnuminyear();
CREATE OR REPLACE FUNCTION dbo.tcaDD_DMY_DIMdate1_Monthnuminyear() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_DMY_Version) INTO maxVersion
    FROM
        _tmp_DD_DMY_DIMdate1_Monthnuminyear;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_DMY_DIMdate1_Monthnuminyear
        SET
            DD_DMY_StatementType =
                CASE
                    WHEN DMY.DD_DMY_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_DMY_DIMdate1_Monthnuminyear v
        LEFT JOIN
            dbo._DD_DMY_DIMdate1_Monthnuminyear DMY
        ON
            DMY.DD_DMY_DD_ID = v.DD_DMY_DD_ID
        AND
            DMY.DD_DMY_DIMdate1_Monthnuminyear = v.DD_DMY_DIMdate1_Monthnuminyear
        WHERE
            v.DD_DMY_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_DMY_DIMdate1_Monthnuminyear (
            DD_DMY_DD_ID,
            DD_DMY_DIMdate1_Monthnuminyear
        )
        SELECT
            DD_DMY_DD_ID,
            DD_DMY_DIMdate1_Monthnuminyear
        FROM
            _tmp_DD_DMY_DIMdate1_Monthnuminyear
        WHERE
            DD_DMY_Version = currentVersion
        AND
            DD_DMY_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_DMY_DIMdate1_Monthnuminyear;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_DMY_DIMdate1_Monthnuminyear
AFTER INSERT ON dbo.DD_DMY_DIMdate1_Monthnuminyear
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_DMY_DIMdate1_Monthnuminyear();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_WNY_DIMdate1_Weeknuminyear ON dbo.DD_WNY_DIMdate1_Weeknuminyear;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_WNY_DIMdate1_Weeknuminyear();
CREATE OR REPLACE FUNCTION dbo.tcbDD_WNY_DIMdate1_Weeknuminyear() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_WNY_DIMdate1_Weeknuminyear (
            DD_WNY_DD_ID int not null,
            DD_WNY_DIMdate1_Weeknuminyear Numeric(53) not null,
            DD_WNY_Version bigint not null,
            DD_WNY_StatementType char(1) not null,
            primary key(
                DD_WNY_Version,
                DD_WNY_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_WNY_DIMdate1_Weeknuminyear
BEFORE INSERT ON dbo.DD_WNY_DIMdate1_Weeknuminyear
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_WNY_DIMdate1_Weeknuminyear();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_WNY_DIMdate1_Weeknuminyear ON dbo.DD_WNY_DIMdate1_Weeknuminyear;
-- DROP FUNCTION IF EXISTS dbo.tciDD_WNY_DIMdate1_Weeknuminyear();
CREATE OR REPLACE FUNCTION dbo.tciDD_WNY_DIMdate1_Weeknuminyear() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_WNY_DIMdate1_Weeknuminyear
        SELECT
            NEW.DD_WNY_DD_ID,
            NEW.DD_WNY_DIMdate1_Weeknuminyear,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_WNY_DIMdate1_Weeknuminyear
INSTEAD OF INSERT ON dbo.DD_WNY_DIMdate1_Weeknuminyear
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_WNY_DIMdate1_Weeknuminyear();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_WNY_DIMdate1_Weeknuminyear ON dbo.DD_WNY_DIMdate1_Weeknuminyear;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_WNY_DIMdate1_Weeknuminyear();
CREATE OR REPLACE FUNCTION dbo.tcaDD_WNY_DIMdate1_Weeknuminyear() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_WNY_Version) INTO maxVersion
    FROM
        _tmp_DD_WNY_DIMdate1_Weeknuminyear;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_WNY_DIMdate1_Weeknuminyear
        SET
            DD_WNY_StatementType =
                CASE
                    WHEN WNY.DD_WNY_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_WNY_DIMdate1_Weeknuminyear v
        LEFT JOIN
            dbo._DD_WNY_DIMdate1_Weeknuminyear WNY
        ON
            WNY.DD_WNY_DD_ID = v.DD_WNY_DD_ID
        AND
            WNY.DD_WNY_DIMdate1_Weeknuminyear = v.DD_WNY_DIMdate1_Weeknuminyear
        WHERE
            v.DD_WNY_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_WNY_DIMdate1_Weeknuminyear (
            DD_WNY_DD_ID,
            DD_WNY_DIMdate1_Weeknuminyear
        )
        SELECT
            DD_WNY_DD_ID,
            DD_WNY_DIMdate1_Weeknuminyear
        FROM
            _tmp_DD_WNY_DIMdate1_Weeknuminyear
        WHERE
            DD_WNY_Version = currentVersion
        AND
            DD_WNY_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_WNY_DIMdate1_Weeknuminyear;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_WNY_DIMdate1_Weeknuminyear
AFTER INSERT ON dbo.DD_WNY_DIMdate1_Weeknuminyear
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_WNY_DIMdate1_Weeknuminyear();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_SSA_DIMdate1_Sellingseason ON dbo.DD_SSA_DIMdate1_Sellingseason;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_SSA_DIMdate1_Sellingseason();
CREATE OR REPLACE FUNCTION dbo.tcbDD_SSA_DIMdate1_Sellingseason() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_SSA_DIMdate1_Sellingseason (
            DD_SSA_DD_ID int not null,
            DD_SSA_DIMdate1_Sellingseason Varchar(12) not null,
            DD_SSA_Version bigint not null,
            DD_SSA_StatementType char(1) not null,
            primary key(
                DD_SSA_Version,
                DD_SSA_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_SSA_DIMdate1_Sellingseason
BEFORE INSERT ON dbo.DD_SSA_DIMdate1_Sellingseason
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_SSA_DIMdate1_Sellingseason();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_SSA_DIMdate1_Sellingseason ON dbo.DD_SSA_DIMdate1_Sellingseason;
-- DROP FUNCTION IF EXISTS dbo.tciDD_SSA_DIMdate1_Sellingseason();
CREATE OR REPLACE FUNCTION dbo.tciDD_SSA_DIMdate1_Sellingseason() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_SSA_DIMdate1_Sellingseason
        SELECT
            NEW.DD_SSA_DD_ID,
            NEW.DD_SSA_DIMdate1_Sellingseason,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_SSA_DIMdate1_Sellingseason
INSTEAD OF INSERT ON dbo.DD_SSA_DIMdate1_Sellingseason
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_SSA_DIMdate1_Sellingseason();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_SSA_DIMdate1_Sellingseason ON dbo.DD_SSA_DIMdate1_Sellingseason;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_SSA_DIMdate1_Sellingseason();
CREATE OR REPLACE FUNCTION dbo.tcaDD_SSA_DIMdate1_Sellingseason() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_SSA_Version) INTO maxVersion
    FROM
        _tmp_DD_SSA_DIMdate1_Sellingseason;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_SSA_DIMdate1_Sellingseason
        SET
            DD_SSA_StatementType =
                CASE
                    WHEN SSA.DD_SSA_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_SSA_DIMdate1_Sellingseason v
        LEFT JOIN
            dbo._DD_SSA_DIMdate1_Sellingseason SSA
        ON
            SSA.DD_SSA_DD_ID = v.DD_SSA_DD_ID
        AND
            SSA.DD_SSA_DIMdate1_Sellingseason = v.DD_SSA_DIMdate1_Sellingseason
        WHERE
            v.DD_SSA_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_SSA_DIMdate1_Sellingseason (
            DD_SSA_DD_ID,
            DD_SSA_DIMdate1_Sellingseason
        )
        SELECT
            DD_SSA_DD_ID,
            DD_SSA_DIMdate1_Sellingseason
        FROM
            _tmp_DD_SSA_DIMdate1_Sellingseason
        WHERE
            DD_SSA_Version = currentVersion
        AND
            DD_SSA_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_SSA_DIMdate1_Sellingseason;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_SSA_DIMdate1_Sellingseason
AFTER INSERT ON dbo.DD_SSA_DIMdate1_Sellingseason
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_SSA_DIMdate1_Sellingseason();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_LFL_DIMdate1_Lastdayinweekfl ON dbo.DD_LFL_DIMdate1_Lastdayinweekfl;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_LFL_DIMdate1_Lastdayinweekfl();
CREATE OR REPLACE FUNCTION dbo.tcbDD_LFL_DIMdate1_Lastdayinweekfl() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_LFL_DIMdate1_Lastdayinweekfl (
            DD_LFL_DD_ID int not null,
            DD_LFL_DIMdate1_Lastdayinweekfl char(1) not null,
            DD_LFL_Version bigint not null,
            DD_LFL_StatementType char(1) not null,
            primary key(
                DD_LFL_Version,
                DD_LFL_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_LFL_DIMdate1_Lastdayinweekfl
BEFORE INSERT ON dbo.DD_LFL_DIMdate1_Lastdayinweekfl
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_LFL_DIMdate1_Lastdayinweekfl();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_LFL_DIMdate1_Lastdayinweekfl ON dbo.DD_LFL_DIMdate1_Lastdayinweekfl;
-- DROP FUNCTION IF EXISTS dbo.tciDD_LFL_DIMdate1_Lastdayinweekfl();
CREATE OR REPLACE FUNCTION dbo.tciDD_LFL_DIMdate1_Lastdayinweekfl() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_LFL_DIMdate1_Lastdayinweekfl
        SELECT
            NEW.DD_LFL_DD_ID,
            NEW.DD_LFL_DIMdate1_Lastdayinweekfl,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_LFL_DIMdate1_Lastdayinweekfl
INSTEAD OF INSERT ON dbo.DD_LFL_DIMdate1_Lastdayinweekfl
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_LFL_DIMdate1_Lastdayinweekfl();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_LFL_DIMdate1_Lastdayinweekfl ON dbo.DD_LFL_DIMdate1_Lastdayinweekfl;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_LFL_DIMdate1_Lastdayinweekfl();
CREATE OR REPLACE FUNCTION dbo.tcaDD_LFL_DIMdate1_Lastdayinweekfl() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_LFL_Version) INTO maxVersion
    FROM
        _tmp_DD_LFL_DIMdate1_Lastdayinweekfl;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_LFL_DIMdate1_Lastdayinweekfl
        SET
            DD_LFL_StatementType =
                CASE
                    WHEN LFL.DD_LFL_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_LFL_DIMdate1_Lastdayinweekfl v
        LEFT JOIN
            dbo._DD_LFL_DIMdate1_Lastdayinweekfl LFL
        ON
            LFL.DD_LFL_DD_ID = v.DD_LFL_DD_ID
        AND
            LFL.DD_LFL_DIMdate1_Lastdayinweekfl = v.DD_LFL_DIMdate1_Lastdayinweekfl
        WHERE
            v.DD_LFL_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_LFL_DIMdate1_Lastdayinweekfl (
            DD_LFL_DD_ID,
            DD_LFL_DIMdate1_Lastdayinweekfl
        )
        SELECT
            DD_LFL_DD_ID,
            DD_LFL_DIMdate1_Lastdayinweekfl
        FROM
            _tmp_DD_LFL_DIMdate1_Lastdayinweekfl
        WHERE
            DD_LFL_Version = currentVersion
        AND
            DD_LFL_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_LFL_DIMdate1_Lastdayinweekfl;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_LFL_DIMdate1_Lastdayinweekfl
AFTER INSERT ON dbo.DD_LFL_DIMdate1_Lastdayinweekfl
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_LFL_DIMdate1_Lastdayinweekfl();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_LDL_DIMdate1_Lastdayinmonthfl ON dbo.DD_LDL_DIMdate1_Lastdayinmonthfl;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_LDL_DIMdate1_Lastdayinmonthfl();
CREATE OR REPLACE FUNCTION dbo.tcbDD_LDL_DIMdate1_Lastdayinmonthfl() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_LDL_DIMdate1_Lastdayinmonthfl (
            DD_LDL_DD_ID int not null,
            DD_LDL_DIMdate1_Lastdayinmonthfl char(1) not null,
            DD_LDL_Version bigint not null,
            DD_LDL_StatementType char(1) not null,
            primary key(
                DD_LDL_Version,
                DD_LDL_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_LDL_DIMdate1_Lastdayinmonthfl
BEFORE INSERT ON dbo.DD_LDL_DIMdate1_Lastdayinmonthfl
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_LDL_DIMdate1_Lastdayinmonthfl();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_LDL_DIMdate1_Lastdayinmonthfl ON dbo.DD_LDL_DIMdate1_Lastdayinmonthfl;
-- DROP FUNCTION IF EXISTS dbo.tciDD_LDL_DIMdate1_Lastdayinmonthfl();
CREATE OR REPLACE FUNCTION dbo.tciDD_LDL_DIMdate1_Lastdayinmonthfl() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_LDL_DIMdate1_Lastdayinmonthfl
        SELECT
            NEW.DD_LDL_DD_ID,
            NEW.DD_LDL_DIMdate1_Lastdayinmonthfl,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_LDL_DIMdate1_Lastdayinmonthfl
INSTEAD OF INSERT ON dbo.DD_LDL_DIMdate1_Lastdayinmonthfl
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_LDL_DIMdate1_Lastdayinmonthfl();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_LDL_DIMdate1_Lastdayinmonthfl ON dbo.DD_LDL_DIMdate1_Lastdayinmonthfl;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_LDL_DIMdate1_Lastdayinmonthfl();
CREATE OR REPLACE FUNCTION dbo.tcaDD_LDL_DIMdate1_Lastdayinmonthfl() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_LDL_Version) INTO maxVersion
    FROM
        _tmp_DD_LDL_DIMdate1_Lastdayinmonthfl;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_LDL_DIMdate1_Lastdayinmonthfl
        SET
            DD_LDL_StatementType =
                CASE
                    WHEN LDL.DD_LDL_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_LDL_DIMdate1_Lastdayinmonthfl v
        LEFT JOIN
            dbo._DD_LDL_DIMdate1_Lastdayinmonthfl LDL
        ON
            LDL.DD_LDL_DD_ID = v.DD_LDL_DD_ID
        AND
            LDL.DD_LDL_DIMdate1_Lastdayinmonthfl = v.DD_LDL_DIMdate1_Lastdayinmonthfl
        WHERE
            v.DD_LDL_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_LDL_DIMdate1_Lastdayinmonthfl (
            DD_LDL_DD_ID,
            DD_LDL_DIMdate1_Lastdayinmonthfl
        )
        SELECT
            DD_LDL_DD_ID,
            DD_LDL_DIMdate1_Lastdayinmonthfl
        FROM
            _tmp_DD_LDL_DIMdate1_Lastdayinmonthfl
        WHERE
            DD_LDL_Version = currentVersion
        AND
            DD_LDL_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_LDL_DIMdate1_Lastdayinmonthfl;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_LDL_DIMdate1_Lastdayinmonthfl
AFTER INSERT ON dbo.DD_LDL_DIMdate1_Lastdayinmonthfl
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_LDL_DIMdate1_Lastdayinmonthfl();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_HOF_DIMdate1_Holydayfl ON dbo.DD_HOF_DIMdate1_Holydayfl;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_HOF_DIMdate1_Holydayfl();
CREATE OR REPLACE FUNCTION dbo.tcbDD_HOF_DIMdate1_Holydayfl() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_HOF_DIMdate1_Holydayfl (
            DD_HOF_DD_ID int not null,
            DD_HOF_DIMdate1_Holydayfl char(1) not null,
            DD_HOF_Version bigint not null,
            DD_HOF_StatementType char(1) not null,
            primary key(
                DD_HOF_Version,
                DD_HOF_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_HOF_DIMdate1_Holydayfl
BEFORE INSERT ON dbo.DD_HOF_DIMdate1_Holydayfl
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_HOF_DIMdate1_Holydayfl();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_HOF_DIMdate1_Holydayfl ON dbo.DD_HOF_DIMdate1_Holydayfl;
-- DROP FUNCTION IF EXISTS dbo.tciDD_HOF_DIMdate1_Holydayfl();
CREATE OR REPLACE FUNCTION dbo.tciDD_HOF_DIMdate1_Holydayfl() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_HOF_DIMdate1_Holydayfl
        SELECT
            NEW.DD_HOF_DD_ID,
            NEW.DD_HOF_DIMdate1_Holydayfl,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_HOF_DIMdate1_Holydayfl
INSTEAD OF INSERT ON dbo.DD_HOF_DIMdate1_Holydayfl
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_HOF_DIMdate1_Holydayfl();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_HOF_DIMdate1_Holydayfl ON dbo.DD_HOF_DIMdate1_Holydayfl;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_HOF_DIMdate1_Holydayfl();
CREATE OR REPLACE FUNCTION dbo.tcaDD_HOF_DIMdate1_Holydayfl() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_HOF_Version) INTO maxVersion
    FROM
        _tmp_DD_HOF_DIMdate1_Holydayfl;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_HOF_DIMdate1_Holydayfl
        SET
            DD_HOF_StatementType =
                CASE
                    WHEN HOF.DD_HOF_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_HOF_DIMdate1_Holydayfl v
        LEFT JOIN
            dbo._DD_HOF_DIMdate1_Holydayfl HOF
        ON
            HOF.DD_HOF_DD_ID = v.DD_HOF_DD_ID
        AND
            HOF.DD_HOF_DIMdate1_Holydayfl = v.DD_HOF_DIMdate1_Holydayfl
        WHERE
            v.DD_HOF_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_HOF_DIMdate1_Holydayfl (
            DD_HOF_DD_ID,
            DD_HOF_DIMdate1_Holydayfl
        )
        SELECT
            DD_HOF_DD_ID,
            DD_HOF_DIMdate1_Holydayfl
        FROM
            _tmp_DD_HOF_DIMdate1_Holydayfl
        WHERE
            DD_HOF_Version = currentVersion
        AND
            DD_HOF_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_HOF_DIMdate1_Holydayfl;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_HOF_DIMdate1_Holydayfl
AFTER INSERT ON dbo.DD_HOF_DIMdate1_Holydayfl
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_HOF_DIMdate1_Holydayfl();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDD_WDF_DIMdate1_Weekdayfl ON dbo.DD_WDF_DIMdate1_Weekdayfl;
-- DROP FUNCTION IF EXISTS dbo.tcbDD_WDF_DIMdate1_Weekdayfl();
CREATE OR REPLACE FUNCTION dbo.tcbDD_WDF_DIMdate1_Weekdayfl() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DD_WDF_DIMdate1_Weekdayfl (
            DD_WDF_DD_ID int not null,
            DD_WDF_DIMdate1_Weekdayfl char(1) not null,
            DD_WDF_Version bigint not null,
            DD_WDF_StatementType char(1) not null,
            primary key(
                DD_WDF_Version,
                DD_WDF_DD_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDD_WDF_DIMdate1_Weekdayfl
BEFORE INSERT ON dbo.DD_WDF_DIMdate1_Weekdayfl
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDD_WDF_DIMdate1_Weekdayfl();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDD_WDF_DIMdate1_Weekdayfl ON dbo.DD_WDF_DIMdate1_Weekdayfl;
-- DROP FUNCTION IF EXISTS dbo.tciDD_WDF_DIMdate1_Weekdayfl();
CREATE OR REPLACE FUNCTION dbo.tciDD_WDF_DIMdate1_Weekdayfl() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DD_WDF_DIMdate1_Weekdayfl
        SELECT
            NEW.DD_WDF_DD_ID,
            NEW.DD_WDF_DIMdate1_Weekdayfl,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDD_WDF_DIMdate1_Weekdayfl
INSTEAD OF INSERT ON dbo.DD_WDF_DIMdate1_Weekdayfl
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDD_WDF_DIMdate1_Weekdayfl();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDD_WDF_DIMdate1_Weekdayfl ON dbo.DD_WDF_DIMdate1_Weekdayfl;
-- DROP FUNCTION IF EXISTS dbo.tcaDD_WDF_DIMdate1_Weekdayfl();
CREATE OR REPLACE FUNCTION dbo.tcaDD_WDF_DIMdate1_Weekdayfl() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DD_WDF_Version) INTO maxVersion
    FROM
        _tmp_DD_WDF_DIMdate1_Weekdayfl;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DD_WDF_DIMdate1_Weekdayfl
        SET
            DD_WDF_StatementType =
                CASE
                    WHEN WDF.DD_WDF_DD_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DD_WDF_DIMdate1_Weekdayfl v
        LEFT JOIN
            dbo._DD_WDF_DIMdate1_Weekdayfl WDF
        ON
            WDF.DD_WDF_DD_ID = v.DD_WDF_DD_ID
        AND
            WDF.DD_WDF_DIMdate1_Weekdayfl = v.DD_WDF_DIMdate1_Weekdayfl
        WHERE
            v.DD_WDF_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DD_WDF_DIMdate1_Weekdayfl (
            DD_WDF_DD_ID,
            DD_WDF_DIMdate1_Weekdayfl
        )
        SELECT
            DD_WDF_DD_ID,
            DD_WDF_DIMdate1_Weekdayfl
        FROM
            _tmp_DD_WDF_DIMdate1_Weekdayfl
        WHERE
            DD_WDF_Version = currentVersion
        AND
            DD_WDF_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DD_WDF_DIMdate1_Weekdayfl;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDD_WDF_DIMdate1_Weekdayfl
AFTER INSERT ON dbo.DD_WDF_DIMdate1_Weekdayfl
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDD_WDF_DIMdate1_Weekdayfl();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDP_NAM_DIMpart_Name ON dbo.DP_NAM_DIMpart_Name;
-- DROP FUNCTION IF EXISTS dbo.tcbDP_NAM_DIMpart_Name();
CREATE OR REPLACE FUNCTION dbo.tcbDP_NAM_DIMpart_Name() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DP_NAM_DIMpart_Name (
            DP_NAM_DP_ID int not null,
            DP_NAM_DIMpart_Name varchar(22) not null,
            DP_NAM_Version bigint not null,
            DP_NAM_StatementType char(1) not null,
            primary key(
                DP_NAM_Version,
                DP_NAM_DP_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDP_NAM_DIMpart_Name
BEFORE INSERT ON dbo.DP_NAM_DIMpart_Name
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDP_NAM_DIMpart_Name();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDP_NAM_DIMpart_Name ON dbo.DP_NAM_DIMpart_Name;
-- DROP FUNCTION IF EXISTS dbo.tciDP_NAM_DIMpart_Name();
CREATE OR REPLACE FUNCTION dbo.tciDP_NAM_DIMpart_Name() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DP_NAM_DIMpart_Name
        SELECT
            NEW.DP_NAM_DP_ID,
            NEW.DP_NAM_DIMpart_Name,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDP_NAM_DIMpart_Name
INSTEAD OF INSERT ON dbo.DP_NAM_DIMpart_Name
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDP_NAM_DIMpart_Name();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDP_NAM_DIMpart_Name ON dbo.DP_NAM_DIMpart_Name;
-- DROP FUNCTION IF EXISTS dbo.tcaDP_NAM_DIMpart_Name();
CREATE OR REPLACE FUNCTION dbo.tcaDP_NAM_DIMpart_Name() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DP_NAM_Version) INTO maxVersion
    FROM
        _tmp_DP_NAM_DIMpart_Name;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DP_NAM_DIMpart_Name
        SET
            DP_NAM_StatementType =
                CASE
                    WHEN NAM.DP_NAM_DP_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DP_NAM_DIMpart_Name v
        LEFT JOIN
            dbo._DP_NAM_DIMpart_Name NAM
        ON
            NAM.DP_NAM_DP_ID = v.DP_NAM_DP_ID
        AND
            NAM.DP_NAM_DIMpart_Name = v.DP_NAM_DIMpart_Name
        WHERE
            v.DP_NAM_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DP_NAM_DIMpart_Name (
            DP_NAM_DP_ID,
            DP_NAM_DIMpart_Name
        )
        SELECT
            DP_NAM_DP_ID,
            DP_NAM_DIMpart_Name
        FROM
            _tmp_DP_NAM_DIMpart_Name
        WHERE
            DP_NAM_Version = currentVersion
        AND
            DP_NAM_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DP_NAM_DIMpart_Name;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDP_NAM_DIMpart_Name
AFTER INSERT ON dbo.DP_NAM_DIMpart_Name
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDP_NAM_DIMpart_Name();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDP_MTG_DIMpart_Mfgr ON dbo.DP_MTG_DIMpart_Mfgr;
-- DROP FUNCTION IF EXISTS dbo.tcbDP_MTG_DIMpart_Mfgr();
CREATE OR REPLACE FUNCTION dbo.tcbDP_MTG_DIMpart_Mfgr() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DP_MTG_DIMpart_Mfgr (
            DP_MTG_DP_ID int not null,
            DP_MTG_DIMpart_Mfgr Varchar(6) not null,
            DP_MTG_Version bigint not null,
            DP_MTG_StatementType char(1) not null,
            primary key(
                DP_MTG_Version,
                DP_MTG_DP_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDP_MTG_DIMpart_Mfgr
BEFORE INSERT ON dbo.DP_MTG_DIMpart_Mfgr
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDP_MTG_DIMpart_Mfgr();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDP_MTG_DIMpart_Mfgr ON dbo.DP_MTG_DIMpart_Mfgr;
-- DROP FUNCTION IF EXISTS dbo.tciDP_MTG_DIMpart_Mfgr();
CREATE OR REPLACE FUNCTION dbo.tciDP_MTG_DIMpart_Mfgr() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DP_MTG_DIMpart_Mfgr
        SELECT
            NEW.DP_MTG_DP_ID,
            NEW.DP_MTG_DIMpart_Mfgr,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDP_MTG_DIMpart_Mfgr
INSTEAD OF INSERT ON dbo.DP_MTG_DIMpart_Mfgr
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDP_MTG_DIMpart_Mfgr();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDP_MTG_DIMpart_Mfgr ON dbo.DP_MTG_DIMpart_Mfgr;
-- DROP FUNCTION IF EXISTS dbo.tcaDP_MTG_DIMpart_Mfgr();
CREATE OR REPLACE FUNCTION dbo.tcaDP_MTG_DIMpart_Mfgr() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DP_MTG_Version) INTO maxVersion
    FROM
        _tmp_DP_MTG_DIMpart_Mfgr;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DP_MTG_DIMpart_Mfgr
        SET
            DP_MTG_StatementType =
                CASE
                    WHEN MTG.DP_MTG_DP_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DP_MTG_DIMpart_Mfgr v
        LEFT JOIN
            dbo._DP_MTG_DIMpart_Mfgr MTG
        ON
            MTG.DP_MTG_DP_ID = v.DP_MTG_DP_ID
        AND
            MTG.DP_MTG_DIMpart_Mfgr = v.DP_MTG_DIMpart_Mfgr
        WHERE
            v.DP_MTG_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DP_MTG_DIMpart_Mfgr (
            DP_MTG_DP_ID,
            DP_MTG_DIMpart_Mfgr
        )
        SELECT
            DP_MTG_DP_ID,
            DP_MTG_DIMpart_Mfgr
        FROM
            _tmp_DP_MTG_DIMpart_Mfgr
        WHERE
            DP_MTG_Version = currentVersion
        AND
            DP_MTG_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DP_MTG_DIMpart_Mfgr;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDP_MTG_DIMpart_Mfgr
AFTER INSERT ON dbo.DP_MTG_DIMpart_Mfgr
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDP_MTG_DIMpart_Mfgr();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDP_CAT_DIMpart_Category ON dbo.DP_CAT_DIMpart_Category;
-- DROP FUNCTION IF EXISTS dbo.tcbDP_CAT_DIMpart_Category();
CREATE OR REPLACE FUNCTION dbo.tcbDP_CAT_DIMpart_Category() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DP_CAT_DIMpart_Category (
            DP_CAT_DP_ID int not null,
            DP_CAT_DIMpart_Category Varchar(7) not null,
            DP_CAT_Version bigint not null,
            DP_CAT_StatementType char(1) not null,
            primary key(
                DP_CAT_Version,
                DP_CAT_DP_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDP_CAT_DIMpart_Category
BEFORE INSERT ON dbo.DP_CAT_DIMpart_Category
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDP_CAT_DIMpart_Category();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDP_CAT_DIMpart_Category ON dbo.DP_CAT_DIMpart_Category;
-- DROP FUNCTION IF EXISTS dbo.tciDP_CAT_DIMpart_Category();
CREATE OR REPLACE FUNCTION dbo.tciDP_CAT_DIMpart_Category() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DP_CAT_DIMpart_Category
        SELECT
            NEW.DP_CAT_DP_ID,
            NEW.DP_CAT_DIMpart_Category,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDP_CAT_DIMpart_Category
INSTEAD OF INSERT ON dbo.DP_CAT_DIMpart_Category
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDP_CAT_DIMpart_Category();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDP_CAT_DIMpart_Category ON dbo.DP_CAT_DIMpart_Category;
-- DROP FUNCTION IF EXISTS dbo.tcaDP_CAT_DIMpart_Category();
CREATE OR REPLACE FUNCTION dbo.tcaDP_CAT_DIMpart_Category() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DP_CAT_Version) INTO maxVersion
    FROM
        _tmp_DP_CAT_DIMpart_Category;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DP_CAT_DIMpart_Category
        SET
            DP_CAT_StatementType =
                CASE
                    WHEN CAT.DP_CAT_DP_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DP_CAT_DIMpart_Category v
        LEFT JOIN
            dbo._DP_CAT_DIMpart_Category CAT
        ON
            CAT.DP_CAT_DP_ID = v.DP_CAT_DP_ID
        AND
            CAT.DP_CAT_DIMpart_Category = v.DP_CAT_DIMpart_Category
        WHERE
            v.DP_CAT_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DP_CAT_DIMpart_Category (
            DP_CAT_DP_ID,
            DP_CAT_DIMpart_Category
        )
        SELECT
            DP_CAT_DP_ID,
            DP_CAT_DIMpart_Category
        FROM
            _tmp_DP_CAT_DIMpart_Category
        WHERE
            DP_CAT_Version = currentVersion
        AND
            DP_CAT_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DP_CAT_DIMpart_Category;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDP_CAT_DIMpart_Category
AFTER INSERT ON dbo.DP_CAT_DIMpart_Category
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDP_CAT_DIMpart_Category();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDP_BRA_DIMpart_Brand1 ON dbo.DP_BRA_DIMpart_Brand1;
-- DROP FUNCTION IF EXISTS dbo.tcbDP_BRA_DIMpart_Brand1();
CREATE OR REPLACE FUNCTION dbo.tcbDP_BRA_DIMpart_Brand1() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DP_BRA_DIMpart_Brand1 (
            DP_BRA_DP_ID int not null,
            DP_BRA_DIMpart_Brand1 Varchar(9) not null,
            DP_BRA_Version bigint not null,
            DP_BRA_StatementType char(1) not null,
            primary key(
                DP_BRA_Version,
                DP_BRA_DP_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDP_BRA_DIMpart_Brand1
BEFORE INSERT ON dbo.DP_BRA_DIMpart_Brand1
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDP_BRA_DIMpart_Brand1();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDP_BRA_DIMpart_Brand1 ON dbo.DP_BRA_DIMpart_Brand1;
-- DROP FUNCTION IF EXISTS dbo.tciDP_BRA_DIMpart_Brand1();
CREATE OR REPLACE FUNCTION dbo.tciDP_BRA_DIMpart_Brand1() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DP_BRA_DIMpart_Brand1
        SELECT
            NEW.DP_BRA_DP_ID,
            NEW.DP_BRA_DIMpart_Brand1,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDP_BRA_DIMpart_Brand1
INSTEAD OF INSERT ON dbo.DP_BRA_DIMpart_Brand1
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDP_BRA_DIMpart_Brand1();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDP_BRA_DIMpart_Brand1 ON dbo.DP_BRA_DIMpart_Brand1;
-- DROP FUNCTION IF EXISTS dbo.tcaDP_BRA_DIMpart_Brand1();
CREATE OR REPLACE FUNCTION dbo.tcaDP_BRA_DIMpart_Brand1() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DP_BRA_Version) INTO maxVersion
    FROM
        _tmp_DP_BRA_DIMpart_Brand1;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DP_BRA_DIMpart_Brand1
        SET
            DP_BRA_StatementType =
                CASE
                    WHEN BRA.DP_BRA_DP_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DP_BRA_DIMpart_Brand1 v
        LEFT JOIN
            dbo._DP_BRA_DIMpart_Brand1 BRA
        ON
            BRA.DP_BRA_DP_ID = v.DP_BRA_DP_ID
        AND
            BRA.DP_BRA_DIMpart_Brand1 = v.DP_BRA_DIMpart_Brand1
        WHERE
            v.DP_BRA_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DP_BRA_DIMpart_Brand1 (
            DP_BRA_DP_ID,
            DP_BRA_DIMpart_Brand1
        )
        SELECT
            DP_BRA_DP_ID,
            DP_BRA_DIMpart_Brand1
        FROM
            _tmp_DP_BRA_DIMpart_Brand1
        WHERE
            DP_BRA_Version = currentVersion
        AND
            DP_BRA_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DP_BRA_DIMpart_Brand1;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDP_BRA_DIMpart_Brand1
AFTER INSERT ON dbo.DP_BRA_DIMpart_Brand1
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDP_BRA_DIMpart_Brand1();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDP_COL_DIMpart_Color ON dbo.DP_COL_DIMpart_Color;
-- DROP FUNCTION IF EXISTS dbo.tcbDP_COL_DIMpart_Color();
CREATE OR REPLACE FUNCTION dbo.tcbDP_COL_DIMpart_Color() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DP_COL_DIMpart_Color (
            DP_COL_DP_ID int not null,
            DP_COL_DIMpart_Color Varchar(11) not null,
            DP_COL_Version bigint not null,
            DP_COL_StatementType char(1) not null,
            primary key(
                DP_COL_Version,
                DP_COL_DP_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDP_COL_DIMpart_Color
BEFORE INSERT ON dbo.DP_COL_DIMpart_Color
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDP_COL_DIMpart_Color();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDP_COL_DIMpart_Color ON dbo.DP_COL_DIMpart_Color;
-- DROP FUNCTION IF EXISTS dbo.tciDP_COL_DIMpart_Color();
CREATE OR REPLACE FUNCTION dbo.tciDP_COL_DIMpart_Color() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DP_COL_DIMpart_Color
        SELECT
            NEW.DP_COL_DP_ID,
            NEW.DP_COL_DIMpart_Color,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDP_COL_DIMpart_Color
INSTEAD OF INSERT ON dbo.DP_COL_DIMpart_Color
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDP_COL_DIMpart_Color();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDP_COL_DIMpart_Color ON dbo.DP_COL_DIMpart_Color;
-- DROP FUNCTION IF EXISTS dbo.tcaDP_COL_DIMpart_Color();
CREATE OR REPLACE FUNCTION dbo.tcaDP_COL_DIMpart_Color() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DP_COL_Version) INTO maxVersion
    FROM
        _tmp_DP_COL_DIMpart_Color;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DP_COL_DIMpart_Color
        SET
            DP_COL_StatementType =
                CASE
                    WHEN COL.DP_COL_DP_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DP_COL_DIMpart_Color v
        LEFT JOIN
            dbo._DP_COL_DIMpart_Color COL
        ON
            COL.DP_COL_DP_ID = v.DP_COL_DP_ID
        AND
            COL.DP_COL_DIMpart_Color = v.DP_COL_DIMpart_Color
        WHERE
            v.DP_COL_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DP_COL_DIMpart_Color (
            DP_COL_DP_ID,
            DP_COL_DIMpart_Color
        )
        SELECT
            DP_COL_DP_ID,
            DP_COL_DIMpart_Color
        FROM
            _tmp_DP_COL_DIMpart_Color
        WHERE
            DP_COL_Version = currentVersion
        AND
            DP_COL_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DP_COL_DIMpart_Color;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDP_COL_DIMpart_Color
AFTER INSERT ON dbo.DP_COL_DIMpart_Color
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDP_COL_DIMpart_Color();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDP_TYP_DIMpart_Type ON dbo.DP_TYP_DIMpart_Type;
-- DROP FUNCTION IF EXISTS dbo.tcbDP_TYP_DIMpart_Type();
CREATE OR REPLACE FUNCTION dbo.tcbDP_TYP_DIMpart_Type() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DP_TYP_DIMpart_Type (
            DP_TYP_DP_ID int not null,
            DP_TYP_DIMpart_Type Varchar(25) not null,
            DP_TYP_Version bigint not null,
            DP_TYP_StatementType char(1) not null,
            primary key(
                DP_TYP_Version,
                DP_TYP_DP_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDP_TYP_DIMpart_Type
BEFORE INSERT ON dbo.DP_TYP_DIMpart_Type
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDP_TYP_DIMpart_Type();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDP_TYP_DIMpart_Type ON dbo.DP_TYP_DIMpart_Type;
-- DROP FUNCTION IF EXISTS dbo.tciDP_TYP_DIMpart_Type();
CREATE OR REPLACE FUNCTION dbo.tciDP_TYP_DIMpart_Type() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DP_TYP_DIMpart_Type
        SELECT
            NEW.DP_TYP_DP_ID,
            NEW.DP_TYP_DIMpart_Type,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDP_TYP_DIMpart_Type
INSTEAD OF INSERT ON dbo.DP_TYP_DIMpart_Type
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDP_TYP_DIMpart_Type();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDP_TYP_DIMpart_Type ON dbo.DP_TYP_DIMpart_Type;
-- DROP FUNCTION IF EXISTS dbo.tcaDP_TYP_DIMpart_Type();
CREATE OR REPLACE FUNCTION dbo.tcaDP_TYP_DIMpart_Type() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DP_TYP_Version) INTO maxVersion
    FROM
        _tmp_DP_TYP_DIMpart_Type;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DP_TYP_DIMpart_Type
        SET
            DP_TYP_StatementType =
                CASE
                    WHEN TYP.DP_TYP_DP_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DP_TYP_DIMpart_Type v
        LEFT JOIN
            dbo._DP_TYP_DIMpart_Type TYP
        ON
            TYP.DP_TYP_DP_ID = v.DP_TYP_DP_ID
        AND
            TYP.DP_TYP_DIMpart_Type = v.DP_TYP_DIMpart_Type
        WHERE
            v.DP_TYP_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DP_TYP_DIMpart_Type (
            DP_TYP_DP_ID,
            DP_TYP_DIMpart_Type
        )
        SELECT
            DP_TYP_DP_ID,
            DP_TYP_DIMpart_Type
        FROM
            _tmp_DP_TYP_DIMpart_Type
        WHERE
            DP_TYP_Version = currentVersion
        AND
            DP_TYP_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DP_TYP_DIMpart_Type;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDP_TYP_DIMpart_Type
AFTER INSERT ON dbo.DP_TYP_DIMpart_Type
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDP_TYP_DIMpart_Type();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDP_SIZ_DIMpart_Size ON dbo.DP_SIZ_DIMpart_Size;
-- DROP FUNCTION IF EXISTS dbo.tcbDP_SIZ_DIMpart_Size();
CREATE OR REPLACE FUNCTION dbo.tcbDP_SIZ_DIMpart_Size() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DP_SIZ_DIMpart_Size (
            DP_SIZ_DP_ID int not null,
            DP_SIZ_DIMpart_Size Numeric(50) not null,
            DP_SIZ_Version bigint not null,
            DP_SIZ_StatementType char(1) not null,
            primary key(
                DP_SIZ_Version,
                DP_SIZ_DP_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDP_SIZ_DIMpart_Size
BEFORE INSERT ON dbo.DP_SIZ_DIMpart_Size
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDP_SIZ_DIMpart_Size();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDP_SIZ_DIMpart_Size ON dbo.DP_SIZ_DIMpart_Size;
-- DROP FUNCTION IF EXISTS dbo.tciDP_SIZ_DIMpart_Size();
CREATE OR REPLACE FUNCTION dbo.tciDP_SIZ_DIMpart_Size() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DP_SIZ_DIMpart_Size
        SELECT
            NEW.DP_SIZ_DP_ID,
            NEW.DP_SIZ_DIMpart_Size,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDP_SIZ_DIMpart_Size
INSTEAD OF INSERT ON dbo.DP_SIZ_DIMpart_Size
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDP_SIZ_DIMpart_Size();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDP_SIZ_DIMpart_Size ON dbo.DP_SIZ_DIMpart_Size;
-- DROP FUNCTION IF EXISTS dbo.tcaDP_SIZ_DIMpart_Size();
CREATE OR REPLACE FUNCTION dbo.tcaDP_SIZ_DIMpart_Size() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DP_SIZ_Version) INTO maxVersion
    FROM
        _tmp_DP_SIZ_DIMpart_Size;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DP_SIZ_DIMpart_Size
        SET
            DP_SIZ_StatementType =
                CASE
                    WHEN SIZ.DP_SIZ_DP_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DP_SIZ_DIMpart_Size v
        LEFT JOIN
            dbo._DP_SIZ_DIMpart_Size SIZ
        ON
            SIZ.DP_SIZ_DP_ID = v.DP_SIZ_DP_ID
        AND
            SIZ.DP_SIZ_DIMpart_Size = v.DP_SIZ_DIMpart_Size
        WHERE
            v.DP_SIZ_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DP_SIZ_DIMpart_Size (
            DP_SIZ_DP_ID,
            DP_SIZ_DIMpart_Size
        )
        SELECT
            DP_SIZ_DP_ID,
            DP_SIZ_DIMpart_Size
        FROM
            _tmp_DP_SIZ_DIMpart_Size
        WHERE
            DP_SIZ_Version = currentVersion
        AND
            DP_SIZ_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DP_SIZ_DIMpart_Size;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDP_SIZ_DIMpart_Size
AFTER INSERT ON dbo.DP_SIZ_DIMpart_Size
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDP_SIZ_DIMpart_Size();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDP_CON_DIMpart_Container ON dbo.DP_CON_DIMpart_Container;
-- DROP FUNCTION IF EXISTS dbo.tcbDP_CON_DIMpart_Container();
CREATE OR REPLACE FUNCTION dbo.tcbDP_CON_DIMpart_Container() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DP_CON_DIMpart_Container (
            DP_CON_DP_ID int not null,
            DP_CON_DIMpart_Container Char(10) not null,
            DP_CON_Version bigint not null,
            DP_CON_StatementType char(1) not null,
            primary key(
                DP_CON_Version,
                DP_CON_DP_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDP_CON_DIMpart_Container
BEFORE INSERT ON dbo.DP_CON_DIMpart_Container
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDP_CON_DIMpart_Container();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDP_CON_DIMpart_Container ON dbo.DP_CON_DIMpart_Container;
-- DROP FUNCTION IF EXISTS dbo.tciDP_CON_DIMpart_Container();
CREATE OR REPLACE FUNCTION dbo.tciDP_CON_DIMpart_Container() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DP_CON_DIMpart_Container
        SELECT
            NEW.DP_CON_DP_ID,
            NEW.DP_CON_DIMpart_Container,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDP_CON_DIMpart_Container
INSTEAD OF INSERT ON dbo.DP_CON_DIMpart_Container
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDP_CON_DIMpart_Container();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDP_CON_DIMpart_Container ON dbo.DP_CON_DIMpart_Container;
-- DROP FUNCTION IF EXISTS dbo.tcaDP_CON_DIMpart_Container();
CREATE OR REPLACE FUNCTION dbo.tcaDP_CON_DIMpart_Container() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DP_CON_Version) INTO maxVersion
    FROM
        _tmp_DP_CON_DIMpart_Container;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DP_CON_DIMpart_Container
        SET
            DP_CON_StatementType =
                CASE
                    WHEN CON.DP_CON_DP_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DP_CON_DIMpart_Container v
        LEFT JOIN
            dbo._DP_CON_DIMpart_Container CON
        ON
            CON.DP_CON_DP_ID = v.DP_CON_DP_ID
        AND
            CON.DP_CON_DIMpart_Container = v.DP_CON_DIMpart_Container
        WHERE
            v.DP_CON_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DP_CON_DIMpart_Container (
            DP_CON_DP_ID,
            DP_CON_DIMpart_Container
        )
        SELECT
            DP_CON_DP_ID,
            DP_CON_DIMpart_Container
        FROM
            _tmp_DP_CON_DIMpart_Container
        WHERE
            DP_CON_Version = currentVersion
        AND
            DP_CON_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DP_CON_DIMpart_Container;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDP_CON_DIMpart_Container
AFTER INSERT ON dbo.DP_CON_DIMpart_Container
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDP_CON_DIMpart_Container();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbFL_SHP_FACTlineorder_Shippriority ON dbo.FL_SHP_FACTlineorder_Shippriority;
-- DROP FUNCTION IF EXISTS dbo.tcbFL_SHP_FACTlineorder_Shippriority();
CREATE OR REPLACE FUNCTION dbo.tcbFL_SHP_FACTlineorder_Shippriority() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_FL_SHP_FACTlineorder_Shippriority (
            FL_SHP_FL_ID int not null,
            FL_SHP_FACTlineorder_Shippriority Char(1) not null,
            FL_SHP_Version bigint not null,
            FL_SHP_StatementType char(1) not null,
            primary key(
                FL_SHP_Version,
                FL_SHP_FL_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbFL_SHP_FACTlineorder_Shippriority
BEFORE INSERT ON dbo.FL_SHP_FACTlineorder_Shippriority
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbFL_SHP_FACTlineorder_Shippriority();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciFL_SHP_FACTlineorder_Shippriority ON dbo.FL_SHP_FACTlineorder_Shippriority;
-- DROP FUNCTION IF EXISTS dbo.tciFL_SHP_FACTlineorder_Shippriority();
CREATE OR REPLACE FUNCTION dbo.tciFL_SHP_FACTlineorder_Shippriority() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_FL_SHP_FACTlineorder_Shippriority
        SELECT
            NEW.FL_SHP_FL_ID,
            NEW.FL_SHP_FACTlineorder_Shippriority,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciFL_SHP_FACTlineorder_Shippriority
INSTEAD OF INSERT ON dbo.FL_SHP_FACTlineorder_Shippriority
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciFL_SHP_FACTlineorder_Shippriority();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaFL_SHP_FACTlineorder_Shippriority ON dbo.FL_SHP_FACTlineorder_Shippriority;
-- DROP FUNCTION IF EXISTS dbo.tcaFL_SHP_FACTlineorder_Shippriority();
CREATE OR REPLACE FUNCTION dbo.tcaFL_SHP_FACTlineorder_Shippriority() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(FL_SHP_Version) INTO maxVersion
    FROM
        _tmp_FL_SHP_FACTlineorder_Shippriority;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_FL_SHP_FACTlineorder_Shippriority
        SET
            FL_SHP_StatementType =
                CASE
                    WHEN SHP.FL_SHP_FL_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_FL_SHP_FACTlineorder_Shippriority v
        LEFT JOIN
            dbo._FL_SHP_FACTlineorder_Shippriority SHP
        ON
            SHP.FL_SHP_FL_ID = v.FL_SHP_FL_ID
        AND
            SHP.FL_SHP_FACTlineorder_Shippriority = v.FL_SHP_FACTlineorder_Shippriority
        WHERE
            v.FL_SHP_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._FL_SHP_FACTlineorder_Shippriority (
            FL_SHP_FL_ID,
            FL_SHP_FACTlineorder_Shippriority
        )
        SELECT
            FL_SHP_FL_ID,
            FL_SHP_FACTlineorder_Shippriority
        FROM
            _tmp_FL_SHP_FACTlineorder_Shippriority
        WHERE
            FL_SHP_Version = currentVersion
        AND
            FL_SHP_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_FL_SHP_FACTlineorder_Shippriority;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaFL_SHP_FACTlineorder_Shippriority
AFTER INSERT ON dbo.FL_SHP_FACTlineorder_Shippriority
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaFL_SHP_FACTlineorder_Shippriority();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbFL_OPY_FACTlineorder_Orderpriority ON dbo.FL_OPY_FACTlineorder_Orderpriority;
-- DROP FUNCTION IF EXISTS dbo.tcbFL_OPY_FACTlineorder_Orderpriority();
CREATE OR REPLACE FUNCTION dbo.tcbFL_OPY_FACTlineorder_Orderpriority() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_FL_OPY_FACTlineorder_Orderpriority (
            FL_OPY_FL_ID int not null,
            FL_OPY_FACTlineorder_Orderpriority Char(15) not null,
            FL_OPY_Version bigint not null,
            FL_OPY_StatementType char(1) not null,
            primary key(
                FL_OPY_Version,
                FL_OPY_FL_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbFL_OPY_FACTlineorder_Orderpriority
BEFORE INSERT ON dbo.FL_OPY_FACTlineorder_Orderpriority
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbFL_OPY_FACTlineorder_Orderpriority();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciFL_OPY_FACTlineorder_Orderpriority ON dbo.FL_OPY_FACTlineorder_Orderpriority;
-- DROP FUNCTION IF EXISTS dbo.tciFL_OPY_FACTlineorder_Orderpriority();
CREATE OR REPLACE FUNCTION dbo.tciFL_OPY_FACTlineorder_Orderpriority() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_FL_OPY_FACTlineorder_Orderpriority
        SELECT
            NEW.FL_OPY_FL_ID,
            NEW.FL_OPY_FACTlineorder_Orderpriority,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciFL_OPY_FACTlineorder_Orderpriority
INSTEAD OF INSERT ON dbo.FL_OPY_FACTlineorder_Orderpriority
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciFL_OPY_FACTlineorder_Orderpriority();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaFL_OPY_FACTlineorder_Orderpriority ON dbo.FL_OPY_FACTlineorder_Orderpriority;
-- DROP FUNCTION IF EXISTS dbo.tcaFL_OPY_FACTlineorder_Orderpriority();
CREATE OR REPLACE FUNCTION dbo.tcaFL_OPY_FACTlineorder_Orderpriority() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(FL_OPY_Version) INTO maxVersion
    FROM
        _tmp_FL_OPY_FACTlineorder_Orderpriority;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_FL_OPY_FACTlineorder_Orderpriority
        SET
            FL_OPY_StatementType =
                CASE
                    WHEN OPY.FL_OPY_FL_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_FL_OPY_FACTlineorder_Orderpriority v
        LEFT JOIN
            dbo._FL_OPY_FACTlineorder_Orderpriority OPY
        ON
            OPY.FL_OPY_FL_ID = v.FL_OPY_FL_ID
        AND
            OPY.FL_OPY_FACTlineorder_Orderpriority = v.FL_OPY_FACTlineorder_Orderpriority
        WHERE
            v.FL_OPY_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._FL_OPY_FACTlineorder_Orderpriority (
            FL_OPY_FL_ID,
            FL_OPY_FACTlineorder_Orderpriority
        )
        SELECT
            FL_OPY_FL_ID,
            FL_OPY_FACTlineorder_Orderpriority
        FROM
            _tmp_FL_OPY_FACTlineorder_Orderpriority
        WHERE
            FL_OPY_Version = currentVersion
        AND
            FL_OPY_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_FL_OPY_FACTlineorder_Orderpriority;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaFL_OPY_FACTlineorder_Orderpriority
AFTER INSERT ON dbo.FL_OPY_FACTlineorder_Orderpriority
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaFL_OPY_FACTlineorder_Orderpriority();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbFL_LNB_FACTlineorder_Linenumber ON dbo.FL_LNB_FACTlineorder_Linenumber;
-- DROP FUNCTION IF EXISTS dbo.tcbFL_LNB_FACTlineorder_Linenumber();
CREATE OR REPLACE FUNCTION dbo.tcbFL_LNB_FACTlineorder_Linenumber() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_FL_LNB_FACTlineorder_Linenumber (
            FL_LNB_FL_ID int not null,
            FL_LNB_FACTlineorder_Linenumber numeric(7) not null,
            FL_LNB_Version bigint not null,
            FL_LNB_StatementType char(1) not null,
            primary key(
                FL_LNB_Version,
                FL_LNB_FL_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbFL_LNB_FACTlineorder_Linenumber
BEFORE INSERT ON dbo.FL_LNB_FACTlineorder_Linenumber
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbFL_LNB_FACTlineorder_Linenumber();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciFL_LNB_FACTlineorder_Linenumber ON dbo.FL_LNB_FACTlineorder_Linenumber;
-- DROP FUNCTION IF EXISTS dbo.tciFL_LNB_FACTlineorder_Linenumber();
CREATE OR REPLACE FUNCTION dbo.tciFL_LNB_FACTlineorder_Linenumber() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_FL_LNB_FACTlineorder_Linenumber
        SELECT
            NEW.FL_LNB_FL_ID,
            NEW.FL_LNB_FACTlineorder_Linenumber,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciFL_LNB_FACTlineorder_Linenumber
INSTEAD OF INSERT ON dbo.FL_LNB_FACTlineorder_Linenumber
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciFL_LNB_FACTlineorder_Linenumber();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaFL_LNB_FACTlineorder_Linenumber ON dbo.FL_LNB_FACTlineorder_Linenumber;
-- DROP FUNCTION IF EXISTS dbo.tcaFL_LNB_FACTlineorder_Linenumber();
CREATE OR REPLACE FUNCTION dbo.tcaFL_LNB_FACTlineorder_Linenumber() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(FL_LNB_Version) INTO maxVersion
    FROM
        _tmp_FL_LNB_FACTlineorder_Linenumber;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_FL_LNB_FACTlineorder_Linenumber
        SET
            FL_LNB_StatementType =
                CASE
                    WHEN LNB.FL_LNB_FL_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_FL_LNB_FACTlineorder_Linenumber v
        LEFT JOIN
            dbo._FL_LNB_FACTlineorder_Linenumber LNB
        ON
            LNB.FL_LNB_FL_ID = v.FL_LNB_FL_ID
        AND
            LNB.FL_LNB_FACTlineorder_Linenumber = v.FL_LNB_FACTlineorder_Linenumber
        WHERE
            v.FL_LNB_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._FL_LNB_FACTlineorder_Linenumber (
            FL_LNB_FL_ID,
            FL_LNB_FACTlineorder_Linenumber
        )
        SELECT
            FL_LNB_FL_ID,
            FL_LNB_FACTlineorder_Linenumber
        FROM
            _tmp_FL_LNB_FACTlineorder_Linenumber
        WHERE
            FL_LNB_Version = currentVersion
        AND
            FL_LNB_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_FL_LNB_FACTlineorder_Linenumber;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaFL_LNB_FACTlineorder_Linenumber
AFTER INSERT ON dbo.FL_LNB_FACTlineorder_Linenumber
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaFL_LNB_FACTlineorder_Linenumber();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbFL_TXA_FACTlineorder_Tax ON dbo.FL_TXA_FACTlineorder_Tax;
-- DROP FUNCTION IF EXISTS dbo.tcbFL_TXA_FACTlineorder_Tax();
CREATE OR REPLACE FUNCTION dbo.tcbFL_TXA_FACTlineorder_Tax() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_FL_TXA_FACTlineorder_Tax (
            FL_TXA_FL_ID int not null,
            FL_TXA_FACTlineorder_Tax numeric(8) not null,
            FL_TXA_Version bigint not null,
            FL_TXA_StatementType char(1) not null,
            primary key(
                FL_TXA_Version,
                FL_TXA_FL_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbFL_TXA_FACTlineorder_Tax
BEFORE INSERT ON dbo.FL_TXA_FACTlineorder_Tax
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbFL_TXA_FACTlineorder_Tax();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciFL_TXA_FACTlineorder_Tax ON dbo.FL_TXA_FACTlineorder_Tax;
-- DROP FUNCTION IF EXISTS dbo.tciFL_TXA_FACTlineorder_Tax();
CREATE OR REPLACE FUNCTION dbo.tciFL_TXA_FACTlineorder_Tax() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_FL_TXA_FACTlineorder_Tax
        SELECT
            NEW.FL_TXA_FL_ID,
            NEW.FL_TXA_FACTlineorder_Tax,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciFL_TXA_FACTlineorder_Tax
INSTEAD OF INSERT ON dbo.FL_TXA_FACTlineorder_Tax
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciFL_TXA_FACTlineorder_Tax();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaFL_TXA_FACTlineorder_Tax ON dbo.FL_TXA_FACTlineorder_Tax;
-- DROP FUNCTION IF EXISTS dbo.tcaFL_TXA_FACTlineorder_Tax();
CREATE OR REPLACE FUNCTION dbo.tcaFL_TXA_FACTlineorder_Tax() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(FL_TXA_Version) INTO maxVersion
    FROM
        _tmp_FL_TXA_FACTlineorder_Tax;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_FL_TXA_FACTlineorder_Tax
        SET
            FL_TXA_StatementType =
                CASE
                    WHEN TXA.FL_TXA_FL_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_FL_TXA_FACTlineorder_Tax v
        LEFT JOIN
            dbo._FL_TXA_FACTlineorder_Tax TXA
        ON
            TXA.FL_TXA_FL_ID = v.FL_TXA_FL_ID
        AND
            TXA.FL_TXA_FACTlineorder_Tax = v.FL_TXA_FACTlineorder_Tax
        WHERE
            v.FL_TXA_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._FL_TXA_FACTlineorder_Tax (
            FL_TXA_FL_ID,
            FL_TXA_FACTlineorder_Tax
        )
        SELECT
            FL_TXA_FL_ID,
            FL_TXA_FACTlineorder_Tax
        FROM
            _tmp_FL_TXA_FACTlineorder_Tax
        WHERE
            FL_TXA_Version = currentVersion
        AND
            FL_TXA_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_FL_TXA_FACTlineorder_Tax;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaFL_TXA_FACTlineorder_Tax
AFTER INSERT ON dbo.FL_TXA_FACTlineorder_Tax
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaFL_TXA_FACTlineorder_Tax();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbFL_QTY_FACTlineorder_Quantity ON dbo.FL_QTY_FACTlineorder_Quantity;
-- DROP FUNCTION IF EXISTS dbo.tcbFL_QTY_FACTlineorder_Quantity();
CREATE OR REPLACE FUNCTION dbo.tcbFL_QTY_FACTlineorder_Quantity() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_FL_QTY_FACTlineorder_Quantity (
            FL_QTY_FL_ID int not null,
            FL_QTY_FACTlineorder_Quantity Numeric(50) not null,
            FL_QTY_Version bigint not null,
            FL_QTY_StatementType char(1) not null,
            primary key(
                FL_QTY_Version,
                FL_QTY_FL_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbFL_QTY_FACTlineorder_Quantity
BEFORE INSERT ON dbo.FL_QTY_FACTlineorder_Quantity
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbFL_QTY_FACTlineorder_Quantity();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciFL_QTY_FACTlineorder_Quantity ON dbo.FL_QTY_FACTlineorder_Quantity;
-- DROP FUNCTION IF EXISTS dbo.tciFL_QTY_FACTlineorder_Quantity();
CREATE OR REPLACE FUNCTION dbo.tciFL_QTY_FACTlineorder_Quantity() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_FL_QTY_FACTlineorder_Quantity
        SELECT
            NEW.FL_QTY_FL_ID,
            NEW.FL_QTY_FACTlineorder_Quantity,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciFL_QTY_FACTlineorder_Quantity
INSTEAD OF INSERT ON dbo.FL_QTY_FACTlineorder_Quantity
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciFL_QTY_FACTlineorder_Quantity();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaFL_QTY_FACTlineorder_Quantity ON dbo.FL_QTY_FACTlineorder_Quantity;
-- DROP FUNCTION IF EXISTS dbo.tcaFL_QTY_FACTlineorder_Quantity();
CREATE OR REPLACE FUNCTION dbo.tcaFL_QTY_FACTlineorder_Quantity() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(FL_QTY_Version) INTO maxVersion
    FROM
        _tmp_FL_QTY_FACTlineorder_Quantity;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_FL_QTY_FACTlineorder_Quantity
        SET
            FL_QTY_StatementType =
                CASE
                    WHEN QTY.FL_QTY_FL_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_FL_QTY_FACTlineorder_Quantity v
        LEFT JOIN
            dbo._FL_QTY_FACTlineorder_Quantity QTY
        ON
            QTY.FL_QTY_FL_ID = v.FL_QTY_FL_ID
        AND
            QTY.FL_QTY_FACTlineorder_Quantity = v.FL_QTY_FACTlineorder_Quantity
        WHERE
            v.FL_QTY_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._FL_QTY_FACTlineorder_Quantity (
            FL_QTY_FL_ID,
            FL_QTY_FACTlineorder_Quantity
        )
        SELECT
            FL_QTY_FL_ID,
            FL_QTY_FACTlineorder_Quantity
        FROM
            _tmp_FL_QTY_FACTlineorder_Quantity
        WHERE
            FL_QTY_Version = currentVersion
        AND
            FL_QTY_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_FL_QTY_FACTlineorder_Quantity;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaFL_QTY_FACTlineorder_Quantity
AFTER INSERT ON dbo.FL_QTY_FACTlineorder_Quantity
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaFL_QTY_FACTlineorder_Quantity();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbFL_EPR_FACTlineorder_Extendedprice ON dbo.FL_EPR_FACTlineorder_Extendedprice;
-- DROP FUNCTION IF EXISTS dbo.tcbFL_EPR_FACTlineorder_Extendedprice();
CREATE OR REPLACE FUNCTION dbo.tcbFL_EPR_FACTlineorder_Extendedprice() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_FL_EPR_FACTlineorder_Extendedprice (
            FL_EPR_FL_ID int not null,
            FL_EPR_FACTlineorder_Extendedprice numeric(200) not null,
            FL_EPR_Version bigint not null,
            FL_EPR_StatementType char(1) not null,
            primary key(
                FL_EPR_Version,
                FL_EPR_FL_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbFL_EPR_FACTlineorder_Extendedprice
BEFORE INSERT ON dbo.FL_EPR_FACTlineorder_Extendedprice
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbFL_EPR_FACTlineorder_Extendedprice();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciFL_EPR_FACTlineorder_Extendedprice ON dbo.FL_EPR_FACTlineorder_Extendedprice;
-- DROP FUNCTION IF EXISTS dbo.tciFL_EPR_FACTlineorder_Extendedprice();
CREATE OR REPLACE FUNCTION dbo.tciFL_EPR_FACTlineorder_Extendedprice() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_FL_EPR_FACTlineorder_Extendedprice
        SELECT
            NEW.FL_EPR_FL_ID,
            NEW.FL_EPR_FACTlineorder_Extendedprice,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciFL_EPR_FACTlineorder_Extendedprice
INSTEAD OF INSERT ON dbo.FL_EPR_FACTlineorder_Extendedprice
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciFL_EPR_FACTlineorder_Extendedprice();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaFL_EPR_FACTlineorder_Extendedprice ON dbo.FL_EPR_FACTlineorder_Extendedprice;
-- DROP FUNCTION IF EXISTS dbo.tcaFL_EPR_FACTlineorder_Extendedprice();
CREATE OR REPLACE FUNCTION dbo.tcaFL_EPR_FACTlineorder_Extendedprice() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(FL_EPR_Version) INTO maxVersion
    FROM
        _tmp_FL_EPR_FACTlineorder_Extendedprice;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_FL_EPR_FACTlineorder_Extendedprice
        SET
            FL_EPR_StatementType =
                CASE
                    WHEN EPR.FL_EPR_FL_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_FL_EPR_FACTlineorder_Extendedprice v
        LEFT JOIN
            dbo._FL_EPR_FACTlineorder_Extendedprice EPR
        ON
            EPR.FL_EPR_FL_ID = v.FL_EPR_FL_ID
        AND
            EPR.FL_EPR_FACTlineorder_Extendedprice = v.FL_EPR_FACTlineorder_Extendedprice
        WHERE
            v.FL_EPR_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._FL_EPR_FACTlineorder_Extendedprice (
            FL_EPR_FL_ID,
            FL_EPR_FACTlineorder_Extendedprice
        )
        SELECT
            FL_EPR_FL_ID,
            FL_EPR_FACTlineorder_Extendedprice
        FROM
            _tmp_FL_EPR_FACTlineorder_Extendedprice
        WHERE
            FL_EPR_Version = currentVersion
        AND
            FL_EPR_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_FL_EPR_FACTlineorder_Extendedprice;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaFL_EPR_FACTlineorder_Extendedprice
AFTER INSERT ON dbo.FL_EPR_FACTlineorder_Extendedprice
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaFL_EPR_FACTlineorder_Extendedprice();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbFL_OTP_FACTlineorder_Ordtotalprice ON dbo.FL_OTP_FACTlineorder_Ordtotalprice;
-- DROP FUNCTION IF EXISTS dbo.tcbFL_OTP_FACTlineorder_Ordtotalprice();
CREATE OR REPLACE FUNCTION dbo.tcbFL_OTP_FACTlineorder_Ordtotalprice() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_FL_OTP_FACTlineorder_Ordtotalprice (
            FL_OTP_FL_ID int not null,
            FL_OTP_FACTlineorder_Ordtotalprice Numeric(200) not null,
            FL_OTP_Version bigint not null,
            FL_OTP_StatementType char(1) not null,
            primary key(
                FL_OTP_Version,
                FL_OTP_FL_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbFL_OTP_FACTlineorder_Ordtotalprice
BEFORE INSERT ON dbo.FL_OTP_FACTlineorder_Ordtotalprice
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbFL_OTP_FACTlineorder_Ordtotalprice();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciFL_OTP_FACTlineorder_Ordtotalprice ON dbo.FL_OTP_FACTlineorder_Ordtotalprice;
-- DROP FUNCTION IF EXISTS dbo.tciFL_OTP_FACTlineorder_Ordtotalprice();
CREATE OR REPLACE FUNCTION dbo.tciFL_OTP_FACTlineorder_Ordtotalprice() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_FL_OTP_FACTlineorder_Ordtotalprice
        SELECT
            NEW.FL_OTP_FL_ID,
            NEW.FL_OTP_FACTlineorder_Ordtotalprice,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciFL_OTP_FACTlineorder_Ordtotalprice
INSTEAD OF INSERT ON dbo.FL_OTP_FACTlineorder_Ordtotalprice
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciFL_OTP_FACTlineorder_Ordtotalprice();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaFL_OTP_FACTlineorder_Ordtotalprice ON dbo.FL_OTP_FACTlineorder_Ordtotalprice;
-- DROP FUNCTION IF EXISTS dbo.tcaFL_OTP_FACTlineorder_Ordtotalprice();
CREATE OR REPLACE FUNCTION dbo.tcaFL_OTP_FACTlineorder_Ordtotalprice() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(FL_OTP_Version) INTO maxVersion
    FROM
        _tmp_FL_OTP_FACTlineorder_Ordtotalprice;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_FL_OTP_FACTlineorder_Ordtotalprice
        SET
            FL_OTP_StatementType =
                CASE
                    WHEN OTP.FL_OTP_FL_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_FL_OTP_FACTlineorder_Ordtotalprice v
        LEFT JOIN
            dbo._FL_OTP_FACTlineorder_Ordtotalprice OTP
        ON
            OTP.FL_OTP_FL_ID = v.FL_OTP_FL_ID
        AND
            OTP.FL_OTP_FACTlineorder_Ordtotalprice = v.FL_OTP_FACTlineorder_Ordtotalprice
        WHERE
            v.FL_OTP_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._FL_OTP_FACTlineorder_Ordtotalprice (
            FL_OTP_FL_ID,
            FL_OTP_FACTlineorder_Ordtotalprice
        )
        SELECT
            FL_OTP_FL_ID,
            FL_OTP_FACTlineorder_Ordtotalprice
        FROM
            _tmp_FL_OTP_FACTlineorder_Ordtotalprice
        WHERE
            FL_OTP_Version = currentVersion
        AND
            FL_OTP_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_FL_OTP_FACTlineorder_Ordtotalprice;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaFL_OTP_FACTlineorder_Ordtotalprice
AFTER INSERT ON dbo.FL_OTP_FACTlineorder_Ordtotalprice
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaFL_OTP_FACTlineorder_Ordtotalprice();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbFL_DSC_FACTlineorder_Discount ON dbo.FL_DSC_FACTlineorder_Discount;
-- DROP FUNCTION IF EXISTS dbo.tcbFL_DSC_FACTlineorder_Discount();
CREATE OR REPLACE FUNCTION dbo.tcbFL_DSC_FACTlineorder_Discount() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_FL_DSC_FACTlineorder_Discount (
            FL_DSC_FL_ID int not null,
            FL_DSC_FACTlineorder_Discount Numeric(10) not null,
            FL_DSC_Version bigint not null,
            FL_DSC_StatementType char(1) not null,
            primary key(
                FL_DSC_Version,
                FL_DSC_FL_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbFL_DSC_FACTlineorder_Discount
BEFORE INSERT ON dbo.FL_DSC_FACTlineorder_Discount
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbFL_DSC_FACTlineorder_Discount();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciFL_DSC_FACTlineorder_Discount ON dbo.FL_DSC_FACTlineorder_Discount;
-- DROP FUNCTION IF EXISTS dbo.tciFL_DSC_FACTlineorder_Discount();
CREATE OR REPLACE FUNCTION dbo.tciFL_DSC_FACTlineorder_Discount() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_FL_DSC_FACTlineorder_Discount
        SELECT
            NEW.FL_DSC_FL_ID,
            NEW.FL_DSC_FACTlineorder_Discount,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciFL_DSC_FACTlineorder_Discount
INSTEAD OF INSERT ON dbo.FL_DSC_FACTlineorder_Discount
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciFL_DSC_FACTlineorder_Discount();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaFL_DSC_FACTlineorder_Discount ON dbo.FL_DSC_FACTlineorder_Discount;
-- DROP FUNCTION IF EXISTS dbo.tcaFL_DSC_FACTlineorder_Discount();
CREATE OR REPLACE FUNCTION dbo.tcaFL_DSC_FACTlineorder_Discount() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(FL_DSC_Version) INTO maxVersion
    FROM
        _tmp_FL_DSC_FACTlineorder_Discount;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_FL_DSC_FACTlineorder_Discount
        SET
            FL_DSC_StatementType =
                CASE
                    WHEN DSC.FL_DSC_FL_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_FL_DSC_FACTlineorder_Discount v
        LEFT JOIN
            dbo._FL_DSC_FACTlineorder_Discount DSC
        ON
            DSC.FL_DSC_FL_ID = v.FL_DSC_FL_ID
        AND
            DSC.FL_DSC_FACTlineorder_Discount = v.FL_DSC_FACTlineorder_Discount
        WHERE
            v.FL_DSC_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._FL_DSC_FACTlineorder_Discount (
            FL_DSC_FL_ID,
            FL_DSC_FACTlineorder_Discount
        )
        SELECT
            FL_DSC_FL_ID,
            FL_DSC_FACTlineorder_Discount
        FROM
            _tmp_FL_DSC_FACTlineorder_Discount
        WHERE
            FL_DSC_Version = currentVersion
        AND
            FL_DSC_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_FL_DSC_FACTlineorder_Discount;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaFL_DSC_FACTlineorder_Discount
AFTER INSERT ON dbo.FL_DSC_FACTlineorder_Discount
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaFL_DSC_FACTlineorder_Discount();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbFL_SCT_FACTlineorder_Supplycost ON dbo.FL_SCT_FACTlineorder_Supplycost;
-- DROP FUNCTION IF EXISTS dbo.tcbFL_SCT_FACTlineorder_Supplycost();
CREATE OR REPLACE FUNCTION dbo.tcbFL_SCT_FACTlineorder_Supplycost() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_FL_SCT_FACTlineorder_Supplycost (
            FL_SCT_FL_ID int not null,
            FL_SCT_FACTlineorder_Supplycost Numeric(200) not null,
            FL_SCT_Version bigint not null,
            FL_SCT_StatementType char(1) not null,
            primary key(
                FL_SCT_Version,
                FL_SCT_FL_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbFL_SCT_FACTlineorder_Supplycost
BEFORE INSERT ON dbo.FL_SCT_FACTlineorder_Supplycost
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbFL_SCT_FACTlineorder_Supplycost();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciFL_SCT_FACTlineorder_Supplycost ON dbo.FL_SCT_FACTlineorder_Supplycost;
-- DROP FUNCTION IF EXISTS dbo.tciFL_SCT_FACTlineorder_Supplycost();
CREATE OR REPLACE FUNCTION dbo.tciFL_SCT_FACTlineorder_Supplycost() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_FL_SCT_FACTlineorder_Supplycost
        SELECT
            NEW.FL_SCT_FL_ID,
            NEW.FL_SCT_FACTlineorder_Supplycost,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciFL_SCT_FACTlineorder_Supplycost
INSTEAD OF INSERT ON dbo.FL_SCT_FACTlineorder_Supplycost
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciFL_SCT_FACTlineorder_Supplycost();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaFL_SCT_FACTlineorder_Supplycost ON dbo.FL_SCT_FACTlineorder_Supplycost;
-- DROP FUNCTION IF EXISTS dbo.tcaFL_SCT_FACTlineorder_Supplycost();
CREATE OR REPLACE FUNCTION dbo.tcaFL_SCT_FACTlineorder_Supplycost() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(FL_SCT_Version) INTO maxVersion
    FROM
        _tmp_FL_SCT_FACTlineorder_Supplycost;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_FL_SCT_FACTlineorder_Supplycost
        SET
            FL_SCT_StatementType =
                CASE
                    WHEN SCT.FL_SCT_FL_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_FL_SCT_FACTlineorder_Supplycost v
        LEFT JOIN
            dbo._FL_SCT_FACTlineorder_Supplycost SCT
        ON
            SCT.FL_SCT_FL_ID = v.FL_SCT_FL_ID
        AND
            SCT.FL_SCT_FACTlineorder_Supplycost = v.FL_SCT_FACTlineorder_Supplycost
        WHERE
            v.FL_SCT_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._FL_SCT_FACTlineorder_Supplycost (
            FL_SCT_FL_ID,
            FL_SCT_FACTlineorder_Supplycost
        )
        SELECT
            FL_SCT_FL_ID,
            FL_SCT_FACTlineorder_Supplycost
        FROM
            _tmp_FL_SCT_FACTlineorder_Supplycost
        WHERE
            FL_SCT_Version = currentVersion
        AND
            FL_SCT_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_FL_SCT_FACTlineorder_Supplycost;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaFL_SCT_FACTlineorder_Supplycost
AFTER INSERT ON dbo.FL_SCT_FACTlineorder_Supplycost
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaFL_SCT_FACTlineorder_Supplycost();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbFL_SHM_FACTlineorder_Shipmode ON dbo.FL_SHM_FACTlineorder_Shipmode;
-- DROP FUNCTION IF EXISTS dbo.tcbFL_SHM_FACTlineorder_Shipmode();
CREATE OR REPLACE FUNCTION dbo.tcbFL_SHM_FACTlineorder_Shipmode() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_FL_SHM_FACTlineorder_Shipmode (
            FL_SHM_FL_ID int not null,
            FL_SHM_FACTlineorder_Shipmode char(10) not null,
            FL_SHM_Version bigint not null,
            FL_SHM_StatementType char(1) not null,
            primary key(
                FL_SHM_Version,
                FL_SHM_FL_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbFL_SHM_FACTlineorder_Shipmode
BEFORE INSERT ON dbo.FL_SHM_FACTlineorder_Shipmode
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbFL_SHM_FACTlineorder_Shipmode();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciFL_SHM_FACTlineorder_Shipmode ON dbo.FL_SHM_FACTlineorder_Shipmode;
-- DROP FUNCTION IF EXISTS dbo.tciFL_SHM_FACTlineorder_Shipmode();
CREATE OR REPLACE FUNCTION dbo.tciFL_SHM_FACTlineorder_Shipmode() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_FL_SHM_FACTlineorder_Shipmode
        SELECT
            NEW.FL_SHM_FL_ID,
            NEW.FL_SHM_FACTlineorder_Shipmode,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciFL_SHM_FACTlineorder_Shipmode
INSTEAD OF INSERT ON dbo.FL_SHM_FACTlineorder_Shipmode
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciFL_SHM_FACTlineorder_Shipmode();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaFL_SHM_FACTlineorder_Shipmode ON dbo.FL_SHM_FACTlineorder_Shipmode;
-- DROP FUNCTION IF EXISTS dbo.tcaFL_SHM_FACTlineorder_Shipmode();
CREATE OR REPLACE FUNCTION dbo.tcaFL_SHM_FACTlineorder_Shipmode() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(FL_SHM_Version) INTO maxVersion
    FROM
        _tmp_FL_SHM_FACTlineorder_Shipmode;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_FL_SHM_FACTlineorder_Shipmode
        SET
            FL_SHM_StatementType =
                CASE
                    WHEN SHM.FL_SHM_FL_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_FL_SHM_FACTlineorder_Shipmode v
        LEFT JOIN
            dbo._FL_SHM_FACTlineorder_Shipmode SHM
        ON
            SHM.FL_SHM_FL_ID = v.FL_SHM_FL_ID
        AND
            SHM.FL_SHM_FACTlineorder_Shipmode = v.FL_SHM_FACTlineorder_Shipmode
        WHERE
            v.FL_SHM_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._FL_SHM_FACTlineorder_Shipmode (
            FL_SHM_FL_ID,
            FL_SHM_FACTlineorder_Shipmode
        )
        SELECT
            FL_SHM_FL_ID,
            FL_SHM_FACTlineorder_Shipmode
        FROM
            _tmp_FL_SHM_FACTlineorder_Shipmode
        WHERE
            FL_SHM_Version = currentVersion
        AND
            FL_SHM_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_FL_SHM_FACTlineorder_Shipmode;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaFL_SHM_FACTlineorder_Shipmode
AFTER INSERT ON dbo.FL_SHM_FACTlineorder_Shipmode
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaFL_SHM_FACTlineorder_Shipmode();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbFL_RVN_FACTlineorder_Revenue ON dbo.FL_RVN_FACTlineorder_Revenue;
-- DROP FUNCTION IF EXISTS dbo.tcbFL_RVN_FACTlineorder_Revenue();
CREATE OR REPLACE FUNCTION dbo.tcbFL_RVN_FACTlineorder_Revenue() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_FL_RVN_FACTlineorder_Revenue (
            FL_RVN_FL_ID int not null,
            FL_RVN_FACTlineorder_Revenue numeric not null,
            FL_RVN_Version bigint not null,
            FL_RVN_StatementType char(1) not null,
            primary key(
                FL_RVN_Version,
                FL_RVN_FL_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbFL_RVN_FACTlineorder_Revenue
BEFORE INSERT ON dbo.FL_RVN_FACTlineorder_Revenue
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbFL_RVN_FACTlineorder_Revenue();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciFL_RVN_FACTlineorder_Revenue ON dbo.FL_RVN_FACTlineorder_Revenue;
-- DROP FUNCTION IF EXISTS dbo.tciFL_RVN_FACTlineorder_Revenue();
CREATE OR REPLACE FUNCTION dbo.tciFL_RVN_FACTlineorder_Revenue() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_FL_RVN_FACTlineorder_Revenue
        SELECT
            NEW.FL_RVN_FL_ID,
            NEW.FL_RVN_FACTlineorder_Revenue,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciFL_RVN_FACTlineorder_Revenue
INSTEAD OF INSERT ON dbo.FL_RVN_FACTlineorder_Revenue
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciFL_RVN_FACTlineorder_Revenue();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaFL_RVN_FACTlineorder_Revenue ON dbo.FL_RVN_FACTlineorder_Revenue;
-- DROP FUNCTION IF EXISTS dbo.tcaFL_RVN_FACTlineorder_Revenue();
CREATE OR REPLACE FUNCTION dbo.tcaFL_RVN_FACTlineorder_Revenue() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(FL_RVN_Version) INTO maxVersion
    FROM
        _tmp_FL_RVN_FACTlineorder_Revenue;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_FL_RVN_FACTlineorder_Revenue
        SET
            FL_RVN_StatementType =
                CASE
                    WHEN RVN.FL_RVN_FL_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_FL_RVN_FACTlineorder_Revenue v
        LEFT JOIN
            dbo._FL_RVN_FACTlineorder_Revenue RVN
        ON
            RVN.FL_RVN_FL_ID = v.FL_RVN_FL_ID
        AND
            RVN.FL_RVN_FACTlineorder_Revenue = v.FL_RVN_FACTlineorder_Revenue
        WHERE
            v.FL_RVN_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._FL_RVN_FACTlineorder_Revenue (
            FL_RVN_FL_ID,
            FL_RVN_FACTlineorder_Revenue
        )
        SELECT
            FL_RVN_FL_ID,
            FL_RVN_FACTlineorder_Revenue
        FROM
            _tmp_FL_RVN_FACTlineorder_Revenue
        WHERE
            FL_RVN_Version = currentVersion
        AND
            FL_RVN_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_FL_RVN_FACTlineorder_Revenue;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaFL_RVN_FACTlineorder_Revenue
AFTER INSERT ON dbo.FL_RVN_FACTlineorder_Revenue
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaFL_RVN_FACTlineorder_Revenue();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_DNM_Dimdate2_Daynuminmonth ON dbo.DA_DNM_Dimdate2_Daynuminmonth;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_DNM_Dimdate2_Daynuminmonth();
CREATE OR REPLACE FUNCTION dbo.tcbDA_DNM_Dimdate2_Daynuminmonth() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_DNM_Dimdate2_Daynuminmonth (
            DA_DNM_DA_ID int not null,
            DA_DNM_Dimdate2_Daynuminmonth integer not null,
            DA_DNM_Version bigint not null,
            DA_DNM_StatementType char(1) not null,
            primary key(
                DA_DNM_Version,
                DA_DNM_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_DNM_Dimdate2_Daynuminmonth
BEFORE INSERT ON dbo.DA_DNM_Dimdate2_Daynuminmonth
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_DNM_Dimdate2_Daynuminmonth();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_DNM_Dimdate2_Daynuminmonth ON dbo.DA_DNM_Dimdate2_Daynuminmonth;
-- DROP FUNCTION IF EXISTS dbo.tciDA_DNM_Dimdate2_Daynuminmonth();
CREATE OR REPLACE FUNCTION dbo.tciDA_DNM_Dimdate2_Daynuminmonth() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_DNM_Dimdate2_Daynuminmonth
        SELECT
            NEW.DA_DNM_DA_ID,
            NEW.DA_DNM_Dimdate2_Daynuminmonth,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_DNM_Dimdate2_Daynuminmonth
INSTEAD OF INSERT ON dbo.DA_DNM_Dimdate2_Daynuminmonth
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_DNM_Dimdate2_Daynuminmonth();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_DNM_Dimdate2_Daynuminmonth ON dbo.DA_DNM_Dimdate2_Daynuminmonth;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_DNM_Dimdate2_Daynuminmonth();
CREATE OR REPLACE FUNCTION dbo.tcaDA_DNM_Dimdate2_Daynuminmonth() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_DNM_Version) INTO maxVersion
    FROM
        _tmp_DA_DNM_Dimdate2_Daynuminmonth;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_DNM_Dimdate2_Daynuminmonth
        SET
            DA_DNM_StatementType =
                CASE
                    WHEN DNM.DA_DNM_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_DNM_Dimdate2_Daynuminmonth v
        LEFT JOIN
            dbo._DA_DNM_Dimdate2_Daynuminmonth DNM
        ON
            DNM.DA_DNM_DA_ID = v.DA_DNM_DA_ID
        AND
            DNM.DA_DNM_Dimdate2_Daynuminmonth = v.DA_DNM_Dimdate2_Daynuminmonth
        WHERE
            v.DA_DNM_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_DNM_Dimdate2_Daynuminmonth (
            DA_DNM_DA_ID,
            DA_DNM_Dimdate2_Daynuminmonth
        )
        SELECT
            DA_DNM_DA_ID,
            DA_DNM_Dimdate2_Daynuminmonth
        FROM
            _tmp_DA_DNM_Dimdate2_Daynuminmonth
        WHERE
            DA_DNM_Version = currentVersion
        AND
            DA_DNM_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_DNM_Dimdate2_Daynuminmonth;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_DNM_Dimdate2_Daynuminmonth
AFTER INSERT ON dbo.DA_DNM_Dimdate2_Daynuminmonth
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_DNM_Dimdate2_Daynuminmonth();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_WNY_Dimdate2_Weeknuminyear ON dbo.DA_WNY_Dimdate2_Weeknuminyear;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_WNY_Dimdate2_Weeknuminyear();
CREATE OR REPLACE FUNCTION dbo.tcbDA_WNY_Dimdate2_Weeknuminyear() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_WNY_Dimdate2_Weeknuminyear (
            DA_WNY_DA_ID int not null,
            DA_WNY_Dimdate2_Weeknuminyear integer not null,
            DA_WNY_Version bigint not null,
            DA_WNY_StatementType char(1) not null,
            primary key(
                DA_WNY_Version,
                DA_WNY_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_WNY_Dimdate2_Weeknuminyear
BEFORE INSERT ON dbo.DA_WNY_Dimdate2_Weeknuminyear
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_WNY_Dimdate2_Weeknuminyear();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_WNY_Dimdate2_Weeknuminyear ON dbo.DA_WNY_Dimdate2_Weeknuminyear;
-- DROP FUNCTION IF EXISTS dbo.tciDA_WNY_Dimdate2_Weeknuminyear();
CREATE OR REPLACE FUNCTION dbo.tciDA_WNY_Dimdate2_Weeknuminyear() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_WNY_Dimdate2_Weeknuminyear
        SELECT
            NEW.DA_WNY_DA_ID,
            NEW.DA_WNY_Dimdate2_Weeknuminyear,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_WNY_Dimdate2_Weeknuminyear
INSTEAD OF INSERT ON dbo.DA_WNY_Dimdate2_Weeknuminyear
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_WNY_Dimdate2_Weeknuminyear();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_WNY_Dimdate2_Weeknuminyear ON dbo.DA_WNY_Dimdate2_Weeknuminyear;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_WNY_Dimdate2_Weeknuminyear();
CREATE OR REPLACE FUNCTION dbo.tcaDA_WNY_Dimdate2_Weeknuminyear() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_WNY_Version) INTO maxVersion
    FROM
        _tmp_DA_WNY_Dimdate2_Weeknuminyear;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_WNY_Dimdate2_Weeknuminyear
        SET
            DA_WNY_StatementType =
                CASE
                    WHEN WNY.DA_WNY_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_WNY_Dimdate2_Weeknuminyear v
        LEFT JOIN
            dbo._DA_WNY_Dimdate2_Weeknuminyear WNY
        ON
            WNY.DA_WNY_DA_ID = v.DA_WNY_DA_ID
        AND
            WNY.DA_WNY_Dimdate2_Weeknuminyear = v.DA_WNY_Dimdate2_Weeknuminyear
        WHERE
            v.DA_WNY_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_WNY_Dimdate2_Weeknuminyear (
            DA_WNY_DA_ID,
            DA_WNY_Dimdate2_Weeknuminyear
        )
        SELECT
            DA_WNY_DA_ID,
            DA_WNY_Dimdate2_Weeknuminyear
        FROM
            _tmp_DA_WNY_Dimdate2_Weeknuminyear
        WHERE
            DA_WNY_Version = currentVersion
        AND
            DA_WNY_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_WNY_Dimdate2_Weeknuminyear;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_WNY_Dimdate2_Weeknuminyear
AFTER INSERT ON dbo.DA_WNY_Dimdate2_Weeknuminyear
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_WNY_Dimdate2_Weeknuminyear();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_SSS_Dimdate2_Sellingseasons ON dbo.DA_SSS_Dimdate2_Sellingseasons;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_SSS_Dimdate2_Sellingseasons();
CREATE OR REPLACE FUNCTION dbo.tcbDA_SSS_Dimdate2_Sellingseasons() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_SSS_Dimdate2_Sellingseasons (
            DA_SSS_DA_ID int not null,
            DA_SSS_Dimdate2_Sellingseasons text not null,
            DA_SSS_Version bigint not null,
            DA_SSS_StatementType char(1) not null,
            primary key(
                DA_SSS_Version,
                DA_SSS_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_SSS_Dimdate2_Sellingseasons
BEFORE INSERT ON dbo.DA_SSS_Dimdate2_Sellingseasons
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_SSS_Dimdate2_Sellingseasons();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_SSS_Dimdate2_Sellingseasons ON dbo.DA_SSS_Dimdate2_Sellingseasons;
-- DROP FUNCTION IF EXISTS dbo.tciDA_SSS_Dimdate2_Sellingseasons();
CREATE OR REPLACE FUNCTION dbo.tciDA_SSS_Dimdate2_Sellingseasons() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_SSS_Dimdate2_Sellingseasons
        SELECT
            NEW.DA_SSS_DA_ID,
            NEW.DA_SSS_Dimdate2_Sellingseasons,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_SSS_Dimdate2_Sellingseasons
INSTEAD OF INSERT ON dbo.DA_SSS_Dimdate2_Sellingseasons
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_SSS_Dimdate2_Sellingseasons();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_SSS_Dimdate2_Sellingseasons ON dbo.DA_SSS_Dimdate2_Sellingseasons;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_SSS_Dimdate2_Sellingseasons();
CREATE OR REPLACE FUNCTION dbo.tcaDA_SSS_Dimdate2_Sellingseasons() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_SSS_Version) INTO maxVersion
    FROM
        _tmp_DA_SSS_Dimdate2_Sellingseasons;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_SSS_Dimdate2_Sellingseasons
        SET
            DA_SSS_StatementType =
                CASE
                    WHEN SSS.DA_SSS_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_SSS_Dimdate2_Sellingseasons v
        LEFT JOIN
            dbo._DA_SSS_Dimdate2_Sellingseasons SSS
        ON
            SSS.DA_SSS_DA_ID = v.DA_SSS_DA_ID
        AND
            SSS.DA_SSS_Dimdate2_Sellingseasons = v.DA_SSS_Dimdate2_Sellingseasons
        WHERE
            v.DA_SSS_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_SSS_Dimdate2_Sellingseasons (
            DA_SSS_DA_ID,
            DA_SSS_Dimdate2_Sellingseasons
        )
        SELECT
            DA_SSS_DA_ID,
            DA_SSS_Dimdate2_Sellingseasons
        FROM
            _tmp_DA_SSS_Dimdate2_Sellingseasons
        WHERE
            DA_SSS_Version = currentVersion
        AND
            DA_SSS_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_SSS_Dimdate2_Sellingseasons;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_SSS_Dimdate2_Sellingseasons
AFTER INSERT ON dbo.DA_SSS_Dimdate2_Sellingseasons
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_SSS_Dimdate2_Sellingseasons();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_LDF_Dimdate2_Lastdayinweekfl ON dbo.DA_LDF_Dimdate2_Lastdayinweekfl;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_LDF_Dimdate2_Lastdayinweekfl();
CREATE OR REPLACE FUNCTION dbo.tcbDA_LDF_Dimdate2_Lastdayinweekfl() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_LDF_Dimdate2_Lastdayinweekfl (
            DA_LDF_DA_ID int not null,
            DA_LDF_Dimdate2_Lastdayinweekfl char(1) not null,
            DA_LDF_Version bigint not null,
            DA_LDF_StatementType char(1) not null,
            primary key(
                DA_LDF_Version,
                DA_LDF_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_LDF_Dimdate2_Lastdayinweekfl
BEFORE INSERT ON dbo.DA_LDF_Dimdate2_Lastdayinweekfl
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_LDF_Dimdate2_Lastdayinweekfl();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_LDF_Dimdate2_Lastdayinweekfl ON dbo.DA_LDF_Dimdate2_Lastdayinweekfl;
-- DROP FUNCTION IF EXISTS dbo.tciDA_LDF_Dimdate2_Lastdayinweekfl();
CREATE OR REPLACE FUNCTION dbo.tciDA_LDF_Dimdate2_Lastdayinweekfl() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_LDF_Dimdate2_Lastdayinweekfl
        SELECT
            NEW.DA_LDF_DA_ID,
            NEW.DA_LDF_Dimdate2_Lastdayinweekfl,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_LDF_Dimdate2_Lastdayinweekfl
INSTEAD OF INSERT ON dbo.DA_LDF_Dimdate2_Lastdayinweekfl
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_LDF_Dimdate2_Lastdayinweekfl();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_LDF_Dimdate2_Lastdayinweekfl ON dbo.DA_LDF_Dimdate2_Lastdayinweekfl;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_LDF_Dimdate2_Lastdayinweekfl();
CREATE OR REPLACE FUNCTION dbo.tcaDA_LDF_Dimdate2_Lastdayinweekfl() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_LDF_Version) INTO maxVersion
    FROM
        _tmp_DA_LDF_Dimdate2_Lastdayinweekfl;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_LDF_Dimdate2_Lastdayinweekfl
        SET
            DA_LDF_StatementType =
                CASE
                    WHEN LDF.DA_LDF_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_LDF_Dimdate2_Lastdayinweekfl v
        LEFT JOIN
            dbo._DA_LDF_Dimdate2_Lastdayinweekfl LDF
        ON
            LDF.DA_LDF_DA_ID = v.DA_LDF_DA_ID
        AND
            LDF.DA_LDF_Dimdate2_Lastdayinweekfl = v.DA_LDF_Dimdate2_Lastdayinweekfl
        WHERE
            v.DA_LDF_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_LDF_Dimdate2_Lastdayinweekfl (
            DA_LDF_DA_ID,
            DA_LDF_Dimdate2_Lastdayinweekfl
        )
        SELECT
            DA_LDF_DA_ID,
            DA_LDF_Dimdate2_Lastdayinweekfl
        FROM
            _tmp_DA_LDF_Dimdate2_Lastdayinweekfl
        WHERE
            DA_LDF_Version = currentVersion
        AND
            DA_LDF_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_LDF_Dimdate2_Lastdayinweekfl;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_LDF_Dimdate2_Lastdayinweekfl
AFTER INSERT ON dbo.DA_LDF_Dimdate2_Lastdayinweekfl
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_LDF_Dimdate2_Lastdayinweekfl();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_DAT_Dimdate2_Date ON dbo.DA_DAT_Dimdate2_Date;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_DAT_Dimdate2_Date();
CREATE OR REPLACE FUNCTION dbo.tcbDA_DAT_Dimdate2_Date() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_DAT_Dimdate2_Date (
            DA_DAT_DA_ID int not null,
            DA_DAT_Dimdate2_Date varchar(18) not null,
            DA_DAT_Version bigint not null,
            DA_DAT_StatementType char(1) not null,
            primary key(
                DA_DAT_Version,
                DA_DAT_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_DAT_Dimdate2_Date
BEFORE INSERT ON dbo.DA_DAT_Dimdate2_Date
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_DAT_Dimdate2_Date();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_DAT_Dimdate2_Date ON dbo.DA_DAT_Dimdate2_Date;
-- DROP FUNCTION IF EXISTS dbo.tciDA_DAT_Dimdate2_Date();
CREATE OR REPLACE FUNCTION dbo.tciDA_DAT_Dimdate2_Date() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_DAT_Dimdate2_Date
        SELECT
            NEW.DA_DAT_DA_ID,
            NEW.DA_DAT_Dimdate2_Date,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_DAT_Dimdate2_Date
INSTEAD OF INSERT ON dbo.DA_DAT_Dimdate2_Date
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_DAT_Dimdate2_Date();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_DAT_Dimdate2_Date ON dbo.DA_DAT_Dimdate2_Date;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_DAT_Dimdate2_Date();
CREATE OR REPLACE FUNCTION dbo.tcaDA_DAT_Dimdate2_Date() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_DAT_Version) INTO maxVersion
    FROM
        _tmp_DA_DAT_Dimdate2_Date;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_DAT_Dimdate2_Date
        SET
            DA_DAT_StatementType =
                CASE
                    WHEN DAT.DA_DAT_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_DAT_Dimdate2_Date v
        LEFT JOIN
            dbo._DA_DAT_Dimdate2_Date DAT
        ON
            DAT.DA_DAT_DA_ID = v.DA_DAT_DA_ID
        AND
            DAT.DA_DAT_Dimdate2_Date = v.DA_DAT_Dimdate2_Date
        WHERE
            v.DA_DAT_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_DAT_Dimdate2_Date (
            DA_DAT_DA_ID,
            DA_DAT_Dimdate2_Date
        )
        SELECT
            DA_DAT_DA_ID,
            DA_DAT_Dimdate2_Date
        FROM
            _tmp_DA_DAT_Dimdate2_Date
        WHERE
            DA_DAT_Version = currentVersion
        AND
            DA_DAT_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_DAT_Dimdate2_Date;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_DAT_Dimdate2_Date
AFTER INSERT ON dbo.DA_DAT_Dimdate2_Date
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_DAT_Dimdate2_Date();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_DOW_Dimdate2_Dayofweek ON dbo.DA_DOW_Dimdate2_Dayofweek;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_DOW_Dimdate2_Dayofweek();
CREATE OR REPLACE FUNCTION dbo.tcbDA_DOW_Dimdate2_Dayofweek() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_DOW_Dimdate2_Dayofweek (
            DA_DOW_DA_ID int not null,
            DA_DOW_Dimdate2_Dayofweek varchar(9) not null,
            DA_DOW_Version bigint not null,
            DA_DOW_StatementType char(1) not null,
            primary key(
                DA_DOW_Version,
                DA_DOW_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_DOW_Dimdate2_Dayofweek
BEFORE INSERT ON dbo.DA_DOW_Dimdate2_Dayofweek
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_DOW_Dimdate2_Dayofweek();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_DOW_Dimdate2_Dayofweek ON dbo.DA_DOW_Dimdate2_Dayofweek;
-- DROP FUNCTION IF EXISTS dbo.tciDA_DOW_Dimdate2_Dayofweek();
CREATE OR REPLACE FUNCTION dbo.tciDA_DOW_Dimdate2_Dayofweek() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_DOW_Dimdate2_Dayofweek
        SELECT
            NEW.DA_DOW_DA_ID,
            NEW.DA_DOW_Dimdate2_Dayofweek,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_DOW_Dimdate2_Dayofweek
INSTEAD OF INSERT ON dbo.DA_DOW_Dimdate2_Dayofweek
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_DOW_Dimdate2_Dayofweek();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_DOW_Dimdate2_Dayofweek ON dbo.DA_DOW_Dimdate2_Dayofweek;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_DOW_Dimdate2_Dayofweek();
CREATE OR REPLACE FUNCTION dbo.tcaDA_DOW_Dimdate2_Dayofweek() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_DOW_Version) INTO maxVersion
    FROM
        _tmp_DA_DOW_Dimdate2_Dayofweek;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_DOW_Dimdate2_Dayofweek
        SET
            DA_DOW_StatementType =
                CASE
                    WHEN DOW.DA_DOW_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_DOW_Dimdate2_Dayofweek v
        LEFT JOIN
            dbo._DA_DOW_Dimdate2_Dayofweek DOW
        ON
            DOW.DA_DOW_DA_ID = v.DA_DOW_DA_ID
        AND
            DOW.DA_DOW_Dimdate2_Dayofweek = v.DA_DOW_Dimdate2_Dayofweek
        WHERE
            v.DA_DOW_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_DOW_Dimdate2_Dayofweek (
            DA_DOW_DA_ID,
            DA_DOW_Dimdate2_Dayofweek
        )
        SELECT
            DA_DOW_DA_ID,
            DA_DOW_Dimdate2_Dayofweek
        FROM
            _tmp_DA_DOW_Dimdate2_Dayofweek
        WHERE
            DA_DOW_Version = currentVersion
        AND
            DA_DOW_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_DOW_Dimdate2_Dayofweek;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_DOW_Dimdate2_Dayofweek
AFTER INSERT ON dbo.DA_DOW_Dimdate2_Dayofweek
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_DOW_Dimdate2_Dayofweek();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_YRS_Dimdate2_Year ON dbo.DA_YRS_Dimdate2_Year;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_YRS_Dimdate2_Year();
CREATE OR REPLACE FUNCTION dbo.tcbDA_YRS_Dimdate2_Year() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_YRS_Dimdate2_Year (
            DA_YRS_DA_ID int not null,
            DA_YRS_Dimdate2_Year integer not null,
            DA_YRS_Version bigint not null,
            DA_YRS_StatementType char(1) not null,
            primary key(
                DA_YRS_Version,
                DA_YRS_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_YRS_Dimdate2_Year
BEFORE INSERT ON dbo.DA_YRS_Dimdate2_Year
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_YRS_Dimdate2_Year();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_YRS_Dimdate2_Year ON dbo.DA_YRS_Dimdate2_Year;
-- DROP FUNCTION IF EXISTS dbo.tciDA_YRS_Dimdate2_Year();
CREATE OR REPLACE FUNCTION dbo.tciDA_YRS_Dimdate2_Year() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_YRS_Dimdate2_Year
        SELECT
            NEW.DA_YRS_DA_ID,
            NEW.DA_YRS_Dimdate2_Year,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_YRS_Dimdate2_Year
INSTEAD OF INSERT ON dbo.DA_YRS_Dimdate2_Year
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_YRS_Dimdate2_Year();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_YRS_Dimdate2_Year ON dbo.DA_YRS_Dimdate2_Year;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_YRS_Dimdate2_Year();
CREATE OR REPLACE FUNCTION dbo.tcaDA_YRS_Dimdate2_Year() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_YRS_Version) INTO maxVersion
    FROM
        _tmp_DA_YRS_Dimdate2_Year;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_YRS_Dimdate2_Year
        SET
            DA_YRS_StatementType =
                CASE
                    WHEN YRS.DA_YRS_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_YRS_Dimdate2_Year v
        LEFT JOIN
            dbo._DA_YRS_Dimdate2_Year YRS
        ON
            YRS.DA_YRS_DA_ID = v.DA_YRS_DA_ID
        AND
            YRS.DA_YRS_Dimdate2_Year = v.DA_YRS_Dimdate2_Year
        WHERE
            v.DA_YRS_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_YRS_Dimdate2_Year (
            DA_YRS_DA_ID,
            DA_YRS_Dimdate2_Year
        )
        SELECT
            DA_YRS_DA_ID,
            DA_YRS_Dimdate2_Year
        FROM
            _tmp_DA_YRS_Dimdate2_Year
        WHERE
            DA_YRS_Version = currentVersion
        AND
            DA_YRS_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_YRS_Dimdate2_Year;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_YRS_Dimdate2_Year
AFTER INSERT ON dbo.DA_YRS_Dimdate2_Year
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_YRS_Dimdate2_Year();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_YMN_Dimdate2_Yearmonthnum ON dbo.DA_YMN_Dimdate2_Yearmonthnum;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_YMN_Dimdate2_Yearmonthnum();
CREATE OR REPLACE FUNCTION dbo.tcbDA_YMN_Dimdate2_Yearmonthnum() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_YMN_Dimdate2_Yearmonthnum (
            DA_YMN_DA_ID int not null,
            DA_YMN_Dimdate2_Yearmonthnum Integer not null,
            DA_YMN_Version bigint not null,
            DA_YMN_StatementType char(1) not null,
            primary key(
                DA_YMN_Version,
                DA_YMN_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_YMN_Dimdate2_Yearmonthnum
BEFORE INSERT ON dbo.DA_YMN_Dimdate2_Yearmonthnum
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_YMN_Dimdate2_Yearmonthnum();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_YMN_Dimdate2_Yearmonthnum ON dbo.DA_YMN_Dimdate2_Yearmonthnum;
-- DROP FUNCTION IF EXISTS dbo.tciDA_YMN_Dimdate2_Yearmonthnum();
CREATE OR REPLACE FUNCTION dbo.tciDA_YMN_Dimdate2_Yearmonthnum() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_YMN_Dimdate2_Yearmonthnum
        SELECT
            NEW.DA_YMN_DA_ID,
            NEW.DA_YMN_Dimdate2_Yearmonthnum,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_YMN_Dimdate2_Yearmonthnum
INSTEAD OF INSERT ON dbo.DA_YMN_Dimdate2_Yearmonthnum
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_YMN_Dimdate2_Yearmonthnum();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_YMN_Dimdate2_Yearmonthnum ON dbo.DA_YMN_Dimdate2_Yearmonthnum;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_YMN_Dimdate2_Yearmonthnum();
CREATE OR REPLACE FUNCTION dbo.tcaDA_YMN_Dimdate2_Yearmonthnum() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_YMN_Version) INTO maxVersion
    FROM
        _tmp_DA_YMN_Dimdate2_Yearmonthnum;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_YMN_Dimdate2_Yearmonthnum
        SET
            DA_YMN_StatementType =
                CASE
                    WHEN YMN.DA_YMN_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_YMN_Dimdate2_Yearmonthnum v
        LEFT JOIN
            dbo._DA_YMN_Dimdate2_Yearmonthnum YMN
        ON
            YMN.DA_YMN_DA_ID = v.DA_YMN_DA_ID
        AND
            YMN.DA_YMN_Dimdate2_Yearmonthnum = v.DA_YMN_Dimdate2_Yearmonthnum
        WHERE
            v.DA_YMN_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_YMN_Dimdate2_Yearmonthnum (
            DA_YMN_DA_ID,
            DA_YMN_Dimdate2_Yearmonthnum
        )
        SELECT
            DA_YMN_DA_ID,
            DA_YMN_Dimdate2_Yearmonthnum
        FROM
            _tmp_DA_YMN_Dimdate2_Yearmonthnum
        WHERE
            DA_YMN_Version = currentVersion
        AND
            DA_YMN_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_YMN_Dimdate2_Yearmonthnum;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_YMN_Dimdate2_Yearmonthnum
AFTER INSERT ON dbo.DA_YMN_Dimdate2_Yearmonthnum
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_YMN_Dimdate2_Yearmonthnum();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_MMM_Dimdate2_Month ON dbo.DA_MMM_Dimdate2_Month;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_MMM_Dimdate2_Month();
CREATE OR REPLACE FUNCTION dbo.tcbDA_MMM_Dimdate2_Month() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_MMM_Dimdate2_Month (
            DA_MMM_DA_ID int not null,
            DA_MMM_Dimdate2_Month varchar(9) not null,
            DA_MMM_Version bigint not null,
            DA_MMM_StatementType char(1) not null,
            primary key(
                DA_MMM_Version,
                DA_MMM_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_MMM_Dimdate2_Month
BEFORE INSERT ON dbo.DA_MMM_Dimdate2_Month
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_MMM_Dimdate2_Month();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_MMM_Dimdate2_Month ON dbo.DA_MMM_Dimdate2_Month;
-- DROP FUNCTION IF EXISTS dbo.tciDA_MMM_Dimdate2_Month();
CREATE OR REPLACE FUNCTION dbo.tciDA_MMM_Dimdate2_Month() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_MMM_Dimdate2_Month
        SELECT
            NEW.DA_MMM_DA_ID,
            NEW.DA_MMM_Dimdate2_Month,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_MMM_Dimdate2_Month
INSTEAD OF INSERT ON dbo.DA_MMM_Dimdate2_Month
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_MMM_Dimdate2_Month();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_MMM_Dimdate2_Month ON dbo.DA_MMM_Dimdate2_Month;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_MMM_Dimdate2_Month();
CREATE OR REPLACE FUNCTION dbo.tcaDA_MMM_Dimdate2_Month() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_MMM_Version) INTO maxVersion
    FROM
        _tmp_DA_MMM_Dimdate2_Month;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_MMM_Dimdate2_Month
        SET
            DA_MMM_StatementType =
                CASE
                    WHEN MMM.DA_MMM_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_MMM_Dimdate2_Month v
        LEFT JOIN
            dbo._DA_MMM_Dimdate2_Month MMM
        ON
            MMM.DA_MMM_DA_ID = v.DA_MMM_DA_ID
        AND
            MMM.DA_MMM_Dimdate2_Month = v.DA_MMM_Dimdate2_Month
        WHERE
            v.DA_MMM_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_MMM_Dimdate2_Month (
            DA_MMM_DA_ID,
            DA_MMM_Dimdate2_Month
        )
        SELECT
            DA_MMM_DA_ID,
            DA_MMM_Dimdate2_Month
        FROM
            _tmp_DA_MMM_Dimdate2_Month
        WHERE
            DA_MMM_Version = currentVersion
        AND
            DA_MMM_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_MMM_Dimdate2_Month;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_MMM_Dimdate2_Month
AFTER INSERT ON dbo.DA_MMM_Dimdate2_Month
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_MMM_Dimdate2_Month();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_DNW_Dimdate2_Daynuminweek ON dbo.DA_DNW_Dimdate2_Daynuminweek;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_DNW_Dimdate2_Daynuminweek();
CREATE OR REPLACE FUNCTION dbo.tcbDA_DNW_Dimdate2_Daynuminweek() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_DNW_Dimdate2_Daynuminweek (
            DA_DNW_DA_ID int not null,
            DA_DNW_Dimdate2_Daynuminweek integer not null,
            DA_DNW_Version bigint not null,
            DA_DNW_StatementType char(1) not null,
            primary key(
                DA_DNW_Version,
                DA_DNW_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_DNW_Dimdate2_Daynuminweek
BEFORE INSERT ON dbo.DA_DNW_Dimdate2_Daynuminweek
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_DNW_Dimdate2_Daynuminweek();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_DNW_Dimdate2_Daynuminweek ON dbo.DA_DNW_Dimdate2_Daynuminweek;
-- DROP FUNCTION IF EXISTS dbo.tciDA_DNW_Dimdate2_Daynuminweek();
CREATE OR REPLACE FUNCTION dbo.tciDA_DNW_Dimdate2_Daynuminweek() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_DNW_Dimdate2_Daynuminweek
        SELECT
            NEW.DA_DNW_DA_ID,
            NEW.DA_DNW_Dimdate2_Daynuminweek,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_DNW_Dimdate2_Daynuminweek
INSTEAD OF INSERT ON dbo.DA_DNW_Dimdate2_Daynuminweek
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_DNW_Dimdate2_Daynuminweek();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_DNW_Dimdate2_Daynuminweek ON dbo.DA_DNW_Dimdate2_Daynuminweek;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_DNW_Dimdate2_Daynuminweek();
CREATE OR REPLACE FUNCTION dbo.tcaDA_DNW_Dimdate2_Daynuminweek() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_DNW_Version) INTO maxVersion
    FROM
        _tmp_DA_DNW_Dimdate2_Daynuminweek;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_DNW_Dimdate2_Daynuminweek
        SET
            DA_DNW_StatementType =
                CASE
                    WHEN DNW.DA_DNW_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_DNW_Dimdate2_Daynuminweek v
        LEFT JOIN
            dbo._DA_DNW_Dimdate2_Daynuminweek DNW
        ON
            DNW.DA_DNW_DA_ID = v.DA_DNW_DA_ID
        AND
            DNW.DA_DNW_Dimdate2_Daynuminweek = v.DA_DNW_Dimdate2_Daynuminweek
        WHERE
            v.DA_DNW_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_DNW_Dimdate2_Daynuminweek (
            DA_DNW_DA_ID,
            DA_DNW_Dimdate2_Daynuminweek
        )
        SELECT
            DA_DNW_DA_ID,
            DA_DNW_Dimdate2_Daynuminweek
        FROM
            _tmp_DA_DNW_Dimdate2_Daynuminweek
        WHERE
            DA_DNW_Version = currentVersion
        AND
            DA_DNW_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_DNW_Dimdate2_Daynuminweek;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_DNW_Dimdate2_Daynuminweek
AFTER INSERT ON dbo.DA_DNW_Dimdate2_Daynuminweek
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_DNW_Dimdate2_Daynuminweek();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_YMM_Dimdate2_Yearmonth ON dbo.DA_YMM_Dimdate2_Yearmonth;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_YMM_Dimdate2_Yearmonth();
CREATE OR REPLACE FUNCTION dbo.tcbDA_YMM_Dimdate2_Yearmonth() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_YMM_Dimdate2_Yearmonth (
            DA_YMM_DA_ID int not null,
            DA_YMM_Dimdate2_Yearmonth varchar(7) not null,
            DA_YMM_Version bigint not null,
            DA_YMM_StatementType char(1) not null,
            primary key(
                DA_YMM_Version,
                DA_YMM_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_YMM_Dimdate2_Yearmonth
BEFORE INSERT ON dbo.DA_YMM_Dimdate2_Yearmonth
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_YMM_Dimdate2_Yearmonth();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_YMM_Dimdate2_Yearmonth ON dbo.DA_YMM_Dimdate2_Yearmonth;
-- DROP FUNCTION IF EXISTS dbo.tciDA_YMM_Dimdate2_Yearmonth();
CREATE OR REPLACE FUNCTION dbo.tciDA_YMM_Dimdate2_Yearmonth() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_YMM_Dimdate2_Yearmonth
        SELECT
            NEW.DA_YMM_DA_ID,
            NEW.DA_YMM_Dimdate2_Yearmonth,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_YMM_Dimdate2_Yearmonth
INSTEAD OF INSERT ON dbo.DA_YMM_Dimdate2_Yearmonth
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_YMM_Dimdate2_Yearmonth();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_YMM_Dimdate2_Yearmonth ON dbo.DA_YMM_Dimdate2_Yearmonth;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_YMM_Dimdate2_Yearmonth();
CREATE OR REPLACE FUNCTION dbo.tcaDA_YMM_Dimdate2_Yearmonth() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_YMM_Version) INTO maxVersion
    FROM
        _tmp_DA_YMM_Dimdate2_Yearmonth;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_YMM_Dimdate2_Yearmonth
        SET
            DA_YMM_StatementType =
                CASE
                    WHEN YMM.DA_YMM_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_YMM_Dimdate2_Yearmonth v
        LEFT JOIN
            dbo._DA_YMM_Dimdate2_Yearmonth YMM
        ON
            YMM.DA_YMM_DA_ID = v.DA_YMM_DA_ID
        AND
            YMM.DA_YMM_Dimdate2_Yearmonth = v.DA_YMM_Dimdate2_Yearmonth
        WHERE
            v.DA_YMM_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_YMM_Dimdate2_Yearmonth (
            DA_YMM_DA_ID,
            DA_YMM_Dimdate2_Yearmonth
        )
        SELECT
            DA_YMM_DA_ID,
            DA_YMM_Dimdate2_Yearmonth
        FROM
            _tmp_DA_YMM_Dimdate2_Yearmonth
        WHERE
            DA_YMM_Version = currentVersion
        AND
            DA_YMM_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_YMM_Dimdate2_Yearmonth;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_YMM_Dimdate2_Yearmonth
AFTER INSERT ON dbo.DA_YMM_Dimdate2_Yearmonth
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_YMM_Dimdate2_Yearmonth();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_MNY_Dimdate2_Monthnuminyear ON dbo.DA_MNY_Dimdate2_Monthnuminyear;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_MNY_Dimdate2_Monthnuminyear();
CREATE OR REPLACE FUNCTION dbo.tcbDA_MNY_Dimdate2_Monthnuminyear() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_MNY_Dimdate2_Monthnuminyear (
            DA_MNY_DA_ID int not null,
            DA_MNY_Dimdate2_Monthnuminyear integer not null,
            DA_MNY_Version bigint not null,
            DA_MNY_StatementType char(1) not null,
            primary key(
                DA_MNY_Version,
                DA_MNY_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_MNY_Dimdate2_Monthnuminyear
BEFORE INSERT ON dbo.DA_MNY_Dimdate2_Monthnuminyear
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_MNY_Dimdate2_Monthnuminyear();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_MNY_Dimdate2_Monthnuminyear ON dbo.DA_MNY_Dimdate2_Monthnuminyear;
-- DROP FUNCTION IF EXISTS dbo.tciDA_MNY_Dimdate2_Monthnuminyear();
CREATE OR REPLACE FUNCTION dbo.tciDA_MNY_Dimdate2_Monthnuminyear() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_MNY_Dimdate2_Monthnuminyear
        SELECT
            NEW.DA_MNY_DA_ID,
            NEW.DA_MNY_Dimdate2_Monthnuminyear,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_MNY_Dimdate2_Monthnuminyear
INSTEAD OF INSERT ON dbo.DA_MNY_Dimdate2_Monthnuminyear
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_MNY_Dimdate2_Monthnuminyear();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_MNY_Dimdate2_Monthnuminyear ON dbo.DA_MNY_Dimdate2_Monthnuminyear;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_MNY_Dimdate2_Monthnuminyear();
CREATE OR REPLACE FUNCTION dbo.tcaDA_MNY_Dimdate2_Monthnuminyear() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_MNY_Version) INTO maxVersion
    FROM
        _tmp_DA_MNY_Dimdate2_Monthnuminyear;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_MNY_Dimdate2_Monthnuminyear
        SET
            DA_MNY_StatementType =
                CASE
                    WHEN MNY.DA_MNY_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_MNY_Dimdate2_Monthnuminyear v
        LEFT JOIN
            dbo._DA_MNY_Dimdate2_Monthnuminyear MNY
        ON
            MNY.DA_MNY_DA_ID = v.DA_MNY_DA_ID
        AND
            MNY.DA_MNY_Dimdate2_Monthnuminyear = v.DA_MNY_Dimdate2_Monthnuminyear
        WHERE
            v.DA_MNY_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_MNY_Dimdate2_Monthnuminyear (
            DA_MNY_DA_ID,
            DA_MNY_Dimdate2_Monthnuminyear
        )
        SELECT
            DA_MNY_DA_ID,
            DA_MNY_Dimdate2_Monthnuminyear
        FROM
            _tmp_DA_MNY_Dimdate2_Monthnuminyear
        WHERE
            DA_MNY_Version = currentVersion
        AND
            DA_MNY_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_MNY_Dimdate2_Monthnuminyear;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_MNY_Dimdate2_Monthnuminyear
AFTER INSERT ON dbo.DA_MNY_Dimdate2_Monthnuminyear
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_MNY_Dimdate2_Monthnuminyear();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_DNY_Dimdate2_Daynuminyear ON dbo.DA_DNY_Dimdate2_Daynuminyear;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_DNY_Dimdate2_Daynuminyear();
CREATE OR REPLACE FUNCTION dbo.tcbDA_DNY_Dimdate2_Daynuminyear() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_DNY_Dimdate2_Daynuminyear (
            DA_DNY_DA_ID int not null,
            DA_DNY_Dimdate2_Daynuminyear integer not null,
            DA_DNY_Version bigint not null,
            DA_DNY_StatementType char(1) not null,
            primary key(
                DA_DNY_Version,
                DA_DNY_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_DNY_Dimdate2_Daynuminyear
BEFORE INSERT ON dbo.DA_DNY_Dimdate2_Daynuminyear
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_DNY_Dimdate2_Daynuminyear();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_DNY_Dimdate2_Daynuminyear ON dbo.DA_DNY_Dimdate2_Daynuminyear;
-- DROP FUNCTION IF EXISTS dbo.tciDA_DNY_Dimdate2_Daynuminyear();
CREATE OR REPLACE FUNCTION dbo.tciDA_DNY_Dimdate2_Daynuminyear() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_DNY_Dimdate2_Daynuminyear
        SELECT
            NEW.DA_DNY_DA_ID,
            NEW.DA_DNY_Dimdate2_Daynuminyear,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_DNY_Dimdate2_Daynuminyear
INSTEAD OF INSERT ON dbo.DA_DNY_Dimdate2_Daynuminyear
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_DNY_Dimdate2_Daynuminyear();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_DNY_Dimdate2_Daynuminyear ON dbo.DA_DNY_Dimdate2_Daynuminyear;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_DNY_Dimdate2_Daynuminyear();
CREATE OR REPLACE FUNCTION dbo.tcaDA_DNY_Dimdate2_Daynuminyear() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_DNY_Version) INTO maxVersion
    FROM
        _tmp_DA_DNY_Dimdate2_Daynuminyear;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_DNY_Dimdate2_Daynuminyear
        SET
            DA_DNY_StatementType =
                CASE
                    WHEN DNY.DA_DNY_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_DNY_Dimdate2_Daynuminyear v
        LEFT JOIN
            dbo._DA_DNY_Dimdate2_Daynuminyear DNY
        ON
            DNY.DA_DNY_DA_ID = v.DA_DNY_DA_ID
        AND
            DNY.DA_DNY_Dimdate2_Daynuminyear = v.DA_DNY_Dimdate2_Daynuminyear
        WHERE
            v.DA_DNY_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_DNY_Dimdate2_Daynuminyear (
            DA_DNY_DA_ID,
            DA_DNY_Dimdate2_Daynuminyear
        )
        SELECT
            DA_DNY_DA_ID,
            DA_DNY_Dimdate2_Daynuminyear
        FROM
            _tmp_DA_DNY_Dimdate2_Daynuminyear
        WHERE
            DA_DNY_Version = currentVersion
        AND
            DA_DNY_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_DNY_Dimdate2_Daynuminyear;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_DNY_Dimdate2_Daynuminyear
AFTER INSERT ON dbo.DA_DNY_Dimdate2_Daynuminyear
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_DNY_Dimdate2_Daynuminyear();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_LIF_Dimdate2_Lastdayinmonthfl ON dbo.DA_LIF_Dimdate2_Lastdayinmonthfl;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_LIF_Dimdate2_Lastdayinmonthfl();
CREATE OR REPLACE FUNCTION dbo.tcbDA_LIF_Dimdate2_Lastdayinmonthfl() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_LIF_Dimdate2_Lastdayinmonthfl (
            DA_LIF_DA_ID int not null,
            DA_LIF_Dimdate2_Lastdayinmonthfl char(1) not null,
            DA_LIF_Version bigint not null,
            DA_LIF_StatementType char(1) not null,
            primary key(
                DA_LIF_Version,
                DA_LIF_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_LIF_Dimdate2_Lastdayinmonthfl
BEFORE INSERT ON dbo.DA_LIF_Dimdate2_Lastdayinmonthfl
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_LIF_Dimdate2_Lastdayinmonthfl();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_LIF_Dimdate2_Lastdayinmonthfl ON dbo.DA_LIF_Dimdate2_Lastdayinmonthfl;
-- DROP FUNCTION IF EXISTS dbo.tciDA_LIF_Dimdate2_Lastdayinmonthfl();
CREATE OR REPLACE FUNCTION dbo.tciDA_LIF_Dimdate2_Lastdayinmonthfl() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_LIF_Dimdate2_Lastdayinmonthfl
        SELECT
            NEW.DA_LIF_DA_ID,
            NEW.DA_LIF_Dimdate2_Lastdayinmonthfl,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_LIF_Dimdate2_Lastdayinmonthfl
INSTEAD OF INSERT ON dbo.DA_LIF_Dimdate2_Lastdayinmonthfl
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_LIF_Dimdate2_Lastdayinmonthfl();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_LIF_Dimdate2_Lastdayinmonthfl ON dbo.DA_LIF_Dimdate2_Lastdayinmonthfl;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_LIF_Dimdate2_Lastdayinmonthfl();
CREATE OR REPLACE FUNCTION dbo.tcaDA_LIF_Dimdate2_Lastdayinmonthfl() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_LIF_Version) INTO maxVersion
    FROM
        _tmp_DA_LIF_Dimdate2_Lastdayinmonthfl;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_LIF_Dimdate2_Lastdayinmonthfl
        SET
            DA_LIF_StatementType =
                CASE
                    WHEN LIF.DA_LIF_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_LIF_Dimdate2_Lastdayinmonthfl v
        LEFT JOIN
            dbo._DA_LIF_Dimdate2_Lastdayinmonthfl LIF
        ON
            LIF.DA_LIF_DA_ID = v.DA_LIF_DA_ID
        AND
            LIF.DA_LIF_Dimdate2_Lastdayinmonthfl = v.DA_LIF_Dimdate2_Lastdayinmonthfl
        WHERE
            v.DA_LIF_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_LIF_Dimdate2_Lastdayinmonthfl (
            DA_LIF_DA_ID,
            DA_LIF_Dimdate2_Lastdayinmonthfl
        )
        SELECT
            DA_LIF_DA_ID,
            DA_LIF_Dimdate2_Lastdayinmonthfl
        FROM
            _tmp_DA_LIF_Dimdate2_Lastdayinmonthfl
        WHERE
            DA_LIF_Version = currentVersion
        AND
            DA_LIF_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_LIF_Dimdate2_Lastdayinmonthfl;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_LIF_Dimdate2_Lastdayinmonthfl
AFTER INSERT ON dbo.DA_LIF_Dimdate2_Lastdayinmonthfl
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_LIF_Dimdate2_Lastdayinmonthfl();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_HFL_Dimdate2_HolydayFL ON dbo.DA_HFL_Dimdate2_HolydayFL;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_HFL_Dimdate2_HolydayFL();
CREATE OR REPLACE FUNCTION dbo.tcbDA_HFL_Dimdate2_HolydayFL() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_HFL_Dimdate2_HolydayFL (
            DA_HFL_DA_ID int not null,
            DA_HFL_Dimdate2_HolydayFL char(1) not null,
            DA_HFL_Version bigint not null,
            DA_HFL_StatementType char(1) not null,
            primary key(
                DA_HFL_Version,
                DA_HFL_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_HFL_Dimdate2_HolydayFL
BEFORE INSERT ON dbo.DA_HFL_Dimdate2_HolydayFL
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_HFL_Dimdate2_HolydayFL();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_HFL_Dimdate2_HolydayFL ON dbo.DA_HFL_Dimdate2_HolydayFL;
-- DROP FUNCTION IF EXISTS dbo.tciDA_HFL_Dimdate2_HolydayFL();
CREATE OR REPLACE FUNCTION dbo.tciDA_HFL_Dimdate2_HolydayFL() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_HFL_Dimdate2_HolydayFL
        SELECT
            NEW.DA_HFL_DA_ID,
            NEW.DA_HFL_Dimdate2_HolydayFL,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_HFL_Dimdate2_HolydayFL
INSTEAD OF INSERT ON dbo.DA_HFL_Dimdate2_HolydayFL
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_HFL_Dimdate2_HolydayFL();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_HFL_Dimdate2_HolydayFL ON dbo.DA_HFL_Dimdate2_HolydayFL;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_HFL_Dimdate2_HolydayFL();
CREATE OR REPLACE FUNCTION dbo.tcaDA_HFL_Dimdate2_HolydayFL() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_HFL_Version) INTO maxVersion
    FROM
        _tmp_DA_HFL_Dimdate2_HolydayFL;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_HFL_Dimdate2_HolydayFL
        SET
            DA_HFL_StatementType =
                CASE
                    WHEN HFL.DA_HFL_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_HFL_Dimdate2_HolydayFL v
        LEFT JOIN
            dbo._DA_HFL_Dimdate2_HolydayFL HFL
        ON
            HFL.DA_HFL_DA_ID = v.DA_HFL_DA_ID
        AND
            HFL.DA_HFL_Dimdate2_HolydayFL = v.DA_HFL_Dimdate2_HolydayFL
        WHERE
            v.DA_HFL_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_HFL_Dimdate2_HolydayFL (
            DA_HFL_DA_ID,
            DA_HFL_Dimdate2_HolydayFL
        )
        SELECT
            DA_HFL_DA_ID,
            DA_HFL_Dimdate2_HolydayFL
        FROM
            _tmp_DA_HFL_Dimdate2_HolydayFL
        WHERE
            DA_HFL_Version = currentVersion
        AND
            DA_HFL_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_HFL_Dimdate2_HolydayFL;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_HFL_Dimdate2_HolydayFL
AFTER INSERT ON dbo.DA_HFL_Dimdate2_HolydayFL
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_HFL_Dimdate2_HolydayFL();
-- BEFORE INSERT trigger ----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcbDA_WDF_Dimdate2_Weekdayfl ON dbo.DA_WDF_Dimdate2_Weekdayfl;
-- DROP FUNCTION IF EXISTS dbo.tcbDA_WDF_Dimdate2_Weekdayfl();
CREATE OR REPLACE FUNCTION dbo.tcbDA_WDF_Dimdate2_Weekdayfl() RETURNS trigger AS '
    BEGIN
        -- temporary table is used to create an insert order 
        -- (so that rows are inserted in order with respect to temporality)
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_DA_WDF_Dimdate2_Weekdayfl (
            DA_WDF_DA_ID int not null,
            DA_WDF_Dimdate2_Weekdayfl char(1) not null,
            DA_WDF_Version bigint not null,
            DA_WDF_StatementType char(1) not null,
            primary key(
                DA_WDF_Version,
                DA_WDF_DA_ID
            )
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcbDA_WDF_Dimdate2_Weekdayfl
BEFORE INSERT ON dbo.DA_WDF_Dimdate2_Weekdayfl
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcbDA_WDF_Dimdate2_Weekdayfl();
-- INSTEAD OF INSERT trigger ------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tciDA_WDF_Dimdate2_Weekdayfl ON dbo.DA_WDF_Dimdate2_Weekdayfl;
-- DROP FUNCTION IF EXISTS dbo.tciDA_WDF_Dimdate2_Weekdayfl();
CREATE OR REPLACE FUNCTION dbo.tciDA_WDF_Dimdate2_Weekdayfl() RETURNS trigger AS '
    BEGIN
        -- insert rows into the temporary table
        INSERT INTO _tmp_DA_WDF_Dimdate2_Weekdayfl
        SELECT
            NEW.DA_WDF_DA_ID,
            NEW.DA_WDF_Dimdate2_Weekdayfl,
            1,
            ''X'';
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER tciDA_WDF_Dimdate2_Weekdayfl
INSTEAD OF INSERT ON dbo.DA_WDF_Dimdate2_Weekdayfl
FOR EACH ROW
EXECUTE PROCEDURE dbo.tciDA_WDF_Dimdate2_Weekdayfl();
-- AFTER INSERT trigger -----------------------------------------------------------------------------------------------
-- DROP TRIGGER IF EXISTS tcaDA_WDF_Dimdate2_Weekdayfl ON dbo.DA_WDF_Dimdate2_Weekdayfl;
-- DROP FUNCTION IF EXISTS dbo.tcaDA_WDF_Dimdate2_Weekdayfl();
CREATE OR REPLACE FUNCTION dbo.tcaDA_WDF_Dimdate2_Weekdayfl() RETURNS trigger AS '
    DECLARE maxVersion int;
    DECLARE currentVersion int = 0;
BEGIN
    -- find max version
    SELECT
        MAX(DA_WDF_Version) INTO maxVersion
    FROM
        _tmp_DA_WDF_Dimdate2_Weekdayfl;
    -- is max version NULL?
    IF (maxVersion is null) THEN
        RETURN NULL;
    END IF;
    -- loop over versions
    LOOP
        currentVersion := currentVersion + 1;
        -- set statement types
        UPDATE _tmp_DA_WDF_Dimdate2_Weekdayfl
        SET
            DA_WDF_StatementType =
                CASE
                    WHEN WDF.DA_WDF_DA_ID is not null
                    THEN ''D'' -- duplicate
                    ELSE ''N'' -- new statement
                END
        FROM
            _tmp_DA_WDF_Dimdate2_Weekdayfl v
        LEFT JOIN
            dbo._DA_WDF_Dimdate2_Weekdayfl WDF
        ON
            WDF.DA_WDF_DA_ID = v.DA_WDF_DA_ID
        AND
            WDF.DA_WDF_Dimdate2_Weekdayfl = v.DA_WDF_Dimdate2_Weekdayfl
        WHERE
            v.DA_WDF_Version = currentVersion;
        -- insert data into attribute table
        INSERT INTO dbo._DA_WDF_Dimdate2_Weekdayfl (
            DA_WDF_DA_ID,
            DA_WDF_Dimdate2_Weekdayfl
        )
        SELECT
            DA_WDF_DA_ID,
            DA_WDF_Dimdate2_Weekdayfl
        FROM
            _tmp_DA_WDF_Dimdate2_Weekdayfl
        WHERE
            DA_WDF_Version = currentVersion
        AND
            DA_WDF_StatementType in (''N'');
        EXIT WHEN currentVersion >= maxVersion;
    END LOOP;
    DROP TABLE IF EXISTS _tmp_DA_WDF_Dimdate2_Weekdayfl;
    RETURN NULL;
END;
' LANGUAGE plpgsql;
CREATE TRIGGER tcaDA_WDF_Dimdate2_Weekdayfl
AFTER INSERT ON dbo.DA_WDF_Dimdate2_Weekdayfl
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.tcaDA_WDF_Dimdate2_Weekdayfl();
-- ANCHOR TRIGGERS ---------------------------------------------------------------------------------------------------
--
-- The following triggers on the latest view make it behave like a table.
-- There are three different 'instead of' triggers: insert, update, and delete.
-- They will ensure that such operations are propagated to the underlying tables
-- in a consistent way. Default values are used for some columns if not provided
-- by the corresponding SQL statements.
--
-- For idempotent attributes, only changes that represent a value different from
-- the previous or following value are stored. Others are silently ignored in
-- order to avoid unnecessary temporal duplicates.
--
-- BEFORE INSERT trigger --------------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS itb_lDC_DIMcustomer ON dbo.lDC_DIMcustomer;
--DROP FUNCTION IF EXISTS dbo.itb_lDC_DIMcustomer();
CREATE OR REPLACE FUNCTION dbo.itb_lDC_DIMcustomer() RETURNS trigger AS '
    BEGIN
        -- create temporary table to keep inserted rows in
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_it_DC_DIMcustomer (
            DC_ID int not null,
            DC_REG_DC_ID int null,
            DC_REG_DIMcustomer_Region Char(12) null,
            DC_ADD_DC_ID int null,
            DC_ADD_DIMcustomer_Address Varchar(25) null,
            DC_CIT_DC_ID int null,
            DC_CIT_DIMcustomer_City Char(10) null,
            DC_PHN_DC_ID int null,
            DC_PHN_DIMcustomer_Phone char(15) null,
            DC_NAT_DC_ID int null,
            DC_NAT_DIMcustomer_Nation Char(15) null,
            DC_NAM_DC_ID int null,
            DC_NAM_DIMcustomer_Name Varchar(25) null,
            DC_SEG_DC_ID int null,
            DC_SEG_DIMcustomer_Mktsegment Char(10) null
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER itb_lDC_DIMcustomer
BEFORE INSERT ON dbo.lDC_DIMcustomer
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.itb_lDC_DIMcustomer(); 
-- INSTEAD OF INSERT trigger ----------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS iti_lDC_DIMcustomer ON dbo.lDC_DIMcustomer;
--DROP FUNCTION IF EXISTS dbo.iti_lDC_DIMcustomer();
CREATE OR REPLACE FUNCTION dbo.iti_lDC_DIMcustomer() RETURNS trigger AS '
    BEGIN
        -- generate anchor ID (if not provided)
        IF (NEW.DC_ID IS NULL) THEN 
            INSERT INTO dbo.DC_DIMcustomer (
                DC_Dummy
            ) VALUES (
                null
            );
            SELECT
                lastval() 
            INTO NEW.DC_ID;
        -- if anchor ID is provided then let''s insert it into the anchor table
        -- but only if that ID is not present in the anchor table
        ELSE
            INSERT INTO dbo.DC_DIMcustomer (
                DC_ID
            )
            SELECT
                NEW.DC_ID
            WHERE NOT EXISTS(
	            SELECT
	                DC_ID 
	            FROM dbo.DC_DIMcustomer
	            WHERE DC_ID = NEW.DC_ID
	            LIMIT 1
            );
        END IF;
        -- insert row into temporary table
    	INSERT INTO _tmp_it_DC_DIMcustomer (
            DC_ID,
            DC_REG_DC_ID,
            DC_REG_DIMcustomer_Region,
            DC_ADD_DC_ID,
            DC_ADD_DIMcustomer_Address,
            DC_CIT_DC_ID,
            DC_CIT_DIMcustomer_City,
            DC_PHN_DC_ID,
            DC_PHN_DIMcustomer_Phone,
            DC_NAT_DC_ID,
            DC_NAT_DIMcustomer_Nation,
            DC_NAM_DC_ID,
            DC_NAM_DIMcustomer_Name,
            DC_SEG_DC_ID,
            DC_SEG_DIMcustomer_Mktsegment
    	) VALUES (
    	    NEW.DC_ID,
            COALESCE(NEW.DC_REG_DC_ID, NEW.DC_ID),
            NEW.DC_REG_DIMcustomer_Region,
            COALESCE(NEW.DC_ADD_DC_ID, NEW.DC_ID),
            NEW.DC_ADD_DIMcustomer_Address,
            COALESCE(NEW.DC_CIT_DC_ID, NEW.DC_ID),
            NEW.DC_CIT_DIMcustomer_City,
            COALESCE(NEW.DC_PHN_DC_ID, NEW.DC_ID),
            NEW.DC_PHN_DIMcustomer_Phone,
            COALESCE(NEW.DC_NAT_DC_ID, NEW.DC_ID),
            NEW.DC_NAT_DIMcustomer_Nation,
            COALESCE(NEW.DC_NAM_DC_ID, NEW.DC_ID),
            NEW.DC_NAM_DIMcustomer_Name,
            COALESCE(NEW.DC_SEG_DC_ID, NEW.DC_ID),
            NEW.DC_SEG_DIMcustomer_Mktsegment
    	);
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER iti_lDC_DIMcustomer
INSTEAD OF INSERT ON dbo.lDC_DIMcustomer
FOR EACH ROW
EXECUTE PROCEDURE dbo.iti_lDC_DIMcustomer();
-- AFTER INSERT trigger ---------------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS ita_lDC_DIMcustomer ON dbo.lDC_DIMcustomer;
--DROP FUNCTION IF EXISTS dbo.ita_lDC_DIMcustomer();
CREATE OR REPLACE FUNCTION dbo.ita_lDC_DIMcustomer() RETURNS trigger AS '
    BEGIN
        INSERT INTO dbo.DC_REG_DIMcustomer_Region (
            DC_REG_DC_ID,
            DC_REG_DIMcustomer_Region
        )
        SELECT
            i.DC_REG_DC_ID,
            i.DC_REG_DIMcustomer_Region
        FROM
            _tmp_it_DC_DIMcustomer i
        WHERE
            i.DC_REG_DIMcustomer_Region is not null;
        INSERT INTO dbo.DC_ADD_DIMcustomer_Address (
            DC_ADD_DC_ID,
            DC_ADD_DIMcustomer_Address
        )
        SELECT
            i.DC_ADD_DC_ID,
            i.DC_ADD_DIMcustomer_Address
        FROM
            _tmp_it_DC_DIMcustomer i
        WHERE
            i.DC_ADD_DIMcustomer_Address is not null;
        INSERT INTO dbo.DC_CIT_DIMcustomer_City (
            DC_CIT_DC_ID,
            DC_CIT_DIMcustomer_City
        )
        SELECT
            i.DC_CIT_DC_ID,
            i.DC_CIT_DIMcustomer_City
        FROM
            _tmp_it_DC_DIMcustomer i
        WHERE
            i.DC_CIT_DIMcustomer_City is not null;
        INSERT INTO dbo.DC_PHN_DIMcustomer_Phone (
            DC_PHN_DC_ID,
            DC_PHN_DIMcustomer_Phone
        )
        SELECT
            i.DC_PHN_DC_ID,
            i.DC_PHN_DIMcustomer_Phone
        FROM
            _tmp_it_DC_DIMcustomer i
        WHERE
            i.DC_PHN_DIMcustomer_Phone is not null;
        INSERT INTO dbo.DC_NAT_DIMcustomer_Nation (
            DC_NAT_DC_ID,
            DC_NAT_DIMcustomer_Nation
        )
        SELECT
            i.DC_NAT_DC_ID,
            i.DC_NAT_DIMcustomer_Nation
        FROM
            _tmp_it_DC_DIMcustomer i
        WHERE
            i.DC_NAT_DIMcustomer_Nation is not null;
        INSERT INTO dbo.DC_NAM_DIMcustomer_Name (
            DC_NAM_DC_ID,
            DC_NAM_DIMcustomer_Name
        )
        SELECT
            i.DC_NAM_DC_ID,
            i.DC_NAM_DIMcustomer_Name
        FROM
            _tmp_it_DC_DIMcustomer i
        WHERE
            i.DC_NAM_DIMcustomer_Name is not null;
        INSERT INTO dbo.DC_SEG_DIMcustomer_Mktsegment (
            DC_SEG_DC_ID,
            DC_SEG_DIMcustomer_Mktsegment
        )
        SELECT
            i.DC_SEG_DC_ID,
            i.DC_SEG_DIMcustomer_Mktsegment
        FROM
            _tmp_it_DC_DIMcustomer i
        WHERE
            i.DC_SEG_DIMcustomer_Mktsegment is not null;
        DROP TABLE IF EXISTS _tmp_it_DC_DIMcustomer;
        RETURN NULL;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER ita_lDC_DIMcustomer
AFTER INSERT ON dbo.lDC_DIMcustomer
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.ita_lDC_DIMcustomer();
-- BEFORE INSERT trigger --------------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS itb_lDS_DIMsupplier ON dbo.lDS_DIMsupplier;
--DROP FUNCTION IF EXISTS dbo.itb_lDS_DIMsupplier();
CREATE OR REPLACE FUNCTION dbo.itb_lDS_DIMsupplier() RETURNS trigger AS '
    BEGIN
        -- create temporary table to keep inserted rows in
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_it_DS_DIMsupplier (
            DS_ID int not null,
            DS_REG_DS_ID int null,
            DS_REG_DIMsupplier_Region Char(12) null,
            DS_CIT_DS_ID int null,
            DS_CIT_DIMsupplier_City Char(10) null,
            DS_NAT_DS_ID int null,
            DS_NAT_DIMsupplier_Nation Char(15) null,
            DS_PHN_DS_ID int null,
            DS_PHN_DIMsupplier_Phone char(15) null,
            DS_ADD_DS_ID int null,
            DS_ADD_DIMsupplier_Address Varchar(25) null,
            DS_NAM_DS_ID int null,
            DS_NAM_DIMsupplier_Name Char(25) null
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER itb_lDS_DIMsupplier
BEFORE INSERT ON dbo.lDS_DIMsupplier
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.itb_lDS_DIMsupplier(); 
-- INSTEAD OF INSERT trigger ----------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS iti_lDS_DIMsupplier ON dbo.lDS_DIMsupplier;
--DROP FUNCTION IF EXISTS dbo.iti_lDS_DIMsupplier();
CREATE OR REPLACE FUNCTION dbo.iti_lDS_DIMsupplier() RETURNS trigger AS '
    BEGIN
        -- generate anchor ID (if not provided)
        IF (NEW.DS_ID IS NULL) THEN 
            INSERT INTO dbo.DS_DIMsupplier (
                DS_Dummy
            ) VALUES (
                null
            );
            SELECT
                lastval() 
            INTO NEW.DS_ID;
        -- if anchor ID is provided then let''s insert it into the anchor table
        -- but only if that ID is not present in the anchor table
        ELSE
            INSERT INTO dbo.DS_DIMsupplier (
                DS_ID
            )
            SELECT
                NEW.DS_ID
            WHERE NOT EXISTS(
	            SELECT
	                DS_ID 
	            FROM dbo.DS_DIMsupplier
	            WHERE DS_ID = NEW.DS_ID
	            LIMIT 1
            );
        END IF;
        -- insert row into temporary table
    	INSERT INTO _tmp_it_DS_DIMsupplier (
            DS_ID,
            DS_REG_DS_ID,
            DS_REG_DIMsupplier_Region,
            DS_CIT_DS_ID,
            DS_CIT_DIMsupplier_City,
            DS_NAT_DS_ID,
            DS_NAT_DIMsupplier_Nation,
            DS_PHN_DS_ID,
            DS_PHN_DIMsupplier_Phone,
            DS_ADD_DS_ID,
            DS_ADD_DIMsupplier_Address,
            DS_NAM_DS_ID,
            DS_NAM_DIMsupplier_Name
    	) VALUES (
    	    NEW.DS_ID,
            COALESCE(NEW.DS_REG_DS_ID, NEW.DS_ID),
            NEW.DS_REG_DIMsupplier_Region,
            COALESCE(NEW.DS_CIT_DS_ID, NEW.DS_ID),
            NEW.DS_CIT_DIMsupplier_City,
            COALESCE(NEW.DS_NAT_DS_ID, NEW.DS_ID),
            NEW.DS_NAT_DIMsupplier_Nation,
            COALESCE(NEW.DS_PHN_DS_ID, NEW.DS_ID),
            NEW.DS_PHN_DIMsupplier_Phone,
            COALESCE(NEW.DS_ADD_DS_ID, NEW.DS_ID),
            NEW.DS_ADD_DIMsupplier_Address,
            COALESCE(NEW.DS_NAM_DS_ID, NEW.DS_ID),
            NEW.DS_NAM_DIMsupplier_Name
    	);
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER iti_lDS_DIMsupplier
INSTEAD OF INSERT ON dbo.lDS_DIMsupplier
FOR EACH ROW
EXECUTE PROCEDURE dbo.iti_lDS_DIMsupplier();
-- AFTER INSERT trigger ---------------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS ita_lDS_DIMsupplier ON dbo.lDS_DIMsupplier;
--DROP FUNCTION IF EXISTS dbo.ita_lDS_DIMsupplier();
CREATE OR REPLACE FUNCTION dbo.ita_lDS_DIMsupplier() RETURNS trigger AS '
    BEGIN
        INSERT INTO dbo.DS_REG_DIMsupplier_Region (
            DS_REG_DS_ID,
            DS_REG_DIMsupplier_Region
        )
        SELECT
            i.DS_REG_DS_ID,
            i.DS_REG_DIMsupplier_Region
        FROM
            _tmp_it_DS_DIMsupplier i
        WHERE
            i.DS_REG_DIMsupplier_Region is not null;
        INSERT INTO dbo.DS_CIT_DIMsupplier_City (
            DS_CIT_DS_ID,
            DS_CIT_DIMsupplier_City
        )
        SELECT
            i.DS_CIT_DS_ID,
            i.DS_CIT_DIMsupplier_City
        FROM
            _tmp_it_DS_DIMsupplier i
        WHERE
            i.DS_CIT_DIMsupplier_City is not null;
        INSERT INTO dbo.DS_NAT_DIMsupplier_Nation (
            DS_NAT_DS_ID,
            DS_NAT_DIMsupplier_Nation
        )
        SELECT
            i.DS_NAT_DS_ID,
            i.DS_NAT_DIMsupplier_Nation
        FROM
            _tmp_it_DS_DIMsupplier i
        WHERE
            i.DS_NAT_DIMsupplier_Nation is not null;
        INSERT INTO dbo.DS_PHN_DIMsupplier_Phone (
            DS_PHN_DS_ID,
            DS_PHN_DIMsupplier_Phone
        )
        SELECT
            i.DS_PHN_DS_ID,
            i.DS_PHN_DIMsupplier_Phone
        FROM
            _tmp_it_DS_DIMsupplier i
        WHERE
            i.DS_PHN_DIMsupplier_Phone is not null;
        INSERT INTO dbo.DS_ADD_DIMsupplier_Address (
            DS_ADD_DS_ID,
            DS_ADD_DIMsupplier_Address
        )
        SELECT
            i.DS_ADD_DS_ID,
            i.DS_ADD_DIMsupplier_Address
        FROM
            _tmp_it_DS_DIMsupplier i
        WHERE
            i.DS_ADD_DIMsupplier_Address is not null;
        INSERT INTO dbo.DS_NAM_DIMsupplier_Name (
            DS_NAM_DS_ID,
            DS_NAM_DIMsupplier_Name
        )
        SELECT
            i.DS_NAM_DS_ID,
            i.DS_NAM_DIMsupplier_Name
        FROM
            _tmp_it_DS_DIMsupplier i
        WHERE
            i.DS_NAM_DIMsupplier_Name is not null;
        DROP TABLE IF EXISTS _tmp_it_DS_DIMsupplier;
        RETURN NULL;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER ita_lDS_DIMsupplier
AFTER INSERT ON dbo.lDS_DIMsupplier
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.ita_lDS_DIMsupplier();
-- BEFORE INSERT trigger --------------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS itb_lDD_DIMdate1 ON dbo.lDD_DIMdate1;
--DROP FUNCTION IF EXISTS dbo.itb_lDD_DIMdate1();
CREATE OR REPLACE FUNCTION dbo.itb_lDD_DIMdate1() RETURNS trigger AS '
    BEGIN
        -- create temporary table to keep inserted rows in
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_it_DD_DIMdate1 (
            DD_ID int not null,
            DD_DAT_DD_ID int null,
            DD_DAT_DIMdate1_Date Varchar(18) null,
            DD_YMN_DD_ID int null,
            DD_YMN_DIMdate1_Yearmonthnum Numeric(14) null,
            DD_MTH_DD_ID int null,
            DD_MTH_DIMdate1_Month Varchar(9) null,
            DD_DOW_DD_ID int null,
            DD_DOW_DIMdate1_Dayofweek Varchar(9) null,
            DD_DNW_DD_ID int null,
            DD_DNW_DIMdate1_Daynuminweek Numeric(7) null,
            DD_YMM_DD_ID int null,
            DD_YMM_DIMdate1_Yearmonth Varchar(7) null,
            DD_YRS_DD_ID int null,
            DD_YRS_DIMdate1_Year smallint null,
            DD_DNM_DD_ID int null,
            DD_DNM_DIMdate1_Daynuminmonth Numeric(31) null,
            DD_DNY_DD_ID int null,
            DD_DNY_DIMdate1_Daynuminyear Numeric(31) null,
            DD_DMY_DD_ID int null,
            DD_DMY_DIMdate1_Monthnuminyear Numeric(12) null,
            DD_WNY_DD_ID int null,
            DD_WNY_DIMdate1_Weeknuminyear Numeric(53) null,
            DD_SSA_DD_ID int null,
            DD_SSA_DIMdate1_Sellingseason Varchar(12) null,
            DD_LFL_DD_ID int null,
            DD_LFL_DIMdate1_Lastdayinweekfl char(1) null,
            DD_LDL_DD_ID int null,
            DD_LDL_DIMdate1_Lastdayinmonthfl char(1) null,
            DD_HOF_DD_ID int null,
            DD_HOF_DIMdate1_Holydayfl char(1) null,
            DD_WDF_DD_ID int null,
            DD_WDF_DIMdate1_Weekdayfl char(1) null
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER itb_lDD_DIMdate1
BEFORE INSERT ON dbo.lDD_DIMdate1
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.itb_lDD_DIMdate1(); 
-- INSTEAD OF INSERT trigger ----------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS iti_lDD_DIMdate1 ON dbo.lDD_DIMdate1;
--DROP FUNCTION IF EXISTS dbo.iti_lDD_DIMdate1();
CREATE OR REPLACE FUNCTION dbo.iti_lDD_DIMdate1() RETURNS trigger AS '
    BEGIN
        -- generate anchor ID (if not provided)
        IF (NEW.DD_ID IS NULL) THEN 
            INSERT INTO dbo.DD_DIMdate1 (
                DD_Dummy
            ) VALUES (
                null
            );
            SELECT
                lastval() 
            INTO NEW.DD_ID;
        -- if anchor ID is provided then let''s insert it into the anchor table
        -- but only if that ID is not present in the anchor table
        ELSE
            INSERT INTO dbo.DD_DIMdate1 (
                DD_ID
            )
            SELECT
                NEW.DD_ID
            WHERE NOT EXISTS(
	            SELECT
	                DD_ID 
	            FROM dbo.DD_DIMdate1
	            WHERE DD_ID = NEW.DD_ID
	            LIMIT 1
            );
        END IF;
        -- insert row into temporary table
    	INSERT INTO _tmp_it_DD_DIMdate1 (
            DD_ID,
            DD_DAT_DD_ID,
            DD_DAT_DIMdate1_Date,
            DD_YMN_DD_ID,
            DD_YMN_DIMdate1_Yearmonthnum,
            DD_MTH_DD_ID,
            DD_MTH_DIMdate1_Month,
            DD_DOW_DD_ID,
            DD_DOW_DIMdate1_Dayofweek,
            DD_DNW_DD_ID,
            DD_DNW_DIMdate1_Daynuminweek,
            DD_YMM_DD_ID,
            DD_YMM_DIMdate1_Yearmonth,
            DD_YRS_DD_ID,
            DD_YRS_DIMdate1_Year,
            DD_DNM_DD_ID,
            DD_DNM_DIMdate1_Daynuminmonth,
            DD_DNY_DD_ID,
            DD_DNY_DIMdate1_Daynuminyear,
            DD_DMY_DD_ID,
            DD_DMY_DIMdate1_Monthnuminyear,
            DD_WNY_DD_ID,
            DD_WNY_DIMdate1_Weeknuminyear,
            DD_SSA_DD_ID,
            DD_SSA_DIMdate1_Sellingseason,
            DD_LFL_DD_ID,
            DD_LFL_DIMdate1_Lastdayinweekfl,
            DD_LDL_DD_ID,
            DD_LDL_DIMdate1_Lastdayinmonthfl,
            DD_HOF_DD_ID,
            DD_HOF_DIMdate1_Holydayfl,
            DD_WDF_DD_ID,
            DD_WDF_DIMdate1_Weekdayfl
    	) VALUES (
    	    NEW.DD_ID,
            COALESCE(NEW.DD_DAT_DD_ID, NEW.DD_ID),
            NEW.DD_DAT_DIMdate1_Date,
            COALESCE(NEW.DD_YMN_DD_ID, NEW.DD_ID),
            NEW.DD_YMN_DIMdate1_Yearmonthnum,
            COALESCE(NEW.DD_MTH_DD_ID, NEW.DD_ID),
            NEW.DD_MTH_DIMdate1_Month,
            COALESCE(NEW.DD_DOW_DD_ID, NEW.DD_ID),
            NEW.DD_DOW_DIMdate1_Dayofweek,
            COALESCE(NEW.DD_DNW_DD_ID, NEW.DD_ID),
            NEW.DD_DNW_DIMdate1_Daynuminweek,
            COALESCE(NEW.DD_YMM_DD_ID, NEW.DD_ID),
            NEW.DD_YMM_DIMdate1_Yearmonth,
            COALESCE(NEW.DD_YRS_DD_ID, NEW.DD_ID),
            NEW.DD_YRS_DIMdate1_Year,
            COALESCE(NEW.DD_DNM_DD_ID, NEW.DD_ID),
            NEW.DD_DNM_DIMdate1_Daynuminmonth,
            COALESCE(NEW.DD_DNY_DD_ID, NEW.DD_ID),
            NEW.DD_DNY_DIMdate1_Daynuminyear,
            COALESCE(NEW.DD_DMY_DD_ID, NEW.DD_ID),
            NEW.DD_DMY_DIMdate1_Monthnuminyear,
            COALESCE(NEW.DD_WNY_DD_ID, NEW.DD_ID),
            NEW.DD_WNY_DIMdate1_Weeknuminyear,
            COALESCE(NEW.DD_SSA_DD_ID, NEW.DD_ID),
            NEW.DD_SSA_DIMdate1_Sellingseason,
            COALESCE(NEW.DD_LFL_DD_ID, NEW.DD_ID),
            NEW.DD_LFL_DIMdate1_Lastdayinweekfl,
            COALESCE(NEW.DD_LDL_DD_ID, NEW.DD_ID),
            NEW.DD_LDL_DIMdate1_Lastdayinmonthfl,
            COALESCE(NEW.DD_HOF_DD_ID, NEW.DD_ID),
            NEW.DD_HOF_DIMdate1_Holydayfl,
            COALESCE(NEW.DD_WDF_DD_ID, NEW.DD_ID),
            NEW.DD_WDF_DIMdate1_Weekdayfl
    	);
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER iti_lDD_DIMdate1
INSTEAD OF INSERT ON dbo.lDD_DIMdate1
FOR EACH ROW
EXECUTE PROCEDURE dbo.iti_lDD_DIMdate1();
-- AFTER INSERT trigger ---------------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS ita_lDD_DIMdate1 ON dbo.lDD_DIMdate1;
--DROP FUNCTION IF EXISTS dbo.ita_lDD_DIMdate1();
CREATE OR REPLACE FUNCTION dbo.ita_lDD_DIMdate1() RETURNS trigger AS '
    BEGIN
        INSERT INTO dbo.DD_DAT_DIMdate1_Date (
            DD_DAT_DD_ID,
            DD_DAT_DIMdate1_Date
        )
        SELECT
            i.DD_DAT_DD_ID,
            i.DD_DAT_DIMdate1_Date
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_DAT_DIMdate1_Date is not null;
        INSERT INTO dbo.DD_YMN_DIMdate1_Yearmonthnum (
            DD_YMN_DD_ID,
            DD_YMN_DIMdate1_Yearmonthnum
        )
        SELECT
            i.DD_YMN_DD_ID,
            i.DD_YMN_DIMdate1_Yearmonthnum
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_YMN_DIMdate1_Yearmonthnum is not null;
        INSERT INTO dbo.DD_MTH_DIMdate1_Month (
            DD_MTH_DD_ID,
            DD_MTH_DIMdate1_Month
        )
        SELECT
            i.DD_MTH_DD_ID,
            i.DD_MTH_DIMdate1_Month
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_MTH_DIMdate1_Month is not null;
        INSERT INTO dbo.DD_DOW_DIMdate1_Dayofweek (
            DD_DOW_DD_ID,
            DD_DOW_DIMdate1_Dayofweek
        )
        SELECT
            i.DD_DOW_DD_ID,
            i.DD_DOW_DIMdate1_Dayofweek
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_DOW_DIMdate1_Dayofweek is not null;
        INSERT INTO dbo.DD_DNW_DIMdate1_Daynuminweek (
            DD_DNW_DD_ID,
            DD_DNW_DIMdate1_Daynuminweek
        )
        SELECT
            i.DD_DNW_DD_ID,
            i.DD_DNW_DIMdate1_Daynuminweek
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_DNW_DIMdate1_Daynuminweek is not null;
        INSERT INTO dbo.DD_YMM_DIMdate1_Yearmonth (
            DD_YMM_DD_ID,
            DD_YMM_DIMdate1_Yearmonth
        )
        SELECT
            i.DD_YMM_DD_ID,
            i.DD_YMM_DIMdate1_Yearmonth
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_YMM_DIMdate1_Yearmonth is not null;
        INSERT INTO dbo.DD_YRS_DIMdate1_Year (
            DD_YRS_DD_ID,
            DD_YRS_DIMdate1_Year
        )
        SELECT
            i.DD_YRS_DD_ID,
            i.DD_YRS_DIMdate1_Year
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_YRS_DIMdate1_Year is not null;
        INSERT INTO dbo.DD_DNM_DIMdate1_Daynuminmonth (
            DD_DNM_DD_ID,
            DD_DNM_DIMdate1_Daynuminmonth
        )
        SELECT
            i.DD_DNM_DD_ID,
            i.DD_DNM_DIMdate1_Daynuminmonth
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_DNM_DIMdate1_Daynuminmonth is not null;
        INSERT INTO dbo.DD_DNY_DIMdate1_Daynuminyear (
            DD_DNY_DD_ID,
            DD_DNY_DIMdate1_Daynuminyear
        )
        SELECT
            i.DD_DNY_DD_ID,
            i.DD_DNY_DIMdate1_Daynuminyear
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_DNY_DIMdate1_Daynuminyear is not null;
        INSERT INTO dbo.DD_DMY_DIMdate1_Monthnuminyear (
            DD_DMY_DD_ID,
            DD_DMY_DIMdate1_Monthnuminyear
        )
        SELECT
            i.DD_DMY_DD_ID,
            i.DD_DMY_DIMdate1_Monthnuminyear
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_DMY_DIMdate1_Monthnuminyear is not null;
        INSERT INTO dbo.DD_WNY_DIMdate1_Weeknuminyear (
            DD_WNY_DD_ID,
            DD_WNY_DIMdate1_Weeknuminyear
        )
        SELECT
            i.DD_WNY_DD_ID,
            i.DD_WNY_DIMdate1_Weeknuminyear
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_WNY_DIMdate1_Weeknuminyear is not null;
        INSERT INTO dbo.DD_SSA_DIMdate1_Sellingseason (
            DD_SSA_DD_ID,
            DD_SSA_DIMdate1_Sellingseason
        )
        SELECT
            i.DD_SSA_DD_ID,
            i.DD_SSA_DIMdate1_Sellingseason
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_SSA_DIMdate1_Sellingseason is not null;
        INSERT INTO dbo.DD_LFL_DIMdate1_Lastdayinweekfl (
            DD_LFL_DD_ID,
            DD_LFL_DIMdate1_Lastdayinweekfl
        )
        SELECT
            i.DD_LFL_DD_ID,
            i.DD_LFL_DIMdate1_Lastdayinweekfl
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_LFL_DIMdate1_Lastdayinweekfl is not null;
        INSERT INTO dbo.DD_LDL_DIMdate1_Lastdayinmonthfl (
            DD_LDL_DD_ID,
            DD_LDL_DIMdate1_Lastdayinmonthfl
        )
        SELECT
            i.DD_LDL_DD_ID,
            i.DD_LDL_DIMdate1_Lastdayinmonthfl
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_LDL_DIMdate1_Lastdayinmonthfl is not null;
        INSERT INTO dbo.DD_HOF_DIMdate1_Holydayfl (
            DD_HOF_DD_ID,
            DD_HOF_DIMdate1_Holydayfl
        )
        SELECT
            i.DD_HOF_DD_ID,
            i.DD_HOF_DIMdate1_Holydayfl
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_HOF_DIMdate1_Holydayfl is not null;
        INSERT INTO dbo.DD_WDF_DIMdate1_Weekdayfl (
            DD_WDF_DD_ID,
            DD_WDF_DIMdate1_Weekdayfl
        )
        SELECT
            i.DD_WDF_DD_ID,
            i.DD_WDF_DIMdate1_Weekdayfl
        FROM
            _tmp_it_DD_DIMdate1 i
        WHERE
            i.DD_WDF_DIMdate1_Weekdayfl is not null;
        DROP TABLE IF EXISTS _tmp_it_DD_DIMdate1;
        RETURN NULL;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER ita_lDD_DIMdate1
AFTER INSERT ON dbo.lDD_DIMdate1
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.ita_lDD_DIMdate1();
-- BEFORE INSERT trigger --------------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS itb_lDP_DIMpart ON dbo.lDP_DIMpart;
--DROP FUNCTION IF EXISTS dbo.itb_lDP_DIMpart();
CREATE OR REPLACE FUNCTION dbo.itb_lDP_DIMpart() RETURNS trigger AS '
    BEGIN
        -- create temporary table to keep inserted rows in
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_it_DP_DIMpart (
            DP_ID int not null,
            DP_NAM_DP_ID int null,
            DP_NAM_DIMpart_Name varchar(22) null,
            DP_MTG_DP_ID int null,
            DP_MTG_DIMpart_Mfgr Varchar(6) null,
            DP_CAT_DP_ID int null,
            DP_CAT_DIMpart_Category Varchar(7) null,
            DP_BRA_DP_ID int null,
            DP_BRA_DIMpart_Brand1 Varchar(9) null,
            DP_COL_DP_ID int null,
            DP_COL_DIMpart_Color Varchar(11) null,
            DP_TYP_DP_ID int null,
            DP_TYP_DIMpart_Type Varchar(25) null,
            DP_SIZ_DP_ID int null,
            DP_SIZ_DIMpart_Size Numeric(50) null,
            DP_CON_DP_ID int null,
            DP_CON_DIMpart_Container Char(10) null
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER itb_lDP_DIMpart
BEFORE INSERT ON dbo.lDP_DIMpart
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.itb_lDP_DIMpart(); 
-- INSTEAD OF INSERT trigger ----------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS iti_lDP_DIMpart ON dbo.lDP_DIMpart;
--DROP FUNCTION IF EXISTS dbo.iti_lDP_DIMpart();
CREATE OR REPLACE FUNCTION dbo.iti_lDP_DIMpart() RETURNS trigger AS '
    BEGIN
        -- generate anchor ID (if not provided)
        IF (NEW.DP_ID IS NULL) THEN 
            INSERT INTO dbo.DP_DIMpart (
                DP_Dummy
            ) VALUES (
                null
            );
            SELECT
                lastval() 
            INTO NEW.DP_ID;
        -- if anchor ID is provided then let''s insert it into the anchor table
        -- but only if that ID is not present in the anchor table
        ELSE
            INSERT INTO dbo.DP_DIMpart (
                DP_ID
            )
            SELECT
                NEW.DP_ID
            WHERE NOT EXISTS(
	            SELECT
	                DP_ID 
	            FROM dbo.DP_DIMpart
	            WHERE DP_ID = NEW.DP_ID
	            LIMIT 1
            );
        END IF;
        -- insert row into temporary table
    	INSERT INTO _tmp_it_DP_DIMpart (
            DP_ID,
            DP_NAM_DP_ID,
            DP_NAM_DIMpart_Name,
            DP_MTG_DP_ID,
            DP_MTG_DIMpart_Mfgr,
            DP_CAT_DP_ID,
            DP_CAT_DIMpart_Category,
            DP_BRA_DP_ID,
            DP_BRA_DIMpart_Brand1,
            DP_COL_DP_ID,
            DP_COL_DIMpart_Color,
            DP_TYP_DP_ID,
            DP_TYP_DIMpart_Type,
            DP_SIZ_DP_ID,
            DP_SIZ_DIMpart_Size,
            DP_CON_DP_ID,
            DP_CON_DIMpart_Container
    	) VALUES (
    	    NEW.DP_ID,
            COALESCE(NEW.DP_NAM_DP_ID, NEW.DP_ID),
            NEW.DP_NAM_DIMpart_Name,
            COALESCE(NEW.DP_MTG_DP_ID, NEW.DP_ID),
            NEW.DP_MTG_DIMpart_Mfgr,
            COALESCE(NEW.DP_CAT_DP_ID, NEW.DP_ID),
            NEW.DP_CAT_DIMpart_Category,
            COALESCE(NEW.DP_BRA_DP_ID, NEW.DP_ID),
            NEW.DP_BRA_DIMpart_Brand1,
            COALESCE(NEW.DP_COL_DP_ID, NEW.DP_ID),
            NEW.DP_COL_DIMpart_Color,
            COALESCE(NEW.DP_TYP_DP_ID, NEW.DP_ID),
            NEW.DP_TYP_DIMpart_Type,
            COALESCE(NEW.DP_SIZ_DP_ID, NEW.DP_ID),
            NEW.DP_SIZ_DIMpart_Size,
            COALESCE(NEW.DP_CON_DP_ID, NEW.DP_ID),
            NEW.DP_CON_DIMpart_Container
    	);
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER iti_lDP_DIMpart
INSTEAD OF INSERT ON dbo.lDP_DIMpart
FOR EACH ROW
EXECUTE PROCEDURE dbo.iti_lDP_DIMpart();
-- AFTER INSERT trigger ---------------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS ita_lDP_DIMpart ON dbo.lDP_DIMpart;
--DROP FUNCTION IF EXISTS dbo.ita_lDP_DIMpart();
CREATE OR REPLACE FUNCTION dbo.ita_lDP_DIMpart() RETURNS trigger AS '
    BEGIN
        INSERT INTO dbo.DP_NAM_DIMpart_Name (
            DP_NAM_DP_ID,
            DP_NAM_DIMpart_Name
        )
        SELECT
            i.DP_NAM_DP_ID,
            i.DP_NAM_DIMpart_Name
        FROM
            _tmp_it_DP_DIMpart i
        WHERE
            i.DP_NAM_DIMpart_Name is not null;
        INSERT INTO dbo.DP_MTG_DIMpart_Mfgr (
            DP_MTG_DP_ID,
            DP_MTG_DIMpart_Mfgr
        )
        SELECT
            i.DP_MTG_DP_ID,
            i.DP_MTG_DIMpart_Mfgr
        FROM
            _tmp_it_DP_DIMpart i
        WHERE
            i.DP_MTG_DIMpart_Mfgr is not null;
        INSERT INTO dbo.DP_CAT_DIMpart_Category (
            DP_CAT_DP_ID,
            DP_CAT_DIMpart_Category
        )
        SELECT
            i.DP_CAT_DP_ID,
            i.DP_CAT_DIMpart_Category
        FROM
            _tmp_it_DP_DIMpart i
        WHERE
            i.DP_CAT_DIMpart_Category is not null;
        INSERT INTO dbo.DP_BRA_DIMpart_Brand1 (
            DP_BRA_DP_ID,
            DP_BRA_DIMpart_Brand1
        )
        SELECT
            i.DP_BRA_DP_ID,
            i.DP_BRA_DIMpart_Brand1
        FROM
            _tmp_it_DP_DIMpart i
        WHERE
            i.DP_BRA_DIMpart_Brand1 is not null;
        INSERT INTO dbo.DP_COL_DIMpart_Color (
            DP_COL_DP_ID,
            DP_COL_DIMpart_Color
        )
        SELECT
            i.DP_COL_DP_ID,
            i.DP_COL_DIMpart_Color
        FROM
            _tmp_it_DP_DIMpart i
        WHERE
            i.DP_COL_DIMpart_Color is not null;
        INSERT INTO dbo.DP_TYP_DIMpart_Type (
            DP_TYP_DP_ID,
            DP_TYP_DIMpart_Type
        )
        SELECT
            i.DP_TYP_DP_ID,
            i.DP_TYP_DIMpart_Type
        FROM
            _tmp_it_DP_DIMpart i
        WHERE
            i.DP_TYP_DIMpart_Type is not null;
        INSERT INTO dbo.DP_SIZ_DIMpart_Size (
            DP_SIZ_DP_ID,
            DP_SIZ_DIMpart_Size
        )
        SELECT
            i.DP_SIZ_DP_ID,
            i.DP_SIZ_DIMpart_Size
        FROM
            _tmp_it_DP_DIMpart i
        WHERE
            i.DP_SIZ_DIMpart_Size is not null;
        INSERT INTO dbo.DP_CON_DIMpart_Container (
            DP_CON_DP_ID,
            DP_CON_DIMpart_Container
        )
        SELECT
            i.DP_CON_DP_ID,
            i.DP_CON_DIMpart_Container
        FROM
            _tmp_it_DP_DIMpart i
        WHERE
            i.DP_CON_DIMpart_Container is not null;
        DROP TABLE IF EXISTS _tmp_it_DP_DIMpart;
        RETURN NULL;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER ita_lDP_DIMpart
AFTER INSERT ON dbo.lDP_DIMpart
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.ita_lDP_DIMpart();
-- BEFORE INSERT trigger --------------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS itb_lFL_FACTlineorder ON dbo.lFL_FACTlineorder;
--DROP FUNCTION IF EXISTS dbo.itb_lFL_FACTlineorder();
CREATE OR REPLACE FUNCTION dbo.itb_lFL_FACTlineorder() RETURNS trigger AS '
    BEGIN
        -- create temporary table to keep inserted rows in
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_it_FL_FACTlineorder (
            FL_ID int not null,
            FL_SHP_FL_ID int null,
            FL_SHP_FACTlineorder_Shippriority Char(1) null,
            FL_OPY_FL_ID int null,
            FL_OPY_FACTlineorder_Orderpriority Char(15) null,
            FL_LNB_FL_ID int null,
            FL_LNB_FACTlineorder_Linenumber numeric(7) null,
            FL_TXA_FL_ID int null,
            FL_TXA_FACTlineorder_Tax numeric(8) null,
            FL_QTY_FL_ID int null,
            FL_QTY_FACTlineorder_Quantity Numeric(50) null,
            FL_EPR_FL_ID int null,
            FL_EPR_FACTlineorder_Extendedprice numeric(200) null,
            FL_OTP_FL_ID int null,
            FL_OTP_FACTlineorder_Ordtotalprice Numeric(200) null,
            FL_DSC_FL_ID int null,
            FL_DSC_FACTlineorder_Discount Numeric(10) null,
            FL_SCT_FL_ID int null,
            FL_SCT_FACTlineorder_Supplycost Numeric(200) null,
            FL_SHM_FL_ID int null,
            FL_SHM_FACTlineorder_Shipmode char(10) null,
            FL_RVN_FL_ID int null,
            FL_RVN_FACTlineorder_Revenue numeric null
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER itb_lFL_FACTlineorder
BEFORE INSERT ON dbo.lFL_FACTlineorder
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.itb_lFL_FACTlineorder(); 
-- INSTEAD OF INSERT trigger ----------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS iti_lFL_FACTlineorder ON dbo.lFL_FACTlineorder;
--DROP FUNCTION IF EXISTS dbo.iti_lFL_FACTlineorder();
CREATE OR REPLACE FUNCTION dbo.iti_lFL_FACTlineorder() RETURNS trigger AS '
    BEGIN
        -- generate anchor ID (if not provided)
        IF (NEW.FL_ID IS NULL) THEN 
            INSERT INTO dbo.FL_FACTlineorder (
                FL_Dummy
            ) VALUES (
                null
            );
            SELECT
                lastval() 
            INTO NEW.FL_ID;
        -- if anchor ID is provided then let''s insert it into the anchor table
        -- but only if that ID is not present in the anchor table
        ELSE
            INSERT INTO dbo.FL_FACTlineorder (
                FL_ID
            )
            SELECT
                NEW.FL_ID
            WHERE NOT EXISTS(
	            SELECT
	                FL_ID 
	            FROM dbo.FL_FACTlineorder
	            WHERE FL_ID = NEW.FL_ID
	            LIMIT 1
            );
        END IF;
        -- insert row into temporary table
    	INSERT INTO _tmp_it_FL_FACTlineorder (
            FL_ID,
            FL_SHP_FL_ID,
            FL_SHP_FACTlineorder_Shippriority,
            FL_OPY_FL_ID,
            FL_OPY_FACTlineorder_Orderpriority,
            FL_LNB_FL_ID,
            FL_LNB_FACTlineorder_Linenumber,
            FL_TXA_FL_ID,
            FL_TXA_FACTlineorder_Tax,
            FL_QTY_FL_ID,
            FL_QTY_FACTlineorder_Quantity,
            FL_EPR_FL_ID,
            FL_EPR_FACTlineorder_Extendedprice,
            FL_OTP_FL_ID,
            FL_OTP_FACTlineorder_Ordtotalprice,
            FL_DSC_FL_ID,
            FL_DSC_FACTlineorder_Discount,
            FL_SCT_FL_ID,
            FL_SCT_FACTlineorder_Supplycost,
            FL_SHM_FL_ID,
            FL_SHM_FACTlineorder_Shipmode,
            FL_RVN_FL_ID,
            FL_RVN_FACTlineorder_Revenue
    	) VALUES (
    	    NEW.FL_ID,
            COALESCE(NEW.FL_SHP_FL_ID, NEW.FL_ID),
            NEW.FL_SHP_FACTlineorder_Shippriority,
            COALESCE(NEW.FL_OPY_FL_ID, NEW.FL_ID),
            NEW.FL_OPY_FACTlineorder_Orderpriority,
            COALESCE(NEW.FL_LNB_FL_ID, NEW.FL_ID),
            NEW.FL_LNB_FACTlineorder_Linenumber,
            COALESCE(NEW.FL_TXA_FL_ID, NEW.FL_ID),
            NEW.FL_TXA_FACTlineorder_Tax,
            COALESCE(NEW.FL_QTY_FL_ID, NEW.FL_ID),
            NEW.FL_QTY_FACTlineorder_Quantity,
            COALESCE(NEW.FL_EPR_FL_ID, NEW.FL_ID),
            NEW.FL_EPR_FACTlineorder_Extendedprice,
            COALESCE(NEW.FL_OTP_FL_ID, NEW.FL_ID),
            NEW.FL_OTP_FACTlineorder_Ordtotalprice,
            COALESCE(NEW.FL_DSC_FL_ID, NEW.FL_ID),
            NEW.FL_DSC_FACTlineorder_Discount,
            COALESCE(NEW.FL_SCT_FL_ID, NEW.FL_ID),
            NEW.FL_SCT_FACTlineorder_Supplycost,
            COALESCE(NEW.FL_SHM_FL_ID, NEW.FL_ID),
            NEW.FL_SHM_FACTlineorder_Shipmode,
            COALESCE(NEW.FL_RVN_FL_ID, NEW.FL_ID),
            NEW.FL_RVN_FACTlineorder_Revenue
    	);
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER iti_lFL_FACTlineorder
INSTEAD OF INSERT ON dbo.lFL_FACTlineorder
FOR EACH ROW
EXECUTE PROCEDURE dbo.iti_lFL_FACTlineorder();
-- AFTER INSERT trigger ---------------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS ita_lFL_FACTlineorder ON dbo.lFL_FACTlineorder;
--DROP FUNCTION IF EXISTS dbo.ita_lFL_FACTlineorder();
CREATE OR REPLACE FUNCTION dbo.ita_lFL_FACTlineorder() RETURNS trigger AS '
    BEGIN
        INSERT INTO dbo.FL_SHP_FACTlineorder_Shippriority (
            FL_SHP_FL_ID,
            FL_SHP_FACTlineorder_Shippriority
        )
        SELECT
            i.FL_SHP_FL_ID,
            i.FL_SHP_FACTlineorder_Shippriority
        FROM
            _tmp_it_FL_FACTlineorder i
        WHERE
            i.FL_SHP_FACTlineorder_Shippriority is not null;
        INSERT INTO dbo.FL_OPY_FACTlineorder_Orderpriority (
            FL_OPY_FL_ID,
            FL_OPY_FACTlineorder_Orderpriority
        )
        SELECT
            i.FL_OPY_FL_ID,
            i.FL_OPY_FACTlineorder_Orderpriority
        FROM
            _tmp_it_FL_FACTlineorder i
        WHERE
            i.FL_OPY_FACTlineorder_Orderpriority is not null;
        INSERT INTO dbo.FL_LNB_FACTlineorder_Linenumber (
            FL_LNB_FL_ID,
            FL_LNB_FACTlineorder_Linenumber
        )
        SELECT
            i.FL_LNB_FL_ID,
            i.FL_LNB_FACTlineorder_Linenumber
        FROM
            _tmp_it_FL_FACTlineorder i
        WHERE
            i.FL_LNB_FACTlineorder_Linenumber is not null;
        INSERT INTO dbo.FL_TXA_FACTlineorder_Tax (
            FL_TXA_FL_ID,
            FL_TXA_FACTlineorder_Tax
        )
        SELECT
            i.FL_TXA_FL_ID,
            i.FL_TXA_FACTlineorder_Tax
        FROM
            _tmp_it_FL_FACTlineorder i
        WHERE
            i.FL_TXA_FACTlineorder_Tax is not null;
        INSERT INTO dbo.FL_QTY_FACTlineorder_Quantity (
            FL_QTY_FL_ID,
            FL_QTY_FACTlineorder_Quantity
        )
        SELECT
            i.FL_QTY_FL_ID,
            i.FL_QTY_FACTlineorder_Quantity
        FROM
            _tmp_it_FL_FACTlineorder i
        WHERE
            i.FL_QTY_FACTlineorder_Quantity is not null;
        INSERT INTO dbo.FL_EPR_FACTlineorder_Extendedprice (
            FL_EPR_FL_ID,
            FL_EPR_FACTlineorder_Extendedprice
        )
        SELECT
            i.FL_EPR_FL_ID,
            i.FL_EPR_FACTlineorder_Extendedprice
        FROM
            _tmp_it_FL_FACTlineorder i
        WHERE
            i.FL_EPR_FACTlineorder_Extendedprice is not null;
        INSERT INTO dbo.FL_OTP_FACTlineorder_Ordtotalprice (
            FL_OTP_FL_ID,
            FL_OTP_FACTlineorder_Ordtotalprice
        )
        SELECT
            i.FL_OTP_FL_ID,
            i.FL_OTP_FACTlineorder_Ordtotalprice
        FROM
            _tmp_it_FL_FACTlineorder i
        WHERE
            i.FL_OTP_FACTlineorder_Ordtotalprice is not null;
        INSERT INTO dbo.FL_DSC_FACTlineorder_Discount (
            FL_DSC_FL_ID,
            FL_DSC_FACTlineorder_Discount
        )
        SELECT
            i.FL_DSC_FL_ID,
            i.FL_DSC_FACTlineorder_Discount
        FROM
            _tmp_it_FL_FACTlineorder i
        WHERE
            i.FL_DSC_FACTlineorder_Discount is not null;
        INSERT INTO dbo.FL_SCT_FACTlineorder_Supplycost (
            FL_SCT_FL_ID,
            FL_SCT_FACTlineorder_Supplycost
        )
        SELECT
            i.FL_SCT_FL_ID,
            i.FL_SCT_FACTlineorder_Supplycost
        FROM
            _tmp_it_FL_FACTlineorder i
        WHERE
            i.FL_SCT_FACTlineorder_Supplycost is not null;
        INSERT INTO dbo.FL_SHM_FACTlineorder_Shipmode (
            FL_SHM_FL_ID,
            FL_SHM_FACTlineorder_Shipmode
        )
        SELECT
            i.FL_SHM_FL_ID,
            i.FL_SHM_FACTlineorder_Shipmode
        FROM
            _tmp_it_FL_FACTlineorder i
        WHERE
            i.FL_SHM_FACTlineorder_Shipmode is not null;
        INSERT INTO dbo.FL_RVN_FACTlineorder_Revenue (
            FL_RVN_FL_ID,
            FL_RVN_FACTlineorder_Revenue
        )
        SELECT
            i.FL_RVN_FL_ID,
            i.FL_RVN_FACTlineorder_Revenue
        FROM
            _tmp_it_FL_FACTlineorder i
        WHERE
            i.FL_RVN_FACTlineorder_Revenue is not null;
        DROP TABLE IF EXISTS _tmp_it_FL_FACTlineorder;
        RETURN NULL;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER ita_lFL_FACTlineorder
AFTER INSERT ON dbo.lFL_FACTlineorder
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.ita_lFL_FACTlineorder();
-- BEFORE INSERT trigger --------------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS itb_lDA_Dimdate2 ON dbo.lDA_Dimdate2;
--DROP FUNCTION IF EXISTS dbo.itb_lDA_Dimdate2();
CREATE OR REPLACE FUNCTION dbo.itb_lDA_Dimdate2() RETURNS trigger AS '
    BEGIN
        -- create temporary table to keep inserted rows in
        CREATE TEMPORARY TABLE IF NOT EXISTS _tmp_it_DA_Dimdate2 (
            DA_ID int not null,
            DA_DNM_DA_ID int null,
            DA_DNM_Dimdate2_Daynuminmonth integer null,
            DA_WNY_DA_ID int null,
            DA_WNY_Dimdate2_Weeknuminyear integer null,
            DA_SSS_DA_ID int null,
            DA_SSS_Dimdate2_Sellingseasons text null,
            DA_LDF_DA_ID int null,
            DA_LDF_Dimdate2_Lastdayinweekfl char(1) null,
            DA_DAT_DA_ID int null,
            DA_DAT_Dimdate2_Date varchar(18) null,
            DA_DOW_DA_ID int null,
            DA_DOW_Dimdate2_Dayofweek varchar(9) null,
            DA_YRS_DA_ID int null,
            DA_YRS_Dimdate2_Year integer null,
            DA_YMN_DA_ID int null,
            DA_YMN_Dimdate2_Yearmonthnum Integer null,
            DA_MMM_DA_ID int null,
            DA_MMM_Dimdate2_Month varchar(9) null,
            DA_DNW_DA_ID int null,
            DA_DNW_Dimdate2_Daynuminweek integer null,
            DA_YMM_DA_ID int null,
            DA_YMM_Dimdate2_Yearmonth varchar(7) null,
            DA_MNY_DA_ID int null,
            DA_MNY_Dimdate2_Monthnuminyear integer null,
            DA_DNY_DA_ID int null,
            DA_DNY_Dimdate2_Daynuminyear integer null,
            DA_LIF_DA_ID int null,
            DA_LIF_Dimdate2_Lastdayinmonthfl char(1) null,
            DA_HFL_DA_ID int null,
            DA_HFL_Dimdate2_HolydayFL char(1) null,
            DA_WDF_DA_ID int null,
            DA_WDF_Dimdate2_Weekdayfl char(1) null
        ) ON COMMIT DROP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER itb_lDA_Dimdate2
BEFORE INSERT ON dbo.lDA_Dimdate2
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.itb_lDA_Dimdate2(); 
-- INSTEAD OF INSERT trigger ----------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS iti_lDA_Dimdate2 ON dbo.lDA_Dimdate2;
--DROP FUNCTION IF EXISTS dbo.iti_lDA_Dimdate2();
CREATE OR REPLACE FUNCTION dbo.iti_lDA_Dimdate2() RETURNS trigger AS '
    BEGIN
        -- generate anchor ID (if not provided)
        IF (NEW.DA_ID IS NULL) THEN 
            INSERT INTO dbo.DA_Dimdate2 (
                DA_Dummy
            ) VALUES (
                null
            );
            SELECT
                lastval() 
            INTO NEW.DA_ID;
        -- if anchor ID is provided then let''s insert it into the anchor table
        -- but only if that ID is not present in the anchor table
        ELSE
            INSERT INTO dbo.DA_Dimdate2 (
                DA_ID
            )
            SELECT
                NEW.DA_ID
            WHERE NOT EXISTS(
	            SELECT
	                DA_ID 
	            FROM dbo.DA_Dimdate2
	            WHERE DA_ID = NEW.DA_ID
	            LIMIT 1
            );
        END IF;
        -- insert row into temporary table
    	INSERT INTO _tmp_it_DA_Dimdate2 (
            DA_ID,
            DA_DNM_DA_ID,
            DA_DNM_Dimdate2_Daynuminmonth,
            DA_WNY_DA_ID,
            DA_WNY_Dimdate2_Weeknuminyear,
            DA_SSS_DA_ID,
            DA_SSS_Dimdate2_Sellingseasons,
            DA_LDF_DA_ID,
            DA_LDF_Dimdate2_Lastdayinweekfl,
            DA_DAT_DA_ID,
            DA_DAT_Dimdate2_Date,
            DA_DOW_DA_ID,
            DA_DOW_Dimdate2_Dayofweek,
            DA_YRS_DA_ID,
            DA_YRS_Dimdate2_Year,
            DA_YMN_DA_ID,
            DA_YMN_Dimdate2_Yearmonthnum,
            DA_MMM_DA_ID,
            DA_MMM_Dimdate2_Month,
            DA_DNW_DA_ID,
            DA_DNW_Dimdate2_Daynuminweek,
            DA_YMM_DA_ID,
            DA_YMM_Dimdate2_Yearmonth,
            DA_MNY_DA_ID,
            DA_MNY_Dimdate2_Monthnuminyear,
            DA_DNY_DA_ID,
            DA_DNY_Dimdate2_Daynuminyear,
            DA_LIF_DA_ID,
            DA_LIF_Dimdate2_Lastdayinmonthfl,
            DA_HFL_DA_ID,
            DA_HFL_Dimdate2_HolydayFL,
            DA_WDF_DA_ID,
            DA_WDF_Dimdate2_Weekdayfl
    	) VALUES (
    	    NEW.DA_ID,
            COALESCE(NEW.DA_DNM_DA_ID, NEW.DA_ID),
            NEW.DA_DNM_Dimdate2_Daynuminmonth,
            COALESCE(NEW.DA_WNY_DA_ID, NEW.DA_ID),
            NEW.DA_WNY_Dimdate2_Weeknuminyear,
            COALESCE(NEW.DA_SSS_DA_ID, NEW.DA_ID),
            NEW.DA_SSS_Dimdate2_Sellingseasons,
            COALESCE(NEW.DA_LDF_DA_ID, NEW.DA_ID),
            NEW.DA_LDF_Dimdate2_Lastdayinweekfl,
            COALESCE(NEW.DA_DAT_DA_ID, NEW.DA_ID),
            NEW.DA_DAT_Dimdate2_Date,
            COALESCE(NEW.DA_DOW_DA_ID, NEW.DA_ID),
            NEW.DA_DOW_Dimdate2_Dayofweek,
            COALESCE(NEW.DA_YRS_DA_ID, NEW.DA_ID),
            NEW.DA_YRS_Dimdate2_Year,
            COALESCE(NEW.DA_YMN_DA_ID, NEW.DA_ID),
            NEW.DA_YMN_Dimdate2_Yearmonthnum,
            COALESCE(NEW.DA_MMM_DA_ID, NEW.DA_ID),
            NEW.DA_MMM_Dimdate2_Month,
            COALESCE(NEW.DA_DNW_DA_ID, NEW.DA_ID),
            NEW.DA_DNW_Dimdate2_Daynuminweek,
            COALESCE(NEW.DA_YMM_DA_ID, NEW.DA_ID),
            NEW.DA_YMM_Dimdate2_Yearmonth,
            COALESCE(NEW.DA_MNY_DA_ID, NEW.DA_ID),
            NEW.DA_MNY_Dimdate2_Monthnuminyear,
            COALESCE(NEW.DA_DNY_DA_ID, NEW.DA_ID),
            NEW.DA_DNY_Dimdate2_Daynuminyear,
            COALESCE(NEW.DA_LIF_DA_ID, NEW.DA_ID),
            NEW.DA_LIF_Dimdate2_Lastdayinmonthfl,
            COALESCE(NEW.DA_HFL_DA_ID, NEW.DA_ID),
            NEW.DA_HFL_Dimdate2_HolydayFL,
            COALESCE(NEW.DA_WDF_DA_ID, NEW.DA_ID),
            NEW.DA_WDF_Dimdate2_Weekdayfl
    	);
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER iti_lDA_Dimdate2
INSTEAD OF INSERT ON dbo.lDA_Dimdate2
FOR EACH ROW
EXECUTE PROCEDURE dbo.iti_lDA_Dimdate2();
-- AFTER INSERT trigger ---------------------------------------------------------------------------------------------------------
--DROP TRIGGER IF EXISTS ita_lDA_Dimdate2 ON dbo.lDA_Dimdate2;
--DROP FUNCTION IF EXISTS dbo.ita_lDA_Dimdate2();
CREATE OR REPLACE FUNCTION dbo.ita_lDA_Dimdate2() RETURNS trigger AS '
    BEGIN
        INSERT INTO dbo.DA_DNM_Dimdate2_Daynuminmonth (
            DA_DNM_DA_ID,
            DA_DNM_Dimdate2_Daynuminmonth
        )
        SELECT
            i.DA_DNM_DA_ID,
            i.DA_DNM_Dimdate2_Daynuminmonth
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_DNM_Dimdate2_Daynuminmonth is not null;
        INSERT INTO dbo.DA_WNY_Dimdate2_Weeknuminyear (
            DA_WNY_DA_ID,
            DA_WNY_Dimdate2_Weeknuminyear
        )
        SELECT
            i.DA_WNY_DA_ID,
            i.DA_WNY_Dimdate2_Weeknuminyear
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_WNY_Dimdate2_Weeknuminyear is not null;
        INSERT INTO dbo.DA_SSS_Dimdate2_Sellingseasons (
            DA_SSS_DA_ID,
            DA_SSS_Dimdate2_Sellingseasons
        )
        SELECT
            i.DA_SSS_DA_ID,
            i.DA_SSS_Dimdate2_Sellingseasons
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_SSS_Dimdate2_Sellingseasons is not null;
        INSERT INTO dbo.DA_LDF_Dimdate2_Lastdayinweekfl (
            DA_LDF_DA_ID,
            DA_LDF_Dimdate2_Lastdayinweekfl
        )
        SELECT
            i.DA_LDF_DA_ID,
            i.DA_LDF_Dimdate2_Lastdayinweekfl
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_LDF_Dimdate2_Lastdayinweekfl is not null;
        INSERT INTO dbo.DA_DAT_Dimdate2_Date (
            DA_DAT_DA_ID,
            DA_DAT_Dimdate2_Date
        )
        SELECT
            i.DA_DAT_DA_ID,
            i.DA_DAT_Dimdate2_Date
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_DAT_Dimdate2_Date is not null;
        INSERT INTO dbo.DA_DOW_Dimdate2_Dayofweek (
            DA_DOW_DA_ID,
            DA_DOW_Dimdate2_Dayofweek
        )
        SELECT
            i.DA_DOW_DA_ID,
            i.DA_DOW_Dimdate2_Dayofweek
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_DOW_Dimdate2_Dayofweek is not null;
        INSERT INTO dbo.DA_YRS_Dimdate2_Year (
            DA_YRS_DA_ID,
            DA_YRS_Dimdate2_Year
        )
        SELECT
            i.DA_YRS_DA_ID,
            i.DA_YRS_Dimdate2_Year
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_YRS_Dimdate2_Year is not null;
        INSERT INTO dbo.DA_YMN_Dimdate2_Yearmonthnum (
            DA_YMN_DA_ID,
            DA_YMN_Dimdate2_Yearmonthnum
        )
        SELECT
            i.DA_YMN_DA_ID,
            i.DA_YMN_Dimdate2_Yearmonthnum
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_YMN_Dimdate2_Yearmonthnum is not null;
        INSERT INTO dbo.DA_MMM_Dimdate2_Month (
            DA_MMM_DA_ID,
            DA_MMM_Dimdate2_Month
        )
        SELECT
            i.DA_MMM_DA_ID,
            i.DA_MMM_Dimdate2_Month
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_MMM_Dimdate2_Month is not null;
        INSERT INTO dbo.DA_DNW_Dimdate2_Daynuminweek (
            DA_DNW_DA_ID,
            DA_DNW_Dimdate2_Daynuminweek
        )
        SELECT
            i.DA_DNW_DA_ID,
            i.DA_DNW_Dimdate2_Daynuminweek
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_DNW_Dimdate2_Daynuminweek is not null;
        INSERT INTO dbo.DA_YMM_Dimdate2_Yearmonth (
            DA_YMM_DA_ID,
            DA_YMM_Dimdate2_Yearmonth
        )
        SELECT
            i.DA_YMM_DA_ID,
            i.DA_YMM_Dimdate2_Yearmonth
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_YMM_Dimdate2_Yearmonth is not null;
        INSERT INTO dbo.DA_MNY_Dimdate2_Monthnuminyear (
            DA_MNY_DA_ID,
            DA_MNY_Dimdate2_Monthnuminyear
        )
        SELECT
            i.DA_MNY_DA_ID,
            i.DA_MNY_Dimdate2_Monthnuminyear
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_MNY_Dimdate2_Monthnuminyear is not null;
        INSERT INTO dbo.DA_DNY_Dimdate2_Daynuminyear (
            DA_DNY_DA_ID,
            DA_DNY_Dimdate2_Daynuminyear
        )
        SELECT
            i.DA_DNY_DA_ID,
            i.DA_DNY_Dimdate2_Daynuminyear
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_DNY_Dimdate2_Daynuminyear is not null;
        INSERT INTO dbo.DA_LIF_Dimdate2_Lastdayinmonthfl (
            DA_LIF_DA_ID,
            DA_LIF_Dimdate2_Lastdayinmonthfl
        )
        SELECT
            i.DA_LIF_DA_ID,
            i.DA_LIF_Dimdate2_Lastdayinmonthfl
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_LIF_Dimdate2_Lastdayinmonthfl is not null;
        INSERT INTO dbo.DA_HFL_Dimdate2_HolydayFL (
            DA_HFL_DA_ID,
            DA_HFL_Dimdate2_HolydayFL
        )
        SELECT
            i.DA_HFL_DA_ID,
            i.DA_HFL_Dimdate2_HolydayFL
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_HFL_Dimdate2_HolydayFL is not null;
        INSERT INTO dbo.DA_WDF_Dimdate2_Weekdayfl (
            DA_WDF_DA_ID,
            DA_WDF_Dimdate2_Weekdayfl
        )
        SELECT
            i.DA_WDF_DA_ID,
            i.DA_WDF_Dimdate2_Weekdayfl
        FROM
            _tmp_it_DA_Dimdate2 i
        WHERE
            i.DA_WDF_Dimdate2_Weekdayfl is not null;
        DROP TABLE IF EXISTS _tmp_it_DA_Dimdate2;
        RETURN NULL;
    END;
' LANGUAGE plpgsql;
CREATE TRIGGER ita_lDA_Dimdate2
AFTER INSERT ON dbo.lDA_Dimdate2
FOR EACH STATEMENT
EXECUTE PROCEDURE dbo.ita_lDA_Dimdate2();
-- TIE TEMPORAL PERSPECTIVES ------------------------------------------------------------------------------------------
--
-- These table valued functions simplify temporal querying by providing a temporal
-- perspective of each tie. There are four types of perspectives: latest,
-- point-in-time, difference, and now.
--
-- The latest perspective shows the latest available information for each tie.
-- The now perspective shows the information as it is right now.
-- The point-in-time perspective lets you travel through the information to the given timepoint.
--
-- changingTimepoint the point in changing time to travel to
--
-- The difference perspective shows changes between the two given timepoints.
--
-- intervalStart the start of the interval for finding changes
-- intervalEnd the end of the interval for finding changes
--
-- Under equivalence all these views default to equivalent = 0, however, corresponding
-- prepended-e perspectives are provided in order to select a specific equivalent.
--
-- equivalent the equivalent for which to retrieve data
--
-- DROP TIE TEMPORAL PERSPECTIVES ----------------------------------------------------------------------------------
/*
DROP VIEW IF EXISTS dbo.nDP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2;
DROP FUNCTION IF EXISTS dbo.pDP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2(
    timestamp without time zone
);
DROP VIEW IF EXISTS dbo.lDP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2;
*/
-- Latest perspective -------------------------------------------------------------------------------------------------
-- lDP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2 viewed by the latest available information (may include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dbo.lDP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2 AS
SELECT
    tie.DP_ID_ispof,
    tie.FL_ID_isordby,
    tie.DD_ID_is1,
    tie.DC_ID_isCustrOf,
    tie.DS_ID_isSuppBy,
    tie.DA_ID_is2
FROM
    dbo.DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2 tie;
-- Point-in-time perspective ------------------------------------------------------------------------------------------
-- pDP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2 viewed by the latest available information (may include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION dbo.pDP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2 (
    changingTimepoint timestamp without time zone
)
RETURNS TABLE (
    DP_ID_ispof int,
    FL_ID_isordby int,
    DD_ID_is1 int,
    DC_ID_isCustrOf int,
    DS_ID_isSuppBy int,
    DA_ID_is2 int
) AS '
SELECT
    tie.DP_ID_ispof,
    tie.FL_ID_isordby,
    tie.DD_ID_is1,
    tie.DC_ID_isCustrOf,
    tie.DS_ID_isSuppBy,
    tie.DA_ID_is2
FROM
    dbo.DP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2 tie;
' LANGUAGE SQL;
-- Now perspective ----------------------------------------------------------------------------------------------------
-- nDP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2 viewed as it currently is (cannot include future versions)
-----------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dbo.nDP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2 AS
SELECT
    *
FROM
    dbo.pDP_ispof_FL_isordby_DD_is1_DC_isCustrOf_DS_isSuppBy_DA_is2(LOCALTIMESTAMP);
-- DESCRIPTIONS -------------------------------------------------------------------------------------------------------