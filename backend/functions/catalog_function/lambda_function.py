import hashlib
import json
import os
from urllib.parse import unquote_plus

import boto3

s3 = boto3.client("s3")



import hashlib
import json
from urllib.parse import unquote_plus

import boto3

s3 = boto3.client("s3")


def lambda_handler(event, context):
    for record in event.get("Records", []):
        # SNS wraps the S3 event in a JSON string.
        if record.get("EventSource") != "aws:sns":
            continue

        sns_message = record["Sns"]["Message"]
        s3_event = json.loads(sns_message)

        for s3_record in s3_event.get("Records", []):
            bucket = s3_record["s3"]["bucket"]["name"]
            obj = s3_record["s3"]["object"]

            # S3 object keys are URL-encoded.
            key = unquote_plus(obj["key"])

            size = obj.get("size")
            etag = obj.get("eTag")
            sequencer = obj.get("sequencer", "")
            event_time = s3_record.get("eventTime")
            event_name = s3_record.get("eventName")

            filename = key.rsplit("/", 1)[-1]
            extension = (
                filename.rsplit(".", 1)[-1].lower()
                if "." in filename and not filename.endswith(".")
                else None
            )

            # A stable output key for duplicate deliveries of the same event.
            identity = f"{bucket}\n{key}\n{sequencer}"
            digest = hashlib.sha256(
                identity.encode("utf-8")
            ).hexdigest()

            metadata_key = f"metadata/{digest}.json"

            metadata = {
                "bucket": bucket,
                "key": key,
                "size_bytes": size,
                "etag": etag,
                "extension": extension,
                "event_time": event_time,
                "event_name": event_name,
                "sequencer": sequencer,
            }

            s3.put_object(
                Bucket=bucket,
                Key=metadata_key,
                Body=json.dumps(metadata, indent=2).encode("utf-8"),
                ContentType="application/json",
            )

            print(
                f"Created metadata for s3://{bucket}/{key} "
                f"at s3://{bucket}/{metadata_key}"
            )

    return {"statusCode": 200, "body": "Processed SNS notification"}
