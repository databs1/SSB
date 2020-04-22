# SSB
Benchmarking Star Schema Models, Data Vaults and Anchor Models
Inspired by Pat O'Neil, Betty O'Neil, Xuedong Chen, check [https://www.cs.umb.edu/~poneil/StarSchemaB.PDF](https://www.cs.umb.edu/~poneil/StarSchemaB.PDF) 
for more information on the Star Schema Benchmark used. All the tests were done on the Postgres command terminal locally.


The Star Schema Model from the paper was modified :
![SSB Model](https://github.com/databs1/SSB/blob/master/SSB.PNG?raw=true)

UML class diagram of the Data Vault Model : 
![Data Vault Model](https://github.com/databs1/SSB/blob/master/Data_vault_SSB.png?raw=true)

UML class diagram of the Anchor Model : 
![Anchor Model](https://github.com/databs1/SSB/blob/master/AnchorModel.PNG?raw=true)


The idea of the project was to compare the Star Schema model to the Data Vault and Anchor Models performance wise. 
Here are some results on a not so fast setup (8gbs of RAM, 4 cores) :
![SF1 Results](https://github.com/databs1/SSB/blob/master/ResultatSF1.PNG?raw=true)
