resource "proxmox_vm_qemu" "vm-instance" {

    count = 0
    name                = "vm-instance-${count.index + 1}"
    target_node         = "pve"
    clone               = "bastion-alpine"
    full_clone          = true
    memory              = 512
    bios = "ovmf"
    agent = 0
    scsihw = "virtio-scsi-single"

cpu {
    cores = 1
}

efidisk {
	storage = "local-lvm"
}

disk {
    type        = "disk"
    storage = "local-lvm"
    passthrough = false
    slot        = "scsi0"
    size = "1G"
    iothread = true
}
    network {
    	id = 0
        model     = "virtio"
        bridge    = "vmbr0"
        firewall  = true
        link_down = false
	tag = 101
    }
}
