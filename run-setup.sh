######################
#### RDS setup
## create RDS instance on AWS RDS console
# - identifier: cats-db
# - username: admin
# - password: admin2019


######################
#### S3 setup
## create S3 bucket on AWS S3 console that is globally unique


######################
#### IAM setup
## create a user on AWS Identity and Access Management(IAM) and give it permission to
## programatically access AWS resource
# - under Permissions tab, attach policy AmazonS3FullAccess
# - under Security credentials tab, create access keys and download to your local


######################
#### EC2 setup
## Step 1: set up EC2 instance in AWS EC2 console
# - instance type: Ubuntu Server 18.04 LTS (HVM), SSD Volume Type 
# - set up new security group catbook, that accepts all inbound TCP traffic to port 8080, in addition to ssh
# - create key pair: catbook_key, and download to your local

## Step 2: connect to EC2 instance via ssh
ssh -i catbook_key.pem ubuntu@ec2-3-84-34-244.compute-1.amazonaws.com

## Step 3: update system and install packages on EC2
# update and install pip, the package installer for Python
sudo apt-get update
sudo apt-get install python-pip -y

# Flask is a Python micro web framework
sudo pip install flask
sudo pip install flask_session

# MySQL client
sudo apt-get install mysql-client -y
sudo apt-get install default-libmysqlclient-dev -y
sudo apt-get install libssl-dev -y
sudo pip install mysqlclient

## AWS CLI and Python utils
sudo pip install awscli
sudo pip install boto3

## Step 4: create AWS config and credential files on EC2 instance with vim, for AWS CLI and boto
# ==> ~/.aws/config <==
# [default]
# region = us-east-1

# ==> ~/.aws/credentials <==
# [default]
# aws_access_key_id = xxx
# aws_secret_access_key = xxx

## Step 5: create a temp dir in the EC2 instance to store temp uploaded files
mkdir -p /tmp/upload_tmp

## Step 6: set up RDS table schema by following instructions in cats_db.up.sql

## Step 7: clone repo from github to EC2 instance. It is a handy way to obtain server.py and templates files
# modify server.py with your RDS and S3 config,
# alternatively you can directly create files and directories on EC2.
git clone https://github.com/yanggao1119/web_app_catbook.git

## Step 8: launch server with the command, and you should be able to test the web app via
# http://ec2-3-84-34-244.compute-1.amazonaws.com:8080/
FLASK_APP=~/web_app_catbook/server.py flask run --host=0.0.0.0 --port=8080
