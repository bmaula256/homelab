#!/bin/bash
#This script is used to prep bitwarden and grab the encryption key as an environment variable
#before terraform/opentofu is run.
#In order for this to work, you must run this file with: "source ./prepBitwarden.sh"
export BW_SESSION=$(bw unlock --raw)
echo "Session Exported"
export TF_VAR_state_encryption_passphrase=$(bw get password "opentofu_enc")
echo "Encryption passphrase ready"
