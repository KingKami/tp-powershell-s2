function getNetworkAdapterSpeed([string]$type) {
    $NetworkAdapterSpeed = Get-WmiObject Win32_NetworkAdapter -ComputerName "localhost" |`
    Where-Object {$_.Name -match $type -and $_.Name -notmatch 'virtual' -and $null -ne $_.Speed -and $null -ne $_.MACAddress} |`
    Measure-Object -Property speed -sum |`
    ForEach-Object { [Math]::Round(($_.sum / 1GB))}    
    if ($null -ne $NetworkAdapterSpeed) {
        return $NetworkAdapterSpeed
    } else {
        return "no ${type} adapter found"
    }
}

function get_computer_info([string]$SharedFolderPath){
    $server = "localhost"
    $infoObject = New-Object PSObject
    $CPUInfo = Get-WmiObject Win32_Processor -ComputerName $server
    $SystemName = $CPUInfo.SystemName
    $OSInfo = Get-WmiObject Win32_OperatingSystem -ComputerName $server
    $PhysicalMemory = Get-WmiObject CIM_PhysicalMemory -ComputerName $server | Measure-Object -Property capacity -Sum | ForEach-Object { [Math]::Round(($_.sum / 1GB), 2) }
    $DiskSize = Get-WmiObject Win32_logicaldisk -ComputerName localhost | Measure-Object -Property size -Sum | ForEach-Object { [Math]::Round(($_.sum / 1GB), 2) }
    $WirelessAdapterSpeed = getNetworkAdapterSpeed("wireless")
    $EthernetAdapterSpeed = getNetworkAdapterSpeed("ethernet")
    $DateTime = Get-Date -UFormat "%Y/%m/%d %T"
    Add-Member -inputObject $infoObject -memberType NoteProperty -name "SystemName" -value $SystemName
    Add-Member -inputObject $infoObject -memberType NoteProperty -name "Processor" -value $CPUInfo.Name
    Add-Member -inputObject $infoObject -memberType NoteProperty -name "PhysicalCores" -value $CPUInfo.NumberOfCores
    Add-Member -inputObject $infoObject -memberType NoteProperty -name "LogicalCores" -value $CPUInfo.NumberOfLogicalProcessors
    Add-Member -inputObject $infoObject -memberType NoteProperty -name "OSName" -value $OSInfo.Caption
    Add-Member -inputObject $infoObject -memberType NoteProperty -name "OSVersion" -value $OSInfo.Version
    Add-Member -inputObject $infoObject -memberType NoteProperty -name "TotalPhysicalMemoryGB" -value $PhysicalMemory
    Add-Member -inputObject $infoObject -MemberType NoteProperty -name "TotalDiskSizeGB" -Value $DiskSize
    Add-Member -inputObject $infoObject -MemberType NoteProperty -name "WirelessAdapterSpeedGB" -Value $WirelessAdapterSpeed
    Add-Member -inputObject $infoObject -MemberType NoteProperty -name "EthernetAdapterSpeedGB" -Value $EthernetAdapterSpeed
    Add-Member -inputObject $infoObject -MemberType NoteProperty -name "Username" -Value $env:UserName
    Add-Member -inputObject $infoObject -MemberType NoteProperty -name "InventoryTime" -Value $DateTime
    $infoObject | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 | Set-Content -Path "${SharedFolderPath}${SystemName}.csv" -Encoding UTF8
}

function fuse_to_inventory([string]$SharedFolderPath){
    $header = '"SystemName","Processor","PhysicalCores","LogicalCores","OSName","OSVersion","TotalPhysicalMemoryGB","TotalDiskSizeGB","WirelessAdapterSpeedGB","EthernetAdapterSpeedGB","Username","InventoryTime"'
    Set-Content -Path "${SharedFolderPath}inventory.csv" -Value $header -Encoding UTF8
    Get-ChildItem -File -Path "${SharedFolderPath}*" -Include *.csv -Exclude *inventory.csv* | Foreach-Object {
        $content = Get-Content $_.FullName
        Add-Content -Path "${SharedFolderPath}inventory.csv" -Value $content -Encoding UTF8
    }
}

function main() {
    $SharedFolderPath = "D:\Karthike\cours\powershell\tp-powershell-s2\part2\"
    do {
        Clear-Host
        Write-Host "1) Get Computer Specs`n2) Fuse To Inventory"
        Write-Host "Enter 1 or 2: " -ForegroundColor Yellow -NoNewline
        $choice = Read-Host
        if ($choice -eq 1 -or $choice -eq 2) {
            $ok = $true
        }
        else {
            $ok = $false
        }
    } while ($ok -eq $false)
    switch ($choice) {
        1 { get_computer_info $SharedFolderPath}
        2 { fuse_to_inventory $SharedFolderPath}
    }
}

main
