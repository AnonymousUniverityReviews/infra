import boto3
import psycopg2

def handler(event, context):
    validate(event)
    sql_script = download(event)
    connection = get_db_connection(event['db_name'])
    
    if connection is None:
        raise RuntimeError("DB connection failed")
    with connection:
        with connection.cursor() as cur:
            print(f"Executing script...")
            cur.execute(sql_script)
            print(f"Script executed successfully")

def validate(event):
    if 'bucket' not in event or 'key' not in event or 'db_name' not in event:
        raise ValueError("Bucket, key and database name are required")
    if not event['key'].endswith('.sql'):
        raise ValueError("Invalid key name")
    if event['bucket'] == "":
        raise ValueError("Bucket name cannot be empty")
    if event['key'] == "":
        raise ValueError("Key name cannot be empty")
    if event['db_name'] == "":
        raise ValueError("Database name cannot be empty")

def download(event):
    s3 = boto3.client("s3")
    obj = s3.get_object(
        Bucket=event["bucket"],
        Key=event["key"]
    )
    return obj["Body"].read().decode("utf-8")

def get_db_connection(db_identifier, region='eu-central-1'):
    rds_client = boto3.client('rds', region_name=region)
    
    try:
        response = rds_client.describe_db_instances(DBInstanceIdentifier=db_identifier)
        db_instance = response['DBInstances'][0]
        
        hostname = db_instance['Endpoint']['Address']
        port = db_instance['Endpoint']['Port']
        username = db_instance['MasterUsername']
        db_name =  db_instance['DBName']
        

        auth_token = rds_client.generate_db_auth_token(
            DBHostname=hostname,
            Port=port,
            DBUsername=username,
            Region=region
        )

        conn = psycopg2.connect(
            host=hostname,
            port=port,
            database=db_name,
            user=username,
            password=auth_token,
            sslmode="require"
        )
        return conn

    except Exception as e:
        print(f"Error: {e}")
        return None
