FROM python:3.8.2-alpine
RUN apk add --no-cache jq libc-dev libffi-dev make curl py-pip python-dev gcc linux-headers && pip install pynacl
COPY generate.* /
ENTRYPOINT [ "/generate.sh" ]

