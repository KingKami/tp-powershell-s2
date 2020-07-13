function import_csv([string]$file) {
    $list = Import-Csv $file -Delimiter ','
    return $list
}

function test_aduser([string]$username) {
    Try {
        Get-ADuser -Identity $username -ErrorAction Stop
        return $true
    }
    Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
        return $false
    }
}

function create_users([Object[]]$list) {
    foreach ($user in $list) {
        $password = $user.name[0] + "." + $user.surname[0] + "@" + $user.company + (get-date -Format "MM")
        $username = $user.name+"."+$user.surname
        $initials = $user.name[0] + $user.surname[0]
        $name = $user.name
        $surname = $user.surname
        $displayname = $user.name + " " + $user.surname
        $company = $user.company
        $department = $user.department
        $expiry_date = $user.contract_end
        $path = "OU=Users,OU=${department},OU=${company},DC=ESGI-SRC,DC=fr"
        if ($user.ispresent -eq 1){
            $isenabled = $True
        } else {
            $isenabled = $False
        }
        if (test_aduser($username)) {
            if ($isenabled) {
                Get-ADuser -Identity $username | Enable-ADAccount 
                write-host "user exists no action required"
            }
            else {
                Get-ADuser -Identity $username | Disable-ADAccount 
                write-host "${username} has been disabled"
            }
        } else {
            if ($isenabled) {
                New-ADUser `
                -AccountExpirationDate $expiry_date `
                -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
                -ChangePasswordAtLogon $true `
                -Company $company `
                -Department $department `
                -DisplayName $displayname `
                -Enabled $isenabled `
                -Initials $initials `
                -Name $name `
                -SamAccountName $username `
                -Surname $surname `
                -GivenName $surname `
                -Path $path
                Add-ADGroupMember -Identity "Administrateur local" -Members $username
                write-host "${username} has been created"
            } else {
                write-host "no action required ${username} is not present"
            }
        }
    }
}

function remove_inactive_account([Object[]]$list){
    $then = (Get-Date).AddDays(-30)
    foreach ($user in $list){
        $username = $user.name + "." + $user.surname
        $expired = Search-ADAccount -AccountExpired | Where-Object {$_.enabled -eq $False -and $_.SamAccountName -eq $username -and $_.AccountExpirationDate -lt $then}
        write-host "removing ${username}"
        $expired | Remove-ADUser
    }
}

function main() {
    $list = import_csv(".\user-list.csv")
    do {
        Clear-Host
        Write-Host "1) Create users from csv`n2) Delete expired users"
        Write-Host "Enter 1 or 2: " -ForegroundColor Yellow -NoNewline
        $choice = Read-Host
        if ($choice -eq 1 -or $choice -eq 2) {
            $ok = $true
        } else {
            $ok = $false
        }
    } while ($ok -eq $false)
    switch ($choice) {
        1 { create_users $list}
        2 { remove_inactive_account $list}
    }
}

main
