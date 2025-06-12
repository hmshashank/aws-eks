#!/usr/bin/env python3
import os
from aws_cdk import App
from s3_stack import S3BucketStack

app = App()

bucket_name = os.environ.get('BUCKET_NAME', 'my-cdk-bucket')
aws_region = os.environ.get('AWS_REGION', 'us-east-1')

S3BucketStack(app, "S3BucketStack",
    bucket_name=bucket_name,
    env={'region': aws_region}
)

app.synth()