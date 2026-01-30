#Consider this too as a template, this is why count is zero.
#This is for ubuntu servers stored on my NFS server. (With QEMU guest agent enabled)
resource "proxmox_vm_qemu" "ubuntu-test-agent" {

	count = 0
	name = "ubuntu-test-agent-${count.index + 1}"
	target_node = "pve"
	clone = "ubuntu-server-24.04-wAgent"
	full_clone = true
	memory = 2048
	scsihw = "virtio-scsi-single"
	vm_state = "stopped"
	skip_ipv6 = true
	agent = 1

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
