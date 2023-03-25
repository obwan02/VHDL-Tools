#!/bin/bash

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
echo [-] Installing just ...
brew install just
echo [+] Installed!

echo ""
echo [-] Installing GHDL ...
brew install ghdl
echo [+] Installed!

echo ""
echo [-] Installing GTKWave ...
brew install gtkwave
echo [+] Installed!

