### Github Secrets generator
Sets QUAY_USERNAME and QUAY_PASSWORD secrets in the given repository:


login = QUAY_USERNAME plaintext value

password = QUAY_PASSWORD plaintext value



$ docker run --rm -it secret ${GITHUB_TOKEN} github-org/github-repo ${login} ${password}

