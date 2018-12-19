# avg-revenue-per-customer
SQL script that takes csv file on transaction data over a year
and calculates average revenue per customer for each day of the year.

Be sure to change the destination directories to what works for your computer.
If there is any issue with writing the files, make sure database user
has file writing permissions in order to import export your csv files.
This can be done by making sure the directory has read write access
(ie. postgres user has read & write permissions on downloads folder)

this can be done in the terminal using
chmod a+rX /users/your_username/ /users/your_username/downloads /users/your_username/downloads/payments_data.csv

This code needs to be refactored to not create a new table every query. Work in progress will update.
use the following syntax.

UPDATE A
SET A.c1 = expresion
FROM B
WHERE A.c2 = B.c2;
