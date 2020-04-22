DROP TABLE IF EXISTS Hubcustomer, Hubpart, Hubdate1, Hubdate2, 
Hubsupplier, Satcustomer, Satpart, SatDate1, 
SatDate2, Satsupplier, Satlineorder, Linklineorder CASCADE;

Create table Hubcustomer(
	DVS_hub_customer integer primary key,
	loadTS TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	RecordSRC text DEFAULT 'satcustomer'
);
Create table Hubpart(
	DVS_hub_part integer primary key,
	loadTS TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	RecordSRC text DEFAULT 'satpart'
);
Create table Hubdate1(
	DVS_hub_date1 DATE primary key,
	loadTS TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	RecordSRC text DEFAULT 'satdate1'
);
Create table Hubdate2(
	DVS_hub_date2 DATE primary key,
	loadTS TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	RecordSrc text DEFAULT 'satdate2'
);
Create table Hubsupplier(
	DVS_hub_supplier integer primary key,
	loadTS TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	RecordSrc text DEFAULT 'satsupplier'
);
create table Linklineorder(
	DVS_link_lineorder SERIAL primary key,
	DVS_hub_part integer references Hubpart,
	DVS_hub_customer integer references Hubcustomer,
	DVS_hub_Date1 DATE references Hubdate1,
	DVS_hub_Date2 DATE references Hubdate2,
	DVS_hub_supplier integer references Hubsupplier,
	LoadTS TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	RecordSRC text DEFAULT 'tbl'
);
Create table Satcustomer(
	DVS_hub_customer integer NOT NULL,
	LoadTS TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	c_name       TEXT,
    c_address    TEXT,
    c_city       CHAR(10),
    c_nation     CHAR(15),
    c_region     CHAR(12),
    c_phone      CHAR(15),
    c_mktsegment CHAR(10),
    dummy        TEXT, -- dbgen last delimiter
	primary key (DVS_hub_customer,LoadTS)
	/*foreign key (DVS_hub_customer) references Hubcustomer*/
);
Create table Satpart(
	DVS_hub_part integer NOT NULL,
	loadTS TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	p_name      TEXT,
    p_mfgr      CHAR(6),
    p_category  CHAR(7),
    p_brand1    CHAR(9),
    p_color     CHAR(11),
    p_type      TEXT,
    p_size      INTEGER,
    p_container CHAR(10),
    dummy       TEXT,
	primary key (DVS_hub_part,LoadTS)
	/*foreign key (DVS_hub_part) references Hubpart*/
);
Create table Satsupplier(
	DVS_hub_supplier integer NOT NULL,
	loadTS TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    s_name    CHAR(25),
    s_address TEXT,
    s_city    CHAR(10),
    s_nation  CHAR(15),
    s_region  CHAR(12),
    s_phone   CHAR(15),
    dummy            TEXT, -- dbgen last delimiter
	primary key (DVS_hub_supplier,LoadTS)
	/*foreign key (DVS_hub_supplier) references Hubsupplier*/
);
Create table Satdate1(
	DVS_hub_date1 date NOT NULL,
	loadTS TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    d_date             CHAR(18),
    d_dayofweek        CHAR(9),
    d_month            CHAR(9),
    d_year             INTEGER,
    d_yearmonthnum     INTEGER,
    d_yearmonth        CHAR(7),
    d_daynuminweek     INTEGER,
    d_daynuminmonth    INTEGER,
    d_daynuminyear     INTEGER,
    d_monthnuminyear   INTEGER,
    d_weeknuminyear    INTEGER,
    d_sellingseason    TEXT,
    d_lastdayinweekfl  CHAR(1),
    d_lastdayinmonthfl CHAR(1),
    d_holidayfl        CHAR(1),
    d_weekdayfl        CHAR(1),
    dummy              TEXT, -- dbgen last delimiter
	primary key (DVS_hub_date1,LoadTS)
	/*foreign key (DVS_hub_date1) references Hubdate1*/
);
Create table Satdate2(
	DVS_hub_date2 date NOT NULL,
	loadTS TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    d_date             CHAR(18),
    d_dayofweek        CHAR(9),
    d_month            CHAR(9),
    d_year             INTEGER,
    d_yearmonthnum     INTEGER,
    d_yearmonth        CHAR(7),
    d_daynuminweek     INTEGER,
    d_daynuminmonth    INTEGER,
    d_daynuminyear     INTEGER,
    d_monthnuminyear   INTEGER,
    d_weeknuminyear    INTEGER,
    d_sellingseason    TEXT,
    d_lastdayinweekfl  CHAR(1),
    d_lastdayinmonthfl CHAR(1),
    d_holidayfl        CHAR(1),
    d_weekdayfl        CHAR(1),
    dummy              TEXT, -- dbgen last delimiter
	primary key (DVS_hub_date2,LoadTS)
	/*foreign key (DVS_hub_date2) references Hubdate2*/
);
create table Satlineorder(
	DVS_link_lineorder SERIAL,
	loadTS TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	lo_orderkey		 BIGINT,
	lo_linenumber    INTEGER,
    lo_custkey       INTEGER, -- FK to C_CUSTKEY
    lo_partkey       INTEGER, -- FK to P_PARTKEY
    lo_suppkey       INTEGER, -- FK to S_SUPPKEY
    lo_orderdate     DATE,    -- FK to D_DATEKEY
    lo_orderpriority CHAR(15),
    lo_shippriority  CHAR(1),
    lo_quantity      INTEGER,
    lo_extendedprice NUMERIC,
    lo_ordtotalprice NUMERIC,
    lo_discount      NUMERIC,
    lo_revenue       NUMERIC,
    lo_supplycost    NUMERIC,
    lo_tax           NUMERIC,
    lo_commitdate    DATE, -- FK to D_DATEKEY
    lo_shipmod       CHAR(10), 
    dummy            TEXT, -- dbgen last delimiter
	primary key (DVS_link_lineorder,LoadTS)
	/*foreign key (DVS_link_lineorder) references Linklineorder*/
);
/*CREATE EXTENSION dblink;
INSERT INTO public.hubcustomer(dvs_hub_customer) SELECT dvs_hub_customer FROM satcustomer;
INSERT INTO t(a, b, c)
SELECT a, b, c FROM dblink('host=xxx user=xxx password=xxx dbname=xxx', 'SELECT a, b, c FROM t') AS x(a integer, b integer, c integer)*/

