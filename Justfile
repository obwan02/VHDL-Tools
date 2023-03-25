set windows-shell := ["powershell", "-c"]

GHDL_FLAGS := "-fsynopsys -fexplicit -fcolor-diagnostics"

# This command analyses all files
# in the current directory, and all sub-directories.
# 
# Analysing files checks them for syntax errors,
# and registers the entitys/components/architectures
# that are in the VHDL files.
#
# This command accepts an optional parameter called pattern.
# If a filename matches this pattern in any subdirectory, this
# file will be added to the list of files to analyse
#
# This (kind of) is equivalent to 'compilation', but it isn't really
# 
# TL;DR:
# Analyse/compile selected files
[macos]
analyse PATTERN='**/*.vhdl?':
	@echo "> Analysing VHDL Files..."
	ghdl -a {{GHDL_FLAGS}} {{PATTERN}}

# Analyse/compile selected files
[windows]
analyse NAME_PAT='*.vhd' RECURSE="-r":
	@echo "> Analysing VHDL Files..."
	gci {{RECURSE}} -fi *.jar ghdl -a {{GHDL_FLAGS}} {{PATTERN}}
	
# See the docs for 'anlayse'
[windows]
a NAME_PAT='*.vhd' RECURSE="-r": (analyse NAME_PAT RECURSE)

# See the docs for 'anlayse'
[macos]
a PATTERN="*.vhd": (analyse PATTERN)

# This option should only be used
# if you have a custom install of GHDL that
# uses GCC or LLVM. If you don't know what that
# means, then you probably don't need to run
# this command
# 
# You probably don't need to run this command
_elaborate UNIT: (analyse '*.vhd')
	ghdl -e {{GHDL_FLAGS}} {{UNIT}}

# This command simulates a VHDL design unit,
# and outputs a waveform. It does not precompile
# any code.
#
# TL;DR:
# Simulate the chosen design unit, and output a waveform, wo/ compiling first
_sim UNIT STOP_TIME OUT='sim_wav.ghw':
    ghdl -r {{GHDL_FLAGS}} {{UNIT}}  --stop-time={{STOP_TIME}} --wave={{OUT}}

# Compile all, and simulate a design unit, and output a waveform
sim UNIT STOP_TIME OUT='sim_wav.ghw': (_elaborate UNIT) (_sim UNIT STOP_TIME OUT)

# Synthesises a design. By default generates a graphviz file. See https://ghdl.github.io/ghdl/using/Synthesis.html#cmdoption-ghdl-out for more output options 
synth UNIT FMT="dot":
	ghdl --synth {{GHDL_FLAGS}} --out={{FMT}} {{UNIT}} 


# Opens GTKWave with the default wave file
[windows]
open-gtkwave FILE='sim_wav.ghw':
    gtkwave {{FILE}}

# Opens GTKWave with the default wave file
[macos]
open-gtkwave FILE='sim_wav.ghw':
    open /Applications/gtkwave.app {{FILE}}
