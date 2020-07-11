# tp-powershell-s2

## Authors
- DA SILVA OLIVEIRA PHILIPPE 4SRC2
- EZHILARASAN KARTHIKE 4SRC2
- PIOT JEAN-ALEXANDRE 4SRC2

## :warning: Prerequisite

- Have a domain controller ready with the domain `ESGI-SRC.FR`
    - Domain name can be modified by editing the script
- Have a shared directory
    - Can be a simple directory for simultation purpose

## Part 1

- Fill up the `part1\user-list.csv`
- Run `part1\part-1.ps1`
    - Choose 1 to create users
    - Choose 2 to deleted expired users

## Part 2

- Edit `part2\part-2.ps1` to set the `$SharedFolderPath` to your shared directory 
- run `part2\part-2.ps1`
    - Choose 1 to get specs of local computer
    - Choose 2 to fuse all genereted files to inventory
        - :warning: deleted files content will be lost if run multiple times

## Part 3

- Edit `part3\part-3.ps1` to set the `$SharedFolderPath` to your shared directory
- run `part3\part-3.ps1`
    - Number of computers to renew can be found in `part3\computerToBuy.txt`
    - Details on computers ready for migration can be found in `part3\readyToMigrate.csv`
    - Total Number of computers migrated can be found in `part3\workdone.txt`