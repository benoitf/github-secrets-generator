#!/bin/bash
GITHUB_TOKEN=$1
GITHUB_REPO=$2
FIRST_VAR=$3

OUTPUT=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/repos/${GITHUB_REPO}/actions/secrets/public-key)
# PUBLIC_KEY=$(echo $OUTPUT  | jq -r .key )
KEY_ID=$(echo $OUTPUT  | jq -r .key_id )
# echo "KEY_ID is ${KEY_ID}"
if [ ! $KEY_ID ]; then echo "Error: could not read public key from https://api.github.com/repos/${GITHUB_REPO}/actions/secrets/public-key !"; exit 1; fi

# echo "Fetching tokens for repository ${GITHUB_REPO} using the key ${PUBLIC_KEY}"

echo -n "Number of secrets: "
curl -sSL -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/repos/${GITHUB_REPO}/actions/secrets | jq '.total_count'

if [[ -n ${FIRST_VAR} ]] && [[ ${FIRST_VAR} != "--list" ]]; then 
    echo "Secret ${FIRST_VAR}:"
    curl -sSL -H "Authorization: token ${GITHUB_TOKEN}"  -X GET -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/${GITHUB_REPO}/actions/secrets/${FIRST_VAR}
else
    curl -sSL -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/repos/${GITHUB_REPO}/actions/secrets | jq '.secrets[].name'
fi
