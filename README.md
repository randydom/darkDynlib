# darkDynlib
A platform-agnostic wrapper class around OS dynamic library loading functions.
This library has been extracted from the darkGlass project at https://github.com/chapmanworld/DarkGlass as a sub-module which can be used independently. 

# Usage Instructions

1) Clone the repository.
2) Open and build the pkgDarkDynlib file (.dpk/.lpk depending on compiler)
3) Add /out/lib/$(Platform)/$(Target) to your project path (adjust for compiler as required).
4) Read the help file.

# Additional build instructions

The packages for darkTest and darkDynlib must be built for the desired target first, before building the unit test application.
Note, currently the unit tests are for windows only - Pending update.
