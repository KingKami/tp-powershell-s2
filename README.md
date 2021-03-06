# TP Powershell

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
        - :warning: You must have a global security group named `Administrateur local` for the script to run the group name can be changed by editing line 58
        - :warning: You must have the following path in your active directory `OU=Users,OU=migration,OU=PRESTA10,DC=ESGI-SRC,DC=fr` the path can be changed by editing line 27
    - Choose 2 to delete expired users

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