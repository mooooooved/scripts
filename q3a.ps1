function Download-File {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [string]$Url,

    [Parameter(Mandatory=$true)]
    [string]$Path
  )

  Write-Host "Downloading $Path ..."
  Invoke-WebRequest -Uri $Url -OutFile $Path -UseBasicParsing -TimeoutSec 600 -Method GET -ContentType "application/zip" -Headers @{"Accept-Encoding"="gzip";"User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"}
}

$dlPath = "$HOME\Downloads"
$ioq3Path = Join-Path $dlPath "ioq3"

if (Test-Path $ioq3Path) {
  Start-Process -FilePath "$ioq3Path\ioquake3.x86_64.exe" -WorkingDirectory $ioq3Path -NoNewWindow
  Exit
} else {
  New-Item -ItemType Directory -Path $ioq3Path
}

Download-File -Url "https://files.ioquake3.org/Windows.zip" -Path (Join-Path "$ioq3Path\Windows.zip")

Expand-Archive -Path (Join-Path $ioq3Path "Windows.zip") -DestinationPath $ioq3Path

$zip = Join-Path $ioq3Path "release-mingw64-x86_64.zip"
if (Test-Path $zip) {
  Expand-Archive -Path $zip -DestinationPath $ioq3Path
} else {
  Write-Error "release-mingw64-x86_64.zip not found!"
  Pause
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

Start-Process -FilePath "$ioq3Path\ioquake3.x86_64.exe" -WorkingDirectory $ioq3Path -NoNewWindow
Exit
