

# Setup Script
$scriptPath = $(Split-Path $Script:MyInvocation.InvocationName)

$testFolderName = "Test"
$testFolderPath = Join-Path -Path $scriptPath -ChildPath $testFolderName

$archiveFolderName = "Archiv"
$archiveFolderPath = Join-Path -Path $testFolderPath -ChildPath $archiveFolderName

# File list
$currentFileList = [ordered]@{
    "D-1.txt" = Get-Date;
    "D-2.txt" = (Get-Date).AddMinutes(-10);
    "D-3.txt" = (Get-Date).AddMinutes(-45).AddSeconds(33);
    "A-1.txt" = (Get-Date).AddHours(-1).AddMinutes(-55);
    "A-2.txt" = (Get-Date).AddHours(-1).AddMinutes(-1);
    "A-3.txt" = (Get-Date).AddDays((-2));
    $($archiveFolderName + "\AK-1.txt") = (Get-Date).AddDays((-5));
    $($archiveFolderName + "\AD-1.txt") = (Get-Date).AddDays((-7));
    $($archiveFolderName + "\AD-2.txt") = (Get-Date).AddDays((-9));
 }

#######################################################################################################

# Cleanup Test Env
if (Test-Path $testFolderPath) {
    Remove-Item -Recurse -Force -Path $testFolderPath
}

# Create test folder structure
New-Item -Path $scriptPath -Name $testFolderName -ItemType Directory | Out-Null
New-Item -Path $testFolderPath -Name $archiveFolderName -ItemType Directory | Out-Null

# Create test files
foreach ($newFile in $currentFileList.GetEnumerator()) {
    $fullFilePath = Join-Path -Path $testFolderPath -ChildPath $newFile.Name
    New-Item -Path $fullFilePath -ItemType File | Out-Null
    Set-ItemProperty -Path $fullFilePath -Name LastWriteTime -Value $newFile.Value
}

""
#*************************************************************************"
# Test
# *************************************************************************"

# Print folder content
Get-ChildItem $testFolderPath -Recurse

# Run cleanup script
. $(Join-Path -Path $scriptPath -ChildPath "cleanup.ps1")

# Reprint folder content
Get-ChildItem $testFolderPath -Recurse