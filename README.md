# PS_VisualCLibraries-download

 A Script to download all Visual C++ Runtime Libraries Download
 
 Example:
 
 Script will create a folder structure as below:

```
 D:\SETUP
└───Install - Microsoft Visual C++ - x86 - x64
    ├───VC2005
    │   ├───VC2005X64
    │   └───VC2005X86
    ├───VC2008
    │   ├───VC2008X64
    │   └───VC2008X86
    ├───VC2010
    │   ├───VC2010X64
    │   └───VC2010X86
    ├───VC2012
    │   ├───VC2012X64
    │   └───VC2012X86
    ├───VC2013
    │   ├───VC2013X64
    │   └───VC2013X86
    └───VC2015
        ├───VC2015X64
        └───VC2015X86
```    

The D:\SETUP is the changable value passed in from the command input: 
.\Invoke-VisualC_RuntimeLibrariesDownload.ps1 -RootFolder d:\setup -TreeView
