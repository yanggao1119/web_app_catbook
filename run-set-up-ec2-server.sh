######################
## Step 1: set up ec2 instance in AWS EC2 console
## - instance type: Ubuntu Server 18.04 LTS (HVM), SSD Volume Type 
## - security group catbook, that accepts inbound traffic from anywhere
## - key pair: catbook_key
## make sure the RDS instance accepts traffic from anywhere.

## Step 2: connect to EC2 instance via ssh
#ssh -i catbook_key.pem ubuntu@ec2-3-84-34-244.compute-1.amazonaws.com

## Step 3: update system and install packages on EC2
# update and install pip
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

## Step 4: create a temp dir to store temp uploaded files
mkdir -p /tmp/upload_tmp

## Step 5: create RDS instance on AWS RDS console
## with identifier: cats-db
## username: admin
## password: admin2019
# on EC2 instance
# set up schema by following this: cats_db.up.sql

## Step 6: modify code in python with your RDS and S3 config

## Step 7: create credential files on EC2 instance, boto needs to auth to AWS
# files
# Programmatic access for catbook
# Enables an access key ID and secret access key for the AWS API, CLI, SDK, and other development tools.

# ==> ~/.aws/config <==
# [default]
# output = json
# region = us-east-1

# ==> ~/.aws/credentials <==
# [default]
# aws_access_key_id = xxx
# aws_secret_access_key = xxx


## Step 5: launch server with command
# copy server code
git clone https://github.com/yanggao1119/web_app_catbook.git
## TODO: run this with nohup, currently I am using screen
FLASK_APP=~/web_app_catbook/server.py flask run --host=0.0.0.0 --port=8080



## Step 6: test server http://ec2-3-84-34-244.compute-1.amazonaws.com:8080/