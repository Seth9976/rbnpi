# Tuning Sonic Pi for best performance

Several of the programs I write for Sonic Pi push it fairly close to the limit when run on a Raspberry Pi. This note gives some tips on to how to maximise the performance on that platform. Of course, if you run Sonic Pi on Mac OSX,or a Windows PC then the performance is much better on these more powerful platforms and some of the issues may not arise.

## Over-clocking your Pi

By increasing the voltage applied to the Pi processor, and running it at a higher clock frequency than normal it is possible to achive significant gains in performance. The down side is that you **may** reduce the lifetime of your Pi. There are five levels that can be configured: None, Modest, Medium, High and Turbo. I routinely run my Raspberry Pis with Medium Overclocking and have noticed no ill effects on any of them.

If you wish to apply some over-clocking you do so by running the program **raspi-config** from the command line. Having logged on, from the command line before you start the graphical user interface, or if you have, then from a terminal window type:
``sudo raspi-config``
A small window will be created with 9 choices. Use the **down arrow** key to select choice 7 Overclock and press the **return key**. Read the warning and press **return** again. Use the **up and down arrow keys** to select the overclock level you want to use, and press **return** again. After a short pause, whist the overclock lvel is set, press **return** again to move back to the initial menu of choices. There press the **tab key** twice to highlight the word **<Finish>** in red, and press the **Return** key again. In order to activate the new overclock setting you have to Reboot your Pi. You can use the tab key again to select whether to do it immediately **<Yes>** or leave it till later **<No>**  Finally press the **Return** key once more to select and activate your choice, and exit the raspi-config program.

## Using Set_Sched_Ahead_Time!

Sonic Pi has a user adjustable feature which can help it cope with severe processing demands, and still play the music generated in perfect time. The help file states: 

"**Using Set_Sched_Ahead_Time**

Specify how many seconds ahead of time the synths should be triggered. This represents the amount of time between pressing 'Run' and hearing audio. A larger time gives the system more room to work with and can reduce performance issues in playing fast sections on slower platforms. However, a larger time also increases latency between modifying code and hearing the result whilst live coding."

A typical command might be:
``set_sched_ahead_time! 4``
At the end of the piece you can reset it with
``set_sched_ahead_time! 1``

 Experiment wiht a piece which is showing a tendency to come adrift by adding a **set_sched_ahead_time!** command and increasing the value bit by bit until it runs smoothly.

One thing to realise about this command is that when you change the **ahead time** the new value remains in force until either you restart Sonic Pi, or you change it for a new value. The default value on a Raspberry Pi is 1. On one or two programs I have written I have had to use values of 8 or 10 or even higher, but usually a more moderate setting of 2  or 4 can improve program performance. The down side is that there is a gap in time when you press run before the program starts playing. For a linear piece this is not too much of a problem, but if you are doing live coding then it means there is quite a slow response when you change the code and re-run before the change takes place.

## Turning off output messages

One of the easiest ways to improve performance is to switch off printed output whilst Sonic Pi is running a program. This can be done in the **Preference Settings** where you can untick the settings **Print output** and **check synth args**.The settings are remembered and restored when you stop and restart Sonic Pi. Alternatively you can insert the code ``use_debug false`` at the beginning of your program. Note if your program includes statements like ``puts "print this string"`` then these will still be printed, as will certain other statements like cues and sample loaded statements, but these should not affect the performance too much.

## Not running other programs at the same time

This is probably fairly obvious. The more your Raspberry Pi has to do, then the fewer resources it can devote to Sonic Pi. If possible quit other programs when using Sonic Pi.

## Avoiding situations that may create problems

This is not always possible but you should be aware that the following will increase the processing load in Sonic Pi.

The more threads you have running simultaneously the greater the loading

Having several different synth voices running at the same time increases loading

Adding effects can incresae loading, especially when these become nested. So for example, applying reverb AND echo together can make things difficult.

Running effects settings INSIDE a loop is more taxing than enclosing the loop inside an effects wrapper. In the former case you are setting up multiple effects processors.

If your program uses many samples consider preloading them before the program starts running in earnest. This can be done using a statement like ``load_samples [:elec_plip, :elec_blip]`` where the samples to be loaded are put into a list. Note however that you may also have to put a sleep statement in after this load statement to make sure the samples have enough time to load. This is more important when you use your own externally added samples as I often do when adding other musical instrument voices to Sonic Pi.

## Symptoms of things going wrong

If notes start falling over one another or a thread stops running or Sonic Pi becomes unresponsive when playing, with the processor load (top right on the screen on the new desktop interface, or a green graph bottom right on the older one) showing 100% or solid green, then Sonic Pi is having problerms in running the code. Another thing to be careful about is that you are allowing notes or samples sufficient time to complete, especially in looped code. For example
``loop do
  play 72,sustain: 5
  sleep 0.1
end``
will run into problems, because the notes are sounding for 5 seconds but you are only allowing 0.1 second between them. After playing for a bit the thread will fall over.

## Recovery when things go wrong

Symptoms of things going wrong are when notes start to run together, or the timing of notes in separate threads that should play together start going wrong. I usually like to stop the program running fairly quickly at this stage, as otherwise all the processing power of the Raspberry Pi is utilised in trying to play your notes and samples and the program can become unresponsive to the stop button being pressed, sometimes taking many seconds to respond. On occasion, I have to quit Sonic Pi to restore things, but usually have to do this from a separate terminal window typing a command like ``sudo killall ruby`` which knocks out the ruby language called by Sonic Pi and causes it to quit. No harm is done, and you can restart Sonic Pi again. If all else fails you might have to pull the power plug from the Raspberry Pi which is a bit drastic, and not to be recommended unless absolutely necessary.

## Final note

You can avoid most of these problems when using Sonic Pi on a Mac or Windows PC. However, you should remember that most users, are likely to be using a Raspberry Pi, and so, if at all possibly you should check programs on the Raspberry Pi before publishing them, and if necessary take steps to make them run OK. Certainly for any published program you should make it clear that it will NOT work satisfactorilly on a Raspberry Pi IF that is the case.

Don't let this article put you off. The majority of programs will run perfectly happily on an unclocked Pi. It is only when you start to use more ambitious programs that you will have to take into consideration the topics raised in this article.

Enjoy your Sonic Pi coding!!!