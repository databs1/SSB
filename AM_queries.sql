--Q1.1
select sum(fl_epr_factlineorder_extendedprice*fl_dsc_factlineorder_discount) as revenue
FROM dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 li
	JOIN dbo.dd_dimdate1 dd ON dd.dd_id=li.dd_id_is1
	LEFT JOIN dbo._dd_yrs_dimdate1_year yr ON yr.dd_yrs_dd_id = dd.dd_id
	JOIN dbo.fl_factlineorder fl ON fl.fl_id=li.fl_id_isordby
	LEFT JOIN dbo._fl_dsc_factlineorder_discount ds ON ds.fl_dsc_fl_id = fl.fl_id
	LEFT JOIN dbo._fl_qty_factlineorder_quantity qt ON qt.fl_qty_fl_id = fl.fl_id
	LEFT JOIN dbo._fl_epr_factlineorder_extendedprice ep ON ep.fl_epr_fl_id = fl.fl_id
 where dd_yrs_dimdate1_year = 1993
 and fl_dsc_factlineorder_discount between 1 and 3
 and fl_qty_factlineorder_quantity < 25;
--Q1.2
select sum(fl_epr_factlineorder_extendedprice*fl_dsc_factlineorder_discount) as revenue
FROM dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 li
	JOIN dbo.dd_dimdate1 dd ON dd.dd_id=li.dd_id_is1
	LEFT JOIN dbo.dd_ymn_dimdate1_yearmonthnum ymn ON ymn.dd_ymn_dd_id = dd.dd_id
	JOIN dbo.fl_factlineorder fl ON fl.fl_id=li.fl_id_isordby
	LEFT JOIN dbo._fl_dsc_factlineorder_discount ds ON ds.fl_dsc_fl_id = fl.fl_id
	LEFT JOIN dbo._fl_qty_factlineorder_quantity qt ON qt.fl_qty_fl_id = fl.fl_id
	LEFT JOIN dbo._fl_epr_factlineorder_extendedprice ep ON ep.fl_epr_fl_id = fl.fl_id
 where dd_ymn_dimdate1_yearmonthnum = 199401
 and fl_dsc_factlineorder_discount between 4 and 6
 and fl_qty_factlineorder_quantity between 26 and 35;
--Q1.3
select sum(fl_epr_factlineorder_extendedprice*fl_dsc_factlineorder_discount) as revenue
FROM dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 li
	JOIN dbo.dd_dimdate1 dd ON dd.dd_id=li.dd_id_is1
	LEFT JOIN dbo._dd_yrs_dimdate1_year yr ON yr.dd_yrs_dd_id = dd.dd_id
	LEFT JOIN dbo._dd_wny_dimdate1_weeknuminyear wny ON wny.dd_wny_dd_id = dd.dd_id
	JOIN dbo.fl_factlineorder fl ON fl.fl_id=li.fl_id_isordby
	LEFT JOIN dbo._fl_dsc_factlineorder_discount ds ON ds.fl_dsc_fl_id = fl.fl_id
	LEFT JOIN dbo._fl_qty_factlineorder_quantity qt ON qt.fl_qty_fl_id = fl.fl_id
	LEFT JOIN dbo._fl_epr_factlineorder_extendedprice ep ON ep.fl_epr_fl_id = fl.fl_id
 where dd_wny_dimdate1_weeknuminyear = 6 
 and dd_yrs_dimdate1_year = 1993
 and fl_dsc_factlineorder_discount between 5 and 7
 and fl_qty_factlineorder_quantity between 26 and 35;
--Q2.1
SELECT sum(fl_rvn_factlineorder_revenue), dd_yrs_dimdate1_year, dp_bra_dimpart_brand1
FROM dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 li
	JOIN dbo.dd_dimdate1 dd ON dd.dd_id=li.dd_id_is1
	LEFT JOIN dbo._dd_yrs_dimdate1_year yr ON yr.dd_yrs_dd_id = dd.dd_id
	JOIN dbo.dp_dimpart prt ON prt.dp_id=li.dp_id_ispof
	LEFT JOIN dbo._dp_bra_dimpart_brand1 br ON br.dp_bra_dp_id= prt.dp_id
	LEFT JOIN dbo._dp_cat_dimpart_category cat ON cat.dp_cat_dp_id= prt.dp_id
	JOIN dbo._ds_dimsupplier cst ON cst.ds_id = li.ds_id_issuppby
	LEFT JOIN dbo._ds_reg_dimsupplier_region rg ON rg.ds_reg_ds_id =cst.ds_id
	JOIN dbo.fl_factlineorder fl ON fl.fl_id=li.fl_id_isordby
	LEFT JOIN dbo._fl_rvn_factlineorder_revenue rv ON rv.fl_rvn_fl_id = fl.fl_id 	
WHERE dp_cat_dimpart_category = 'MFGR#12'
AND ds_reg_dimsupplier_region = 'AMERICA'
group by dd_yrs_dimdate1_year, dp_bra_dimpart_brand1
order by dd_yrs_dimdate1_year, dp_bra_dimpart_brand1;
--Q2.2
SELECT sum(fl_rvn_factlineorder_revenue), dd_yrs_dimdate1_year, dp_bra_dimpart_brand1
FROM dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 li
	JOIN dbo.dd_dimdate1 dd ON dd.dd_id=li.dd_id_is1
	LEFT JOIN dbo._dd_yrs_dimdate1_year yr ON yr.dd_yrs_dd_id = dd.dd_id
	JOIN dbo.dp_dimpart prt ON prt.dp_id=li.dp_id_ispof
	LEFT JOIN dbo._dp_bra_dimpart_brand1 br ON br.dp_bra_dp_id= prt.dp_id
	JOIN dbo._ds_dimsupplier cst ON cst.ds_id = li.ds_id_issuppby
	LEFT JOIN dbo._ds_reg_dimsupplier_region rg ON rg.ds_reg_ds_id =cst.ds_id
	JOIN dbo.fl_factlineorder fl ON fl.fl_id=li.fl_id_isordby
	LEFT JOIN dbo._fl_rvn_factlineorder_revenue rv ON rv.fl_rvn_fl_id = fl.fl_id 	
WHERE dp_bra_dimpart_brand1 between 'MFGR#2221' and 'MFGR#2228'
AND ds_reg_dimsupplier_region = 'ASIA'
group by dd_yrs_dimdate1_year, dp_bra_dimpart_brand1
order by dd_yrs_dimdate1_year, dp_bra_dimpart_brand1;
--Q2.3
SELECT sum(fl_rvn_factlineorder_revenue), dd_yrs_dimdate1_year, dp_bra_dimpart_brand1
FROM dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 li
	JOIN dbo.dd_dimdate1 dd ON dd.dd_id=li.dd_id_is1
	LEFT JOIN dbo._dd_yrs_dimdate1_year yr ON yr.dd_yrs_dd_id = dd.dd_id
	JOIN dbo.dp_dimpart prt ON prt.dp_id=li.dp_id_ispof
	LEFT JOIN dbo._dp_bra_dimpart_brand1 br ON br.dp_bra_dp_id= prt.dp_id
	JOIN dbo._ds_dimsupplier cst ON cst.ds_id = li.ds_id_issuppby
	LEFT JOIN dbo._ds_reg_dimsupplier_region rg ON rg.ds_reg_ds_id =cst.ds_id
	JOIN dbo.fl_factlineorder fl ON fl.fl_id=li.fl_id_isordby
	LEFT JOIN dbo._fl_rvn_factlineorder_revenue rv ON rv.fl_rvn_fl_id = fl.fl_id 	
WHERE dp_bra_dimpart_brand1 = 'MFGR#2221'
AND ds_reg_dimsupplier_region = 'EUROPE'
group by dd_yrs_dimdate1_year, dp_bra_dimpart_brand1
order by dd_yrs_dimdate1_year, dp_bra_dimpart_brand1;
--Q3.1
select dc_nat_dimcustomer_nation, ds_nat_dimsupplier_nation, dd_yrs_dimdate1_year, sum(fl_rvn_factlineorder_revenue) as revenue
FROM dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 li
	JOIN dbo.dd_dimdate1 dd ON dd.dd_id=li.dd_id_is1
	LEFT JOIN dbo._dd_yrs_dimdate1_year yr ON yr.dd_yrs_dd_id = dd.dd_id
	JOIN dbo.fl_factlineorder fl ON fl.fl_id=li.fl_id_isordby
	LEFT JOIN dbo._fl_rvn_factlineorder_revenue rv ON rv.fl_rvn_fl_id = fl.fl_id 
	JOIN dbo._ds_dimsupplier sup ON sup.ds_id = li.ds_id_issuppby
	LEFT JOIN dbo._ds_reg_dimsupplier_region rgs ON rgs.ds_reg_ds_id = sup.ds_id
	LEFT JOIN dbo._ds_nat_dimsupplier_nation nts ON nts.ds_nat_ds_id = sup.ds_id
	JOIN dbo._dc_dimcustomer cst ON cst.dc_id = li.dc_id_iscustrof
	LEFT JOIN dbo._dc_nat_dimcustomer_nation ntc ON ntc.dc_nat_dc_id = cst.dc_id
	LEFT JOIN dbo._dc_reg_dimcustomer_region rgc ON rgc.dc_reg_dc_id = cst.dc_id
where dc_reg_dimcustomer_region = 'ASIA' and ds_reg_dimsupplier_region = 'ASIA'
and dd_yrs_dimdate1_year >= 1992 and dd_yrs_dimdate1_year <= 1997
group by dc_nat_dimcustomer_nation, ds_nat_dimsupplier_nation, dd_yrs_dimdate1_year
order by dd_yrs_dimdate1_year asc, revenue desc;
--Q3.2
select dc_cit_dimcustomer_city, ds_cit_dimsupplier_city, dd_yrs_dimdate1_year, sum(fl_rvn_factlineorder_revenue) as revenue
FROM dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 li
	JOIN dbo.dd_dimdate1 dd ON dd.dd_id=li.dd_id_is1
	LEFT JOIN dbo._dd_yrs_dimdate1_year yr ON yr.dd_yrs_dd_id = dd.dd_id
	JOIN dbo.fl_factlineorder fl ON fl.fl_id=li.fl_id_isordby
	LEFT JOIN dbo._fl_rvn_factlineorder_revenue rv ON rv.fl_rvn_fl_id = fl.fl_id 
	JOIN dbo._ds_dimsupplier sup ON sup.ds_id = li.ds_id_issuppby
	LEFT JOIN dbo._ds_reg_dimsupplier_region rgs ON rgs.ds_reg_ds_id = sup.ds_id
	LEFT JOIN dbo._ds_nat_dimsupplier_nation nts ON nts.ds_nat_ds_id = sup.ds_id
	LEFT JOIN dbo._ds_cit_dimsupplier_city cty ON cty.ds_cit_ds_id = sup.ds_id
	JOIN dbo._dc_dimcustomer cst ON cst.dc_id = li.dc_id_iscustrof
	LEFT JOIN dbo._dc_nat_dimcustomer_nation ntc ON ntc.dc_nat_dc_id = cst.dc_id
	LEFT JOIN dbo._dc_reg_dimcustomer_region rgc ON rgc.dc_reg_dc_id = cst.dc_id
	LEFT JOIN dbo._dc_cit_dimcustomer_city sty ON sty.dc_cit_dc_id = cst.dc_id
where dc_nat_dimcustomer_nation = 'UNITED STATES' 
and ds_nat_dimsupplier_nation = 'UNITED STATES'
and dd_yrs_dimdate1_year >= 1992 and dd_yrs_dimdate1_year <= 1997
group by dc_cit_dimcustomer_city, ds_cit_dimsupplier_city, dd_yrs_dimdate1_year
order by dd_yrs_dimdate1_year asc, revenue desc;
--Q3.3
select dc_cit_dimcustomer_city, ds_cit_dimsupplier_city, dd_yrs_dimdate1_year, sum(fl_rvn_factlineorder_revenue) as revenue
FROM dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 li
	JOIN dbo.dd_dimdate1 dd ON dd.dd_id=li.dd_id_is1
	LEFT JOIN dbo._dd_yrs_dimdate1_year yr ON yr.dd_yrs_dd_id = dd.dd_id
	JOIN dbo.fl_factlineorder fl ON fl.fl_id=li.fl_id_isordby
	LEFT JOIN dbo._fl_rvn_factlineorder_revenue rv ON rv.fl_rvn_fl_id = fl.fl_id 
	JOIN dbo._ds_dimsupplier sup ON sup.ds_id = li.ds_id_issuppby
	LEFT JOIN dbo._ds_cit_dimsupplier_city cty ON cty.ds_cit_ds_id = sup.ds_id
	JOIN dbo._dc_dimcustomer cst ON cst.dc_id = li.dc_id_iscustrof
	LEFT JOIN dbo._dc_cit_dimcustomer_city sty ON sty.dc_cit_dc_id = cst.dc_id
where (dc_cit_dimcustomer_city='UNITED KI1'
 or dc_cit_dimcustomer_city='UNITED KI5')
 and (ds_cit_dimsupplier_city='UNITED KI1'
 or ds_cit_dimsupplier_city='UNITED KI5')
 and dd_yrs_dimdate1_year >= 1992 and dd_yrs_dimdate1_year <= 1997
 group by dc_cit_dimcustomer_city, ds_cit_dimsupplier_city, dd_yrs_dimdate1_year
 order by dd_yrs_dimdate1_year asc, revenue desc;
--Q3.4
select dc_cit_dimcustomer_city, ds_cit_dimsupplier_city, dd_yrs_dimdate1_year, sum(fl_rvn_factlineorder_revenue) as revenue
FROM dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 li
	JOIN dbo.dd_dimdate1 dd ON dd.dd_id=li.dd_id_is1
	LEFT JOIN dbo._dd_yrs_dimdate1_year yr ON yr.dd_yrs_dd_id = dd.dd_id
	LEFT JOIN dbo._dd_ymm_dimdate1_yearmonth ymr ON ymr.dd_ymm_dd_id = dd.dd_id
	JOIN dbo.fl_factlineorder fl ON fl.fl_id=li.fl_id_isordby
	LEFT JOIN dbo._fl_rvn_factlineorder_revenue rv ON rv.fl_rvn_fl_id = fl.fl_id 
	JOIN dbo._ds_dimsupplier sup ON sup.ds_id = li.ds_id_issuppby
	LEFT JOIN dbo._ds_cit_dimsupplier_city cty ON cty.ds_cit_ds_id = sup.ds_id
	JOIN dbo._dc_dimcustomer cst ON cst.dc_id = li.dc_id_iscustrof
	LEFT JOIN dbo._dc_cit_dimcustomer_city sty ON sty.dc_cit_dc_id = cst.dc_id
where (dc_cit_dimcustomer_city='UNITED KI1'
 or dc_cit_dimcustomer_city='UNITED KI5')
 and (ds_cit_dimsupplier_city='UNITED KI1'
 or ds_cit_dimsupplier_city='UNITED KI5')
 and dd_ymm_dimdate1_yearmonth = 'Dec1997'
 group by dc_cit_dimcustomer_city, ds_cit_dimsupplier_city, dd_yrs_dimdate1_year
 order by dd_yrs_dimdate1_year asc, revenue desc;
--Q4.1
select yr.dd_yrs_dimdate1_year, ntc.dc_nat_dimcustomer_nation, sum(rv.fl_rvn_factlineorder_revenue -sc.fl_sct_factlineorder_supplycost) as profit
FROM dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 li
	JOIN dbo.dd_dimdate1 dd ON dd.dd_id=li.dd_id_is1
	LEFT JOIN dbo._dd_yrs_dimdate1_year yr ON yr.dd_yrs_dd_id = dd.dd_id
	JOIN dbo.fl_factlineorder fl ON fl.fl_id=li.fl_id_isordby
	LEFT JOIN dbo._fl_sct_factlineorder_supplycost sc ON sc.fl_sct_fl_id = fl.fl_id 
	LEFT JOIN dbo._fl_rvn_factlineorder_revenue rv ON rv.fl_rvn_fl_id = fl.fl_id 
	JOIN dbo._ds_dimsupplier sup ON sup.ds_id = li.ds_id_issuppby
	LEFT JOIN dbo._ds_reg_dimsupplier_region rgs ON rgs.ds_reg_ds_id = sup.ds_id
	JOIN dbo._dc_dimcustomer cst ON cst.dc_id = li.dc_id_iscustrof
	LEFT JOIN dbo._dc_reg_dimcustomer_region rgc ON rgc.dc_reg_dc_id = cst.dc_id
	LEFT JOIN dbo._dc_nat_dimcustomer_nation ntc ON ntc.dc_nat_dc_id = cst.dc_id
	JOIN dbo._dp_dimpart dpt ON dpt.dp_id = li.dp_id_ispof
	LEFT JOIN dbo._dp_mtg_dimpart_mfgr mfg ON mfg.dp_mtg_dp_id = dpt.dp_id	
where rgc.dc_reg_dimcustomer_region = 'AMERICA'
and rgs.ds_reg_dimsupplier_region = 'AMERICA'
and (mfg.dp_mtg_dimpart_mfgr = 'MFGR#1' or mfg.dp_mtg_dimpart_mfgr = 'MFGR#2')
group by yr.dd_yrs_dimdate1_year, ntc.dc_nat_dimcustomer_nation
order by yr.dd_yrs_dimdate1_year, ntc.dc_nat_dimcustomer_nation;
--Q4.2
select yr.dd_yrs_dimdate1_year, ntc.dc_nat_dimcustomer_nation, cat.dp_cat_dimpart_category, sum(rv.fl_rvn_factlineorder_revenue -sc.fl_sct_factlineorder_supplycost) as profit
FROM dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 li
	JOIN dbo.dd_dimdate1 dd ON dd.dd_id=li.dd_id_is1
	LEFT JOIN dbo._dd_yrs_dimdate1_year yr ON yr.dd_yrs_dd_id = dd.dd_id
	JOIN dbo.fl_factlineorder fl ON fl.fl_id=li.fl_id_isordby
	LEFT JOIN dbo._fl_sct_factlineorder_supplycost sc ON sc.fl_sct_fl_id = fl.fl_id 
	LEFT JOIN dbo._fl_rvn_factlineorder_revenue rv ON rv.fl_rvn_fl_id = fl.fl_id 
	JOIN dbo._ds_dimsupplier sup ON sup.ds_id = li.ds_id_issuppby
	LEFT JOIN dbo._ds_reg_dimsupplier_region rgs ON rgs.ds_reg_ds_id = sup.ds_id
	JOIN dbo._dc_dimcustomer cst ON cst.dc_id = li.dc_id_iscustrof
	LEFT JOIN dbo._dc_reg_dimcustomer_region rgc ON rgc.dc_reg_dc_id = cst.dc_id
	LEFT JOIN dbo._dc_nat_dimcustomer_nation ntc ON ntc.dc_nat_dc_id = cst.dc_id
	JOIN dbo._dp_dimpart dpt ON dpt.dp_id = li.dp_id_ispof
	LEFT JOIN dbo._dp_mtg_dimpart_mfgr mfg ON mfg.dp_mtg_dp_id = dpt.dp_id
	LEFT JOIN dbo._dp_cat_dimpart_category cat ON cat.dp_cat_dp_id= dpt.dp_id
where rgc.dc_reg_dimcustomer_region = 'AMERICA'
and rgs.ds_reg_dimsupplier_region = 'AMERICA'
and (dd_yrs_dimdate1_year = 1997 or dd_yrs_dimdate1_year = 1998) 
and (mfg.dp_mtg_dimpart_mfgr = 'MFGR#1' or mfg.dp_mtg_dimpart_mfgr = 'MFGR#2')
group by yr.dd_yrs_dimdate1_year, ntc.dc_nat_dimcustomer_nation,dp_cat_dimpart_category
order by yr.dd_yrs_dimdate1_year, ntc.dc_nat_dimcustomer_nation,dp_cat_dimpart_category;
--Q4.3
select yr.dd_yrs_dimdate1_year, ds_cit_dimsupplier_city, br1.dp_bra_dimpart_brand1, sum(rv.fl_rvn_factlineorder_revenue -sc.fl_sct_factlineorder_supplycost) as profit
FROM dbo._dp_ispof_fl_isordby_dd_is1_dc_iscustrof_ds_issuppby_da_is2 li
	JOIN dbo.dd_dimdate1 dd ON dd.dd_id=li.dd_id_is1
	LEFT JOIN dbo._dd_yrs_dimdate1_year yr ON yr.dd_yrs_dd_id = dd.dd_id
	JOIN dbo.fl_factlineorder fl ON fl.fl_id=li.fl_id_isordby
	LEFT JOIN dbo._fl_sct_factlineorder_supplycost sc ON sc.fl_sct_fl_id = fl.fl_id 
	LEFT JOIN dbo._fl_rvn_factlineorder_revenue rv ON rv.fl_rvn_fl_id = fl.fl_id 
	JOIN dbo._ds_dimsupplier sup ON sup.ds_id = li.ds_id_issuppby
	LEFT JOIN dbo._ds_nat_dimsupplier_nation nat ON nat.ds_nat_ds_id = sup.ds_id
	LEFT JOIN dbo._ds_cit_dimsupplier_city ctd ON ctd.ds_cit_ds_id = sup.ds_id
	JOIN dbo._dc_dimcustomer cst ON cst.dc_id = li.dc_id_iscustrof
	LEFT JOIN dbo._dc_reg_dimcustomer_region rgc ON rgc.dc_reg_dc_id = cst.dc_id
	JOIN dbo._dp_dimpart dpt ON dpt.dp_id = li.dp_id_ispof
	LEFT JOIN dbo._dp_cat_dimpart_category cat ON cat.dp_cat_dp_id= dpt.dp_id
	LEFT JOIN dbo._dp_bra_dimpart_brand1 br1 ON br1.dp_bra_dp_id = dpt.dp_id
where rgc.dc_reg_dimcustomer_region = 'AMERICA'
and nat.ds_nat_dimsupplier_nation = 'UNITED STATES'
and (dd_yrs_dimdate1_year = 1997 or dd_yrs_dimdate1_year = 1998) 
and cat.dp_cat_dimpart_category = 'MFGR#14'
group by yr.dd_yrs_dimdate1_year, ctd.ds_cit_dimsupplier_city, br1.dp_bra_dimpart_brand1
order by yr.dd_yrs_dimdate1_year, ctd.ds_cit_dimsupplier_city, br1.dp_bra_dimpart_brand1;
