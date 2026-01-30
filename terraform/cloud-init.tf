#Think of this file as a template for OMVF cloud init clones.
#Because of this, count is equal to zero.

resource "proxmox_vm_qemu" "ubuntu-cloud-init" {

	count = 0
	name = "ubuntu-test-${count.index + 1}"
	target_node = "pve"
	clone = "ubuntu-cloudinit"
	full_clone = false #Notice that this is a linked clone
	memory = 1024
	bios = "ovmf"
	scsihw = "virtio-scsi-single"

	os_type = "cloud-init"
	boot = "order=scsi0;"

	vm_state = "running"
	ipconfig0="ip=dhcp"

	#Begin in depth ci config
	ciuser = var.cloud_init_user
	cipassword = data.bitwarden_item_login.default_ubuntu_secret_pass.password
	ciupgrade = true
	sshkeys = var.cloud_init_ssh
	

cpu {
	cores = 1
}

serial {
	id = 0
	type = "socket"
}

#efi disk declaration not required here

disk {
	storage = "local-lvm"
	passthrough = "false"
	slot = "scsi0"
	size = "20G"
	iothread = true
	discard = true
	emulatessd = true #Recommened for SSDs
}

disk {
	type = "cloudinit"
	slot = "ide2"
	storage = "local-lvm"
}

network {
	id = 0
	model = "virtio"
	bridge = "vmbr0"
	firewall = true
	tag = 101

}

}
