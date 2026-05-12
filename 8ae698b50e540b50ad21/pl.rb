#!/usr/bin/ruby

#ruby script to play a playlist of sonic pi files contained in a specified directory by Robin Newman, July 2015
#sample usage: ./pl.rb /home/pi/spfiles    (where spfiles contains the sonic pi files to be played)
#A 2 second gap is placed between each file playing and the next
#requires the Command Line Interface gem sonic_pi downloadable from https://github.com/Widdershin/sonic-pi-cli

#check for arg
if ARGV.length == 0 then
  puts 'usage: ./pl.rb absolute/path/to/directory/of/sonicpifiles'
  exit 1
else
  spfiles = ARGV[0]
end

#PATHNAMES WHICH ARE USED
path="/tmp/jukebox" #path for temporary files folder
clipath="/usr/local/bin" #absolute path to sonic_cli command line interface

#setup temp file directory
system 'mkdir '+path
#set up init.txt file containing initialisation commands for SP
#makes sure that any changes made in one sp file are cancelled before the next one plays
f=open(path+'/init.txt','w')
f.puts "use_debug false"
#originally set_sched_ahead! was reset too but this will not work here
f.puts "set_volume! 1"
f.close
#get list of filenames and number of files to be played
fnames=[]
Dir.foreach(spfiles) do |filename|
  next if File.directory?(spfiles+"/"+filename) #ignore non file entries
  fnames.concat [filename]
end
fnames=fnames.sort_by{|word| word.downcase}.reverse #sort in reverse order alpahbetically case insensitive

numfiles= fnames.length

#send commands to cli for each file, topping and tailing with sync and cue commands
for x in 0..(numfiles-1) do
    #set up sync command ahead of next file
    f=open(path+'/sync.txt','w')
    f.puts "\nsync :link"+(numfiles-x-1).to_s
    f.puts "sleep 2" #add sleep gaps between files
    f.close
    #set up cue command after next file
    f=open(path+'/cue.txt','w')
    f.puts "\ncue :link"+(numfiles-x).to_s
    f.close
    #check if last file
    if x < (numfiles -1) then
      #if not last file send sync, init, file data and cue commands
      system "cat "+path+"/sync.txt "+path+"/init.txt "+spfiles+"/"+fnames[x]+" "+path+"/cue.txt| "+clipath+"/sonic_pi "# >> "+path+"/out.txt" #
    else
      #now do last file, omitting the sync command so that this plays straight away
      system "cat "+path+"/init.txt "+spfiles+"/"+fnames[x]+" "+path+"/cue.txt| "+clipath+"/sonic_pi "# >> "+path+"/out.txt" #
    end
    puts "Now loading "+fnames[x]+" play number "+(numfiles-x).to_s
  end
  puts "\nNB files loaded in reverse to playorder"
  #tidy up by deleting temporary files
  system 'rm -fR '+path