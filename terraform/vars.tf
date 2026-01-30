#This file is for Terraform variable declaration. These can be done on the local level as well for .tf files, but I choose to do these here for better organization.

# This passphrase is passed in by another program as an environment variable.
variable "state_encryption_passphrase" {
        type = string
        sensitive = true
}

variable "proxmox_api_url" {
        type = string
}

variable "proxmox_api_token_id" {
        type = string
        sensitive = true
}

variable "cloud_init_user" {
	type = string
}

variable "cloud_init_ssh" {
	type = string
	sensitive = true
}

data "bitwarden_item_login" "default_ubuntu_secret_pass" {
	id = "3923afc7-6634-4c8c-b25e-b3df0019b1e5"
}

data "bitwarden_item_login" "proxmox_api_secret" {
        id = "8e937c3b-d159-4492-993b-b3d300376db0"
}
