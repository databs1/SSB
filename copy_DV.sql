	COPY public.satlineorder(lo_orderkey, lo_linenumber, lo_custkey,
							 lo_partkey, lo_suppkey, lo_orderdate, lo_orderpriority,
							 lo_shippriority, lo_quantity, lo_extendedprice, 
							 lo_ordtotalprice, lo_discount, lo_revenue, lo_supplycost, 
							 lo_tax, lo_commitdate, lo_shipmod, dummy
						) FROM 'C:\Users\Public\Documents\test\lineorder.tbl'
						WITH 
							delimiter '|';
COPY public.satdate1(dvs_hub_date1, d_date,
					 d_dayofweek, d_month, d_year, d_yearmonthnum,
					 d_yearmonth, d_daynuminweek, d_daynuminmonth,
					 d_daynuminyear, d_monthnuminyear, d_weeknuminyear,
					 d_sellingseason, d_lastdayinweekfl, d_lastdayinmonthfl,
					 d_holidayfl, d_weekdayfl, dummy) FROM 'C:\Users\Public\Documents\test\date.tbl'
					WITH 
						delimiter '|';
COPY public.satdate2(dvs_hub_date2, d_date,
					 d_dayofweek, d_month, d_year, d_yearmonthnum,
					 d_yearmonth, d_daynuminweek, d_daynuminmonth,
					 d_daynuminyear, d_monthnuminyear, d_weeknuminyear,
					 d_sellingseason, d_lastdayinweekfl, d_lastdayinmonthfl,
					 d_holidayfl, d_weekdayfl, dummy) FROM 'C:\Users\Public\Documents\test\date.tbl'
					WITH 
						delimiter '|';
COPY public.satcustomer(dvs_hub_customer, c_name, c_address,
						c_city, c_nation, c_region, c_phone, c_mktsegment, dummy)
FROM 'C:\Users\Public\Documents\test\customer.tbl'
					WITH 
						delimiter '|';
COPY public.satpart(dvs_hub_part, p_name, p_mfgr,
					p_category, p_brand1, p_color, p_type, p_size, p_container, dummy)
FROM 'C:\Users\Public\Documents\test\part.tbl'
					WITH 
						delimiter '|';
COPY public.satsupplier(dvs_hub_supplier, s_name, s_address,
						s_city, s_nation, s_region, s_phone, dummy)
FROM 'C:\Users\Public\Documents\test\supplier.tbl'
					WITH 
						delimiter '|';