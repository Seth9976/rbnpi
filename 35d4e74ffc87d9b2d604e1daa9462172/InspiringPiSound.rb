
#inspiring sonic pi driver
#start sudo inspserver.py --ip 172.20.10.6 on client
use_osc "localhost",4559 #osc destination for the local machine

remote_ip_address="172.20.10.6" #adjust this for your setup.
# uncomment next to lines to shutdown client raspberry pi
##| osc_send  remote_ip_address,8000, "/hello/shutdown"
##| stop
use_bpm 140 #initial setting of bpm (set to 160 by the first bpm_mul
use_cue_logging false
use_osc_logging false
delay=0
##| l1= [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
##| l2= [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23]
##| l3= [1, 4, 7, 10, 13, 16, 19, 22]
##| l4= [1, 5, 9, 13, 17, 21]
##| l5= [1, 7, 13, 19]
##| l6= [1, 9, 17]
##| l7= [1, 13]
s=[:tri,:pulse,:saw,:piano]
set :stopflag,false
set :stopall,false
at 121 do
  set:stopflag,true
end

sleep 1
live_loop :send do
  use_real_time
  6.step(0,-1) do |y|
    st=[1,2,3,4,6,8,12][y]
    p=[0,1].choose
    syn=s.choose
    ##| w=[0,1,2,3,5,7,11][y]
    ##| (24-w).step(1,-st) do |x|
    for x in (1..24).step(st) do
        osc "hello/play",delay,x,0.1,x+1.to_f/25,syn,60
        osc_send remote_ip_address,8000, "/hello/play",delay,x,0.1,x.to_f/24,syn,60,0,0,[((x+y)%7+1),y%7+1][p],1
        sleep 0.2
      end
      w=[0,1,2,3,5,7,11][y]
      (24-w).step(1,-st) do |x|
        ##| for x in (1..24).step(st) do
        osc "hello/play",delay,x,0.1,x+1.to_f/25,:tri,60
        osc_send remote_ip_address,8000, "/hello/play",delay,x,0.1,x.to_f/24,syn,60,0,0,0,1
        sleep 0.2
      end
    end
    6.step(0,-1) do |y|
      st=[1,2,3,4,6,8,12][y]
      p=[0,1].choose
      syn=s.choose
      w=[0,1,2,3,5,7,11][y]
      (24-w).step(1,-st) do |x|
        #for x in (1..24).step(st) do
        osc "hello/play",delay,x,0.1,x+1.to_f/25,syn,60
        osc_send remote_ip_address,8000, "/hello/play",delay,x,0.1,x.to_f/24,syn,60,0,0,[((x+y)%7+1),y%7+1][p],1
        sleep 0.2
      end
      ##| w=[0,1,2,3,5,7,11][y]
      ##| (24-w).step(1,-st) do |x|
      for x in (1..24).step(st) do
          osc "hello/play",delay,x,0.1,x+1.to_f/25,:tri,60
          osc_send remote_ip_address,8000, "/hello/play",delay,x,0.1,x.to_f/24,syn,60,0,0,0,1
          sleep 0.2
        end
      end
      if get(:stopflag)
        set :stopall,true
        osc_send  remote_ip_address,8000, "/hello/kill"
        stop
      end
    end
    
    
    live_loop :playit do
      use_real_time
      b = sync "/osc/hello/play"
      use_synth b[4]
      play b[1]+60,amp: b[3],sustain: b[2],release: 0.1
      sleep b[2]
      stop if get(:stopall)
    end
    