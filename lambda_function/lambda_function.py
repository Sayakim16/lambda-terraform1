import json

def handler(event, context):
    print("Lambda triggered by CloudWatch Event:", json.dumps(event))
    return {
        "statusCode": 200,
        "body": json.dumps("Lambda executed successfully!")
    }