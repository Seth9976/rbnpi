These files comprise two versions of a midifileplayer for Sonic Pi version 3.0.1 or later. There are two versions.

File SPbasicMidiFilePlayer.rb is the basic version, where the synths used to play each channel in the midifile have to be specified in teh code before running the program in the form of a sonic pi ring. If this contains just a single synth e.g. (ring :saw) then each channel will use this synth. If two synths are specified eg (ring :rri) then midi channel 1 will use :saw, channel 2 :tri and then any further channel will use index into this ring and use in turn :saw, :tri,:saw,:tri This is set in line 38. Also specified at run time in the code is the attenuation level set by the fx :level wrapper in teh variable attenAmp set to 0.5 by default in line 40.

In the second more complicated vbesion, support is provided for an external TouchOSC interface which can be used to specify synth allocation on the fly as the program is running. and also to adjust the attenAmp setting in teh range 0.1 to 1 again as the program is running.

Bot version also requires a template mplayer.touchosc which is created from the file index.xml in this gist post.

Detailed instructions on theeh working of the programs and their installation is included in the associated article which you can read at rbnpi.wordpress.com  This also details suitable ways of streaming the midifiles you wish to play to Sonic Pi.

There is a short video of a slightly earlier version of the program at https://twitter.com/rbnman/status/1221201258780020736 