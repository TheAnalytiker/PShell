﻿$folderscope = '\'

$success = New-Object System.Collections.ArrayList
$errors = New-Object System.Collections.ArrayList
$PFs = get-publicfolder $folderscope –Recurse
#$PS = $PFs | Get-PublicFolderClientPermission
#$PS = $PS | ? { ($_.user.displayname -notmatch "Default") -and ($_.user.displayname -notmatch "Anonymous") }
$count = $PFs.count
for ($P = 0; $P -lt $PFs.count; $P++) { 
$F = $PFs[$P].identity.ToString()
#$DN = $PS[$P].user.displayname.ToString()
#$DST = $PS[$P].user.RecipientPrincipal
# $AR = $PS[$P].accessrights
#$SPF = $PS[$P].SharingPermissionFlags
Write-Progress -Activity "Remove permission - [current Folder] $($F)" -Id 2 -ParentId 1 -Status "For [USER] $($DN)" -PercentComplete (($P/$count)*100) -SecondsRemaining $($count-$P) ;

$perm = Get-PublicFolderClientPermission -Identity $F
$perm = $perm | ? { ($_.user.displayname -notmatch "Default") -and ($_.user.displayname -notmatch "Anonymous") }

Foreach ($PM in $perm) {
$DN = $PM.user.displayname.ToString()
$DST = $PM.user.RecipientPrincipal
$AR = $PM.accessrights
$SPF = $PM.SharingPermissionFlags

Try { Remove-PublicFolderClientPermission $F -User $DN -Confirm:$false -EA 'stop' ; $success += $PM
               } catch {  Write-host $Error[0].Exception.Message -F yellow ; $errors += $PM }  
               
                       }
}

# get-publicfolder \ -Recurse | Get-PublicFolderClientPermission | Remove-PublicFolderClientPermission