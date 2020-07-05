function get_computer_info() {
    $computer_info = Get-ComputerInfo -Property "WindowsBuildLabEx", "WindowsCurrentVersion", "WindowsEditionId", "WindowsInstallationType", "WindowsInstallDateFromRegistry", "WindowsProductId", "WindowsProductName", "WindowsRegisteredOrganization", "WindowsRegisteredOwner", "WindowsSystemRoot", "WindowsVersion", "CsDNSHostName", "CsDomain", "CsDomainRole", "CsName", "CsNetworkAdapters", "CsNumberOfLogicalProcessors", "CsNumberOfProcessors", "CsProcessors", "CsPartOfDomain", "CsSystemType", "CsTotalPhysicalMemory", "CsPhyicallyInstalledMemory", "CsUserName", "CsWorkgroup", "OsName", "OsType", "OsOperatingSystemSKU", "OsVersion", "OsBuildNumber", "OsHotFixes", "OsCountryCode", "OsCurrentTimeZone", "OsLocaleID", "OsLocale", "OsLocalDateTime", "OsTotalVisibleMemorySize", "OsFreePhysicalMemory", "OsTotalVirtualMemorySize", "OsFreeVirtualMemory", "OsInUseVirtualMemory", "OsInstallDate", "OsManufacturer", "OsMuiLanguages", "OsNumberOfProcesses", "OsNumberOfUsers", "OsArchitecture", "OsLanguage", "OsPrimary", "OsProductType", "OsSerialNumber", "KeyboardLayout", "TimeZone", "LogonServer", "PowerPlatformRole"
    $csname = $computer_info.CsName
    $computer_info | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 | Set-Content -Path "${csname}.csv"
}

function main() {
    get_computer_info    
}

main
