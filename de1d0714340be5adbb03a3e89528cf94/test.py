#Script to check the correct operation of the three leds and single pushbutton
#used in the demonstration of controlling Sonic Pi from the GPIO and vice versa
#You are strongly advised to use this before trying to use the SPoschandler.py script

from gpiozero import LED,Button
from time import sleep
from signal import pause
r=LED(20) #amend if you use leds connected to different GPIO pins
w=LED(17)
b=LED(14)
button=Button(24) #amend if using a differnt pin for input.

r.on()
b.on()
w.on()
sleep(2)
r.off()
b.off()
w.off()

button.when_pressed= b.on
button.when_released= b.off

pause()
