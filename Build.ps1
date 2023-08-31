$ErrorActionPreference = 'Stop'

if ($IsWindows) {
    $downloadUrl = "https://github.com/glfw/glfw/releases/download/3.3.8/glfw-3.3.8.bin.WIN64.zip"
    $cacheFileName = Split-Path $downloadUrl -leaf
    $cacheFilePath = "cache/$cacheFileName"
    $extractPath = "cache/glfw-3.3.8.bin.WIN64"
    
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
    
    # Copy headers
    Remove-Item -Path "include" -Force -Recurse -ErrorAction SilentlyContinue
    Copy-Item -Path "$extractPath/include" -Destination "include" -Recurse
    
    # Make win64 folder
    New-Item -ItemType Directory -Force "win64" | Out-Null

    # Make vc2022 folder
    New-Item -ItemType Directory -Force "win64/vc2022" | Out-Null

    # Copy static lib
    Remove-Item -Path "win64/vc2022/glfw3.lib" -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "$extractPath/lib-vc2022/glfw3.lib" -Destination "win64/vc2022/glfw3.lib"
} else {
    Write-Host "Other platforms not supported yet."
}

