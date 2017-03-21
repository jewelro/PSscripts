# =====================================================================
# Prologue : Copyright 2017
# Author   : Dzevel ROGOVIC
# =====================================================================

# Install via proxy

cls
Set-ExecutionPolicy Unrestricted

$IPproxy = '172.17.138.54:3128'
$env:https_proxy = $IPproxy
$env:http_proxy = $IPproxy
$proxy = New-Object System.Net.WebProxy($env:https_proxy, $true)
$downloader = new-object System.Net.WebClient
$downloader.Proxy = $proxy

icm $executioncontext.InvokeCommand.NewScriptBlock($downloader.DownloadString("https://chocolatey.org/install.ps1"))

# install some programs
Invoke-Expression("choco install vlc -y")