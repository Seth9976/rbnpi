#SP-KeyboardController3.rb
#this version allows synth selection
#experimental program to control Sonic Pi from the keyboard
#developed from an original program written by Robin Newman, April 2016
#you can play notes direct, and select the synth to be used using the number keys
#now updated to use OSC communiation from the key polling program

#set up hash to contain notes
notes=Hash.new
#list of notes
l=[:c4,:cs4, :d4, :ds4, :e4, :f4, :fs4, :g4, :gs4, :a4, :as4, :b4, :c5, :cs5, :d5, :ds5, :e5, :f5, :fs5,  :g5]
#list of associated keys (may have to alter depending on your keyboard layout)
n=["a", "w", "s", "e",  "d", "f",  "t", "g",  "y", "h",  "u", "j", "k",  "o", "l", "p",  ";", "'",  "]", "#"]
set :n,n
20.times do |i| #loop to create the hash
  notes[n[i].ord]=l[i]
end
set :s,"sine" #initial synth
live_loop :getkey do
  use_real_time
  b= sync "/osc/key" #kEY pressed sent in an OSC message from
  k=b[0]
  puts k
  ks=k.to_i.chr
  #check if key to play note or not
  if !["a", "w", "s", "e",  "d", "f",  "t", "g",  "y", "h",  "u", "j", "k",  "o", "l", "p",  ";", "'",  "]", "#"].include? ks
    #check for synth choice
    case ks
    when "1"
      set :s,"tri" #adjust choices to suit your requirements
    when "2"
      set :s,"pulse"
    when "3"
      set :s,"tb303"
    when "4"
      set :s,"saw"
    when "5"
      set :s,"tri"
    when "6"
      set :s,"pulse"
    when "7"
      set :s,"tb303"
    when "8"
      set :s,"prophet"
    when "9"
      set :s,"zawa"
    when "0"
      set :s,"fm"
    end
    
  else
    #note to play
    use_synth get(:s)
    puts "current synth :#{get(:s)}"
    play notes[k.to_i],sustain: 0.5,release: 0.05,amp: 0.3
    sleep 0.05
  end
end

define :pl do |tune,dur| #loop to play a tune held in a notes and a durations list
  tune.zip(dur).each do |n,d|
    play n,sustain: d*0.9,release: d*0.1
    sleep d
  end
end