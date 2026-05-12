#Musical random blocks in Minecraft from Sonic Pi by Robin Newman, April 2015

# Area goes from -max_xz to max_xz.
max_xz = 128
max_xy = 64

base_block = :sandstone

mc_set_area :air, -max_xz, 0, -max_xz, max_xz, max_xy, max_xz
mc_set_area base_block, -max_xz, 0, -max_xz, max_xz, -max_xy, max_xz

sleep 6
mc_teleport 0,17,0
mc_chat_post "Sonic Pi generated Random Musical Blocks"
mc_chat_post "coded by Robin Newman, April 2015"
l=[]
100.times do
  l << [rrand_i(-20,20),rrand_i(1,15),rrand_i(-20,20)]
end
blist=[:gold,:iron,:stone,:brick,:diamond]
slist=[:saw,:zawa,:fm,:tb303,:prophet]
5.times do |q|

  in_thread do
    sleep 1.4
    100.times do |i|

      mc_set_block blist[q],l[i][0],l[i][1],l[i][2]
      sleep 0.05
    end
    sleep 2
    100.times do |i|

      mc_set_block :air,l[i][0],l[i][1],l[i][2]
      sleep 0.05
    end
    sleep 2
    l=l.shuffle
  end

  use_synth slist[q]
  100.times do |i|
    play [:c4,:e4,:g4,:c5,:e5,:g5,:c6,:e6,:g6].choose,release: 0.05
    sleep 0.05
  end
  sleep 2
  use_synth slist[q]
  100.times do |i|
    play [:c4,:e4,:g4,:c5,:e5,:g5,:c6,:e6,:g6].choose,release: 0.05
    sleep 0.05
  end
  sleep 2
end