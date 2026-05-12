#This uses SP2.11 to play the theme and one variation from the film The Go Between (1971)
#original music my Michel Legrand. This version was transcribed by ear from
#two youtube recordings by Jerome Allain who produced piano transcriptions.
# enteredthe notes into MuseScore with copious use of the program Audacity to
#slow down and loop various sections so that I could discern the notes in the
#different parts. From MuseScore the parts were exported to MusicXML files and
#were then passed through a script running under the application "processing"
#which converted them into Sonic Pi notation. I experimented with sounding the
#parts with the built in piano synth in Sonic Pi, but unfortunately it is not good
#at sustaining notes to the extend required, so I decided to use code I had
#already written which utilises the Grand Piano samples in the Sonatina
#Symphonic Orchestra. I also experimented with the gverb effect in Sonic Pi which
#enables a larger effect than the reverb fx, althouhg it reequires some
#tweaking to get the sound I wanted. The overall effect of the driving left
#hand rhythm with the running right hand notes illustrates well the little boy
#Leo who ran as a Go Between between the two lovers, whio came from very different
#social classes, and whose affair was doomed to a cataclysmic end from the outset.
#I hope you enjoy listening as much as I enjoyed putting this together.
#If you haven't seen the film then I can thoroughy recommend it!

run_file "~/Documents/SpfromXML/GoBetween-samples-RF.rb" #play main theme. Alter path to suit where your file is
sync :variation
run_file "~/Documents/SpfromXML/GoBetweenVariation-samples-RF.rb" #play the variation. Alter path to suit where your file is

