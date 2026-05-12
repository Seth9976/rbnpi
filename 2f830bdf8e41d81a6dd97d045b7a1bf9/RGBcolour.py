from gpiozero import RGBLED
import subprocess,pygame,sys

#initialise items
pygame.init() 
clock = pygame.time.Clock()
ps3 = pygame.joystick.Joystick(0)
ps3.init()
led = RGBLED(red=17, green=18, blue=19)
modeflag=1
changeflag=0

#function to rescale joystick range (used to give 0-255 printed output)
def translate(value,inputMin,inputMax,outputMin,outputMax):
    inputSpan = inputMax-inputMin
    outputSpan=outputMax-outputMin
    valueScaled = float(value-inputMin)/ float(inputSpan)
    return outputMin + (valueScaled * outputSpan)

while True:
    try:
        print("colour wheel")
        pygame.event.pump() #update event queue
        #read left joystick and centre button values
        lud=ps3.get_axis(1) #left up down axis reading ranges -1 to +1
        llr=ps3.get_axis(0) #left left right axis reading ranges -1 to +1
        bflip=ps3.get_button(10) #left joystick button on PS23 controller
        #calcuate rgb values from joystick
        redv=-min(lud,0) #red on 0-&gt; up axis (minus sign makes value increase
        bluev=-min(llr,0) #blue on 0-&gt; left axis (minus sign makes value increase)
        greenv=max(llr,0) #green used on two axes 0-&gt;down and 0-&gt;right
        green2v=max(lud,0)
        if bflip==1 and changeflag==0: #toggle mode from subtractive to additive
            modeflag=modeflag*-1
            changeflag=1 #lock so that one toggle until button released
        if bflip==0: #release the lock when button released
            changeflag=0
        if ((lud &gt; 0) and (llr &gt; 0)): #disregard bottom right segment: set all leds off here
            led.color=(0,0,0)
            print("red:   0")
            print("green: 0")
            print("blue:  0") 
        elif modeflag==1: #additive mode
            led.color=(redv,(green2v+greenv),bluev)
            print("red:   "+str(int(translate(redv,0,1,0,255))))
            print("green: "+str(int(translate(greenv+green2v,0,1,0,255))))
            print("blue:  "+str(int(translate(bluev,0,1,0,255))))
            print("additive mode")
        else: #subtractive mode
            led.color=((1-redv),(1-green2v-greenv),(1-bluev)) #invert all led inputs
            print("red:   "+str(255-int(translate(redv,0,1,0,255))))
            print("green: "+str(255-int(translate(green2v+greenv,0,1,0,255))))
            print("blue:  "+str(255-int(translate(bluev,0,1,0,255))))
            print("subtractive mode")
        print("lud value: "+str(lud)) #print joystick raw values
        print("llr value: "+str(llr))
  int("LLR value: "+str(llr))
        clock.tick(20) #limit loop refresh rate
        subprocess.call("clear") #clear terminal screen before next pass
    except KeyboardInterrupt: #continue until ctrl-C is pressed
        print("\nExiting")
        pygame.quit()
        sys.exit(1) #use to ignore error retrace