# modbase
A optimized fork of ioquake3 for creating Quake III Arena mods.
<br /><br />
## What's different?
* All engine code has been removed, it will build into **Dynamic Link Libraries** or **Quake Virtual Machine** files.
* All utility code such as q3asm, q3cpp, q3lcc, q3rcc has been removed, you will have to supply your own [binaries](https://github.com/thefakeryker/qvm_tools/releases/) using the `QVM_TOOLS_PATH` option in CMake.
* All third-party libraries have been removed as they are no longer needed.
* All code pertaining to Quake III: Team Arena has been removed.
* Useless miscellaneous files and other bloat has been removed aswell.
<br /><br />
## Building
* [Clone thefakeryker/modbase.git](https://github.com/thefakeryker/modbase/archive/refs/heads/main.zip).
* Modified the code to your wildiest dreams.
* Use the commands displayed below to bulld your project:   
`cmake -DCMAKE_BUILD_TYPE="Release" -S ./ -B "./build/"`     
`cmake --build "./build"`
* Archive the output files into a PK3.
* Copy that PK3 into a subdirectory in your Quake III Arena environment. Do not paste it into the *baseq3* folder as it may not work.
* Load the mod.
* Profit!
