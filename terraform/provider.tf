#This file assumes an open-sourced fork for terraform called OpenTofu, which supports state file encryption is used.
#This is where I do my provider config.
terraform {
	encryption {
		key_provider "pbkdf2" "getBitWarden" {
			passphrase = var.state_encryption_passphrase
		}

		method "aes_gcm" "getTheBitWarden" {
			#This is gonna grab the key from a variable that gets populated via bitwardem api.
			keys = key_provider.pbkdf2.getBitWarden
		}

		state {
			method = method.aes_gcm.getTheBitWarden
			enforced = true
		}
		plan {
			method = method.aes_gcm.getTheBitWarden
			enforced = true
		}
	}

    required_providers {
        proxmox = {
            source = "telmate/proxmox"
	    version = "3.0.2-rc07"
        }

	bitwarden = {
		source = "maxlaverse/bitwarden"
		version = ">=0.16.0"
	}
    }
}

provider "bitwarden" {
	vault_path = ""	
}

provider "proxmox" {
	pm_api_url = var.proxmox_api_url
	pm_api_token_id = var.proxmox_api_token_id

	#Below this extracts the api token secret from bitwarden.
	pm_api_token_secret = data.bitwarden_item_login.proxmox_api_secret.password
  	
	pm_tls_insecure = true  # Safe over Tailscale because the tunnel is already encrypted
  	pm_parallel     = 10
  	pm_timeout      = 600
}
