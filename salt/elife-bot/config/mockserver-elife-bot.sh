#!/bin/sh
set -e

echo "elife-bot expectations"

curl -v -X PUT "http://app:1080/mockserver/expectation" -d '{
    "httpRequest" : {
        "method" : "POST",
        "path" : "/job.api/updateDigest"
    },
    "httpResponse" : {
        "statusCode": 200,
        "body" : "dummy response body"
    }
}'
