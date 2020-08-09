#Script to change stale or existing owner of GPO using AD DACL  modules


$OwnerNew = "Domain Admins" #Name of the Object user or group to be updated
$GPOName = "TestGPO*" #GPO to be updated, This field accepts wildcards,  "*" updates all GPO

#Get all GPOs, filter if required

$AllGPO = Get-GPO -All | ?{$_.DisplayName -like $GPOName}
#$AllGPO = Get-GPO -All

"" 
"GPO Name"+"           "+ "OwnerBefore"+"                      "+ "OwnerAfter"
"--------"+"           "+ "-----------"+"                      "+ "----------"

foreach ($gp in $AllGPO){

  #"GPO Name: " + $gp.DisplayName
  
    #Get the GUID and add wild* 

    #Get-GPO "TestGPO"
    $gpId = "*"+($gp).Id+"*"

    #Store the GPO AD Object in a variable

    $Gpo1 = get-adobject -Filter {Name -like $gpId}

    #Store the new Owner in a  variable as well (Note changes for group and user accounts)
        #$Ownr = New-Object System.Security.Principal.SecurityIdentifier (Get-ADGroup "Domain Admins").SID
        #$Ownr = New-Object System.Security.Principal.SecurityIdentifier (Get-ADUser "USer1").SID

    #Generic Cmdlet to get User or Group
    $Ownr = New-Object System.Security.Principal.SecurityIdentifier (Get-ADObject -Filter {Name -like $OwnerNew} -Properties objectSid).objectSid
    #$Ownr = New-Object System.Security.Principal.SecurityIdentifier (Get-ADObject -Filter {Name -like "User1"} -Properties objectSid).objectSid

    #Copy the DACL for the GPO object to be modified in a variable

    $Acl = Get-ACL -Path "ad:$($Gpo1.DistinguishedName)"

    #Validate the currect owner (- can be skipped in when in a script)
    
    #"Before:"
    $aclBefore = $Acl.GetOwner([System.Security.Principal.NTAccount]).Value

    #Edit Owner on a GPO using Powershell to new Owner 
    $Acl.SetOwner($Ownr)

    #Note changes are not yet commited, we have made changes only to the variable data not the actual object
    #"Ready:"
    #$Acl.Owner

    #Commit the changes on the variable to the -Path actual object
    Set-ACL -Path "ad:$($Gpo1.DistinguishedName)" -ACLObject $Acl

    #"After:"
    #Get actual data, not from the old variable to confirm change has been made:
    $aclafter = (Get-ACL -Path "ad:$($Gpo1.DistinguishedName)").Owner

    

$gp.DisplayName+"           "+ $aclBefore+"           "+ $aclafter         

}

<#  Sample output
PS C:\Users\Administrator> C:\Users\Administrator\Desktop\ChangeGPO-Owner.ps1

GPO Name           OwnerBefore                      OwnerAfter
--------           -----------                      ----------
TestGPO2           BLUEBELL\Domain Admins           BLUEBELL\User1_
TestGPO1           BLUEBELL\Domain Admins           BLUEBELL\User1_

PS C:\Users\Administrator> C:\Users\Administrator\Desktop\ChangeGPO-Owner.ps1

GPO Name           OwnerBefore                      OwnerAfter
--------           -----------                      ----------
TestGPO2           BLUEBELL\User1_           BLUEBELL\Domain Admins
TestGPO1           BLUEBELL\User1_           BLUEBELL\Domain Admins

PS C:\Users\Administrator> 

#>