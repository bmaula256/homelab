# Homelab
This is where I document my homelab for potential recruiters and so that I have a central area to access scripts and other resources. The purpose of this homelab is to learn basic automation utilities, along with networking and security fundamentals for cybersecurity and devops type positions. Here is a slim tech stack before I dive into the meat and potatoes of this project:
|Category | Tools Used|
|---------|-----------|
|Hypervisor | Proxmox VE |
|Authentication | Tailscale, Cloudflare Access (emails) |
|Storage | TrueNAS SCALE (NFS) |
|SIEM/Logging | Splunk |

![This is a cool diagram](diagrams/Homelab-Diagram.png)

## The Diagram
Above is a diagram which depicts the overall structure and flow of my homelab. There are two primaries flows to be concerned with here. The one which begins on the left side of the diagram depicts my management access workflow. This is how I access the machines and backends directly for the applications which I deploy. I have my authenticated management laptops ssh via tailscale into bastion100 and bastion101 (one bastion host for each VLAN), which then hops to other applications. (To follow appropriate security principles, every endpoint uses key-based-authentication when utilizing ssh.) I will detail each endpoint and the logic behind them later in the readme. The second flow comes from cloudflare tunnels, as depicted on the right. Approved users authenticate through cloudflare access, where they are allowed into certain applications based on their email account used to authenticate. In this way, let's say my D&D group can access application front ends for Nextcloud and FoundryVTT, but they cannot for example access my splunk instance or portainer. **Please note, all endpoints that show up on this diagram are represented by their actual assigned hostname, and are accessed by such when I traverse between them via my bastion hosts.** The main exception here is the cloudflare tunnels, some of these are local hosted and some are a seperate host being routed to the proper endpoint. It is a little unorganized at the moment to I abstracted them to one node on the diagram per VLAN for simplicity.

### VLAN 100
This VLAN is partitioned from the rest of the network specifically because services within need to access my storage server. A little backstory, my current setup involves an ASUS router, which doesn't allow specific inter-VLAN firewall rules. This is important, because the proxmox interface, where I host my VMs, needs access to the storage server for backups, which means it is on this same VLAN. In an attempt to exercise principle of least privelage and minimize the attack service for my proxmox instance, I have moved all endpoints that do not need to access the storage server or other endpoints that access the storage server onto a different VLAN.

#### Hosted Services
- **bastion100**: Run of the mill bastion host. This runs Alpine linux instead of the generally implemented ubuntu server in my lab. The purpose of this was to conserve resources since this host wouldn't be doing anything extensive other than being watched by splunk later, and also serving as a spring board for myself and my scripts.
- **nextcloud**: File management server, to summarize, it is like a self hosted google drive, with a few extra bells and whistles. It is currently the only thing being watched by my recently deployed splunk server, I plan to change that later. My primary use case for this service is to store content for my D&D group that shouldn't necessarily be stored in Foundry VTT. I also use this as a personal storage. It owns a share on my TrueNAS server for all major storage.
- **portainer1**: This machine runs the portainer docker image. As I progress more in my journey with docker, I intend to do most of my configuration and management from my portainer instance to achieve better organization for my containers and practice using industry relevant tools.
- **splunk-main**: One of my most recently introduced endpoints, currently it only watches nextcloud, since nextcloud lives in docker containers, and by extension its own self maintained docker network I decided to use a docker driver to send the logs over to splunk. Splunk listens for these over its HTTP event collector. I configured a dashboard to watch these logs for login attempts and also file changes and create a pie chart from the results which I can see on my splunk home screen. Eventually I plan to have splunk watch my bastions, TrueNAS, and the majority of the rest of my services.
- **truenas**: Currently the only service run outside of my proxmox, my homelab consists of a two pronged setup, the proxmox with all the containers and virtual machines, and a seperate TrueNAS SCALE box for all my storage needs. Currently hosts a variety of NFS shares for whatever services in VLAN 100 needs them.

### VLAN 101
This VLAN contains all/most of the endpoints that do not require direct access to the storage server or any adjacent services. This is done because my proxmox management interface lives on VLAN 100, and I wanted to reduce the attack surface as stated above.

#### Hosted Services
- **bastion101**: Pretty much the same as bastion 100, this exists as a springboard for access via tailscale into the rest of the VLAN. It runs Alpine Linux to save resources.
- **foundry-vtt-server**: This is where I run pretty much all of my D&D games, this is a cool virtual tabletop that you can install third party modules on for unique functionality. If you play D&D, definitely look this up, it's cool.
- **musicbot**: This is the discord music bot which I host for D&D sessions. It is unique because I can put youtube links into it, which a lot of other music bots either cannot do, or will charge premium prices for.

## Current mission
Right now my goal is to focus on automation and splunk. I properly configured my own domain, locked things down with VLANs, tailscale, and cloudflare access. I've done quite a bit with network fundamentals and linux config. Now I am building knowledge with and setting my sights on Ansible, Terraform, and Splunk. I will likely continue to revist docker throughout my journey as well since that is on my radar.
