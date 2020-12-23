#!/bin/sh
GITHUB_TOKEN=$1
GITHUB_REPO=$2
# FIRST_VAR could be "QUAY_USERNAME" and FIRST would be the value of that variable
FIRST_VAR=$3
FIRST=$4
# SECOND_VAR could be "QUAY_PASSWORD" and SECOND would be the value of that variable
# if saving a single secret, omit SECOND_VAR and SECOND value
SECOND_VAR=$5
SECOND=$6

OUTPUT=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/repos/${GITHUB_REPO}/actions/secrets/public-key)
PUBLIC_KEY=$(echo $OUTPUT  | jq -r .key )
KEY_ID=$(echo $OUTPUT  | jq -r .key_id )
echo "Generating tokens for repository ${GITHUB_REPO} using the key ${PUBLIC_KEY}"
if [ ${SECOND} ] && [ ${SECOND_VAR} ]; then
    ENCRYPT_RESULT=$(python /generate.py ${PUBLIC_KEY} ${FIRST} ${SECOND})
else
    ENCRYPT_RESULT=$(python /generate.py ${PUBLIC_KEY} ${FIRST})
fi

#echo ${ENCRYPT_RESULT}
ENCODED_FIRSTSECRET=$(echo ${ENCRYPT_RESULT}  | jq -r .firstSecret )
ENCODED_SECONDSECRET=$(echo ${ENCRYPT_RESULT}  | jq -r .secondSecret )

echo "KEY_ID is ${KEY_ID}"

echo "secrets list [before]:"
curl -s -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/repos/${GITHUB_REPO}/actions/secrets

curl -H "Authorization: token ${GITHUB_TOKEN}"  -X PUT -H "Content-Type: application/json" -d "{\"encrypted_value\":\"${ENCODED_FIRSTSECRET}\",\"key_id\":\"${KEY_ID}\"}" https://api.github.com/repos/${GITHUB_REPO}/actions/secrets/${FIRST_VAR}
if [ "${ENCODED_SECONDSECRET}" ]; then
    curl -H "Authorization: token ${GITHUB_TOKEN}"  -X PUT -H "Content-Type: application/json" -d "{\"encrypted_value\":\"${ENCODED_SECONDSECRET}\",\"key_id\":\"${KEY_ID}\"}" https://api.github.com/repos/${GITHUB_REPO}/actions/secrets/${SECOND_VAR}
fi
echo "secrets list [after]:"
curl -s -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/repos/${GITHUB_REPO}/actions/secrets
