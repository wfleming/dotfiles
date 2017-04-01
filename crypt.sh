#!/bin/sh
#
# Helper for encrypting/decrypting files in this repo.
set -e

mode="unset"

while getopts "edED" opt; do
 case $opt in
    e)
      mode=encrypt;;
    d)
      mode=decrypt;;
    E)
      mode=encrypt_all;;
    D)
      mode=decrypt_all;;
    "?")
      printf "Invalid option -%s\n" "$OPTARG"
      exit 64;;
  esac
  shift
done

fail() {
  printf "%s\n" "$1"
  exit 1
}

decrypt() {
  [ -f "$1" ] || fail "The file '$1' doesn't seem to exist"
  gpg \
    --yes \
    --output "${1%.gpg}" \
    --decrypt "$1"
  printf "Plaintext is in %s.\n" "${1%.gpg}"
}

gpg_uid() {
  gpg --list-secret-keys | grep "@" | sed "s/^.*<\(.\+\)>.*$/\1/"
}

encrypt() {
  [ -f "$1" ] || fail "The file '$1' doesn't seem to exist"
  uid=$(gpg_uid)
  printf "Encrypting %s with & for %s GPG identity.\n" "$1" "$uid"
  gpg \
    --yes \
    --output "$1.gpg" \
    --local-user "$uid" \
    --recipient "$uid" \
    --encrypt "$1"
  printf "Ciphertext is in %s.gpg.\n" "$1"
}

all_encrypted_files() {
  git ls-files | grep "\.gpg$"
}

encrypt_all() {
  for encrypted in $(all_encrypted_files); do
    encrypt "${encrypted%.gpg}"
  done
}

decrypt_all() {
  for encrypted in $(all_encrypted_files); do
    decrypt "$encrypted"
  done
}

help() {
  echo "Usage:"
  echo "./crypt.sh -e path/to/file        -- encrypt a file"
  echo "./crypt.sh -d path/to/file.gpg    -- decrypt a file"
  echo "./crypt.sh -E                     -- re-encrypt all files with gpg pairs"
  echo "./crypt.sh -D                     -- decrypt all gpg files"
}

case "$mode" in
  "encrypt")
    encrypt "$1";;
  "decrypt")
    decrypt "$1";;
  "encrypt_all")
    encrypt_all;;
  "decrypt_all")
    decrypt_all;;
  *)
    help
esac
