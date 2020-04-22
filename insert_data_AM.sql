/*COPY dbo.ldp_dimpart(dp_nam_dimpart_name,
					 dp_mtg_dimpart_mfgr,dp_cat_dimpart_category,
					 dp_bra_dimpart_brand1,dp_col_dimpart_color,dp_typ_dimpart_type,
					 dp_siz_dimpart_size,dp_con_dimpart_container,dp_ddd_dimpart_dummy
					) FROM 'C:\Users\Public\Documents\test\part.tbl'
					WITH 
						delimiter '|';
INSERT INTO dbo.ldp_dimpart(dp_nam_dimpart_name,
					 dp_mtg_dimpart_mfgr,dp_cat_dimpart_category,
					 dp_bra_dimpart_brand1,dp_col_dimpart_color,dp_typ_dimpart_type,
					 dp_siz_dimpart_size,dp_con_dimpart_container,dp_ddd_dimpart_dummy
					) SELECT p_name,p_mfgr,p_category ,p_brand1,p_color,p_type,p_size,p_container,dummy FROM parttmp;
*/
/*COPY dbo.ldp_dimpart(dp_id,dp_nam_dimpart_name,
					 dp_mtg_dimpart_mfgr,dp_cat_dimpart_category,
					 dp_bra_dimpart_brand1,dp_col_dimpart_color,dp_typ_dimpart_type,
					 dp_siz_dimpart_size,dp_con_dimpart_container,dp_ddd_dimpart_dummy
					) FROM 'C:\Users\Public\Documents\test\part.tbl'
					WITH 
						delimiter '|';
COPY dbo.nds_dimsupplier(ds_id,ds_reg_dimsupplier_region,
					 ds_cit_dimsupplier_city,ds_nat_dimsupplier_nation,
					 ds_phn_dimsupplier_phone,ds_add_dimsupplier_address,ds_nam_dimsupplier_name
						 ,ds_ddd_dimsupplier_dummy
					) FROM '\Users\Public\Documents\test\supplier.tbl'
					WITH 
						delimiter '|';
 
INSERT INTO dbo.ldp_dimpart(dp_nam_dimpart_name,
					 dp_mtg_dimpart_mfgr,dp_cat_dimpart_category,
					 dp_bra_dimpart_brand1,dp_col_dimpart_color,dp_typ_dimpart_type,
					 dp_siz_dimpart_size,dp_con_dimpart_container,dp_ddd_dimpart_dummy
					) SELECT p_name,p_mfgr,p_category ,p_brand1,p_color,p_type,p_size,p_container,dummy FROM parttmp;
*/
/*partmp*/
CREATE TABLE parttmp (
  p_partkey   INTEGER PRIMARY KEY,
  p_name      TEXT,
  p_mfgr      CHAR(6),
  p_category  CHAR(7),
  p_brand1    CHAR(9),
  p_color     CHAR(11),
  p_type      TEXT,
  p_size      INTEGER,
  p_container CHAR(10),
  dummy       TEXT  -- dbgen last delimiter
);
COPY parttmp FROM 'C:\Users\Public\Documents\test\part.tbl'
					WITH 
						delimiter '|';		
INSERT INTO dbo._dp_dimpart(dp_id) SELECT p_partkey FROM parttmp;
INSERT INTO dbo._dp_nam_dimpart_name(dp_nam_dp_id,dp_nam_dimpart_name) SELECT p_partkey,p_name FROM parttmp;
INSERT INTO dbo._dp_mtg_dimpart_mfgr(dp_mtg_dp_id,dp_mtg_dimpart_mfgr) SELECT p_partkey,p_mfgr FROM parttmp;
INSERT INTO dbo._dp_siz_dimpart_size(dp_siz_dp_id,dp_siz_dimpart_size) SELECT p_partkey,p_size FROM parttmp;
INSERT INTO dbo._dp_typ_dimpart_type(dp_typ_dp_id,dp_typ_dimpart_type) SELECT p_partkey,p_type FROM parttmp;
INSERT INTO dbo._dp_cat_dimpart_category(dp_cat_dp_id,dp_cat_dimpart_category) SELECT p_partkey,p_category FROM parttmp;
INSERT INTO dbo._dp_bra_dimpart_brand1(dp_bra_dp_id,dp_bra_dimpart_brand1) SELECT p_partkey,p_brand1 FROM parttmp;
INSERT INTO dbo._dp_con_dimpart_container(dp_con_dp_id,dp_con_dimpart_container) SELECT p_partkey,p_container FROM parttmp;
INSERT INTO dbo._dp_col_dimpart_color(dp_col_dp_id,dp_col_dimpart_color) SELECT p_partkey,p_color FROM parttmp;
/*INSERT INTO dbo._dp_ddd_dimpart_dummy(dp_ddd_dp_id,dp_ddd_dimpart_dummy) SELECT p_partkey,dummy FROM parttmp;*/

drop table parttmp;
/*suppliertmp*/	
CREATE TABLE suppliertmp (
  s_suppkey INTEGER PRIMARY KEY,
  s_name    CHAR(25),
  s_address TEXT,
  s_city    CHAR(10),
  s_nation  CHAR(15),
  s_region  CHAR(12),
  s_phone   CHAR(15),
  dummy     TEXT -- dbgen last delimiter
);
COPY suppliertmp FROM 'C:\Users\Public\Documents\test\supplier.tbl'
					WITH 
						delimiter '|';	
INSERT INTO dbo._ds_dimsupplier(ds_id) SELECT s_suppkey FROM suppliertmp;
INSERT INTO dbo._ds_add_dimsupplier_address(ds_add_ds_id,ds_add_dimsupplier_address) SELECT s_suppkey,s_address FROM suppliertmp;
INSERT INTO dbo._ds_cit_dimsupplier_city(ds_cit_ds_id,ds_cit_dimsupplier_city) SELECT s_suppkey,s_city FROM suppliertmp;
/*INSERT INTO dbo._ds_ddd_dimsupplier_dummy(ds_ddd_ds_id,ds_ddd_dimsupplier_dummy) SELECT s_suppkey,dummy FROM suppliertmp;*/
INSERT INTO dbo._ds_nam_dimsupplier_name(ds_nam_ds_id,ds_nam_dimsupplier_name) SELECT s_suppkey,s_name FROM suppliertmp;
INSERT INTO dbo._ds_nat_dimsupplier_nation(ds_nat_ds_id,ds_nat_dimsupplier_nation) SELECT s_suppkey,s_nation FROM suppliertmp;
INSERT INTO dbo._ds_phn_dimsupplier_phone(ds_phn_ds_id,ds_phn_dimsupplier_phone) SELECT s_suppkey,s_phone FROM suppliertmp;
INSERT INTO dbo._ds_reg_dimsupplier_region(ds_reg_ds_id,ds_reg_dimsupplier_region) SELECT s_suppkey,s_region FROM suppliertmp;

drop table suppliertmp;
/*customertmp*/
CREATE TABLE customertmp (
  c_custkey    INTEGER PRIMARY KEY,
  c_name       TEXT,
  c_address    TEXT,
  c_city       CHAR(10),
  c_nation     CHAR(15),
  c_region     CHAR(12),
  c_phone      CHAR(15),
  c_mktsegment CHAR(10),
  dummy        TEXT -- dbgen last delimiter
);
COPY customertmp FROM 'C:\Users\Public\Documents\test\customer.tbl'
					WITH 
						delimiter '|';	
INSERT INTO dbo._dc_dimcustomer(dc_id) SELECT c_custkey FROM customertmp;
INSERT INTO dbo._dc_add_dimcustomer_address(dc_add_dc_id,dc_add_dimcustomer_address) SELECT c_custkey,c_address FROM customertmp;
INSERT INTO dbo._dc_cit_dimcustomer_city(dc_cit_dc_id,dc_cit_dimcustomer_city) SELECT c_custkey,c_city FROM customertmp;
/*INSERT INTO dbo._dc_ddd_dimcustomer_dummy(dc_ddd_dc_id,dc_ddd_dimcustomer_dummy) SELECT c_custkey,dummy FROM customertmp;*/
INSERT INTO dbo._dc_nam_dimcustomer_name(dc_nam_dc_id,dc_nam_dimcustomer_name) SELECT c_custkey,c_name FROM customertmp;
INSERT INTO dbo._dc_nat_dimcustomer_nation(dc_nat_dc_id,dc_nat_dimcustomer_nation) SELECT c_custkey,c_nation FROM customertmp;
INSERT INTO dbo._dc_phn_dimcustomer_phone(dc_phn_dc_id,dc_phn_dimcustomer_phone) SELECT c_custkey,c_phone FROM customertmp;
INSERT INTO dbo._dc_reg_dimcustomer_region(dc_reg_dc_id,dc_reg_dimcustomer_region) SELECT c_custkey,c_region FROM customertmp;
INSERT INTO dbo._dc_seg_dimcustomer_mktsegment(dc_seg_dc_id,dc_seg_dimcustomer_mktsegment) SELECT c_custkey,c_mktsegment FROM customertmp;

DROP TABLE customertmp;
/*datetmp*/
CREATE TABLE datetmp (
  d_datekey          INTEGER PRIMARY KEY,
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
  dummy              TEXT -- dbgen last delimiter
);
COPY datetmp FROM 'C:\Users\Public\Documents\test\date.tbl'
					WITH 
						delimiter '|';	
INSERT INTO dbo._dd_dimdate1(dd_id) SELECT d_datekey FROM datetmp;
INSERT INTO  dbo._dd_dat_dimdate1_date SELECT d_datekey,d_date FROM datetmp;
INSERT INTO dbo._dd_dow_dimdate1_dayofweek SELECT d_datekey,d_dayofweek FROM datetmp;
INSERT INTO dbo._dd_mth_dimdate1_month SELECT d_datekey,d_month FROM datetmp;
INSERT INTO dbo._dd_yrs_dimdate1_year SELECT d_datekey,d_year FROM datetmp;
INSERT INTO dbo._dd_ymn_dimdate1_yearmonthnum SELECT d_datekey,d_yearmonthnum FROM datetmp;
INSERT INTO dbo._dd_ymm_dimdate1_yearmonth SELECT d_datekey,d_yearmonth FROM datetmp;
INSERT INTO dbo._dd_dnw_dimdate1_daynuminweek SELECT d_datekey,d_daynuminweek FROM datetmp;
INSERT INTO dbo._dd_dnm_dimdate1_daynuminmonth SELECT d_datekey,d_daynuminmonth FROM datetmp;
INSERT INTO dbo._dd_dny_dimdate1_daynuminyear SELECT d_datekey,d_daynuminyear FROM datetmp;
INSERT INTO dbo._dd_dmy_dimdate1_monthnuminyear SELECT d_datekey,d_monthnuminyear FROM datetmp;
INSERT INTO dbo._dd_wny_dimdate1_weeknuminyear SELECT d_datekey,d_weeknuminyear FROM datetmp;
INSERT INTO dbo._dd_ssa_dimdate1_sellingseason SELECT d_datekey,d_sellingseason FROM datetmp;
INSERT INTO dbo._dd_lfl_dimdate1_lastdayinweekfl SELECT d_datekey,d_lastdayinweekfl FROM datetmp;
INSERT INTO dbo._dd_ldl_dimdate1_lastdayinmonthfl SELECT d_datekey,d_lastdayinmonthfl FROM datetmp;
INSERT INTO dbo._dd_hof_dimdate1_holydayfl SELECT d_datekey,d_holidayfl FROM datetmp;
INSERT INTO dbo._dd_wdf_dimdate1_weekdayfl SELECT d_datekey,d_weekdayfl FROM datetmp;

INSERT INTO dbo.lda_dimdate2 SELECT d_datekey, d_datekey, d_daynuminmonth, d_datekey, d_weeknuminyear, d_datekey, d_sellingseason, d_datekey, d_lastdayinweekfl, d_datekey, d_date, d_datekey, d_dayofweek, d_datekey, d_year, d_datekey, d_yearmonthnum, d_datekey, d_month, d_datekey, d_daynuminweek, d_datekey, d_yearmonth, d_datekey, d_monthnuminyear,
d_datekey, d_daynuminyear, d_datekey, d_lastdayinmonthfl, d_datekey, d_holidayfl, d_datekey, d_weekdayfl from datetmp;

drop table datetmp;
/*
populate database from external source 'dv'
ALTER TABLE lineordertmp
ADD tmp INTEGER;*/

CREATE EXTENSION dblink;
INSERT INTO dbo._fl_factlineorder(fl_id)
SELECT DVS_link_lineorder FROM dblink('host=localhost user=postgres password=root dbname=dv', 'SELECT DVS_link_lineorder FROM Satlineorder') AS x(DVS_link_lineorder integer);
/* adding column to temp table*/
INSERT INTO dbo._fl_dsc_factlineorder_discount
SELECT DVS_link_lineorder,lo_discount FROM dblink('host=localhost user=postgres password=root dbname=dv', 'SELECT DVS_link_lineorder,lo_discount FROM Satlineorder') AS x(DVS_link_lineorder integer,lo_discount numeric);
INSERT INTO dbo._fl_epr_factlineorder_extendedprice
SELECT DVS_link_lineorder,lo_extendedprice FROM dblink('host=localhost user=postgres password=root dbname=dv', 'SELECT DVS_link_lineorder,lo_extendedprice FROM Satlineorder') AS x(DVS_link_lineorder integer,lo_extendedprice numeric);
INSERT INTO dbo._fl_lnb_factlineorder_linenumber
SELECT DVS_link_lineorder,lo_linenumber FROM dblink('host=localhost user=postgres password=root dbname=dv', 'SELECT DVS_link_lineorder,lo_linenumber FROM Satlineorder') AS x(DVS_link_lineorder integer,lo_linenumber numeric);
INSERT INTO dbo._fl_otp_factlineorder_ordtotalprice
SELECT DVS_link_lineorder,lo_ordtotalprice FROM dblink('host=localhost user=postgres password=root dbname=dv', 'SELECT DVS_link_lineorder,lo_ordtotalprice FROM Satlineorder') AS x(DVS_link_lineorder integer,lo_ordtotalprice numeric);
INSERT INTO dbo._fl_qty_factlineorder_quantity
SELECT DVS_link_lineorder,lo_quantity FROM dblink('host=localhost user=postgres password=root dbname=dv', 'SELECT DVS_link_lineorder,lo_quantity FROM Satlineorder') AS x(DVS_link_lineorder integer,lo_quantity integer);
INSERT INTO dbo._fl_sct_factlineorder_supplycost
SELECT DVS_link_lineorder,lo_supplycost FROM dblink('host=localhost user=postgres password=root dbname=dv', 'SELECT DVS_link_lineorder,lo_supplycost FROM Satlineorder') AS x(DVS_link_lineorder integer,lo_supplycost numeric);
INSERT INTO dbo._fl_shm_factlineorder_shipmode
SELECT DVS_link_lineorder,lo_shipmod FROM dblink('host=localhost user=postgres password=root dbname=dv', 'SELECT DVS_link_lineorder,lo_shipmod FROM Satlineorder') AS x(DVS_link_lineorder integer,lo_shipmod char(10));
INSERT INTO dbo._fl_shp_factlineorder_shippriority
SELECT DVS_link_lineorder,lo_shippriority FROM dblink('host=localhost user=postgres password=root dbname=dv', 'SELECT DVS_link_lineorder,lo_shippriority FROM Satlineorder') AS x(DVS_link_lineorder integer,lo_shippriority char(1));
INSERT INTO dbo._fl_txa_factlineorder_tax
SELECT DVS_link_lineorder,lo_tax FROM dblink('host=localhost user=postgres password=root dbname=dv', 'SELECT DVS_link_lineorder,lo_tax FROM Satlineorder') AS x(DVS_link_lineorder integer,lo_tax numeric);
INSERT INTO dbo._fl_rvn_factlineorder_revenue
SELECT DVS_link_lineorder,lo_revenue FROM dblink('host=localhost user=postgres password=root dbname=dv', 'SELECT DVS_link_lineorder,lo_revenue FROM Satlineorder') AS x(DVS_link_lineorder integer,lo_revenue numeric);
INSERT INTO dbo._fl_opy_factlineorder_orderpriority
SELECT DVS_link_lineorder,lo_orderpriority FROM dblink('host=localhost user=postgres password=root dbname=dv', 'SELECT DVS_link_lineorder,lo_orderpriority FROM Satlineorder') AS x(DVS_link_lineorder integer,lo_orderpriority char(15));
/*insert into anchor _dp_ispartof_fl_isordby_dd_iss_dc_iscustrof_ds_issuppby */

/*INSERT INTO dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 
SELECT DVS_hub_part,DVS_link_lineorder,DVS_hub_Date1,DVS_hub_customer,DVS_hub_supplier,DVS_hub_Date2
FROM dblink('host=localhost user=postgres password=root dbname=dv', 'SELECT DVS_hub_part,DVS_link_lineorder,DVS_hub_Date1,DVS_hub_customer,DVS_hub_supplier,DVS_hub_Date2 FROM linklineorder') AS x(
DVS_hub_part integer,DVS_link_lineorder integer,DVS_hub_Date1 date,DVS_hub_customer integer,DVS_hub_supplier integer,DVS_hub_Date2 date);*/

/*lineordertmp*/
CREATE TABLE lineordertmp (
  DVS_link_lineorder SERIAL primary key,
  lo_orderkey      BIGINT, -- Consider SF 300+
  lo_linenumber    INTEGER,
  lo_custkey       INTEGER, -- FK to C_CUSTKEY
  lo_partkey       INTEGER, -- FK to P_PARTKEY
  lo_suppkey       INTEGER, -- FK to S_SUPPKEY
  lo_orderdate     INTEGER,    -- FK to D_DATEKEY
  lo_orderpriority CHAR(15),
  lo_shippriority  CHAR(1),
  lo_quantity      INTEGER,
  lo_extendedprice NUMERIC,
  lo_ordtotalprice NUMERIC,
  lo_discount      NUMERIC,
  lo_revenue       NUMERIC,
  lo_supplycost    NUMERIC,
  lo_tax           NUMERIC,
  lo_commitdate    INTEGER, -- FK to D_DATEKEY
  lo_shipmod       CHAR(10), 
  dummy            TEXT -- dbgen last delimiter
);
COPY lineordertmp(lo_orderkey,lo_linenumber,lo_custkey,lo_partkey,lo_suppkey,lo_orderdate,lo_orderpriority,lo_shippriority,lo_quantity,lo_extendedprice,lo_ordtotalprice,lo_discount,lo_revenue,lo_supplycost,lo_tax,lo_commitdate,lo_shipmod,dummy) FROM 'C:\Users\Public\Documents\test\lineorder.tbl'
					WITH 
						delimiter '|';
/* ^^^ Query returned successfully in 51 min 42 secs.*/
ALTER TABLE dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 DROP CONSTRAINT dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2_fkda CASCADE;
ALTER TABLE dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 DROP CONSTRAINT dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2_fkdc CASCADE;
ALTER TABLE dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 DROP CONSTRAINT dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2_fkdd CASCADE;
ALTER TABLE dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 DROP CONSTRAINT dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2_fkdp CASCADE;
ALTER TABLE dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 DROP CONSTRAINT dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2_fkds CASCADE;
ALTER TABLE dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 DROP CONSTRAINT dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2_fkfl CASCADE;

INSERT INTO dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2
SELECT lo_partkey,DVS_link_lineorder,lo_orderdate,lo_custkey,lo_suppkey,lo_commitdate
FROM lineordertmp;
alter table dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 ADD CONSTRAINT dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2_fkdd FOREIGN KEY (dd_id_is1)
REFERENCES dbo._dd_dimdate1 (dd_id) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION;
alter table dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 ADD CONSTRAINT dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2_fkda FOREIGN KEY (da_id_is2)
REFERENCES dbo._da_dimdate2 (da_id) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION;
alter table dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 ADD CONSTRAINT dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2_fkdp FOREIGN KEY (dp_id_ispof)
REFERENCES dbo._dp_dimpart (dp_id) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION;
alter table dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 ADD CONSTRAINT dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2_fkdc FOREIGN KEY (dc_id_isCustrOf)
REFERENCES dbo._dc_dimcustomer (dc_id) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION;
alter table dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 ADD CONSTRAINT dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2_fkds FOREIGN KEY (ds_id_isSuppBy)
REFERENCES dbo._ds_dimsupplier (ds_id) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION;
alter table dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 ADD CONSTRAINT dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2_fkfl FOREIGN KEY (fl_id_isordby)
REFERENCES dbo._fl_factlineorder (fl_id) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION;
drop table lineordertmp;


