param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false) {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

echo "ShecanOn Script, Powered By Samiantec."
$adapterIndex = Get-NetAdapter | Where-Object {$_.Name -like "Wi-Fi"} | Select-Object -ExpandProperty ifIndex
set-DnsClientServerAddress -InterfaceIndex $adapterIndex -ServerAddresses ("178.22.122.100", "185.51.200.2")
Start-Sleep -Seconds 0.6
exit