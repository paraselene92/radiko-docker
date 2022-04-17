import sys
import boto3

def create_presign_url(bucketname, objectname, expiration=3600):
    client = boto3.client("s3")
    try:
        response = client.generate_presigned_url(
            'get_object',
            Params={
                'Bucket': bucketname,
                'Key': objectname,
            },
            ExpiresIn=expiration
        )
    except:
        print("Error!")
        return None

    return response

if __name__ == '__main__':
    response = create_presign_url(sys.argv[1], sys.argv[2], sys.argv[3])
    print(response)

