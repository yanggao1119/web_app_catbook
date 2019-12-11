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

## craete a temp dir to store temp uploaded files
mkdir -p /tmp/upload_tmp

## launch server with command
git clone https://github.com/yanggao1119/laioffer_cloud_computing.git
## TODO: run this with nohup, currently I am using screen
FLASK_APP=~/laioffer_cloud_computing/toy_project/server.py flask run --host=0.0.0.0 --port=8080

## create files 
# ==> ~/.aws/config <==
# [default]
# output = json
# region = us-east-1

# ==> ~/.aws/credentials <==
# [default]
# aws_access_key_id = xxx
# aws_secret_access_key = xxx

## test server http://ec2-3-87-22-58.compute-1.amazonaws.com:8080/