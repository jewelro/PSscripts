<#
 Author : Dzevel ROGOVIC
 Date   : 2017
#>
cls
Set-ExecutionPolicy Unrestricted

[string]$CurrentDir = $(get-location).Path
[string]$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
[string]$Depot = "https://raw.githubusercontent.com/jewelro/PSscripts/master/"

# Log file
[string]$fileName = "mainInstall"
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

# Install function
function Install-GitFile {
	[cmdletbinding()]
	param (
		[Parameter(Mandatory=$true)][string]$installFile,
		[Parameter(Mandatory=$false)][string[]]$argList
	) 
	$logmess = "install: $installFile : args : $argList"
	Write-toLog -logMessage $logmess
	if ($argList){
		icm $executioncontext.InvokeCommand.NewScriptBlock((New-Object Net.WebClient).DownloadString($installFile)) -ArgumentList $argList
	}
	else {
		icm $executioncontext.InvokeCommand.NewScriptBlock((New-Object Net.WebClient).DownloadString($installFile)) 
	}
	#wait 2 seconds 
	Start-Sleep -m 2000
}

Write-toLog -logMessage "start execution $fileName"

try {
	# install chocolatey
	$myfile=$Depot + "chocoInstall.ps1"
	Install-GitFile -installFile $myfile

	# install 1
	$myfile = $Depot + "newDirectory.ps1"
	$targList = @("c:\azerty99","c:\test99")
	install-GitFile -installFile $myfile -argList $targList

	# install 2
	#Write-toLog -logMessage "choco install vlc -y"
	#Invoke-Expression("choco install vlc -y --force")

	# install 3
	#Write-toLog -logMessage "choco install tomcat -y"
	#Invoke-Expression("choco install tomcat -y")

	# install 4
	Write-toLog -logMessage "calc"
	Invoke-Expression("calc")

	#===================================
	# Exit
	Write-toLog -logMessage "end execution $fileName"
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
