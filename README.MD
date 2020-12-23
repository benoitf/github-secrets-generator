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

3. to load a set of secrets from a file, assuming each line of the file is in the format:

```
SECRET_VARIABLE1 SECRET_PLAINTEXT_VALUE1
SECRET_VARIABLE2 SECRET_PLAINTEXT_VALUE2
...
```

Run this:

```
uploadSecretsFromFile() 
{
    secretfile=$1
    GH_ORG_REPO=$2
    if [[ ! $GITHUB_TOKEN ]]; then echo "Must export a valid GITHUB_TOKEN to run this script."; exit 1; fi
    echo "In github.com/${GH_ORG_REPO}, update:"
    while IFS= read -r myline
    do
        myVAR=${myline% *}
        myVAL=${myline#* }
        if [[ $myVAR ]] && [[ $myVAL ]]; then
            echo "* $myVAR"
            podman run --rm github-secrets-generator "${GITHUB_TOKEN}" "${GH_ORG_REPO}" "${myVAR}" "${myVAL}"
        fi
        unset myVAR
        unset myVAL
    done <"$secretfile"
}

uploadSecretsFromFile secretfile.txt my-org/my-repo

```
