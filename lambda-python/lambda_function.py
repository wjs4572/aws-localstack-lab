import json
import datetime

def lambda_handler(event, context):
    """
    Simple Lambda function that returns a greeting message.
    Demonstrates basic Lambda structure and response formatting.
    """
    
    # Get name from event, default to 'World'
    name = event.get('name', 'World')
    
    # Current timestamp
    timestamp = datetime.datetime.now().isoformat()
    
    # Construct response
    message = f"Hello, {name}! This is a Python Lambda function."
    
    response = {
        'statusCode': 200,
        'body': json.dumps({
            'message': message,
            'timestamp': timestamp,
            'runtime': 'python3.11',
            'input': event
        })
    }
    
    print(f"Lambda invoked at {timestamp} with name: {name}")
    
    return response
