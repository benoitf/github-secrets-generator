# Github Secrets generator

Sets check if a secret is defined in a given github repo, or upload 1 or more secrets to a github repo.

### Usage

1. build the image

```bash
$ podman build -t github-secrets-generator .
```

Or, use `./run.sh`

2. check if a secret already exists in a repo:

```bash
$ podman run --rm --entrypoint /checkIfSecretExists.sh github-secrets-generator "${GITHUB_TOKEN}" github-org/github-repo MY_SECRET
```

Or, use `./run.sh`

3. load 1 or more secrets from a file, assuming each line of the file is in the format:

```
SECRET_VARIABLE1 SECRET_PLAINTEXT_VALUE1
SECRET_VARIABLE2 SECRET_PLAINTEXT_VALUE2
...
```

Use `./run.sh`

4. You can also uplod individual secrets, passing these parameters in order: 

* GITHUB_TOKEN 
* github-org/github-repo 
* SECRET_VARIABLE 
* SECRET_PLAINTEXT_VALUE 

```bash
$ podman run --rm -it github-secrets-generator ${GITHUB_TOKEN} github-org/github-repo SECRET_TOKEN ${SECRET_PLAINTEXT_VALUE}
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
