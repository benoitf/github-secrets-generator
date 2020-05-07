# Github Secrets generator

Sets QUAY_USERNAME and QUAY_PASSWORD secrets in the given repository:


login = QUAY_USERNAME plaintext value

password = QUAY_PASSWORD plaintext value

### Usage

1. build the image
$ docker build -t github-secrets-generator .

2. run command
$ docker run --rm -it github-secrets-generator ${GITHUB_TOKEN} github-org/github-repo ${login} ${password}

