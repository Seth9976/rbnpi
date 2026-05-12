use_osc "localhost",8000
live_loop :flasher do
  for n in 0..4 do
      osc "/ledNum",n,1
      sleep 0.2
    end
    for n in 0..4 do
        osc "/ledNum",n,0
        sleep 0.2
      end
    end