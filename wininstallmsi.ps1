# =====================================================================
# Prologue : Copyright 2017
# Author   : Dzevel ROGOVIC
# =====================================================================

# Install application .msi

cls
Set-ExecutionPolicy Unrestricted

$AppDepot = "http://downloads.sourceforge.net/sevenzip/"
$AppInstaller = "7z920-x64.msi"

[string]$CurrentDir = $(get-location).Path
[string]$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

# Log file
[string]$fileName = "scriptInstall"
[string]$logfile = $CurrentDir + '\\' + $fileName + '.log'

# Transcription file
[string]$transcriptPath = $CurrentDir + '\\' + $fileName + 'Transcript.txt'
Start-Transcript -Path $transcriptPath -Force -Append -NoClobber

# WritetoLog
function Write-toLog {
	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$true)][string]$logMessage
	) 
	$date = Get-Date
	$logMessage2 = "> " + $date + " : User : " + $CurrentUser + " : Action : " + $logMessage
	Add-Content $logfile $logMessage2
	Write-Output $logMessage2
}

# install and verify if program is well installed
function Verify-ifInstalled{
	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$true)][string]$msifile,
		[Parameter(Mandatory=$true)][string]$arguments
	)
	if (Test-Path $msifile){
		Write-Output ">Installing .. $msifile"
		Start-Process `
     		-file  $msifile `
     		-arg $arguments `
     		-passthru | wait-process
			
		Write-Output ">End of installation .. $msifile"
		rm $msifile -ErrorAction SilentlyContinue -Verbose
	}else{
		Write-Output ">File not  found : $msifile"
	}
}

Write-toLog -logMessage "start execution $AppDepot $AppInstaller"

try {
	$downloader = (new-object System.Net.WebClient)
	$downloader.DownloadFile($AppDepot+$AppInstaller, "$LocalTempDir\$AppInstaller")
	#msiexec /package "$LocalTempDir\$AppInstaller" /passive
	$msifile= "$LocalTempDir\$AppInstaller" 
	$arguments= " /passive"
	Verify-ifInstalled -msifile $msifile -arguments $arguments
	# Exit
	Write-toLog -logMessage "end execution $msifile"
	stop-transcript
}
catch {
	Write-Output "EXCEPTION : "
	$ErrorMessage = $_.Exception.Message
	$FailedItem = $_.Exception.ItemName
	Write-toLog -logMessage $ErrorMessage
	stop-transcript
	Throw $_.Exception
}

