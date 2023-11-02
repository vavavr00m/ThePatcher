# Auto-elevate Powershell https://stackoverflow.com/questions/69774566/how-can-i-elevate-powershell-while-keeping-the-current-working-directory-and-mai

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-NoExit -c cd '$pwd'; & `"" + $MyInvocation.MyCommand.Path + "`""
        Start-Process powershell -Verb runas -ArgumentList $CommandLine
        Exit
    }
}

# Add hosts to prevent warning of unlicensed or non-genuine usage - https://discord.com/channels/808943947660394517/971079960255164477/1155400046532100208

Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n0.0.0.0`tpojvrj7ho5.adobe.io" -Force
Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n0.0.0.0`tic.adobe.io" -Force

# Stop Creative Cloud - https://discord.com/channels/808943947660394517/971079960255164477/1166781698684498053

Stop-Process -Name "Adobe Desktop Service" -force

# Uninstall AGS - Adobe Genuine Service - https://discord.com/channels/808943947660394517/971079960255164477/1166781698684498053

[System.Diagnostics.Process]::Start("C:\Program Files (x86)\Common Files\Adobe\AdobeGCClient\AdobeCleanUpUtility.exe")

# Back up AppsPanelBL.dll - https://discord.com/channels/808943947660394517/971079960255164477/1153941241927565384

cp "C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\AppsPanel\AppsPanelBL.dll" "C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\AppsPanel\AppsPanelBL.dll.bak"

# Patch AppsPanelBL.dll - https://discord.com/channels/808943947660394517/971079960255164477/1153941072637079593

$bytes  = [System.IO.File]::ReadAllBytes("C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\AppsPanel\AppsPanelBL.dll")
$bytes[1116554] = 0xfe
$bytes[1216383] = 0xfe
$bytes[1987439] = 0xfe
$bytes[2150557] = 0xfe
$bytes[2151982] = 0xfe
$bytes[2152497] = 0xfe
$bytes[2153297] = 0xfe
$bytes[2279801] = 0xc6
$bytes[2279802] = 0x40
$bytes[2279811] = 0xc6
$bytes[2279812] = 0x40
$bytes[2279821] = 0xc6
$bytes[2279822] = 0x40
[System.IO.File]::WriteAllBytes("C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\AppsPanel\AppsPanelBL.dll", $bytes)
