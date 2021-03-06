CREATE TABLE public."payments" (id int, created_at timestamp, user_id int, amount int);
COPY public."payments" FROM '/Users/your_username/Downloads/payments_data.csv' DELIMITER ',' CSV HEADER;

SELECT extract (doy from created_at), * INTO analysis FROM payments;

SELECT * INTO results FROM generate_series(1,365) AS Day;

CREATE OR REPLACE FUNCTION ytdamt()
RETURNS TABLE (rev bigint) AS
$$
BEGIN
FOR i in 1 .. 365 
LOOP
RETURN QUERY Select SUM (amount) from analysis where date_part <=i;
END LOOP;
END;
$$
LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION gen_distinct()
RETURNS TABLE (users bigint) AS
$$
BEGIN
FOR i in 1 .. 365 
LOOP
RETURN QUERY select count(distinct user_id) from analysis where date_part <=i;
END LOOP;
END;
$$
LANGUAGE 'plpgsql';

SELECT * INTO YTD_Revenue FROM ytdamt() as ytd_amt;
SELECT * INTO YTD_Unique FROM gen_distinct() as ytd_distinct_users;

SELECT * INTO revkey FROM (SELECT rev,
ROW_NUMBER () OVER (ORDER BY rev)
FROM ytd_revenue) AS revenue;

SELECT * INTO userkey FROM (SELECT users,
ROW_NUMBER () OVER (ORDER BY users)
FROM ytd_unique) AS users;

SELECT * INTO arpckey
FROM 
(SELECT arpc, ROW_NUMBER() OVER (ORDER BY arpc) FROM
(select (revkey.rev/ userkey.users) as arpc
from revkey, userkey
where revkey.row_number = userkey.row_number) AS arpc
) AS arpc;

COPY (select results.day, arpckey.arpc
from results, arpckey
where results.day = arpckey.row_number)
TO '/Users/your_username/Downloads/arpc.csv'
WITH (FORMAT CSV, HEADER);
