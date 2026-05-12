run_file "/home/pi/Documents/SPfromXML/BachFugueInGminorArrLisztBWV542-RF.rb"
live_audio :qsynth,stereo: true,amp: 3
#used to run the fugue on a Raspberry Pi. Adjust path to suit
#line 2 feeds audio back for qsynth into sonic pi
#used when playing via midi
#I used qjackctl to set up midi path to qsynth
#and to feed qaynth audio back to Sonic Pi (connection window audio and alsa tabs)