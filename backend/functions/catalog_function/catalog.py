import hashlib
import json
import os
from urllib.parse import unquote_plus

import boto3

s3 = boto3.client("s3")


def handler(event, context):
    print(json.dumps(event))
    for record in event["Records"]:
        bucket = record["s3"]["bucket"]["name"]
        obj = record["s3"]["object"]

        # S3 event keys are URL-encoded.
        key = unquote_plus(obj["key"])

        size = obj.get("size")
        etag = obj.get("eTag")
        sequencer = obj.get("sequencer", "")
        event_time = record.get("eventTime")

        # Extract the extension, if present.
        filename = key.rsplit("/", 1)[-1]
        extension = (
            filename.rsplit(".", 1)[-1].lower()
            if "." in filename and not filename.endswith(".")
            else None
        )

        # Deterministic for the same bucket, key and sequencer.
        identity = f"{bucket}\n{key}\n{sequencer}"
        digest = hashlib.sha256(identity.encode("utf-8")).hexdigest()

        output_key = f"metadata/{digest}.json"

        metadata = {
            "bucket": bucket,
            "key": key,
            "size_bytes": size,
            "etag": etag,
            "extension": extension,
            "event_time": event_time,
            "sequencer": sequencer,
        }

        s3.put_object(
            Bucket=bucket,
            Key=output_key,
            Body=json.dumps(metadata).encode("utf-8"),
            ContentType="application/json",
        )

    return {"statusCode": 200}