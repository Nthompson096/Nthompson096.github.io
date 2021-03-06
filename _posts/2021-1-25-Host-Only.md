---
layout: post
title:  "Host Only mode with one nic inside Proxmox"
summary: |-
            So far I've made a hostonly network with proxmox today for my active directory network (and             other computers if I feel like it); mind you I'm only using one phyiscal NIC (Network             Interface Card). To use create a host only network in proxmox you'd have to use the following!
date:   2021-1-25 10:51
categories: Proxmox
description: "Proxmox Hostonly mode with one nic"
#image: 'https://www.csrhymes.com//img/static-site-generator.jpg'
published: true
#canonical_url: https://www.csrhymes.com/development/2018/05/28/why-use-a-static-site-generator.html
---

<h1>Active Directory and Host only with Proxmox</h1>
<p>So far I've made a hostonly network with proxmox today for my active directory network (and other computers if I feel like it); mind you I'm only using one phyiscal NIC (Network Interface Card). To use create a host only network in proxmox you'd have to use the following!
</p>
<p><code>
        address 10.0.0.0/24
<br>
        bridge-ports none
<br>
        bridge-stp off
<br>
        bridge-fd 0 <br>
	# This will forward your port/address into vmbr0 which would be required for proxmox webinterface/default virtual nic, least from what I understand.
<br>
        post-up echo 1 > /proc/sys/net/ipv4/ip_forward
<br>
        post-up   iptables -t nat -A POSTROUTING -s '10.0.0.0/24' -o vmbr0 -j MASQUERADE
<br>
        post-down iptables -t nat -D POSTROUTING -s '10.0.0.0/24' -o vmbr0 -j MASQUERADE</code></p>
<p>Be sure to paste this inside /etc/network/interfaces file, as this controls all the settings for a virtual/physical nic. Host only is good for an active directoy virtual environment as it wouldn't actually hand out any IP addresses if you're doing a DHCP server; least that I'm aware. Though there's always a case of misconfiguring or fogetting a setting for a virtual nic or interface config file inside /etc/network/interface or otherwise. Now the reason you probably wouldn't want two DHCP servers is most likely because it can and will conflict with your physical DHCP server at home or work which would give you networking errors and you'd probably wouldn't want that; unless if you'd want a redundant server incase one goes down.</p>
<h3>According to Microsoft Docs</h3>
<p>With DHCP failover, DHCPv4 scopes can be replicated from a primary DHCP server to a partner DHCP server, enabling redundancy and load balancing of DHCP services.</p>
<p>
<ul>
<li>You cannot configure DHCP failover on a DHCP scope to include more than two DHCP servers.</li>
<li>DHCP failover supports DHCPv4 scopes only. DHCPv6 scopes cannot be failover-enabled.</li>
<li>DHCP failover partners must both be running Windows Server 2012 or a later operating system.</li>
<li>DHCP failover can be configured, and settings can be modified without the need to pause, stop, or restart the DHCP Server service.</li>
<li>If parameters of a failover-enabled scope are modified, these settings must be manually replicated to the partner DHCP server. Note: Automatic replication of scope settings is available if you use IP address management (IPAM) in Windows Server 2012 R2 to modify failover-enabled scope settings.</li>
<li>Replication of scope settings can be initiated from either DHCP server to its failover partner server.</li>
<li>Clustered DHCP is supported in conjunction with DHCP failover. For purposes of failover, a DHCP cluster is considered a single DHCP server. See DHCP failover and Windows Failover Clustering for more information.</li>
<li>DHCP clients must be able to communicate with both DHCP failover partner servers, either directly or using a DHCP relay.</li>
<li>DHCP servers configured as failover partners can be located on different subnets, but this is not required.</li>
<li>When DHCP failover is enabled on a DHCP scope, the DHCP server that renews a DHCP client lease can be different from the DHCP server that initially granted the lease.</li>
<li>Two DHCP servers configured as failover partners will attempt to maintain a persistent TCP/IP connection.</li>
<li>Two separate, synchronized client lease databases are maintained independently by each DHCP failover partner server.</li>
<li>DHCP servers configured as failover partners are both aware of the status of the DHCP service on the other server, and are informed of any change in that status with minimal delay.</li>
<li>If two DHCP servers configured as failover partners are unable to communicate, precautions are taken to avoid the same IP address lease being issued to two different DHCP clients.</li>
<li>If a DHCP server becomes unavailable before it is able to successfully synchronize all DHCP client information with its failover partner, precautions are taken to ensure DHCP lease continuity for DHCP clients.</li>
</ul>
</p>
<p>More can be read <a href="https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/dn338983(v=ws.11)">here</a></p>
