function get_computer_info() {
    $computer_info = Get-ComputerInfo -Property "WindowsBuildLabEx", "WindowsCurrentVersion", "WindowsEditionId", "WindowsInstallationType", "WindowsInstallDateFromRegistry", "WindowsProductId", "WindowsProductName", "WindowsRegisteredOrganization", "WindowsRegisteredOwner", "WindowsSystemRoot", "WindowsVersion", "CsDNSHostName", "CsDomain", "CsDomainRole", "CsName", "CsNetworkAdapters", "CsNumberOfLogicalProcessors", "CsNumberOfProcessors", "CsProcessors", "CsPartOfDomain", "CsSystemType", "CsTotalPhysicalMemory", "CsPhyicallyInstalledMemory", "CsUserName", "CsWorkgroup", "OsName", "OsType", "OsOperatingSystemSKU", "OsVersion", "OsBuildNumber", "OsHotFixes", "OsCountryCode", "OsCurrentTimeZone", "OsLocaleID", "OsLocale", "OsLocalDateTime", "OsTotalVisibleMemorySize", "OsFreePhysicalMemory", "OsTotalVirtualMemorySize", "OsFreeVirtualMemory", "OsInUseVirtualMemory", "OsInstallDate", "OsManufacturer", "OsMuiLanguages", "OsNumberOfProcesses", "OsNumberOfUsers", "OsArchitecture", "OsLanguage", "OsPrimary", "OsProductType", "OsSerialNumber", "KeyboardLayout", "TimeZone", "LogonServer", "PowerPlatformRole"
    $csname = $computer_info.CsName
    $computer_info | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 | Set-Content -Path "${csname}.csv"
}

function fuse_to_inventory() {
        
}

function main() {
    
    do {
        Clear-Host
        Write-Host "1) get computer specs"
        Write-Host "2) fuse to inventory"
        Write-Host "Enter 1 or 2:" -ForegroundColor Yellow -NoNewline
        $choice = Read-Host
        
        if ($choice -eq 1 -or $choice -eq 2) {
            $ok = $true
        }
        else {
            $ok = $false
        }
    } while ($ok -eq $false)
    
    
    switch ($choice) {
        1 { get_computer_info }
        2 { fuse_to_inventory }
    }
}

main
