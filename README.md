# VHDL Tools

ModelSim is a terrible piece of software. Luckily, there are
open source alternatives, that are friendlier and better.
This repo combines these open source tools into a open
source build system that is fast, and user-friendly.

The goal for this project is for it to be (in order of
priority):

1. User Friendly
2. Hackable (easy to modify)
3. Portable

To install the build system, head to the installation
section for your OS.

# Table of Contents

1. [How to Use](#how-to-use)
2. [Common Commands](#common-commands)
    - [Advanced Commands](#advanced-commands)
3. [Using GTKWave](#using-gtkwave)
    - [Hot Reloading](#hot-reloading)
4. [Installation (MacOS)](#installation---macos)
5. [Installation (Windows)](#installation---windows)
6. [Modifying/Hacking](#modifyinghacking)
7. [Acknowledgements](#acknowledgements)
8. [Contributing](#contributing)
  

# How to Use

Once you have installed the tools ([macos install](#installation---macos), [windows install](#installation---windows)), 
I would recommend installing the [VHDL LS](https://marketplace.visualstudio.com/items?itemName=hbohlin.vhdl-ls) 
extension for VS Code, if you use VS Code. This extension
provides real-time syntax-error highlighting, along with
other features.

To start using the build system, navigate to the directory
where your vhdl code is stored. Then, crack open a terminal,
(powershell if you are using windows), and type
```sh
new-vhdl-project
```

In your terminal, you can now run `just --list` to see what
build actions are available. For information on what build
actions to use, see the [common commands
section](#common-commands)

### Notes

- When a VHDL project is created, it will consider
all code in all subdirectories to be a part of the current
project.
- Build actions are only available after running
  `new-vhdl-project`
- Build actions are available from the project directory,
  and all subdirectories

# Common Commands

To analyse/compile your vhdl files, run
```sh
just analyse
```

To simulate a design, run the following command, where
`<UNIT>` is the entity/design unit you want to simulate:
```sh
just sim <UNIT> <STOP_TIME>
# EXAMPLE:
just sim test_counter 300ns
```

To list all entities in your design, run:
```sh
just list-entities
```

To open GTKWave, run
```sh
just open-gtkwave
```
For more information on GTKWave, see the [using GTKWave
section](#using-gtkwave)

## Advanced Commands
You can specify which files to analyse when running the
`just analyse` command. For example:
```sh
# Only analyse the test_part1.vhd file
just analyse pattern="test_part1.vhd"
```
To get more information on analysing, [see the GHDL docs](https://ghdl.github.io/ghdl/using/InvokingGHDL.html#analysis-a).


You can change the output of the `just sim` command. By default, the output
file is called `sim_wav.ghw`. To change the name, run
```sh
just sim <MY_UNIT> <MY_TIME> 'whatever_you_want.ghw'
```
To change which file GTKWave opens, run `just open-gtkwave
whatever_you_want.ghw`.

To synthesize a design, run
```sh
just synth <UNIT> [FMT]
```
This will try to synthesize the specified design unit. This
command is only really useful for testing if a design is
synthesizable. NOTE: This operation is still experimental 
in GHDL (the underlying compiler/simulator). The `FMT`
paramter can be used to specify what type of file should be
output. [See the GHDL docs for more info](https://ghdl.github.io/ghdl/using/Simulation.html)

# Using GTKWave

GTKWave is similar to the simulation tools provided by
ModelSim, expect better.

To open GTKWave, run `just open-gtkwave`. Note that you
should run a simulation before opening GTKWave.

The rest of the application should is fairly similar to
ModelSim, and is fairly intuitive.

## 'Hot' Reloading

One of the most aluring features of GTKWave is the ability
to 'hot' reload simulated waves. This means that you can
have a waveform open in GTKWave, re-run a simulation, and
'hot'-reload the waveform, without losing your position,
signals, or signals formats.

To 'hot' reload, first, ensure that you have run a
simulation and keep GTKWave open. Next, change your code to
your hearts desire, and re-run your simulation. Then, switch
back to GTKWave, and click `File > Reload Waveform`.

# Installation - MacOS

You can either install the requirements manually, or
automatically. Internally, this script just runs homebrew,
so if you have any experience using homebrew, please
consider manual installation.

Note that when your run `just`/`ghdl` after first installation, you
may have to allow it to run from your security preferences.
To do this, go to `Apple Logo > System Settings > Privacy
& Security`. Then find the message that says `Program ...
has been blocked`, and click `Allow anyway`. This process
might have to be repeated for llvm.

## Automatic 

To install the requirements for this project, run
```sh
curl --proto '=https' --tlsv1.2 -sSLf https://raw.githubusercontent.com/obwan02/VHDL-Tools/main/install_tools_macos.sh | bash
```

## Manual


### Intel (x86_64)

First, make sure you have [homebrew installed](https://brew.sh).

Then, installed the required packages
```sh
brew update
brew install just ghdl gtkwave
```

Then, you need to create your own `new-vhdl-project` alias.
See the `install_tools_macos.sh` script for inspiration.

### M1/M2 (arm64)

First, make sure you have [homebrew installed](https://brew.sh).

Then, install the required packages
```sh
brew update
brew install just ghdl gtkwave
```

However, you also need to install llvm. Unfortunately,
because the `ghdl` in homebrew is an x86_64 binary, you need
to install the x86_64 version of llvm. To do this, you first
need to install Rosetta:
```sh
/usr/sbin/softwareupdate --install-rosetta
```

Then, install the x86_64 version of homebrew:
```sh
arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
```

Then, figure out which version of llvm you should install.
To do this, run `ghdl -v`, and there should be a line in the
output of that command that says `llvm XX.XX.XX code
generator`. The version of llvm you want to install
corresponds to the major version of llvm that ghdl expects.
For example, if I had the output `llvm 14.0.2 code
generator`, I would install llvm 14.

To install your desired llvm version, run
```sh
arch -x86_64  /usr/local/bin/brew install llvm@<VERSION>
```

So, for example if I was installing llvm 15, I would run:
```sh
arch -x86_64  /usr/local/bin/brew install llvm@15
```

Finally, you need to make sure that `ghdl` can pick up
your llvm library. To do this create a symlink from
`/usr/local/opt/llvm@<VERSION>` to `/usr/local/opt/llvm`

For example, if I installed llvm 15:
```sh
ln -s /usr/local/opt/llvm@15 /usr/local/opt/llvm
```

Then, you need to create your own `new-vhdl-project` alias.
See the `install_tools_macos.sh` script for inspiration.

# Installation - Windows

If you have Powershell Core, and Powershell 5.1, installed,
make sure that you run the install script in the version of
Powershell that you want the tools to be available on. If
you want the tools to be available in both versions, run the
install script in both versions.

Note that installation on University computers isn't
advised. This is mainly because powershell profiles are
stored in OneDrive, which means that you cannot have a
profile per university machine. 

## Automatic

From inside powershell, run:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/obwan02/VHDL-Tools/main/install_tools_win.ps1'))
```

## Manual

If you reaalllllllllly want to manually install your
software, these are the instructions:

First, download the archives for the programs:
- [GHDL](https://github.com/ghdl/ghdl/releases/download/v3.0.0/ghdl-UCRT64.zip)
- [just](https://github.com/casey/just/releases/download/1.13.0/just-1.13.0-x86_64-pc-windows-msvc.zip)
- [GTKWave](https://sourceforge.net/projects/gtkwave/files/gtkwave-3.3.100-bin-win64/gtkwave-3.3.100-bin-win64.zip/download)

Then extract these files to your desired installation
location. If you are installing these programs on the
university computers, I'd recommend extracing to a location
accessible from all computers.

If you are running on a home computer, I'd recommend
simply modify your `PATH` environment variable so that they
include your newly acquired binaries.

Additionally, if you run a manual installation, you will
have to create your own `new-vhdl-project` alias in your
powershell profile.

## Windows Specific Notes 

The installation script modifies you powershell profile to
make the installed tools available everywhere. As such, you
will only be able to access the tools from powershell.

# Modifying / Hacking

After you install the tools, the only thing that is needed
to make the project build is the `Justfile`. This file is
similar to `make`s `Makefile` (`make` is a linux build
tool). The `Justfile` specifies what commands should be run
when you type `just <COMMAND>`. When you type a command,
`just` will search through the `Justfile` for that command,
and will run it. See the [just docs](https://just.systems/man/en/chapter_1.html)
for more information.

N.B. The `new-vhdl-project` command, simply downloads the
lastest `Justfile` from github. 

Hopefully, by using a `Justfile`, this project can easily be
modified/hacked. To get started, you can either read the
[just docs](https://just.systems/man/en/chapter_1.html), or
if you are feeling adventurous, you can just hop in and
start messing around the `Justfile`.

Some ideas for modifications:
- A `just format` command, that formats all your files using
  `ghdl`.

- If you require custom libraries, you could add them to the
  build flags at the top of the `Justfile`.

- By default, `ghdl` targets the VHDL-1993 standard.
  However, it also has partial support for the VHDL-2008
  standard. N.B. Quartus doesn't support VHDL-2008 code, but
  you could enable VHDL-2008 code in just the test benches.

- Create separate commands for building test
  benches and building entities.

- Use `ghdl`s pretty-printy HTML feature to automatically
  create HTML files that containa syntax-highlighted VHDL
  code.

- Create a strict-compile mode, where the `-fsynopsys` and
  `-fexplicit` flags aren't passed to `ghdl`. The
  `-fsyopsys` flag enables the non-standard (and not
  recommended) `std_logic_unsigned` library, and the
  `-fexplicit` flag tells `ghdl` to choose the most
  applicable overloaded function/operator (which is also not
  recommened, as it breaks encapsulation)

# Acknowledgements

Behind the scenes this repo relies on amazing OSS
projects. These projects are:

- [GHDL: a VHDL 2008/93/87 simulator](https://github.com/ghdl/ghdl)
- [just: Just a command runner](https://just.systems)
- [GTKWave](https://gtkwave.sourceforge.net/)

# Contributing

If you have any feature requests or 🐛s (bugs), please open an
issue in the issues tab on GitHub. 

If you want to contribute any code, feel free to create a
PR (although try to submit a PR that fixes a particular open
issue :) ).

