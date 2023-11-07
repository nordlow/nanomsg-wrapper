#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR=$SCRIPT_DIR
SOURCE_DIR=${PROJECT_DIR}/source/nanomsg
SKELETON="${PROJECT_DIR}"/.skeleton.html
DOCS_DIR="${PROJECT_DIR}"/docs

echo Generating documentation for "${PROJECT_DIR}" into directory docs ...

TMP_DIR=$(mktemp -d)
delete_TMP_DIR() {
  echo "Cleaning up temporary directory ${TMP_DIR} ..."
  rm -rf "${TMP_DIR}"
}
trap 'delete_TMP_DIR' ERR
git clone https://github.com/adamdruppe/adrdox "${TMP_DIR}"/adrdox

make -C "${TMP_DIR}"/adrdox

rm -rf "${DOCS_DIR}"
mkdir -p "${DOCS_DIR}"/examples

DOC2="${TMP_DIR}"/adrdox/doc2
"${DOC2}" --case-insensitive-filenames -s "${SKELETON}" -i "${SOURCE_DIR}" -o "${DOCS_DIR}"
"${DOC2}" --case-insensitive-filenames -s "${SKELETON}" -i "${PROJECT_DIR}"/examples -o "${DOCS_DIR}"/examples
cp "${DOCS_DIR}"/nanomsg.html "${DOCS_DIR}"/index.html

delete_TMP_DIR

echo Generation of documentation for "${PROJECT_DIR}" succeeded
