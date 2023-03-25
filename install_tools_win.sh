#!/bin/bash

# Check if GHDL already exists


echo [-] Downloading GHDL, just and GTKWave ...
GHDL_TEMP=$(mktemp)
JUST_TEMP=$(mktemp)
GTKWAVE_TEMP=$(mktemp)
curl -#L "https://github.com/ghdl/ghdl/releases/download/v3.0.0/ghdl-UCRT64.zip" -o $GHDL_TEMP
ghdl_ok=$?
[ $ghdl_ok -eq 0 ] && echo [+] Downloaded GHDL || echo [x] Failed to download GHDL
curl -#L "https://github.com/casey/just/releases/download/1.13.0/just-1.13.0-x86_64-pc-windows-msvc.zip" -o $JUST_TEMP 
just_ok=$?
[ $just_ok -eq 0 ] && echo [+] Downloaded just || echo [x] Failed to download just
curl -#L "https://sourceforge.net/projects/gtkwave/files/gtkwave-3.3.100-bin-win64/gtkwave-3.3.100-bin-win64.zip/download" -o $GTKWAVE_TEMP
gtkwave_ok=$?
[ $gktwave_ok -eq 0 ] && echo [+] Downloaded GTKWave || echo [x] Failed to download GTKWave

if [ $ghdl_ok -ne 0 ] || [ $just_ok -ne 0 ] || [ $gtkwave_ok -ne 0 ]
then
    echo "[x] Failed one or more downloads. exiting ..."
    exit 1
fi

echo [+] Downloads were successful
# new line
echo ""

echo [-] Unzipping downloaded archives
mkdir -p "$LOCALAPPDATA\\Programs\\just"
unzip -oq $GHDL_TEMP -d "$LOCALAPPDATA\\Programs" 
ghdl_ok=$?
[ $ghdl_ok -eq 0 ] && echo [+] Unzipped GHDL || echo [x] Failed to unzip GHDL
unzip -oq $JUST_TEMP -d "$LOCALAPPDATA\\Programs\\just" just.exe
just_ok=$?
[ $just_ok -eq 0 ] && echo [+] Unzipped just || echo [x] Failed to unzip just
unzip -oq $GTKWAVE_TEMP -d "$LOCALAPPDATA\\Programs"
gtkwave_ok=$?
[ $gtkwave_ok -eq 0 ] && echo [+] Unzipped GTKWave || echo [x] Failed to unzip GTKWave

if [ $ghdl_ok -ne 0 ] || [ $just_ok -ne 0 ] || [ $gtkwave_ok -ne 0 ]
then
    echo "[x] Failed to extract one or more archives. exiting ..."
    exit 1
fi

echo [+] Unzipping was successful
# new line 
echo ""

CURRENT_PATH=$(powershell -Command "[Environment]::GetEnvironmentVariable('PATH')")

function add_to_path () {
	echo  "> Checking if $1 is in PATH"
	if ! (command -v $1 &> /dev/null)
	then
		echo " - Couldn't find $1 in PATH. Adding $1 to PATH"
		CURRENT_PATH="$CURRENT_PATH;$(powershell -Command '[Environment]::GetEnvironmentVariable("LOCALAPPDATA")')$2"
		echo " - Preparing to add $1 to PATH"
	else
		echo " + Found ghdl at $(command -v $1)"
	fi
}

echo "[?] Checking PATH ..."
add_to_path ghdl "\\Programs\\GHDL\\bin"
add_to_path just "\\Programs\\just"
add_to_path gtkwave "\\Programs\\gtkwave64\\bin"
powershell -Command "[Environment]::SetEnvironmentVariable('PATH', '$CURRENT_PATH', [EnvironmentVariableTarget]::User)"
# new line
echo ""
echo "[+] GHDL and just have been added to your PATH. To reload your PATH (and to access the tools), you need to restart your shell."

read -p "[?] Waiting for user input before exiting ..."
