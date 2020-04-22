/*ADD foreign keys for satellites*/
alter table public.satlineorder add foreign key (DVS_link_lineorder) references Linklineorder;
alter table public.satdate2 add foreign key (DVS_hub_date2) references Hubdate2;
alter table public.satdate1 add foreign key (DVS_hub_date1) references Hubdate1;
alter table public.satsupplier add foreign key (DVS_hub_supplier) references Hubsupplier;
alter table public.satpart add foreign key (DVS_hub_part) references Hubpart;
alter table public.satcustomer add foreign key (DVS_hub_customer) references Hubcustomer;
/* if linklineorder supplied last remove all constraints and readd : */
alter table public.linklineorder add foreign key(dvs_hub_part) references hubpart, 
	add foreign key(DVS_hub_customer) references Hubcustomer,
	add foreign key(DVS_hub_Date1) references Hubdate1,
	add foreign key(DVS_hub_Date2) references Hubdate2,
	add foreign key(DVS_hub_supplier) references Hubsupplier;
/*drop foreign key columns from satlineorder*/
INSERT INTO public.hubdate1 SELECT dvs_hub_date1 FROM satdate1;
INSERT INTO public.hubdate2 SELECT dvs_hub_date2 FROM satdate2;
INSERT INTO public.hubpart SELECT dvs_hub_part FROM satpart;
INSERT INTO public.hubsupplier SELECT dvs_hub_supplier FROM satsupplier;
INSERT INTO public.hubcustomer SELECT dvs_hub_customer FROM satcustomer;
INSERT INTO public.linklineorder(dvs_hub_part,dvs_hub_customer,dvs_hub_date1,dvs_hub_date2,dvs_hub_supplier) SELECT lo_partkey, lo_custkey, lo_orderdate, lo_commitdate, lo_suppkey FROM satlineorder;
/*drop foreign key columns from satlineorder*/
ALTER TABLE public.satlineorder DROP CONSTRAINT lo_pkey;
alter table public.satlineorder drop column lo_custkey,
drop column lo_orderkey,
drop column lo_partkey, 
drop column lo_suppkey,
drop column lo_orderdate,
drop column lo_commitdate;
alter table public.satlineorder add primary key (dvs_link_lineorder,loadts);
alter table public.satlineorder add foreign key (dvs_link_lineorder) references linklineorder;

/*
CREATE IDENTITY books_sequence
  start 2
  increment 2;
UPDATE satlineorder
SET dvs_link_lineorder = linklineorder.dvs_link_lineorder
FROM linklineorder
WHERE linklineorder.loadts = satlineorder.loadts
Select * from dblink_connect('host=localhost user=postgres password=root dbname=SSB');
ALTER TABLE linklineorder ADD COLUMN dvs_link_lineorder SERIAL PRIMARY KEY;

*/