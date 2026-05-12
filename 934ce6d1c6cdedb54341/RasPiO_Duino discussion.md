# Two further files to try with the RasPiO_Duino Board

##The First Program
Having successfully built my RasPiO_Duino Board, I have been playing with it over the past two days. It is a great board to use, although unfortunately I appear to have had an accident, as one of the pins (11) is not working properly, although it did to start with. This has meant that I have had to modify one or two of the programs to utilise other pins. One program I have concentrated on is the program BlinkPWM_flip_flop_RGB. As written this uses a loop to set up pins 9,10 and 11 as PWM output pins. In order to move pin 11 to pin 5 (one of the other spare PWM pins) I used an array to hold the pin numbers. To do this I declared an array just after the time_delay=2; line giving:
```
int rgbPins[] = {5,9,10};
```
This declares the array and populates the first three elements with 5,9 and 10 the pins I want to use.
Next in the setup function I modify the for loop that traverses the three pins replacing
```
for(int rgbPin = 9; rgbPin < 12; rgbPin++){
  pinMode(rgbPin, OUTPUT);
}
```
with
```
for(int k = 0; k < 3; k++){
  pinMode(rgbPins[k], OUTPUT);
}
```
This sets up the pins 5,9 and 10 for output, reading the pin numbers from the array as its three elements are traversed: (note they number from 0).

In a similar fashion, in the main loop function the for loops are modified to use the array values rather than the sequential values 9,10,11 so
```
for(int rgbPin = 9; rgbPin < 12; rgbPin++){
```
is replaced by
```
  for (int k = 0; k < 3; k++) {
```
and references to 
```
analogWrite(rgbPin, brightness)
```
are replaced with
```
analogWrite(rgbPins[k], brightness)
```
##The second program
Although the first program is impressive, it seemed to me to give a rather abrupt fade for the leds. There was a quick change in brightness at low levels, but thereafter there wasn't much perceived change as the loop continued. I Googled this and sure enough found that it was the subject of much discussion. It turns out that the perceived light output of a led does not vary in a linear manner as the PWM level changes. There was a wide range of discussion on the subject, some of it highly technical. Having done one or two experiments myself, I eventually decided to follow an article by a web developer called Diarmuid, who discussed the subject in his blog. The link to this is at http://diarmuid.ie/blog/pwm-exponential-led-fading-on-arduino-or-other-platforms

I looked at his code and incorporated it in the listing for the second program above. Rather than repeat the description here, I refer you to his article for more detail. The end result is a much smoother variation, where you can continuously see the brightness.
 changing.

It has been fun to work on these two programs, The first modification was of necessity. Of course, you should be able to use the guts of the second program with the original pin settings assuming your board is intact :-) but I leave it as an excercise for you to work out the changes necessary to go back again. Now I must see if I can buy a replacement chip from Alex...
