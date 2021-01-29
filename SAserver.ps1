Install-WindowsFeature AD-Domain-Services

Start-Sleep -Seconds 60

Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" -DomainName "SAserver.local" -DomainNetbiosName "SASERVER" -InstallDns:$true -LogPath "C:\Windows\NTDS" -SysvolPath "C:\Windows\Sysvol" -NoRebootOnCompletion:$true -Force:$true

# DomainMode Is basically which funtional level of the first domain when creating a new forest
# Stuff like WinThreshold is basically the running windows server edition (Windows 2016)
# The FQDN of the domain
# Netbios name for older systems
# Forestmode is basically like doaminmode; except it's for the fucntional level of the new forest.
# To install a DNS Server
# LogPath is Where you keep logging for DC
# Sysvol Keeps all Active Directory files
# all done in one line.