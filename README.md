# VHDL Tools

ModelSim is a terrible piece of software. Luckily, there are
open source alternatives, that are friendlier and better.

This repo combines those open source programs into a
(hopefully) friendly build system. The goal of this project
is to make writing, compiling, and simulating VHDL fun!

To start using these tools, head to the [installation
section](#installation)

# How it Works / How to Use

Once you have [installed the requirements](#installation),
I'd also recommend installing the [VHDL LS](https://marketplace.visualstudio.com/items?itemName=hbohlin.vhdl-ls) 
extension for VS Code, if you use VS Code.

Now, download the `Justfile` from this repository. You can do this by
clicking on the file in this repository, and then clicking the download button.

To use the tools in a project, copy the `Justfile` into 
your project folder. For example, if I had a project
at `Documents/Lab1`, I would copy the `Justfile` to
`Documents/Lab1/Justfile`.

This should be done for each new project/folder that you
make. For example if I had a new project @ `Documents/Lab2`,
I would repeat the same process as descibed above.

Now, open a terminal in that directory, and run `just
--list` to see what commands are available.

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

To open GTKWave, run
```sh
just open-gtkwave
```

You can keep GTKWave open over multiple simulations. Once
you re-run a simulation, click `File > Reload Waveform`, to
reload the new simulation output wave.

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

Note that when your run `just`/`ghdl` after first installation, you
may have to allow it to run from your security preferences.
To do this, go to `Apple Logo > System Settings > Privacy
& Security`. Then find the message that says `Program ...
has been blocked`, and click `Allow anyway`. This process
might have to be repeated for llvm.

### Automatic 

To install the requirements for this project, run
```sh
curl --proto '=https' --tlsv1.2 -sSLf https://raw.githubusercontent.com/obwan02/VHDL-Tools/main/install_tools_macos.sh | bash
```

### Manual


#### Intel (x86_64)

First, make sure you have [homebrew installed](brew.sh).

Then, installed the required packages
```sh
brew update
brew install just ghdl gtkwave
```

#### M1/M2 (arm64)

First, make sure you have [homebrew installed](brew.sh).

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

Then, you're done :))

## Windows

Unless you're spectactular at Powershell (or just really
masochistic), there is no manual installation.

### Automatic

From inside powershell, run:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/obwan02/VHDL-Tools/main/install_tools_win.ps1'))
```

### Manual

Ok if you reaalllllllllly want to manually install your
software, these are the instructions:

First, download the archives for the programs:
- [GHDL](https://github.com/ghdl/ghdl/releases/download/v3.0.0/ghdl-UCRT64.zip)
- [just](https://github.com/casey/just/releases/download/1.13.0/just-1.13.0-x86_64-pc-windows-msvc.zip)
- [GTKWave](https://sourceforge.net/projects/gtkwave/files/gtkwave-3.3.100-bin-win64/gtkwave-3.3.100-bin-win64.zip/download)

Then extract these files to your desired installation
location. If you are installing these programs on the
university computers, I'd recommend extracing to a location
accessible from all computers.

Now, if you are running on a home computer, I'd recommend
simply modify your `PATH` environment variable so that they
include your newly acquired binaries.

If you are running on a university computer, modifying the
`PATH` is a bit harder. I'd instead recommend modifying your
`profile.ps1` script (see https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.3)

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
