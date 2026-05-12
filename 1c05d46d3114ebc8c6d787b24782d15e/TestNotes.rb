# Test all notes for Sonic Pi glockenspiel by Robin Newman June 2018
use_osc "localhost",8000
11.times do |n|
  osc "/note",n
  sleep 0.5
end