The accompanying two files play a visual display in VisorLive driven by Sonic Pi.
The VisorMusicBoxFinal.rb file is loaded as a project file into visor version 0.4.0  www.visor.live
A midi connection is established between the two (I used the iac driver on a Mac). The mapping file used
was LaunchControlXL.json (supplied in the midi folder with visor.live)
The sound output of Sonic Pi is linked to the input of visor.live I normally use Rogue Amoeba's LoopBack utility, but it I have also tested the project using the free soundflower utility. NB if you do use this you must disable loopback if you have that installed as well.

https://github.com/mattingalls/Soundflower/releases/tag/2.0b2
1.Install Soundflower.

2.Go to Audio MIDI Setup

3.Click the '+' sign at the bottom left of the window and select 'Create Multi-Output Device'(Aggregate is just the same,but I'm using Multi-Output)

4.Check the boxes at the 'Use' column next to Built-In Output and Soundflower 2ch(64ch is not recommended).Also tick the box in the 'Drift Correction' column for Built-In Output.

5.Adjust your volume before switching(I'll tell you why in the next step)

6.Go to System Preferences->Sound->Output and choose your Multi-Output device(or whatever you named it).BEWARE that this option will make your volume unadjustable.

7.select soundflower (2ch) as your sound input device in Visor

8. You will hear the sound also in your local speakers/headphones.
A video of the project is on youtube/rbn1tube https://youtu.be/TB1_i39c4XY