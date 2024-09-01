#!/bin/bash
# cronjob to do $ aws s3 sync /world/ s3://{bucket-name}
set -x
aws s3 sync /home/ec2-user/world/ s3://data-for-mc-server/world/