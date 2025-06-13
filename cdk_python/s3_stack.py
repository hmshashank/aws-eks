from aws_cdk import (
    Stack,
    CfnOutput,
    aws_s3 as s3,
    RemovalPolicy  # Add this import
)
from constructs import Construct

class S3BucketStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, bucket_name: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # Create an S3 bucket
        bucket = s3.Bucket(self, "SimpleBucket",
            bucket_name=bucket_name,
            removal_policy=RemovalPolicy.DESTROY,
            auto_delete_objects=True
        )

        # Output the bucket name
        CfnOutput(self, "BucketName", value=bucket.bucket_name)
        
        # Output the bucket ARN
        CfnOutput(self, "BucketArn", value=bucket.bucket_arn)
