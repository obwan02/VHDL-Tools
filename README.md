# VHDL Tools

ModelSim is a terrible piece of software. Luckily, there are
open source alternatives, that are friendlier and better.

This repo combines those open source programs into a
(hopefully) friendly build system. The goal of this project
is to make writing, compiling, and simulating VHDL fun!

# How it Works / How to Use

Once you have [installed the requirements](#installation),
copy the `Justfile` to a project folder. For example, if I
had a project @ `Documents/Lab1`, I would copy the `Justfile`
to `Documents/Lab1/Justfile`.

This should be done for each new project/folder that you
make. For example if I had a new project @ `Documents/Lab2`,
I would repeat the same process as descibed above.

Now, open a terminal in that directory, and run `just
--list` to see what command are available.

# VS Code

Visual Studio Code has a great language server extension
for VHDL that gives you syntax highlighting, realtime
errors, and more. 

[Check it out here](https://marketplace.visualstudio.com/items?itemName=hbohlin.vhdl-ls)

# Common Commands

To analyse/compile your vhdl files, run
```sh
just analyse
```

To simulate a design, run
```sh
just sim <UNIT> <STOP_TIME>
```
For example,
```sh
just sim test_counter 300ns
```

To open GTKWave, run
```sh
just open-gtkwave
```

# Advanced Commands
You can specify which files to analyse when running the
`just_analyse` command. For example:
```sh
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

# Installation

## MacOS

You can either install the requirements manually, or
automatically. Internally, this script just runs homebrew,
so if you have any experience using homebrew, please
consider manual installation.

### Automatic 

To install the requirements for this project, run
```sh
curl --proto '=https' --tlsv1.2 -sSLf https://raw.githubusercontent.com/obwan02/VHDL-Tools/main/install_tools_macos.sh | bash
```

### Manual

First, make sure you have [homebrew installed](brew.sh).

Then, installed the required packages.
```sh
brew update
brew install just ghdl gtkwave
```
## Windows

Unless you're a Windows Powershell/CMD professional, there
is no manual installation.

### Automatic

From inside powershell, run:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/obwan02/VHDL-Tools/main/install_tools_win.ps1'))
```
# Windows Specific Notes 

The installation script modifies you powershell profile to
make the installed tools available everywhere. As such, you
will only be able to access the tools from powershell.

# Acknowledgements

Behind the scenes this repo relies on amazing OSS
projects. These projects are:

- [GHDL: a VHDL 2008/93/87 simulator](https://github.com/ghdl/ghdl)
- [just: Just a command runner](just.systems)
- [GTKWave](https://gtkwave.sourceforge.net/)
