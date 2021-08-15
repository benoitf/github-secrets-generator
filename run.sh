#!/bin/bash

build_container ()
{
    BUILDER=$(command -v podman || true)
    if [[ ! -x $BUILDER ]]; then
        BUILDER=$(command -v docker || true)
        if [[ ! -x $BUILDER ]]; then
            echo "[ERROR] can't find docker or podman. Abort!"; exit 1
        fi
    fi
    $BUILDER build -t github-secrets-generator .
}

checkIfSecretExists()
{
    GH_ORG_REPO=$1
    SECRET_TO_CHECK=$2
    if [[ ! $GITHUB_TOKEN ]]; then echo "Must export a valid GITHUB_TOKEN to run this script."; exit 1; fi
    if [[ $SECRET_TO_CHECK == "" ]]; then usage; fi
    echo "In github.com/${GH_ORG_REPO}, fetch:"
    for myVAR in $SECRET_TO_CHECK; do
        echo "* $myVAR"
        podman run --rm --entrypoint /checkIfSecretExists.sh github-secrets-generator "${GITHUB_TOKEN}" "${GH_ORG_REPO}" "${myVAR}"
    done
}

uploadSecretsFromFile()
{
    GH_ORG_REPO=$1
    secretfile=$2
    if [[ ! $GITHUB_TOKEN ]]; then echo "Must export a valid GITHUB_TOKEN to run this script."; exit 1; fi
    echo "In github.com/${GH_ORG_REPO}, update:"
    while IFS= read -r myline
    do
        myVAR=${myline% *}
        myVAL=${myline#* }
        if [[ $myVAR ]] && [[ $myVAL ]]; then
            echo "* $myVAR"
            podman run --rm --entrypoint /generate.sh github-secrets-generator "${GITHUB_TOKEN}" "${GH_ORG_REPO}" "${myVAR}" "${myVAL}"
        fi
        unset myVAR
        unset myVAL
    done <"$secretfile"
}

usage () {
    echo "
To build the github-secrets-generator container (requires podman or docker):

Usage: $0 --build
Example: $0 --build

To check if a secret already exists in a repo:

Usage: $0 -r [GH org/project] [SECRET_TO_CHECK]
Example: $0 -r eclipse-che/che-theia CHE_BOT_GITHUB_TOKEN
Example: $0 -r che-incubator/jetbrains-editor-images CHE_INCUBATOR_BOT_GITHUB_TOKEN

To upload 1 or more secrets from a file (one per line):

Usage: $0 -r [GH org/project] -f [SECRET_FILE]
Example: $0 -r eclipse-che/che-dashboard -f mykeys.txt

Plaintext secret file format: one entry per line, key-value separated by a space

KEY1_NAME VALUE1
KEY2_NAME VALUE2
  ...

"
    exit 1
}

if [[ $# -lt 1 ]]; then usage; exit; fi

DO_BUILD=0
REPO=""
SECRETFILE=""
SECRET_TO_CHECK=""
while [[ "$#" -gt 0 ]]; do
  case $1 in
    '--build') DO_BUILD=1; shift 1;; 
    '-r') REPO="$2"; shift 1;; 
    '-f') SECRETFILE="$2"; shift 1;; 
    *) SECRET_TO_CHECK="$1"; shift 1;; 
  esac
  shift 1
done

if [[ $DO_BUILD -eq 1 ]]; then build_container; fi

if [[ ! $REPO ]] && [[ $DO_BUILD -eq 0 ]]; then usage; exit; fi

if [[ $SECRETFILE ]]; then
    uploadSecretsFromFile $REPO $SECRETFILE
elif [[ $SECRET_TO_CHECK ]]; then
    checkIfSecretExists $REPO $SECRET_TO_CHECK
elif [[ $DO_BUILD -eq 0 ]]; then
    usage
fi