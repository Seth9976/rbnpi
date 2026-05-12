#Play with a spiral in Minecraft coded by Robin Newman, April 2015
#requires version 2.5 or later (or latest 2.5dev), and Pi2
use_debug false
mc_set_area :air,-127,-20,-127,127,127,127 #clear a large area in the world
mc_set_area :grass,-60,-1,-60,60,0,60 #to stand on
mc_set_area :gold,0,0,0,1,15,1
mc_teleport 30,1,30 #starting position

sleep 6 #wait for this all to complete.

s=0.05 #gap between placing blocks
blist=[:stone,:gold,:iron,:diamond]*2 #list of materials to select from
plist=[8,15,12,20]*2 #list of spiral radii to use
pi=Math::PI #from Ruby Math module
define :cos do |v| #set up call to Math cosine
  return Math.cos(v)
end
define :sin do |v| #set up call to Math sine
  return Math.sin(v)
end
x=[];y=[];z=[];l=[] #initialise coordinate lists for unit radius

180.times do |i| #set up 180 entries equivalent to 4 revolutions
  x << sin(i*2*pi*8/360) #every 8 degrees = 45 blocks per revolution
  y << cos(i*2*pi*8/360)
  z << i.to_f/3 #third of a brick displacement between bricks in z direction
  l << [x[i],y[i],z[i]] #store sets of coordinates in list l
end
puts l #list of coordinates

define :spiral do |xs,ys,zs,p,brick| #parameters xs,ys,zs centre start point,radius, brick material
  in_thread do
    sleep 1.6 #offset to sync bricks and notes
    in_thread do #thread to remove bricks
      sleep 90*s #wait till spiral half built then start
      180.times do |i| #remove bricks (set to air)
        mc_set_block :air,xs+l[i][0]*p,ys+l[i][1]*p,zs+l[i][2]
        sleep s #gap between removals
      end
    end
    180.times do |i| #start building spiral
      mc_set_block brick,xs+l[i][0]*p,ys+l[i][1]*p,zs+l[i][2]
      sleep s #gap between placing bricks
    end
    sleep 90*s #gap before starting another one
  end

  in_thread do #play as spiral is removed
    sleep 90*s #wait until half built
    with_synth :fm do
      180.times do |i| #play every brick removal
        play 40+(179-i).to_f/3,release: s #pitch falls as we progress
        sleep s #gap between notes
      end
    end
  end
  with_synth :tri do
    180.times do |i| #play as spiral is built
      play 40+i.to_f/3,release: s #pitch rises as we progress
      sleep s #gap between notes
    end
  end
  sleep 90*s #gap before starting another one
end

#start doing things here
loop do
  8.times do |i| #do 8 spirals
    mc_teleport 30,1,30 #reset starting position
    play [:c4,:e4,:g4],release: 0.5
    sleep 2
    #parameters: centre cordinates, size, material
    spiral(rrand_i(-10,10),30,rrand_i(-10,10),plist[i],blist[i])
    sleep 2
  end
end