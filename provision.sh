#!/bin/bash
# Infrastructure definition for technodos - production

# 1. Database Cluster (MySQL 8.4 • Flex 512 MiB • 5 GB • Awake for 2m)
cloud database-cluster:create \
  --name="technodos" \
  --region="us-east-ohio" \
  --type="mysql" \
  --version="8.4" \
  --size="flex-512" \
  --storage="5" \
  --scale-to-zero=120

# 2. Logical Database (Named 'production')
cloud database:create \
  --cluster="technodos" \
  --name="production"

# 3. App Cluster (US East Ohio • Flex 512 MiB • Awake for 5m)
cloud environment:create \
  --application="technodos" \
  --name="production" \
  --region="us-east-ohio" \
  --size="flex-512" \
  --scale-to-zero=300

# 4. Bind the database to the environment
cloud environment:variables \
  --environment="production" \
  --action=set \
  --key=DB_DATABASE \
  --value=production

# 5. Trigger the initial deployment
cloud deploy --environment="production"
