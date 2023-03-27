#!/bin/bash



echo [?] Searching for homebrew installation ...
if ! (command -v brew) then
	echo [-] Could not find homebrew
	echo [-] Installing homebrew:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" 
	if [ $? -ne 0]; then
		echo [x] Failed to install homebrew. exiting ...
	fi
	echo [+] Installed homebrew

	case "${SHELL}" in
  */bash*)
    if [[ -r "${HOME}/.bash_profile" ]]
    then
      shell_profile="${HOME}/.bash_profile"
    else
      shell_profile="${HOME}/.profile"
    fi
    ;;
  */zsh*)
    shell_profile="${HOME}/.zprofile"
    ;;
  *)
    shell_profile="${HOME}/.profile"
    ;;

esac
	source $shell_profile
else
	echo [+] Found homebrew installation
fi

echo ""
echo [-] Installing ghdl
brew install ghdl
if [ $? -ne 0 ]; then
	echo [x] Failed native installation of ghdl. exiting ...
	exit
fi
echo [+] Installed ghdl
echo ""

# If we are on M1, install x86_64 version of homebrew
# so that we can install libLLVM
extra_packages=""
if [[ $(uname -m) == 'arm64' ]]; then

	echo [?] Checking for Rosetta installation
	if ! (command -v arch) then
		echo [-] Could not find Rosetta
		echo [-] Installing Rosetta
		/usr/sbin/softwareupdate --install-rosetta
		echo [+] Installed Rosetta
	else
		echo [+] Found Rosetta
	fi

	echo [+] Aquiring sudo access for x86_64 brew installation
	# Aquire sudo for brew installation
	sudo -A echo ""

	echo [?] Checking for x86_64 homebrew installation
	if ! [ -f '/usr/local/bin/brew' ]; then
		echo [-] Could not find x86_64 homebrew installation
		echo [-] Installing x86_64 homebrew
		arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
		if [ $? -ne 0 ]; then
			echo [x] Failed x86_64 homebrew installation. exiting ...
			exit
		fi
		echo [+] Installed x86_64 homebrew
	else
		echo [+] Found x86_64 homebrew
	fi

	# The best, and most obvious way to extract the version of 
	# llvm required, is to simply run `ghdl -v` and grep the version
	# out.
	#
	# However, because we've potentially just installed GHDL,
	# we might not be able to run it (immediately) due to MacOS security
	# privileges. This means the installation would have to be
	# run twice - with the user allowing ghdl to run inbetween.
	#
	# So instead we can just be a little sneaky and extract the
	# version string from the binary file itself with a little magic

	# Use `strings` to extract readable text from binary, and grab the LLVM
	# version string (which is luckily just sitting in plaintext)
	llvm_version=$(strings /opt/homebrew/bin/ghdl | sed -nE "s/llvm ([0-9]+)\.[0-9]+\.[0-9]+.*/\1/p")


	echo [-] Installing llvm@$llvm_version
	arch -x86_64 /usr/local/bin/brew install llvm@$llvm_version
	if [ $? -ne 0 ]; then
		echo [x] Failed x86_64 homebrew installation of llvm. exiting ...
		exit
	fi
	echo [+] Installed llvm@$llvm_version

	ln -s /usr/local/opt/llvm@$llvm_version /usr/local/opt/llvm

fi

# If we are on an Intel MacOS, we can ignore 
# llvm, as the homebrew package for ghdl doesn't require it.

echo ""
echo [-] Installing GHDL, just and GTKWave ...
brew install just ghdl gtkwave && echo [+] Installed! || echo [x] Failed install of homebrew packages

