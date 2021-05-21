# List all local packages
# choco list -l

# Require admin rights
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $wshell = New-Object -ComObject Wscript.Shell
	$wshell.Popup("You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!", 0, "Warning", 0x1)
	
	break
}

# Setup Chocolatey
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))


# Install applications
choco install -y 7zip
choco install -y autohotkey
choco install -y autoruns
choco install -y azure-cli
choco install -y beyondcompare --version 3.3.13.18981
choco pin add --name beyondcompare --version 3.3.13.18981
choco install -y ccleaner
choco install -y discord
choco install -y docker-desktop
choco install -y git
choco install -y google-backup-and-sync
choco install -y googlechrome
choco install -y instanteyedropper
choco install -y irfanview
choco install -y jdk8
choco install -y jre8
choco install -y keepass
choco install -y linqpad
choco install -y microsoft-teams
choco install -y microsoft-windows-terminal
choco install -y microsoftazurestorageexplorer
choco install -y mRemoteNG
choco install -y sql-server-management-studio
choco install -y nodejs
choco install -y notepadplusplus
choco install -y nuget.commandline
choco install -y paint.net
choco install -y postman
choco install -y rufus
choco install -y speccy
choco install -y spotify
choco install -y steam
choco install -y sumatrapdf
choco install -y teamviewer --version 13.2.5287
choco pin add --name teamviewer --version 13.2.5287
choco install -y tightvnc --install-arguments 'ADDLOCAL="Viewer" VIEWER_ASSOCIATE_VNC_EXTENSION=1 VIEWER_ADD_FIREWALL_EXCEPTION=1'
choco install -y virtualbox
choco install -y VisualStudioCode
choco install -y vlc
choco install -y vscode
choco install -y windirstat


# Visual studio
# See https://chocolatey.org/packages/visualstudio2019enterprise for other development packages
choco install -y visualstudio2019enterprise
choco install -y visualstudio2019-workload-manageddesktop
choco install -y visualstudio2019-workload-netweb
choco install -y visualstudio2019-workload-netcoretools
choco install -y visualstudio2019-workload-nativedesktop


# Install powershell modules
Install-PackageProvider -Name NuGet -Force
Install-Module -Name SqlServer -Force # For Invoke-SqlCmd


# Show file extensions
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name HideFileExt -Value 0

# Set UAC to never notify
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name PromptOnSecureDesktop -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name ConsentPromptBehaviorAdmin -Value 0

# Disable Cortana
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name SearchboxTaskbarMode -Value 0 -Force

# Enable developer mode in windows 10
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name AllowDevelopmentWithoutDevLicense -Value 1

# Remove task view button in taskbar
Set-ItemProperty -Force -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0 


# Remove Shortcuts
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\Public\Desktop\VLC media player.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\Public\Desktop\Speccy.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\Public\Desktop\CCleaner.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\Public\Desktop\Google Chrome.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\Public\Desktop\Oracle VM VirtualBox.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\Public\Desktop\Steam.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\Public\Desktop\Skype.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\Public\Desktop\Evernote.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\Public\Desktop\Mozilla Firefox.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\Public\Desktop\Acrobat Reader DC.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\Public\Desktop\mRemoteNG.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\Public\Desktop\TeamViewer 12.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\Public\Desktop\Visual Studio Code.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\$Env:UserName\Desktop\LINQPad 5.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\$Env:UserName\Desktop\Discord.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\$Env:UserName\Desktop\Spotify.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\$Env:UserName\Desktop\SourceTree.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\$Env:UserName\Desktop\Google Chrome.lnk"
Remove-Item -ErrorAction SilentlyContinue "$Env:SystemDir\Users\Public\Desktop\paint.net.lnk"


# Url to github repository
$githubUrl = 'https://raw.githubusercontent.com/BlueManiac/config-files/master'


# Replace notepad with notepad++
$filePath = 'C:\Program Files\Notepad++\Notepad++ParamProxy.exe'
Invoke-WebRequest -Uri "$githubUrl/Notepad++/Notepad++ParamProxy.exe" -OutFile $filePath
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" -Name "notepad.exe" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\notepad.exe" -Name Debugger -Value """$filePath""" -Force


# Copy .gitconfig
$filePath = 'C:\.gitconfig'
Invoke-WebRequest -Uri "$githubUrl/.gitconfig" -OutFile $filePath


Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
