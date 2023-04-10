    $x  = import-Csv -Path "C:\Users\NANI KIRAN\OneDrive\Documents\majorproject\silentkeys.csv" -Delimiter ',' -Header 'software_name','silent_key','compare_name' | Select-Object software_name,silent_key,compare_name
    $filePath = ""
    
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "All files (*.*)|*.*"

    if($openFileDialog.ShowDialog() -eq "OK") {
    $filePath = $openFileDialog.FileNames
    $filename = $openFileDialog.SafeFileNames
    }   

    $32bit_softwares = Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
                    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate


    $64bit_softwares = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* |
                     Select-Object DisplayName, DisplayVersion, Publisher, InstallDate


    $all_softwares = $32bit_softwares + $64bit_softwares

    $file_path = "`"$filepath`""



foreach ($software in $x) {
$softexec = $software.software_name
$softexec = $softexec.ToString()
$pkgs = Get-ChildItem $filePath | Where-Object {$_.Name -eq $softexec}

foreach ($pkg in $pkgs) {
$ext = [System.IO.Path]::GetExtension($pkg)
$ext = $ext.ToLower()
$switch =$software.silent_key
$switch =$switch.Tostring()
$name = $software.compare_name
$name = $name.ToString()
#Write-Host "$softexec"
#Write-Host "$switch"
#Write-Host "$name"
#}


}

}

if ($all_softwares.DisplayName -like $name){
Write-Output "software is already installed"
   Write-Host  "----->exiting<--------------" -ForegroundColor Red -BackgroundColor Yellow
   Exit;
   } else{
   Write-Output "softwre not installed, continue to install "
   Write-Output "Installing software: $Name"
   #Start-Process -FilePath $file_Path -ArgumentList $Switch -Wait -PassThru -NoNewWindow
   Start-Process -FilePath $file_Path -ArgumentList $Switch -PassThru | Wait-Process
   Write-Host "$Name  installed"
   }