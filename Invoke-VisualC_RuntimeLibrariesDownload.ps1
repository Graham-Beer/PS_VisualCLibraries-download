<#
.Synopsis
    Script to download all Visual C++ Runtime Libraries Download
.DESCRIPTION
    Script for image creation prerequisite
.EXAMPLE
    .\Invoke-VisualC_RuntimeLibrariesDownload.ps1 -RootFolder C:\Setup\
.NOTES
    Created:	 2017-01-31
    Version:	 1.0

    Author - Graham Beer
#>

    param(
        [parameter(position=0,mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$RootFolder,

        [switch]$TreeView
    )

# Set download information
# contains Fullname,ShortName,Source, DestinationFolder and DestinationFile
# contained in here-string as opposed to an external file
# To symbol an empty column "" is used
$Downloader = @"
Install - Microsoft Visual C++ - x86 - x64,Visual C++ 2005 x86,VC2005X86,http://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.EXE,VC2005,vcredist_x86.EXE
Install - Microsoft Visual C++ - x86 - x64,Visual C++ 2005 x64,VC2005X64,http://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x64.EXE,VC2005,vcredist_x64.EXE
Install - Microsoft Visual C++ - x86 - x64,Visual C++ 2008 x86,VC2008X86,http://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe,VC2008,vcredist_x86.exe
Install - Microsoft Visual C++ - x86 - x64,Visual C++ 2008 x64,VC2008X64,http://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe,VC2008,vcredist_x64.exe
Install - Microsoft Visual C++ - x86 - x64,Visual C++ 2010 x86,VC2010X86,http://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe,VC2010,vcredist_x86.exe
Install - Microsoft Visual C++ - x86 - x64,Visual C++ 2010 x64,VC2010X64,http://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe,VC2010,vcredist_x64.exe
Install - Microsoft Visual C++ - x86 - x64,Visual C++ 2012 x86,VC2012X86,http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe,VC2012,vcredist_x86.exe
Install - Microsoft Visual C++ - x86 - x64,Visual C++ 2012 x64,VC2012X64,http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe,VC2012,vcredist_x64.exe
Install - Microsoft Visual C++ - x86 - x64,Visual C++ 2013 x86,VC2013X86,http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe,VC2013,vcredist_x86.exe
Install - Microsoft Visual C++ - x86 - x64,Visual C++ 2013 x64,VC2013X64,http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe,VC2013,vcredist_x64.exe
Install - Microsoft Visual C++ - x86 - x64,Visual C++ 2015 x86,VC2015X86,http://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x86.exe,VC2015,vc_redist.x86.exe
Install - Microsoft Visual C++ - x86 - x64,Visual C++ 2015 x64,VC2015X64,http://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe,VC2015,vc_redist.x64.exe
"@ | ConvertFrom-Csv -Header FolderContainer,FullName,ShortName,Source,DestinationFolder,DestinationFile # Convert here-string to a csv format for each header object

# Create WebClient Class
$Webclient = New-Object System.NET.Webclient

# Set Messages in a scriptblock to suppress inital output
$Success = { write-host "[Done]" -f Green }
$fail = { write-host "[Error]" -f Red }

# Go through each request to download
$Downloader | foreach {
    # check/clear previous $DestinationFolder variable
    if ($DestinationFolder){rv DestinationFolder}

    # set column variables
    if([bool]$_.FullName){$fullname = $_.FullName}
    if([bool]$_.ShortName){$ShortName = $_.ShortName}
    if([bool]$_.Source){$Source = $_.Source}
    if([bool]$_.FolderContainer){$FolderContainer = $_.FolderContainer}
    if([bool]$_.DestinationFolder){$DestinationFolder = $_.DestinationFolder}
    if([bool]$_.DestinationFile){$DestinationFile = $_.DestinationFile}



    # Define Download destination folders
    $DestinationFolder = $RootFolder,$FolderContainer,$DestinationFolder,$ShortName -join "\"

    # if a column is empty an extra '\' can be added. Check and remove if this happens
     if($DestinationFolder -match "\\"){
       $DestinationFolder = $DestinationFolder.Replace("\\","\")
     }

    $Destination = $DestinationFolder,$DestinationFile -join "\"

    # Check if folder already exists and files have been downloaded
        if (!($null = Test-Path $Destination)){

            write-host "Creating $DestinationFolder..." -NoNewline ; sleep -Milliseconds 500 # add a pause
            # create folder
            try {
                $null = New-Item -Path $DestinationFolder -ItemType Directory -Force -ea Stop
                &$Success # Result
            } catch {
                &$fail # Result
                Write-Warning $_.exception.message
            }

            "$DestinationFile to be downloaded..."

            # Perform download
            try {
                 write-host "Starting Download to $Destination..." -NoNewline
                 $Webclient.DownloadFile($Source, $Destination)
                 &$Success # Result

            } catch {
                &$fail # Result
                Write-Warning $_.exception.message
            }
        } else {
            "$($_.FullName) Already Downloaded !" ; return
        }
    }

# display end file and folder structure
if($TreeView){
    if(test-path C:\windows\system32\tree.com) {
        "" # blank line
        tree /f $RootFolder
    }
}