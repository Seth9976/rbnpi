The Sonic Pi file GabrieliSonataXIII-samples-RF.rb requires Sonic Pi version 2.11beta or later to run.
The file is too long to run from one of the built in buffers, and so uses the run_file command added to Sonic Pi 2.11beta
which enables external SP code to be run without limit on size.

A calling program (which IS run from a Sonic Pi buffer) is:
run_file "path/to/file/GabrieliSonataqXIII-RF.rb"

The program also utilises samples from Sonatina Symphonic Orchestra which can be downloaded from
http://sso.mattiaswestlund.net/download.html
The downloaded zip file should be unzipped and placed on the desktop.
The folder should be renamed from Sonatina Symphonic Orchestra to SSO. This keeps path strings shorter, and avoids
problems when running ona a Windows system with SP2.11beta
The library is accessed using the path in line 11 of the program, which should be adjusted if necessary.
IF you don't want to use the sample based version, a version using the built in :tri synth is shown in the third file.
This should again be run using a run_file command in a SP buffer eg run_file "path/to/file/GabrieliSonataXIII-RF.rb"