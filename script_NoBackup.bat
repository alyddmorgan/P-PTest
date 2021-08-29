REM 	Author: Alydd Morgan
REM 	Date: 28/08/2021
REM 	Version 1.0.0

@echo off
set LOG=Terraform_Update.log

echo ****************************** Script Starts %date% %time% ****************************** > %LOG%
For /F "Delims=" %%A In ('"CURL "https://api.github.com/repos/hashicorp/terraform/releases/latest" | jq -r ".tag_name"  | cut -c 2-"') Do SET "latestVersion=%%A"  >> %LOG%
For /F "Delims=" %%B In ('"terraform version -json | jq -r ".terraform_version"  | cut -c 1-"') Do SET "InstalledVersion=%%B"  >> %LOG%
echo Latest Terraform version is %LatestVersion%  >> %LOG%
echo Current installed version is %InstalledVersion%  >> %LOG%

IF %LatestVersion%==%InstalledVersion% GOTO :NOUPDATE

Echo ****************************** Downloading Latest Version of Terraform ****************************** >> %LOG%
CURL -O https://releases.hashicorp.com/terraform/%LatestVersion%/terraform_%LatestVersion%_windows_amd64.zip  >> %LOG%
Echo ****************************** Version Downloaded, Extracting from Archive ****************************** >> %LOG%
7z -y x %CD%\terraform_%LatestVersion%_windows_amd64.zip -o%CD%\Extract  >> %LOG%
echo ****************************** File extracted, updating binary ****************************** >> %LOG%
xcopy "%CD%\Extract\terraform.exe" "C:\Program Files\terraform" /y  >> %LOG%
GOTO :END

:NOUPDATE
echo No Update Needed  >> %LOG%

:END
echo ****************************** Script Ends %date% %time% ******************************  >> %LOG%