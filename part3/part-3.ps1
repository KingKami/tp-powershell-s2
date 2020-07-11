function import_csv([string]$file, [string]$delimiter=",") {
    $list = Import-Csv $file -Delimiter ${delimiter}
    return $list
}

function get_eligible_computers([string]$SharedFolderPath) {
    $ComputersList = import_csv("..\part2\inventory.csv") 
    $header = Get-Content "..\part2\inventory.csv" | Select-Object -First 1
    Set-Content -Path "${SharedFolderPath}readyToMigrate.csv" -Value $header -Encoding UTF8
    $readyToMigrate = @()

    foreach ($Computer in $ComputersList) {
        [int]$memory = $Computer.TotalPhysicalMemoryGB
        [int]$processor_generation = [convert]::ToInt32($Computer.Processor[21], 10)
        [int]$disk_size = $Computer.TotalDiskSizeGB
        try {
            [int]$wireless_adapter_speed = $Computer.WirelessAdapterSpeedGB
        }
        catch [System.InvalidCastException] {
            $wireless_adapter_speed = 0
        }
        try {
            [int]$ethernet_adapter_speed = $Computer.EthernetAdapterSpeedGB
        }
        catch [System.InvalidCastException] {
            $ethernet_adapter_speed = 0
        }
        if ($memory -ge 12 -and $processor_generation -ge 6 -and $disk_size -ge 500 -and ($ethernet_adapter_speed -ge 1 -or $wireless_adapter_speed -ge 1 )) {
            $readyToMigrate += $Computer
        }else {
            $computer_to_buy += 1
        }
    }
    $readyToMigrate | Export-Csv -NoTypeInformation -Path "${SharedFolderPath}readyToMigrate.csv" -Encoding UTF8
    Set-Content -Path ${SharedFolderPath}computerToBuy.txt -Value "$DateTime : computers to buy: ${computer_to_buy}"
    $work_todo = (($ComputersList | Measure-Object).Count - (import_csv("done.csv") | Measure-Object).Count)
    $DateTime = Get-Date -UFormat "%Y/%m/%d %T"
    Add-Content -path ${SharedFolderPath}workdone.txt -Value "$DateTime : $work_todo computers left to migrate"
}

function main() {
    $SharedFolderPath = "D:\Karthike\cours\powershell\tp-powershell-s2\part3\"
    get_eligible_computers $SharedFolderPath
}

main
