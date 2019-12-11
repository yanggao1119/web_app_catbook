-- Instructions: manually connect to MySQL RDS instance via commandline:
-- mysql -v -h ads-db.cfc6dnp2haqb.us-east-1.rds.amazonaws.com -u admin -p
-- and run these
create database ads_db;
use ads_db;
create table ads (name VARCHAR(255), description TEXT, image_key VARCHAR(255));