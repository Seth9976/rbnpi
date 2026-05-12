#Sonic Pi GPIO control on steroids
#by Robin Newman, 28th March 2020
use_osc "localhost",8000
use_synth :tb303
nlist=[:c4,:d4,:e4,:f4,:g4]
nkeylist=[:n0,:n1,:n2,:n3,:n4]
del = 0.15
define :pl do |n,state|
  if state==1
    set nkeylist[n], (play nlist[n],sustain: 1)
  else
    k=get(nkeylist[n])
    control k,amp: 0,amp_slide: 0.01
    sleep 0.01
    kill k
  end
end

define :allOff do
  5.times do |i|
    osc "/ledNum",i,0
    pl i,0
  end
end
define :allOn do
  5.times do |i|
    osc "/ledNum",i,1
    pl i,1
  end
end


define :linear do
  5.times do |i|
    osc "/ledNum",i,1
    pl i,1
    sleep del
  end
  5.times do |i|
    osc "/ledNum",i,0
    pl i,0
    sleep del
  end
end
define :nightRider do
  setState "01010"
  sleep del
  setState "10101"
  sleep del
end

define :thereAndBack do
  5.times do |i|
    osc "/ledNum",i,1
    pl i,1
    sleep del
  end
  5.times do |i|
    osc "/ledNum",4-i,0
    pl i,0
    sleep del
  end
end
define :setState do |l|
  5.times do |i|
    osc "/ledNum",i,l[i].to_i
    pl i,l[i].to_i
  end
end

define :squash do
  setState "10001"
  sleep del
  setState "01010"
  sleep del
  setState "00100"
  sleep del
  setState "01010"
  sleep del
  setState "10001"
  sleep del
end
sleep 1
2.times do
  linear
end
4.times do
  nightRider
end
allOff
2.times do
  thereAndBack
end
8.times do
  squash
end
allOff
2.times do
  linear
end

6.times do
  allOn
  sleep del
  allOff
  sleep del
end
setState "10101"
sleep 16*del
allOff
