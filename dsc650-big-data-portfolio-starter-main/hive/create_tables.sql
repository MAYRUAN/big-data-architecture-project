-- DSC 650 Portfolio Starter
-- Replace this file with the Hive DDL from your final project.
--
-- Before publishing:
--   1. Remove credentials or environment-specific secrets.
--   2. Add short comments explaining important tables.
--   3. Keep the SQL that best demonstrates your work.

-- In the Hive CLI, create a table named branch_growth:
CREATE TABLE branch_growth (
  `Branch_ID` STRING,
  `Region` STRING,
  `Ad_Budget_K` INT,
  `New_Accnts_Opened` INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
tblproperties("skip.header.line.count"="1");


-- Load data into the Hive Managed table branch_growth:
LOAD DATA INPATH '/tmp/branch_growth.csv' INTO TABLE branch_growth;
