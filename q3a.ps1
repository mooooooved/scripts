function Download-File {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [string]$Url,

    [Parameter(Mandatory=$true)]
    [string]$Directory
  )

  $Filename = [System.IO.Path]::GetFileName($Url)
  $FilePath = Join-Path $Directory $Filename

  Write-Host "Downloading $FilePath ..."
  Invoke-WebRequest -Uri $Url -OutFile $FilePath -UseBasicParsing -ProgressPreference SilentlyContinue -TimeoutSec 600 -Method GET -ContentType "application/zip" -Headers @{"Accept-Encoding"="gzip";"User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"}

  if ($LASTEXITCODE -ne 0) {
    throw "Failed to download $Url"
  }
}

$dlPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$ioq3Path = Join-Path $dlPath "ioq3"

if (Test-Path $ioq3Path) {
  Remove-Item $ioq3Path -Recurse -Force
}

New-Item -ItemType Directory -Path $ioq3Path

Download-File -Url "https://files.ioquake3.org/Windows.zip" -Path Join-Path $ioq3Path "Windows.zip"

Expand-Archive -Path (Join-Path $ioq3Path "Windows.zip") -DestinationPath $ioq3Path

$zip = Join-Path $ioq3Path "release-mingw64-x86_64.zip"
if (Test-Path $zip) {
  Expand-Archive -Path $zip -DestinationPath $ioq3Path
} else {
  Write-Error "release-mingw64-x86_64.zip not found!"
  Pause
}
