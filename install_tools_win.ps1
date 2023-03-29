$GhdlTemp = New-TemporaryFile | Rename-Item -NewName { $_.Name + ".zip" } -PassThru  
$JustTemp = New-TemporaryFile | Rename-Item -NewName { $_.Name + ".zip" } -PassThru  
$GtkWaveTemp = New-TemporaryFile | Rename-Item -NewName { $_.Name + ".zip" } -PassThru  

Write-Host "[-] Downloading GHDL, just and GTKWave"

try {
	Invoke-WebRequest -Uri "https://github.com/ghdl/ghdl/releases/download/v3.0.0/ghdl-UCRT64.zip" -OutFile $GhdlTemp
	Write-Host "[+] Downloaded GHDL"

	Invoke-WebRequest -Uri "https://github.com/casey/just/releases/download/1.13.0/just-1.13.0-x86_64-pc-windows-msvc.zip" -OutFile $JustTemp
	Write-Host "[+] Downloaded just"

	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/obwan02/VHDL-Tools/main/gtkwave-3.3.100-bin-win64.zip" -OutFile $GtkWaveTemp
	Write-Host "[+] Downloaded GtkWave"

} catch {
	Write-Host "[x] Failed one or more downloads. exiting ..."
	break
}

# New Line
Write-Host ""

$BIN_OUT = $HOME

Write-Host "[-] Unzipping downloaded archives"

if( !(Test-Path -Path "$BIN_OUT\VHDL Tools" -PathType Container) ) {
	New-Item -Path "$BIN_OUT\VHDL Tools" -ItemType Directory -Force
}

try {
	Expand-Archive -Force -LiteralPath $GhdlTemp -DestinationPath "$BIN_OUT\VHDL Tools"
	Write-Host "[+] Extracted GHDL to $BIN_OUT\VHDL Tools"
	Expand-Archive -Force -LiteralPath $JustTemp -DestinationPath "$BIN_OUT\VHDL Tools\just"
	Write-Host "[+] Extracted just to $BIN_OUT\VHDL Tools"
	Expand-Archive -Force -LiteralPath $GtkWaveTemp -DestinationPath "$BIN_OUT\VHDL Tools"
	Write-Host "[+] Extracted GTKWave to $BIN_OUT\VHDL Tools"
} catch {
	Write-Host "[x] Failed to extract one or more archives. exiting ..."
	break
}

# New Line
Write-Host ""

# Set execution policy so that powershell profile always loads
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

# Setup profile.ps1 so that we're always in path
if (!(Test-Path -Path $PROFILE.CurrentUserAllHosts)) {
  New-Item -ItemType File -Path $PROFILE.CurrentUserAllHosts -ErrorAction Ignore -Force
}

$ProfileContent = Get-Content $PROFILE.CurrentUserAllHosts

Write-Host "[-] Adding programs to PATH. This is done through modifying the current user's powershell profile. See https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.3 for more information."

Write-Host ""
# Check if binaries are already on path, nd if not, add them
Write-Host "> Checking if GHDL is in PATH"
if( !(Get-Command ghdl -ErrorAction SilentlyContinue) ) {
	Write-Host " - Could not find GHDL in PATH"
	Write-Host " + Modifying profile to add GHDL to PATH"

	echo "`$env:PATH = `$env:PATH + ';' + '$BIN_OUT\VHDL Tools\GHDL\bin'" | Add-Content $PROFILE.CurrentUserAllHosts -Encoding UTF8
} else {
	Write-Host " + Found GHDL binary in PATH @ $((Get-Command ghdl).Path)"
}

Write-Host "> Checking if just is in PATH"
if( !(Get-Command gtkwave -ErrorAction SilentlyContinue) ) {
	Write-Host " - Could not find just in PATH"
	Write-Host " + Modifying profile to add just to PATH"

	echo "`$env:PATH = `$env:PATH + ';' + '$BIN_OUT\VHDL Tools\just'" | Add-Content $PROFILE.CurrentUserAllHosts -Encoding UTF8
} else {
	Write-Host " + Found just binary in PATH @ $((Get-Command just).Path)"
}

Write-Host "> Checking if GTKWave is in PATH"
if( !(Get-Command gtkwave -ErrorAction SilentlyContinue) ) {
	Write-Host " - Could not find GTKWave in PATH"
	Write-Host " + Modifying profile to add GTKWave to PATH"

	echo "`$env:PATH = `$env:PATH + ';' + '$BIN_OUT\VHDL Tools\gtkwave64\bin'" | Add-Content $PROFILE.CurrentUserAllHosts -Encoding UTF8
} else {
	Write-Host " + Found GTKWave binary in PATH @ $((Get-Command gtkwave).Path)"
}

Write-Host ""
Write-Host "[-] Creating 'new-vhdl-project' alias"

if( !(Get-Command new-vhdl-project -ErrorAction SilentlyContinue) ) {
	echo "
function new-vhdl-project {
	Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/obwan02/VHDL-Tools/main/Justfile' -OutFile Justfile 
}
" | Add-Content $PROFILE.CurrentUserAllHosts -Encoding UTF8

	Write-Host "[+] Created the alias in " + $PROFILE.CurrentUserAllHosts
	Write-Host "[*] Please restart your current shell to allow the 'new-vhdl-project' alias to wor alias to work"
} else {
	Write-Host "[+] Alias already exists"
}

# Load the current profile
& $PROFILE.CurrentUserAllHosts
