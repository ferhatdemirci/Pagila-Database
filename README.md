#*`PAGILA Database`*
====================

### Follow the instructions to download and install the pagila database in PostgresSQL and practise SQL queries:
* Download : [Pagila Databse link](https://www.postgresql.org/ftp/projects/pgFoundry/dbsamples/pagila/pagila/)
* Create the database:
	1. Unzip the downloaded folder and open CMD from Windows
	2. Go to the folder where you have pagila database with (cd commands)
	3. Run this: psql -U postgres
		* type your pasword for postgres
	4. Once you are connected to postgres from cmd run these commands
		* \i pagila-schema.sql
		* \i pagila-insert-data.sql
		* \i pagila-data.sql
	5. \connect pagila
* Now the your database is up and running, now you can go to the PgAdmin to run and practise the SQL queries.
