FROM python:3.8.2-alpine
RUN apk add --no-cache bash jq libc-dev libffi-dev make curl py-pip python-dev gcc linux-headers && pip install pynacl
# also include checkIfSecretExists.sh but don't use it by default (optional entrypoint)
COPY checkIfSecretExists.* generate.* /
ENTRYPOINT [ "/generate.sh" ]
