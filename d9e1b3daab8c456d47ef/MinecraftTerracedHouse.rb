#Sonic Pi and Minecraft. Program to draw terraced houses
#Coded by Robin Newman, April 2015 Requires 2.5dev or later

#individual house has pebblestone walls, stone_slab roof, sandstone floor
#and wood_plank ceiling. It has one window and one door.

#The terrace function links several houses together.

define :house do |x,y,z,size,w| #draw 4 blocks in front of x,y,z positon
  #size is size of house cube (should be even number)
  #w is window size, usually 1 (or 2 for larger houses)
  mc_set_area :cobblestone,x-size/2,y,z+2,x+size/2,y+size,z+size+2
  #hollow out
  mc_set_area :air, x-size/2+1,y,z+3,x+size/2-1,y+size-1,z+1+size
  #window
  mc_set_area :glass, x-w,y+size/2-w+(size-2*w)/3,z+2,x+w,y+size/2+w+(size-2*w)/3,z+2
  #roof
  mc_set_area :stone_slab,x-size/2,y+size+1,z+2,x+size/2,y+size+1,z+2+size
  #floor
  mc_set_area :wood_plank, x-size/2+1,y-1,z+3,x+size/2-1,y-1,z+1+size
  #door
  mc_set_area :air,x-1,y,z+2,x+1,y+2,z+3
  #ceiling
  mc_set_area :wood, x-size/2+1,y+size,z+3,x+size/2-1,y+size,z+1+size
end

define :terrace do |n,x=0,y=0,z=4,size=8,w=1|
  n.times do |i|
    house(x+i*(size),y,z,size,w)
  end
end
#setup a blank world
mc_set_area :air,-100,-20,-100,100,100,100
mc_set_area :grass,-100,-2,-100,100,-1,100 #to stand on

#5.89603, 11.8738, -8.23865 start viewing position
mc_teleport 5.89603,11.8738,-8.23865
terrace(3,0,0,4,12,2)
sleep 4
#Add some notes...well it is Sonic Pi after all!
play_pattern_timed scale(:c4,:major,num_octaves: 2).shuffle,[0.2],release: 0.2
play [:c4,:e4,:g4,:c5],release: 2
sleep 2
mc_chat_post "Three terraced houses coded by Robin Newman, April 2015"
mc_chat_post "Using Sonic Pi 2.5dev and Minecraft"