# Sonic Pi init file
# Code in here will be evaluated on launch.
system('/home/pi/Desktop/jb.py --ip 172.24.1.89 --tip 172.24.1.127 >/dev/null 2>&1 &')
play 72,sustain: 2