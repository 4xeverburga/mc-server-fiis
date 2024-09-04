#!/bin/bash
# cronjob to do $ aws s3 cp /world/ s3://{bucket-name}
set -x
aws s3 cp /home/ec2-user/world/ s3://data-for-mc-server/world/ --recursive