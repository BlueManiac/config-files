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
choco install -y adobereader
choco install -y autohotkey
choco install -y autoit
choco install -y autoruns
choco install -y beyondcompare -version 3.3.12.18414
choco install -y ccleaner
choco install -y discord
choco install -y evernote
choco install -y firefox
choco install -y git
choco install -y googlechrome
choco install -y hg
choco install -y irfanview
choco install -y jdk8
choco install -y jre8
choco install -y linqpad
choco install -y mRemoteNG
choco install -y sql-server-management-studio
choco install -y nodejs
choco install -y notepadplusplus
choco install -y nuget.commandline
choco install -y paint.net
choco install -y poshgit
choco install -y prefix
choco install -y procexp
choco install -y rufus
choco install -y skype
choco install -y SourceTree
choco install -y speccy
choco install -y spotify
choco install -y steam
choco install -y teamviewer
choco install -y tightvnc --install-arguments 'ADDLOCAL="Viewer" VIEWER_ASSOCIATE_VNC_EXTENSION=1 VIEWER_ADD_FIREWALL_EXCEPTION=1'
choco install -y virtualbox
choco install -y vagrant
choco install -y VisualStudioCode
choco install -y vlc


# Visual studio
# See https://chocolatey.org/packages/visualstudio2017enterprise for other development packages
choco install -y visualstudio2017enterprise
choco install -y visualstudio2017-workload-manageddesktop
choco install -y visualstudio2017-workload-netweb
choco install -y visualstudio2017-workload-node
choco install -y visualstudio2017-workload-netcoretools
choco install -y resharper


# Refresh path for git and mercurial
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

# install posh-hg
cd $env:ProgramFiles
git clone https://github.com/JeremySkinner/posh-hg.git
cd posh-hg
.\install.ps1
. $PROFILE

# Refresh path for git and mercurial
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

# Show file extensions
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name HideFileExt -Value 0

# Set UAC to never notify
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name PromptOnSecureDesktop -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name ConsentPromptBehaviorAdmin -Value 0

# Disable Cortana
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name AllowCortana -Value 0 -Force

# Enable developer mode in windows 10
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name AllowDevelopmentWithoutDevLicense -Value 1


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


# Improve powershell startup time (using NGEN on Posh binaries)
$env:path = [Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()
[AppDomain]::CurrentDomain.GetAssemblies() | % {
  if (! $_.location) {continue}
  $Name = Split-Path $_.location -leaf
  Write-Host -ForegroundColor Yellow "NGENing : $Name"
  ngen install $_.location | % {"`t$_"}
}

# Url to github repository
$githubUrl = 'https://raw.githubusercontent.com/BlueManiac/config-files/master'


# Replace notepad with notepad++
$filePath = 'C:\Program Files\Notepad++\Notepad++ParamProxy.exe'
Invoke-WebRequest -Uri "$githubUrl/Notepad++/Notepad++ParamProxy.exe" -OutFile $filePath
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\notepad.exe" -Name Debugger -Value """$filePath""" -Force


# Copy .gitconfig
$filePath = 'C:\.gitconfig'
Invoke-WebRequest -Uri "$githubUrl/.gitconfig" -OutFile $filePath


# Copy mercurial.ini
$filePath = "$env:USERPROFILE\mercurial.ini"
Invoke-WebRequest -Uri "$githubUrl/mercurial.ini" -OutFile $filePath


Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
