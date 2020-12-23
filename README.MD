# Github Secrets generator

Sets a pair of user and password secrets, eg., QUAY_USERNAME and QUAY_PASSWORD, in the given repository:

### Usage

1. build the image

```bash
$ podman build -t github-secrets-generator .
```

2. run the command, passing these parameters in order: 

* GITHUB_TOKEN 
* github-org/github-repo 
* SECRET_VARIABLE 
* SECRET_PLAINTEXT_VALUE 

```bash
$ podman run --rm -it github-secrets-generator ${GITHUB_TOKEN} github-org/github-repo SECRET_USERNAME ${SECRET_PLAINTEXT_VALUE}
```
Or, to save a pair of secrets: 

* GITHUB_TOKEN 
* github-org/github-repo 
* USERNAME_VARIABLE 
* USERNAME_PLAINTEXT_VALUE 
* PASSWORD_VARIABLE 
* PASSWORD_PLAINTEXT_VALUE

```bash
$ podman run --rm -it github-secrets-generator ${GITHUB_TOKEN} github-org/github-repo QUAY_USERNAME ${QUAY_USERNAME} QUAY_PASSWORD ${QUAY_PASSWORD}
```
