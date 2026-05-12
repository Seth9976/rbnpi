# ===== Default : Default
colorMode HSB,100,100,100
def polygon (x, y, radius1, radius2, npoints,k)
  pushMatrix
  translate x,y
  rotate k if ka1==1 #rotate star on/off
  angle = TWO_PI / npoints
  halfAngle = angle/2.0
  beginShape()
  0.step(TWO_PI,angle) do |a|
    sx =cos(a) * radius2
    sy =sin(a) * radius2
    vertex(sx, sy)
    sx = cos(a+halfAngle) * radius1
    sy = sin(a+halfAngle) * radius1
    vertex(sx,sy)
  end
  endShape(CLOSE)
  popMatrix
end

def draw
  background volume*400,80,80*ka4
  noStroke
  if ka2==1 #switch central star colour
   fn=30;fc=50
  else
   fn=80;fc=20
  end
  px=width*0.2;py=width*0.1
  fill fn+frameCount%fc,100,100,180
  pushMatrix
  translate width/2,height/2
  scale 1+volume*5
  polygon(0,0,px,py,5+frameCount/5%14.to_i,frameCount*0.1) if ka3==1 #switch pat. stars
  popMatrix  
  translate width/2,height/2
  scale 1+10*volume if ka5==1 #switch scale on/off
  rotate frameCount*volume*0.2 if ka6==1 #rotate fwd on off
  #rotate -frameCount*volume*0.2 if ka7==1 #rotate bkwd on/off 
  
  translate -height/2,-height/2
  xs=height/10;ys=height/10
  for x in(xs..9*xs).step 100 do
    for y in(ys..9*ys).step 100 do
      fv=(x+y)/18# if x <450
      fv =(x-y)/10 if ka7==1
      fill fv,100,100
      polygon(x,y,volume*300,volume*600,3+volume*200.to_i,0.1) if ka8==1
    end
  end
end
colorMode HSB,100,100,100
def polygon (x, y, radius1, radius2, npoints,k)
  pushMatrix
  translate x,y
  rotate k if ka1==1 #rotate star on/off
  angle = TWO_PI / npoints
  halfAngle = angle/2.0
  beginShape()
  0.step(TWO_PI,angle) do |a|
    sx =cos(a) * radius2
    sy =sin(a) * radius2
    vertex(sx, sy)
    sx = cos(a+halfAngle) * radius1
    sy = sin(a+halfAngle) * radius1
    vertex(sx,sy)
  end
  endShape(CLOSE)
  popMatrix
end

def draw
  afactor=1.2 #adjust for optimum vloume effect
  background volume*400,80,80*ka4
  noStroke
  if ka2==1 #switch central star colour
   fn=30;fc=50
  else
   fn=80;fc=20
  end
  px=width*0.2;py=width*0.1
  fill fn+frameCount%fc,100,100,180
  pushMatrix
  translate width/2,height/2
  scale 1+volume*5
  polygon(0,0,px,py,5+frameCount/5%14.to_i,frameCount*0.1) if ka3==1 #switch pat. stars
  popMatrix  
  translate width/2,height/2
  scale 1+10*volume*afactor if ka5==1 #switch scale on/off
  rotate frameCount*volume*0.2*afactor if ka6==1 #rotate fwd on off
  #rotate -frameCount*volume*0.2 if ka7==1 #rotate bkwd on/off 
  
  translate -height/2,-height/2
  xs=height/10;ys=height/10
  for x in(xs..9*xs).step 100 do
    for y in(ys..9*ys).step 100 do
      fv=(x+y)/18# if x <450
      fv =(x-y)/10 if ka7==1
      fill fv,100,100
      polygon(x,y,volume*300*afactor,volume*600*afactor,3+volume*200*afactor.to_i,0.1) if ka8==1
    end
  end
end