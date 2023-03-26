#!/bin/bash

# If we are on M1
if [[ $(uname -m) == 'arm64' ]]; then


else
	# If we are on an Intel MacOS
	
fi

echo [?] Searching for homebrew installation ...
if ! (command -v brew) then
	echo [x] Could not find homebrew
	echo [+] Installing homebrew:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
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
fi

echo ""
echo [-] Installing GHDL, just and GTKWave ...
brew install just ghdl gtkwave && echo [+] Installed! || echo [x] Failed install

