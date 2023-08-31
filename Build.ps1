$ErrorActionPreference = 'Stop'

# Make sure CMAKE is on the path
if (!(Get-Command 'cmake' -errorAction SilentlyContinue)) {
    Write-Host "Could not find cmake. Is it on your PATH?"
    return
}

$downloadUrl = "https://github.com/glfw/glfw/releases/download/3.3.8/glfw-3.3.8.zip"
$cacheFileName = Split-Path $downloadUrl -leaf
$cacheFilePath = "cache/$cacheFileName"
$extractPath = "cache/glfw-3.3.8"

# Create the cache folder so that the web request doesn't fail.
New-Item -ItemType Directory -Force "cache" | Out-Null

# Download library if it doesn't already exist
if (!(Test-Path $cacheFilePath)) {
    Write-Host "Downloading $cacheFileName..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $cacheFilePath
    Write-Host "Download complete."
}

# Unzip archive
if (!(Test-Path $extractPath)) {
    Write-Host "Extracting $cacheFileName"
    Expand-Archive -Path $cacheFilePath -DestinationPath "cache"
}

Remove-Item -Path "include" -Force -Recurse -ErrorAction SilentlyContinue
Copy-Item -Path "cache/glfw-3.3.8/include" -Destination "include" -Recurse
