resource "proxmox_vm_qemu" "ubuntu-test" {

	count = 5
	name = "ubuntu-test-${count.index + 1}"
	target_node = "pve"
	clone = "ubuntu-server-24.04-template"
	full_clone = true
	memory = 1024
	scsihw = "virtio-scsi-single"
	vm_state = "stopped"

cpu {
	cores = 1
}

disk {
	type = "disk"
	storage = "TrueNas_ISOs"
	passthrough = "false"
	slot = "scsi0"
	size = "8G"
	iothread = true
}

network {
	id = 0
	model = "virtio"
	bridge = "vmbr0"
	firewall = true
	tag = 101
}

}
