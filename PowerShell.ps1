# Add Features and Packages to an Online Running System
Get-WindowsCapability -Online

$lofSource="D:\LanguagesAndOptionalFeatures"
$featureToAdd="Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"
Add-WindowsCapability -online -Name $featureToAdd -Source $lofSource -LimitAccess

$onDemandPKG="Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~~.cab"
Add-WindowsPackage -Online -PackagePath $lofSource\$onDemandPKG

$allRSAT=Get-WindowsCapability -Online -Name *rsat*
foreach ($curRSAT in $allRSAT) {Add-WindowsCapability -online -Name $curRSAT -Source $lofSource -LimitAccess}
(Get-WindowsCapability -Online -Name *rsat*).name | ForEach-Object {Add-WindowsCapability -online -Name $_ -Source $lofSource -LimitAccess}


# Add Feature to an Offline VHD, VHDX, or WIM Image
$lofSource="D:\LanguagesAndOptionalFeatures"
$wimSrcPath="C:\Temp\Sources\wim"
$wimMountDir="C:\Temp\Mount\wimmount"
$vhdSrcPath="C:\Temp\Sources\vhd"
$vhdMountDir="C:\Temp\Mount\vhdmount"
$onDemandPKG="Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~~.cab"

Get-WindowsImage -ImagePath $wimSrcPath\install.wim
Mount-WindowsImage -ImagePath $wimSrcPath\install.wim -Path $wimMountDir -Index 3

Mount-WindowsImage -ImagePath $vhdSrcPath\win1124h2OOBE.vhdx -Path $vhdMountDir -Index 1

Add-WindowsCapability -Name $featureToAdd -Path $wimMountDir -Source $lofSource -LimitAccess
Add-WindowsPackage -Path $wimMountDir -PackagePath $lofSource\$onDemandPKG

$allRSAT=(Get-WindowsCapability -Online -Name *rsat*).name
foreach ($curRSAT in $allRSAT) {Add-WindowsCapability -Name $curRSAT -Path $wimMountDir -Source $lofSource -LimitAccess}
Dismount-WindowsImage -Path $wimMountDir


# Add Drivers to an Offline VHD, VHDX, or WIM Image
$driverBaseDir="C:\Temp\Drivers"
$nvidiaDriver="553.35-quadro-rtx-desktop-notebook-win10-win11-64bit-international-dch-whql"
$xeroxPrintDriver="UNIV_5.1009.1.0_PS_x64_Driver.inf"
Add-WindowsDriver -Path $vhdMountDir -Driver $driverBaseDir\$nvidiaDriver\Display.Driver\
Add-WindowsDriver -Path $vhdMountDir -Driver $driverBaseDir\UNIV_5.1009.1.0_PS_x64_Driver.inf\x3UNIVP.inf
