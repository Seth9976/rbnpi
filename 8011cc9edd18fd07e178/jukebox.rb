#!/usr/bin/ruby

#ruby script to give jukebox control over Sonic Pi by Robin Newman, February 2015 (VERSION 2)
#added path variable for sonic-pi-cli so that the program can be used on a Mac as well as a Pi
#utilises sonic_pi_cli by Nick Johnstone which must be installed see https://github.com/Widdershin/sonic-pi-cli

#the program was developed from an initial project to control Sonic Pi via a mobile phone and teh telegram app
#the program will list all files in the program spfiles in the user's root directory, and let you choose by number
#which one to play
#It can also handle a series of files linked by Sonic Pi cue and sync commands, which can be played one after the other
#These are placed in sub folders in the folder linked, and their filenames should be numbered in the order in which they are to be run
#The program can also switch between headphone and hdmi sound output
#Input the command listall to see all the commands recognised

#The program creates the temporary folder /tmp/jukebox where it creates and uses 8 temporary files.
#init.txt, dbf.txt, mlist.txt, comm.txt, llist.txt, coml.txt, linkfiles.txt, mnlist.txt
#These files and the temporary directory are removed when the program is quit
#temp file uses: init.txt and dbf.txt contain preamble commands which are sent to Sonic File before the main music files
#the first initialses !set_sched_ahead_time and !set_volume and sets use_debug false
#The second just contains use_debug false, and is used when linked files are sent to Sonic Pi
#mlist.txt holds the contents of the spfiles folder, with preceding line numbers
#comm.txt holds the filename of the last selected music file to be played
#llist.txt contains a list of the subdirectories in linked containing sets of linked Sonic Pi files (linked with cue and sync commands)
#coml.txt contains the name of the last selected subdirectory in the linked directory
#linkfiles.txt contains the names of the files in the last selected linked files subdirectory
#mnlist.txt is a temporary work file used when adding line numbers to mlist.txt and llist.txt

#PATHNAMES WHICH ARE USED
path="/tmp/jukebox" #path for temporary files folder
spfiles=ENV["HOME"]+"/jukebox/spfiles2" #path for folder cotaining sonic pi files to chose from
linked=ENV["HOME"]+"/jukebox/linkedSP" #path to folder containing folders of linked sonic pi files to play
clipath=ENV["HOME"]+"/user/local/bin"
#adjust on a Mac I use rvm to manage Ruby and so by path was clipath=ENV["HOME"]+"/.rvm/gems/ruby-2.1.2/bin"


#setup temp files and directory
system 'mkdir '+path
f=open(path+'/init.txt','w')
f.puts "use_debug false"
f.puts "set_sched_ahead_time! 2"
f.puts "set_volume! 1"
f.close
f=open(path+'/dbf.txt','w')
f.puts "use_debug false"
f.close
#populate list and linklist output in mlist.txt and llist.txt
system 'ls '+spfiles+' > '+path+'/mnlist.txt'
system 'cat -n '.+path+'/mnlist.txt > '+path+'/mlist.txt'
system 'ls '+linked+' > '+path+'/mnlist.txt'
system 'cat -n '.+path+'/mnlist.txt > '+path+'/llist.txt'

system 'clear'#clear screen
puts 'Sonic Pi Jukebox control program' #title
puts
while true do
    print "Enter Command (listall for help): " 
    $stdout.flush
    c=gets.chomp.downcase
    system 'clear'
    puts 'Sonic Pi Jukebox control program'
    puts
    
    if (c[0..3] == "play" and c =~ /^.....\d/) then #play n command (check number is present with regexp)
        num=c[5..-1] #get value of <n> to num variable
        system "head -'"+num+"' "+path+"/mlist.txt | tail -1 |sed 's/^.......//' > "+path+"/comm.txt 2>&1" #extract filename to comm.txt
        file=File.open(path+"/comm.txt","r") #open and comm.txt and read filename to varaible f
        f=file.readline.chomp
        file.close
        system clipath+'/sonic_pi stop' #stop Sonic Pi from playing
        system "cat "+path+"/init.txt "+spfiles+"/"+f+" | "+clipath+"/sonic_pi" #send file contents to Sonic Pi with init.txt preamble
        puts "Now playing "+f #print file info for user
    end
    if (c[0..7] == "linkplay" and c =~ /^.........\d/) then  #linkplay <n> command (check number is present with regexp)
        num=c[9..-1]  #get value of <n> to num variable
         #get directory name from llist.txt, strip the preceding number and store the directory name in coml.txt
        system "head -'"+num+"' "+path+"/llist.txt | tail -1 |sed 's/^.......//' > "+path+"/coml.txt 2>&1"
        file=File.open(path+"/coml.txt","r") #open coml.txt, read directory name to variable f
        f=file.readline.chomp
        file.close
        system 'ls '+linked+'/'+f+' > '+path+'/linkfiles.txt' #list contents of directory name in "f" and save in file linkfiles.txt
        system clipath+'/sonic_pi stop' #stop Sonic Pi from playing
        file=File.open(path+'/linkfiles.txt') #open linkfiles.txt
        #read filenames to an array fname
        fname=[]
        until file.eof()
            fname << file.readline().chomp #chomp strips trailing /n
        end
        numfiles=fname.length - 1 #numfiles contains number of files to process
        #process all files except the last
        for x in 0..(numfiles-1) do
            system "cat "+path+"/dbf.txt "+linked+"/"+f+"/"+fname[x]+" | "+clipath+"/sonic_pi &"
        end
        #now do last file, which has a different preamble file, init.txt instead of dbf.txt
        system "cat "+path+"/init.txt "+linked+"/"+f+"/"+fname[numfiles]+" | "+clipath+"/sonic_pi &"
        puts "Now playing "+f #inform teh user what is playing
    end
    case c #deal with remaining commands in a case statement
        when "hp"
            system 'amixer cset numid=3 1 >NUL'
            puts "Headphone output selected"
        when "hdmi"
            system 'amixer cset numid=3 2 >NUL'
            puts "HDMI oputput selected"
        when "list"
            system 'cat '+path+'/mlist.txt'
            puts "Use play <num> to select"
        when "linklist"
            system 'cat '+path+'/llist.txt'
            puts "Use linkplay <num> to select"
        when "stop"
            system clipath+'/sonic_pi stop'
         when "listall"
            puts"Commands: hp (headphones), hdmi (hdmi audio), list (music files), play (num)"
            puts"          linklist (linked music pieces), linkplay (num)"
            puts"          stop (playing), quit (program)"
	when "quit"
            system clipath+'/sonic_pi stop' #stop Sonic Pi
            system 'rm -fR '+path #remove temp files
            puts "Program ended"
            break
        else
        if c[0..3] != "play" and c[0..7] != "linkplay" then #ignore known commands
         puts "You entered "+c+" which is not a recognised command"
        end		
    end
end
