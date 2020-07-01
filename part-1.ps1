function import_csv([string]$file) {
    $list = Import-Csv $file -Delimiter ','
    return $list
}

function test_aduser([string]$username, [string]$path) {
    Try {
        Get-ADuser -Identity $username -SearchBase $path -ErrorAction Stop
        return $true
    }
    Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
        return $false
    }
}

function delete_users() {
    $timespan = New-Timespan –Days 30
    Search-ADAccount -AccountInactive -Timespan $timespan | Where-Object { $_.ObjectClass -eq 'user' } | Remove-ADUser
}

function create_users() {
    $list = import_csv(".\user-list.csv")
    $expiry_date = "09/01/2020"

    foreach ($user in $list) {

        $password = $user.name + "." + $user.surname + "@" + $user.company
        $username = "${user.name}.${user.surname}"
        $path = "OU=Users,OU=${user.departement},OU=${user.company},DC=ESGI-SRC,DC=fr"

        if (test_aduser($username)) {
            if (user.ispresent) {
                write-host "user exists no action required"
            }
            else {
                Disable-ADAccount -Identity $username -SearchBase $path
                Remove-LocalGroupMember -Group "Administrators" -Member $username
            }
        }
        else {
            New-ADUser
            -AccountExpirationDate $expiry_date
            -AccountPassword (ConvertTo-SecureString -AsPlainText $password -Force)
            -ChangePasswordAtLogon $true
            -Company $user.company
            -Department $user.departement
            -DisplayName "${user.name} ${user.surname}"
            -EmailAddress $user.mail
            -Enabled $user.ispresent
            -Initials $user.name[0] + $user.surname[0]
            -Name $user.name
            -PasswordNeverExpires $false
            -PasswordNotRequired $false
            -Path $path
            -SamAccountName $username
            -Surname $user.surname
            -TrustedForDelegation $false
            Add-LocalGroupMember -Group "Administrators" -Member $username
        }
    }
}

function main() {
    create_users
    delete_users
}

main
