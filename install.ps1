# Require admin rights
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
  $wshell = New-Object -ComObject Wscript.Shell
  $wshell.Popup("You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!", 0, "Warning", 0x1)
  break
}

# Update winget to latest version
$path = "$($env:TEMP)\Setup.msix"
$url = (Invoke-WebRequest -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest").Content |
	ConvertFrom-Json |
	Select-Object -ExpandProperty "assets" |
	Where-Object "browser_download_url" -Match '.msixbundle' |
	Select-Object -ExpandProperty "browser_download_url"
Invoke-WebRequest -Uri $url -OutFile $path -UseBasicParsing
Add-AppxPackage -Path $path
Remove-Item $path

# APPLICATIONS

# Microsoft store apps
winget install --exact --source msstore --id 9P07XNM5CHP0 --accept-package-agreements # Ambie
winget install --exact --source msstore --id 9P7KNL5RWT25 --accept-package-agreements # Sysinternals Suite

# Machine apps
winget install --exact --source winget --scope machine --id 7zip.7zip
winget install --exact --source winget --scope machine --id Brave.Brave
#winget install --exact --source winget --scope machine --id Docker.DockerDesktop
#winget install --exact --source winget --scope machine --id DominikReichl.KeePass
winget install --exact --source winget --scope machine --id Git.Git
winget install --exact --source winget --scope machine --id GitHub.cli
winget install --exact --source winget --scope machine --id LINQPad.LINQPad.7
winget install --exact --source winget --scope machine --id Microsoft.AzureCLI
winget install --exact --source winget --scope machine --id Microsoft.PowerToys
#winget install --exact --source winget --scope machine --id Microsoft.SQLServerManagementStudio
winget install --exact --source winget --scope machine --id Microsoft.VisualStudioCode
winget install --exact --source winget --scope machine --id Notepad++.Notepad++
winget install --exact --source winget --scope machine --id OpenJS.NodeJS
#winget install --exact --source winget --scope machine --id Oracle.JavaRuntimeEnvironment
winget install --exact --source winget --scope machine --id Rufus.Rufus
#winget install --exact --source winget --scope machine --id ScooterSoftware.BeyondCompare4
winget install --exact --source winget --scope machine --id TeamViewer.TeamViewer
winget install --exact --source winget --scope machine --id VideoLAN.VLC
winget install --exact --source winget --scope machine --id WinDirStat.WinDirStat
winget install --exact --source winget --scope machine --id dotPDNLLC.paintdotnet
winget install --exact --source winget --scope machine --id mRemoteNG.mRemoteNG
winget install --exact --source winget --scope machine --id pnpm

# User apps
winget install --exact --source winget --scope user --id Discord.Discord
winget install --exact --source winget --scope user --id Microsoft.AzureDataStudio
winget install --exact --source winget --scope user --id Microsoft.WindowsTerminal
winget install --exact --source winget --scope user --id Spotify.Spotify # Can't be installed in admin console

# Visual studio, Workloads: https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-enterprise?view=vs-2022&preserve-view=true
winget install --exact --source winget --id Microsoft.VisualStudio.2022.Enterprise --override "--wait --passive --add Microsoft.VisualStudio.Workload.NetWeb --add Microsoft.VisualStudio.Workload.ManagedDesktop"

# Reload enviroment variables
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")

# Install powershell modules
Install-Module -Name SqlServer -Force # For Invoke-SqlCmd

# Windows features
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

# dotnet tools
dotnet tool install --global dotnet-outdated-tool
dotnet tool install --global dotnet-format

# TWEAKS

# Show file extensions
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name HideFileExt -Value 0

# Enable developer mode in windows 10/11
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name AllowDevelopmentWithoutDevLicense -Value 1

# Use old context menu in windows 11
New-Item -Force -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Name "InprocServer32"
Set-ItemProperty -Force -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Name "(Default)" -Value ''

# Disable OneDrive personal account (use business only)
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\OneDrive" -Name DisablePersonalSync -Value 1

# Set the default action of the power button on the Start menu to Shut Down
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name PowerButtonAction -Value 2

# Hide the search bar
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name SearchboxTaskbarMode -Value 0

# Hide the task view button
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ShowTaskViewButton -Value 0

# Hide the widgets button
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarDa -Value 0

# Hide the chat button
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarMn -Value 0


# VARIOUS

# Url to github repository
$githubUrl = 'https://raw.githubusercontent.com/BlueManiac/config-files/master'

# Copy .gitconfig
$filePath = "$Env:UserProfile\.gitconfig"
Invoke-WebRequest -Uri "$githubUrl/.gitconfig" -OutFile $filePath

# Create directories
New-Item -ItemType directory -ErrorAction SilentlyContinue -Path 'C:\Private'
New-Item -ItemType directory -ErrorAction SilentlyContinue -Path 'C:\Repositories'

# Remove Shortcuts on desktop
Get-ChildItem -Path "$Env:SystemDir\Users\Public\Desktop" *.lnk | foreach { Remove-Item -Path $_.FullName }
Get-ChildItem -Path "$Env:UserProfile\Desktop" *.lnk | foreach { Remove-Item -Path $_.FullName }

# Add Windows Defender exclusions
Add-MpPreference -ExclusionPath 'C:\Private'
Add-MpPreference -ExclusionPath 'C:\Program Files (x86)\MSBuild'
Add-MpPreference -ExclusionPath 'C:\Program Files (x86)\Microsoft Visual Studio'
Add-MpPreference -ExclusionPath 'C:\Program Files (x86)\Steam\steamapps\common'
Add-MpPreference -ExclusionPath 'C:\Program Files\MSBuild'
Add-MpPreference -ExclusionPath 'C:\Program Files\Microsoft Visual Studio'
Add-MpPreference -ExclusionPath 'C:\Repositories'
Add-MpPreference -ExclusionProcess 'ServiceHub.RoslynCodeAnalysisService.exe'
Add-MpPreference -ExclusionProcess 'devenv.exe'
Add-MpPreference -ExclusionProcess 'dotnet.exe'
Add-MpPreference -ExclusionProcess 'msbuild.exe'
Add-MpPreference -ExclusionProcess 'node.exe'
Add-MpPreference -ExclusionProcess 'npm.exe'

Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")