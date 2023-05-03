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

function Download-File {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [string]$Url,

    [Parameter(Mandatory=$true)]
    [string]$Path
  )

  Write-Host "Downloading $Path ..."
  $ProgressPreference = 'SilentlyContinue'
  Invoke-WebRequest -Uri $Url -OutFile $Path -UseBasicParsing -TimeoutSec 600 -Method GET -ContentType "application/zip" -Headers @{"Accept-Encoding"="gzip";"User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"}
}

Write-Host "====      INSTALLING QUAKE 3      ===="
Write-Host "==== you can minimize this window ===="
Write-Host "====  brought to you by rretroo   ===="

$dlPath = "$HOME\Downloads"
$ioq3Path = "$dlPath\Quake3"

If (-Not (Test-Path $ioq3Path)) {
  New-Item -ItemType Directory -Path $ioq3Path
}

Download-File -Url "https://fte.triptohell.info/moodles/win32/fteqw.exe" -Path "$ioq3Path\fteqw.exe"

If (-Not (Test-Path "$ioq3path\baseq3")) {
  New-Item -ItemType Directory -Path "$ioq3Path\baseq3"
}

Download-File -Url "https://github.com/nrempel/q3-server/raw/master/baseq3/pak0.pk3" -Path "$ioq3Path\baseq3\pak0.pk3"
Download-File -Url "https://github.com/nrempel/q3-server/raw/master/baseq3/pak1.pk3" -Path "$ioq3Path\baseq3\pak1.pk3"
Download-File -Url "https://github.com/nrempel/q3-server/raw/master/baseq3/pak2.pk3" -Path "$ioq3Path\baseq3\pak2.pk3"
Download-File -Url "https://github.com/nrempel/q3-server/raw/master/baseq3/pak3.pk3" -Path "$ioq3Path\baseq3\pak3.pk3"
Download-File -Url "https://github.com/nrempel/q3-server/raw/master/baseq3/pak4.pk3" -Path "$ioq3Path\baseq3\pak4.pk3"
Download-File -Url "https://github.com/nrempel/q3-server/raw/master/baseq3/pak5.pk3" -Path "$ioq3Path\baseq3\pak5.pk3"
Download-File -Url "https://github.com/nrempel/q3-server/raw/master/baseq3/pak6.pk3" -Path "$ioq3Path\baseq3\pak6.pk3"
Download-File -Url "https://github.com/nrempel/q3-server/raw/master/baseq3/pak7.pk3" -Path "$ioq3Path\baseq3\pak7.pk3"
Download-File -Url "https://github.com/nrempel/q3-server/raw/master/baseq3/pak8.pk3" -Path "$ioq3Path\baseq3\pak8.pk3"

Write-Host "==== INSTALLED. PRESS ENTER TO RUN ===="
Pause

Start-Process -FilePath "$ioq3Path\fteqw.exe" -WorkingDirectory $ioq3Path
Exit
