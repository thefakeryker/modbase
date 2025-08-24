# modbase
A optimized fork of ioquake3 for creating Quake III Arena mods.
<br /><br />
## What's different?
* All engine code has been removed, it will compile into **Dynamic Link Libraries** or **Quake Virtual Machine** files.
* All utility code such as q3asm, q3cpp, q3lcc, q3rcc has been removed, you will have to supply your own binaries using the `QVM_TOOLS_PATH` option in CMake.
* All third-party libraries have been removed as they are no longer needed
* All code pertaining to Quake III: Team Arena has been removed
* Useless miscellaneous files and other bloat has been removed aswell
<br /><br />
## How to use
* [Clone thefakeryker/modbase.git]([https://github.com/thefakeryker/modbase](https://github.com/thefakeryker/modbase/archive/refs/heads/main.zip)
* Change the *baseq3* game name in `cmake/identity.cmake`, Most q3 engines will refuse to run if you keep it the same.
* Modified the code to your wildiest dreams
* Either use the [optional scripts](https://github.com/thefakeryker/modbase/tree/scripts) or use CMake to compile your project     
Example:       
`cmake -DCMAKE_BUILD_TYPE="Release" -DQVM_TOOLS_PATH="/Users/yourname/Downloads/tools/" -S ../ -B "./build/"`     
`cmake --build "./build"`
* Archive the dll or qvm files into a pk3 file
* Copy that pk3 into a folder in your quake3 directory
* Load the mod
* Profit!
