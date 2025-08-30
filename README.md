# MalDev

PowerShell malware development scripts for educational and testing purposes. Contains process injection and social engineering components.

## Scripts

**ProcessInject.ps1** - Advanced process injection script:
- Downloads encrypted and compressed shellcode from remote URLs
- AES-256-CBC decryption with hardcoded key/IV
- Deflate9/gzip decompression support
- Process injection into cmd.exe using Windows API calls
- Downloads and executes secondary payload (meowware.ps1)
- Self-terminates after injection to avoid detection

**meowware.ps1** - Silly prankware for ISTS competition:
- Downloads cat GIF from local server (127.0.0.1:8000)
- Creates Windows Forms popup with "meowware" message
- Displays cat GIF in always-on-top window
- Harmless prank/distraction payload for competition use

## Technical Details

The process injection script uses:
- `OpenProcess` with PROCESS_ALL_ACCESS
- `VirtualAllocEx` with PAGE_EXECUTE_READWRITE
- `WriteProcessMemory` for shellcode injection
- `CreateRemoteThread` for execution
- Custom encryption/compression handling

## Usage

```powershell
# Set execution policy
Set-ExecutionPolicy Bypass -Scope Process -Force

# Run process injection
.\ProcessInject.ps1

# Or run standalone troll payload
.\meowware.ps1
```

---
*For educational malware research and authorized testing only*
