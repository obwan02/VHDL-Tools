set windows-shell := ["powershell", "-c"]

GHDL_FLAGS := "-fsynopsys -fexplicit -fcolor-diagnostics"
DEFAULT_OUT := "sim_wav.ghw"

# See the docs for 'anlayse'
a pattern="*.vhd": (analyse pattern)

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
# Compile selected files
analyse pattern='*.vhd':
	@echo "> Analysing VHDL Files..."
	FILES=$(/usr/bin/find . -name "{{pattern}}") && ghdl -a {{GHDL_FLAGS}} $FILES

# See the help for 'elaborate'
e unit: (elaborate unit)
	
# This option should only be used
# if you have a custom install of GHDL that
# uses GCC or LLVM. If you don't know what that
# means, then you probably don't need to run
# this command
# 
# You probably don't need to run this command
elaborate unit: (analyse '*.vhd')
	ghdl -e {{GHDL_FLAGS}} {{unit}}

# This command simulates a VHDL design unit,
# and outputs a waveform. It does not precompile
# any code.
#
# TL;DR:
# Simulate the chosen design unit, and output a waveform, wo/ compiling first
raw-sim unit stop_time wave_out=DEFAULT_OUT:
    ghdl -r {{GHDL_FLAGS}} {{unit}}  --stop-time={{stop_time}} --wave={{wave_out}}

# Simulate a design unit, and output a waveform
sim unit stop_time wave_out=DEFAULT_OUT: (elaborate unit) (raw-sim unit stop_time wave_out)

# Synthesises a design. By default generates a graphviz file. See https://ghdl.github.io/ghdl/using/Synthesis.html#cmdoption-ghdl-out for more output options 
synth unit out="dot":
	ghdl --synth {{GHDL_FLAGS}} --out={{out}} {{unit}} 


# Opens GTKWave with the default wave file
[windows]
open-gtkwave wave_file=DEFAULT_OUT:
    gtkwave {{wave_file}}

# Opens GTKWave with the default wave file
[macos]
open-gtkwave wave_file=DEFAULT_OUT:
    open /Applications/gtkwave.app {{wave_file}}
