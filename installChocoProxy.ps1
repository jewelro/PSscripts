# =====================================================================
# Prologue : Copyright 2017
# Author   : Dzevel ROGOVIC
# =====================================================================

# Install via proxy

cls
Set-ExecutionPolicy Unrestricted

$IPproxy = '172.17.138.54:3128'
$env:chocolateyProxyLocation = $IPproxy

& ./install.ps1

choco config set proxy $IPproxy

# and then install something ...
choco install vlc -y --force

