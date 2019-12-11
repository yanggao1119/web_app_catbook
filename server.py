from flask import Flask, session
from flask import redirect, url_for, jsonify, flash, request, render_template
from flask_session import Session

import MySQLdb
import uuid
import boto3
import os

# set up Flask app
app = Flask(__name__)
app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True
UPLOAD_DIR = '/tmp/upload_tmp'
app.config['UPLOAD_FOLDER'] = UPLOAD_DIR
SESSION_TYPE = 'filesystem'
app.config.from_object(__name__)
Session(app)

# RDS configs
RDS_USER = 'admin'
RDS_PASSWORD = 'laioffer'
RDS_HOST = 'ads-db.cfc6dnp2haqb.us-east-1.rds.amazonaws.com'
RDS_PORT = 3306
RDS_DB = 'ads_db'

# S3 configs
BUCKET_NAME = 'yanggao-ads-upload'

# S3 resource setup
s3 = boto3.resource('s3')
s3_client = boto3.client('s3')
bucket = s3.Bucket(BUCKET_NAME)

def rds_get_connection():
  return MySQLdb.connect(
    host=RDS_HOST,
    port=RDS_PORT,
    user=RDS_USER,
    password=RDS_PASSWORD,
    database=RDS_DB)

def rds_execute_query(query):
  conn = rds_get_connection()
  cursor = conn.cursor()
  cursor.execute(query)
  rows = cursor.fetchall()
  cursor.close()
  conn.commit()
  conn.close()
  return rows

def generate_uuid():
  return str(uuid.uuid4())

# S3 operations
def s3_check_exist(object_name):
  for obj in bucket.objects.filter(Prefix=object_name):
    if obj.key == object_name:
      return True
  return False

def s3_upload_file(file_path, object_name):
  s3.Object(BUCKET_NAME, object_name).upload_file(file_path)

def s3_list_objects():
  object_list = []
  for obj in bucket.objects.all():
    object_list.append(obj.key)
  return object_list

def s3_get_presigned_url(obj):
  try:
    return s3_client.generate_presigned_url('get_object', Params={'Bucket': BUCKET_NAME, 'Key': obj}, ExpiresIn=300)
  except Exception as err:
    print(err)
    return None

def insert_ad(name, description, image_key):
  query = "INSERT INTO ads(name, description, image_key) VALUES ('{}', '{}', '{}')".format(name, description, image_key)
  rds_execute_query(query)

def list_ads():
  objs = s3_list_objects()
  obj_url_map = {}
  for obj in objs:
    obj_url_map[obj] = s3_get_presigned_url(obj)
  ads = []
  res = rds_execute_query('SELECT * FROM ads')
  for (name, description, image_key) in res:
    ads.append({
                  'name': name, 
                  'description': description,
                  'image_key': image_key,
                  'image_url': obj_url_map[image_key]
                })
  return ads

@app.route('/')
def index():
  return render_template('index.html', ads=list_ads())

#methods used to be ['GET', 'POST'] before allowing uploading image files
@app.route('/upload', methods=['POST'])
def upload():
  if request.method == 'POST':
    if 'file' not in request.files:
      flash('No file part.')
    else:
      file = request.files['file']
      if not file.filename:
        flash('No selected file.')
      else:
        _, ext = os.path.splitext(file.filename)
        image_key = generate_uuid() + ext
        while s3_check_exist(image_key):
          image_key = generate_uuid() + ext
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], image_key)
        file.save(file_path)
        s3_upload_file(file_path, image_key)
        insert_ad(request.form['name'], request.form['description'], image_key)
  return redirect(url_for('index'))
