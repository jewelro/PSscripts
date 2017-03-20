# =====================================================================
# Prologue : Copyright 2017
# Author   : Dzevel ROGOVIC
# =====================================================================

# Install application .exe

cls
Set-ExecutionPolicy Unrestricted

[string]$CurrentDir = $(get-location).Path
[string]$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

$packages = @(  
	@{title='7-zip';url='http://www.7-zip.org/a/7z920.exe';Arguments=' /S';Destination=$CurrentDir}  
)

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
		[Parameter(Mandatory=$true)][string]$exefile,
		[Parameter(Mandatory=$true)][string]$arguments
	)
	if (Test-Path $exefile){
		Write-Output ">Installing .. $exefile"
		Start-Process `
     		-file $exefile `
     		-arg $arguments `
     		-passthru | wait-process
			
		Write-Output ">End of installation .. $exefile"
		rm $exefile -ErrorAction SilentlyContinue -Verbose
	}else{
		Write-Output ">File not  found : $msifile"
	}
}

Write-toLog -logMessage "start execution $AppDepot $AppInstaller"

try {
	# download files
	foreach ($package in $packages) { 
		$packageName = $package.title 
		Write-Output "title : $package.Name"
		Write-Output "url : $package.url"
		$fileName = Split-Path $package.url -Leaf 
		$destinationPath = $package.Destination + "\" + $fileName 
		If (!(Test-Path -Path $destinationPath -PathType Leaf)) { 
			Write-Host "Downloading $packageName" 
			$downloader = New-Object System.Net.WebClient 
			$downloader.DownloadFile($package.url,$destinationPath) 
		} 
	}
	 
	# install files .exe 
	foreach ($package in $packages) { 
	    $packageName = $package.title 
	    $fileName = Split-Path $package.url -Leaf 
	    $destinationPath = $package.Destination + "\" + $fileName 
	    $arguments = $package.Arguments 
	    #Write-Output "Installing $packageName" 
	    #Invoke-Expression -Command "$destinationPath $Arguments" 
		$exefile = $destinationPath 
		Verify-ifInstalled -exefile $exefile -arguments $arguments
		# Exit
		Write-toLog -logMessage "end execution $msifile"
		stop-transcript
	}
}
catch {
	Write-Output "EXCEPTION : "
	$ErrorMessage = $_.Exception.Message
	$FailedItem = $_.Exception.ItemName
	Write-toLog -logMessage $ErrorMessage
	stop-transcript
	Throw $_.Exception
}
