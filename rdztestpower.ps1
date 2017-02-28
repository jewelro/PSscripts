Set-ExecutionPolicy Unrestricted

icm $executioncontext.InvokeCommand.NewScriptBlock((New-Object Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))

Invoke-Expression("choco install notepadplusplus.install -y")

icm $executioncontext.InvokeCommand.NewScriptBlock((New-Object Net.WebClient).DownloadString('https://raw.github.com/EastPoint/PerfTap/master/InstallPerfTap.ps1')) -Args @{HostName='server.addr';Port=8125;Key='Key';SampleInterval='00:00:01';Format='StatSite';DefinitionPaths='CounterDefinitions\system.counters','CounterDefinitions\webservice.counters';CounterNames='\Processor(*)\% Processor Time';}

icm $executioncontext.InvokeCommand.NewScriptBlock((New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/h-medjahed/scripts/master/chocolatey/chocoInstall.ps1"))

 > $Command = "Get-Process"
 > Invoke-Expression $Command
 
 Invoke-Expression("choco install notepadplusplus.install -y")
 Invoke-Expression("choco install vlc -y")
 
 Invoke-Expression -Command ".\newDirectory.ps1 -argduscript c:\xxx"
 Invoke-Expression(".\newDirectory.ps1 -argduscript c:\xxx3")