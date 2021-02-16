# Go to test location

$keepHoursTarget = 1
$keepHoursArchive = 168 # 7 Tage

$targetFolderName = "Test"
$archiveFolderName =  "Archiv"

$Script:MyInvocation.InvocationName
$targetFolderPath = Join-Path -Path $(Split-Path $Script:MyInvocation.InvocationName) -ChildPath $targetFolderName
$archiveFolderPath = Join-Path -Path $targetFolderPath -ChildPath $archiveFolderName 


$currentTime = Get-Date

# Archive files older than $keepHoursTarget
$filesToArchive = Get-ChildItem -Path $targetFolderPath -File
$olderThanArchiveTime = $currentTime.AddDays(-1 * $keepHoursTarget)
foreach ($file in $filesToArchive) {
    if ($file.LastWriteTime -lt $olderThanArchiveTime) {
        Move-Item -Path $file.FullName -Destination $archiveFolderPath -Force
    }
}

# Delete files in archive older than $keepHoursArchive
$filesToDelete = Get-ChildItem -Path $archiveFolderPath
$olderThanDeleteTime = $currentTime.AddDays(-1 * $keepHoursArchive)
foreach ($file in $filesToDelete) {
    if ($file.LastWriteTime -lt $olderThanDeleteTime) {
        Remove-Item -Path $file.FullName -Force
    }
}
