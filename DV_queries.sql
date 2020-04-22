--Q1.1
select sum(lo_extendedprice*lo_discount) as revenue
 FROM linklineorder
	JOIN hubdate1 ON hubdate1.DVS_hub_date1=linklineorder.DVS_hub_date1
	LEFT JOIN satlineorder ON satlineorder.DVS_link_lineorder=linklineorder.DVS_link_lineorder
    LEFT JOIN satdate1 ON satdate1.DVS_hub_date1=hubdate1.DVS_hub_date1
 WHERE d_year = 1993
 and lo_discount between 1 and 3
 and lo_quantity < 25; 
--Q1.2
select sum(lo_extendedprice*lo_discount) as revenue
 FROM linklineorder
	JOIN hubdate1 ON hubdate1.DVS_hub_date1=linklineorder.DVS_hub_date1
	LEFT JOIN satlineorder ON satlineorder.DVS_link_lineorder=linklineorder.DVS_link_lineorder
    LEFT JOIN satdate1 ON satdate1.DVS_hub_date1=hubdate1.DVS_hub_date1
 where d_yearmonthnum = 199401
 and lo_discount between 4 and 6
 and lo_quantity between 26 and 35;
--Q1.3
select sum(lo_extendedprice*lo_discount) as revenue
 FROM linklineorder
	JOIN hubdate1 ON hubdate1.DVS_hub_date1=linklineorder.DVS_hub_date1
	LEFT JOIN satlineorder ON satlineorder.DVS_link_lineorder=linklineorder.DVS_link_lineorder
    LEFT JOIN satdate1 ON satdate1.DVS_hub_date1=hubdate1.DVS_hub_date1
 where d_weeknuminyear = 6
 and d_year = 1994
 and lo_discount between 5 and 7
 and lo_quantity between 26 and 35; 
--Q2.1
SELECT sum(lo_revenue), d_year, p_brand1
FROM linklineorder
	JOIN satlineorder ON satlineorder.DVS_link_lineorder=linklineorder.DVS_link_lineorder
	JOIN hubdate1 ON hubdate1.DVS_hub_date1=linklineorder.DVS_hub_date1
	JOIN satdate1 ON hubdate1.DVS_hub_date1=satdate1.DVS_hub_date1
	JOIN hubpart ON hubpart.DVS_hub_part=linklineorder.DVS_hub_part
	JOIN satpart ON hubpart.DVS_hub_part=satpart.DVS_hub_part
	JOIN hubsupplier ON hubsupplier.DVS_hub_supplier=linklineorder.DVS_hub_supplier
	JOIN satsupplier ON hubsupplier.DVS_hub_supplier=satsupplier.DVS_hub_supplier
WHERE p_category = 'MFGR#12'
and s_region = 'AMERICA'
group by d_year, p_brand1
order by d_year, p_brand1;
--Q2.2
select sum(lo_revenue), d_year, p_brand1
FROM linklineorder
	JOIN satlineorder ON satlineorder.DVS_link_lineorder=linklineorder.DVS_link_lineorder
	JOIN hubdate1 ON hubdate1.DVS_hub_date1=linklineorder.DVS_hub_date1
	JOIN satdate1 ON hubdate1.DVS_hub_date1=satdate1.DVS_hub_date1
	JOIN hubpart ON hubpart.DVS_hub_part=linklineorder.DVS_hub_part
	JOIN satpart ON hubpart.DVS_hub_part=satpart.DVS_hub_part
	JOIN hubsupplier ON hubsupplier.DVS_hub_supplier=linklineorder.DVS_hub_supplier
	JOIN satsupplier ON hubsupplier.DVS_hub_supplier=satsupplier.DVS_hub_supplier
WHERE p_brand1 between 'MFGR#2221' and 'MFGR#2228'
and s_region = 'ASIA'
group by d_year, p_brand1
order by d_year, p_brand1; 
--Q2.3
select sum(lo_revenue), d_year, p_brand1
FROM linklineorder
	JOIN satlineorder ON satlineorder.DVS_link_lineorder=linklineorder.DVS_link_lineorder
	JOIN hubdate1 ON hubdate1.DVS_hub_date1=linklineorder.DVS_hub_date1
	JOIN satdate1 ON hubdate1.DVS_hub_date1=satdate1.DVS_hub_date1
	JOIN hubpart ON hubpart.DVS_hub_part=linklineorder.DVS_hub_part
	JOIN satpart ON hubpart.DVS_hub_part=satpart.DVS_hub_part
	JOIN hubsupplier ON hubsupplier.DVS_hub_supplier=linklineorder.DVS_hub_supplier
	JOIN satsupplier ON hubsupplier.DVS_hub_supplier=satsupplier.DVS_hub_supplier
WHERE p_brand1 = 'MFGR#2221'
and s_region = 'EUROPE'
group by d_year, p_brand1
order by d_year, p_brand1;  
--Q3.1
select c_nation, s_nation, d_year, sum(lo_revenue) as revenue
FROM linklineorder
	JOIN satlineorder ON satlineorder.DVS_link_lineorder=linklineorder.DVS_link_lineorder
	JOIN hubdate1 ON hubdate1.DVS_hub_date1=linklineorder.DVS_hub_date1
	JOIN satdate1 ON hubdate1.DVS_hub_date1=satdate1.DVS_hub_date1
	JOIN hubcustomer ON hubcustomer.DVS_hub_customer=linklineorder.DVS_hub_customer
	JOIN satcustomer ON hubcustomer.DVS_hub_customer=satcustomer.DVS_hub_customer
	JOIN hubsupplier ON hubsupplier.DVS_hub_supplier=linklineorder.DVS_hub_supplier
	JOIN satsupplier ON hubsupplier.DVS_hub_supplier=satsupplier.DVS_hub_supplier
where c_region = 'ASIA' and s_region = 'ASIA'
and d_year >= 1992 and d_year <= 1997
group by c_nation, s_nation, d_year
order by d_year asc, revenue desc; 
--Q3.2
select c_city, s_city, d_year, sum(lo_revenue) as revenue
FROM linklineorder
	JOIN satlineorder ON satlineorder.DVS_link_lineorder=linklineorder.DVS_link_lineorder
	JOIN hubdate1 ON hubdate1.DVS_hub_date1=linklineorder.DVS_hub_date1
	JOIN satdate1 ON hubdate1.DVS_hub_date1=satdate1.DVS_hub_date1
	JOIN hubcustomer ON hubcustomer.DVS_hub_customer=linklineorder.DVS_hub_customer
	JOIN satcustomer ON hubcustomer.DVS_hub_customer=satcustomer.DVS_hub_customer
	JOIN hubsupplier ON hubsupplier.DVS_hub_supplier=linklineorder.DVS_hub_supplier
	JOIN satsupplier ON hubsupplier.DVS_hub_supplier=satsupplier.DVS_hub_supplier
where c_nation = 'UNITED STATES'
and s_nation = 'UNITED STATES'
and d_year >= 1992 and d_year <= 1997
group by c_city, s_city, d_year
order by d_year asc, revenue desc; 
--Q3.3
select c_city, s_city, d_year, sum(lo_revenue) as revenue
FROM linklineorder
	JOIN satlineorder ON satlineorder.DVS_link_lineorder=linklineorder.DVS_link_lineorder
	JOIN hubdate1 ON hubdate1.DVS_hub_date1=linklineorder.DVS_hub_date1
	JOIN satdate1 ON hubdate1.DVS_hub_date1=satdate1.DVS_hub_date1
	JOIN hubcustomer ON hubcustomer.DVS_hub_customer=linklineorder.DVS_hub_customer
	JOIN satcustomer ON hubcustomer.DVS_hub_customer=satcustomer.DVS_hub_customer
	JOIN hubsupplier ON hubsupplier.DVS_hub_supplier=linklineorder.DVS_hub_supplier
	JOIN satsupplier ON hubsupplier.DVS_hub_supplier=satsupplier.DVS_hub_supplier
where (c_city='UNITED KI1'
or c_city='UNITED KI5')
and (s_city='UNITED KI1'
or s_city='UNITED KI5')
and d_year >= 1992 and d_year <= 1997
group by c_city, s_city, d_year
order by d_year asc, revenue desc;
--Q3.4
select c_city, s_city, d_year, sum(lo_revenue) as revenue
FROM linklineorder
	JOIN satlineorder ON satlineorder.DVS_link_lineorder=linklineorder.DVS_link_lineorder
	JOIN hubdate1 ON hubdate1.DVS_hub_date1=linklineorder.DVS_hub_date1
	JOIN satdate1 ON hubdate1.DVS_hub_date1=satdate1.DVS_hub_date1
	JOIN hubcustomer ON hubcustomer.DVS_hub_customer=linklineorder.DVS_hub_customer
	JOIN satcustomer ON hubcustomer.DVS_hub_customer=satcustomer.DVS_hub_customer
	JOIN hubsupplier ON hubsupplier.DVS_hub_supplier=linklineorder.DVS_hub_supplier
	JOIN satsupplier ON hubsupplier.DVS_hub_supplier=satsupplier.DVS_hub_supplier
where (c_city='UNITED KI1' or
 c_city='UNITED KI5')
 and (s_city='UNITED KI1' or
 s_city='UNITED KI5')
 and d_yearmonth = 'Dec1997'
 group by c_city, s_city, d_year
 order by d_year asc, revenue desc;  
--Q4.1
select d_year, c_nation, sum(lo_revenue -lo_supplycost) as profit
FROM linklineorder
	JOIN satlineorder ON satlineorder.DVS_link_lineorder=linklineorder.DVS_link_lineorder
	JOIN hubdate1 ON hubdate1.DVS_hub_date1=linklineorder.DVS_hub_date1
	JOIN satdate1 ON hubdate1.DVS_hub_date1=satdate1.DVS_hub_date1
	JOIN hubcustomer ON hubcustomer.DVS_hub_customer=linklineorder.DVS_hub_customer
	JOIN satcustomer ON hubcustomer.DVS_hub_customer=satcustomer.DVS_hub_customer
	JOIN hubsupplier ON hubsupplier.DVS_hub_supplier=linklineorder.DVS_hub_supplier
	JOIN satsupplier ON hubsupplier.DVS_hub_supplier=satsupplier.DVS_hub_supplier
	JOIN hubpart ON hubpart.DVS_hub_part=linklineorder.DVS_hub_part
	JOIN satpart ON hubpart.DVS_hub_part=satpart.DVS_hub_part
where c_region = 'AMERICA'
and s_region = 'AMERICA'
and (p_mfgr = 'MFGR#1' or p_mfgr = 'MFGR#2')
group by d_year, c_nation
order by d_year, c_nation;
--Q4.2
select d_year, s_nation, p_category,sum(lo_revenue - lo_supplycost) as profit
FROM linklineorder
	JOIN satlineorder ON satlineorder.DVS_link_lineorder=linklineorder.DVS_link_lineorder
	JOIN hubdate1 ON hubdate1.DVS_hub_date1=linklineorder.DVS_hub_date1
	JOIN satdate1 ON hubdate1.DVS_hub_date1=satdate1.DVS_hub_date1
	JOIN hubcustomer ON hubcustomer.DVS_hub_customer=linklineorder.DVS_hub_customer
	JOIN satcustomer ON hubcustomer.DVS_hub_customer=satcustomer.DVS_hub_customer
	JOIN hubsupplier ON hubsupplier.DVS_hub_supplier=linklineorder.DVS_hub_supplier
	JOIN satsupplier ON hubsupplier.DVS_hub_supplier=satsupplier.DVS_hub_supplier
	JOIN hubpart ON hubpart.DVS_hub_part=linklineorder.DVS_hub_part
	JOIN satpart ON hubpart.DVS_hub_part=satpart.DVS_hub_part
where c_region = 'AMERICA'
and s_region = 'AMERICA'
and (d_year = 1997 or d_year = 1998)
and (p_mfgr = 'MFGR#1'
or p_mfgr = 'MFGR#2')
group by d_year, s_nation, p_category
order by d_year, s_nation, p_category;
--Q4.3
select d_year, s_city, p_brand1, sum(lo_revenue- lo_supplycost) as profit
FROM linklineorder
	JOIN satlineorder ON satlineorder.DVS_link_lineorder=linklineorder.DVS_link_lineorder
	JOIN hubdate1 ON hubdate1.DVS_hub_date1=linklineorder.DVS_hub_date1
	JOIN satdate1 ON hubdate1.DVS_hub_date1=satdate1.DVS_hub_date1
	JOIN hubcustomer ON hubcustomer.DVS_hub_customer=linklineorder.DVS_hub_customer
	JOIN satcustomer ON hubcustomer.DVS_hub_customer=satcustomer.DVS_hub_customer
	JOIN hubsupplier ON hubsupplier.DVS_hub_supplier=linklineorder.DVS_hub_supplier
	JOIN satsupplier ON hubsupplier.DVS_hub_supplier=satsupplier.DVS_hub_supplier
	JOIN hubpart ON hubpart.DVS_hub_part=linklineorder.DVS_hub_part
	JOIN satpart ON hubpart.DVS_hub_part=satpart.DVS_hub_part
where c_region = 'AMERICA'
and s_nation = 'UNITED STATES'
and (d_year = 1997 or d_year = 1998)
and p_category = 'MFGR#14'
group by d_year, s_city, p_brand1
order by d_year, s_city, p_brand1;