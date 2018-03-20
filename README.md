# darkDynlib
Delphi platform-agnostic wrapper classes around OS dynamic library loading functions.
This liobrary has been extracted from the darkGlass project at https://github.com/chapmanworld/DarkGlass as a sub-module which can be used independently. 

# Usage Instructions

1) Clone the repository.
2) Open and build the pkgDarkDynlib file (.dpk/.lpk depending on compiler)
3) Add /out/lib/$(Platform)/$(Target) to your project path (adjust for compiler as required).
4) Read the help file.

# Additional build instructions

This library does not depend on any of the other darkGlass libraries, however, the unit test application does depend on darkTest which can be found here https://github.com/chapmanworld/darkTest. In orer to build the unit test project, you must clone both darkTest and darkDynlib into the same parent directory or otherwise adjust the search paths accordingly.
I.E.

    packages/darkTest
    packages/darkDynLib
    
The packages for darkTest and darkDynlib must be built for the desired target first, before building the unit test application.
Note, currently the unit tests compiled using Delphi will only compile for Windows.
