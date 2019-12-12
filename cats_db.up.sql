-- Instructions: manually connect to MySQL RDS instance via commandline:
-- mysql -v -h cats-db.cfc6dnp2haqb.us-east-1.rds.amazonaws.com -u admin -p
-- and run these
create database cats_db;
use cats_db;
create table cats (name VARCHAR(255), description TEXT, image_key VARCHAR(255));