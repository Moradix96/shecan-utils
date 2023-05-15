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

echo "ShecanOff Script, Powered By Samiantec."
$adapterIndex = Get-NetAdapter | Where-Object {$_.Name -like "Wi-Fi"} | Select-Object -ExpandProperty ifIndex
Set-DnsClientServerAddress -InterfaceIndex $adapterIndex -ResetServerAddresses
Start-Sleep -Seconds 0.6
exit