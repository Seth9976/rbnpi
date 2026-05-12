#test communication with StartBarSelector processing GUI
define :ver do
  return version.to_s.split('.')
end

loop do
  v= version
  tr=0
  until tr==1
    s=sync '/transport'
    if version="v2.11.1" or ver[2].to_i > 11
      tr=s[0]
      bs=s[1]
    else
      tr=s[:args][0]
      bs=s[:args][1]
    end
    
    puts "play/stop tr variable is "+tr.to_s
    puts "bs bar start variable is "+bs.to_s
  end
  
  until tr==-1
    s=sync '/transport'
    if version="v2.11.1" or ver[2].to_i > 11
      tr=s[0]
      bs=s[1]
    else
      tr=s[:args][0]
      bs=s[:args][1]
    end
    
    puts "play/stop tr variable is "+tr.to_s
    puts "bs bar start variable is "+bs.to_s
  end
end

