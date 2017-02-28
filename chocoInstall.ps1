Set-ExecutionPolicy Unrestricted
icm $executioncontext.InvokeCommand.NewScriptBlock((New-Object Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))