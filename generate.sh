#!/bin/sh
GITHUB_TOKEN=$1
GITHUB_REPO=$2
LOGIN=$3
PASSWORD=$4

OUTPUT=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/repos/${GITHUB_REPO}/actions/secrets/public-key)
PUBLIC_KEY=$(echo $OUTPUT  | jq -r .key )
KEY_ID=$(echo $OUTPUT  | jq -r .key_id )
echo "Generating tokens for repository ${GITHUB_REPO} using the key ${PUBLIC_KEY}"
ENCRYPT_RESULT=$(python /generate.py ${PUBLIC_KEY} ${LOGIN} ${PASSWORD})

#echo ${ENCRYPT_RESULT}
ENCODED_LOGIN=$(echo ${ENCRYPT_RESULT}  | jq -r .login )
ENCODED_PASSWORD=$(echo ${ENCRYPT_RESULT}  | jq -r .password )

echo "KEY_ID is ${KEY_ID}"

curl -H "Authorization: token ${GITHUB_TOKEN}"  -X PUT -H "Content-Type: application/json" -d "{\"encrypted_value\":\"${ENCODED_LOGIN}\",\"key_id\":\"${KEY_ID}\"}" https://api.github.com/repos/${GITHUB_REPO}/actions/secrets/QUAY_USERNAME
curl -H "Authorization: token ${GITHUB_TOKEN}"  -X PUT -H "Content-Type: application/json" -d "{\"encrypted_value\":\"${ENCODED_PASSWORD}\",\"key_id\":\"${KEY_ID}\"}" https://api.github.com/repos/${GITHUB_REPO}/actions/secrets/QUAY_PASSWORD
