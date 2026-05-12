import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress sonicPi;

float mx,my; //will hold mouse position
int bs = 1; //current bar start value
int tr = 0; //play stop control
boolean flag; //controls OSC sending: once per click
PFont f;
int expand = 70;

void setup(){
  background(204);
  frameRate(60);
  size(240,120); //x value is 100 + 2*expand
  oscP5 = new OscP5(this, 8000);
  sonicPi = new NetAddress("127.0.0.1",4559);//////INSERT ADDRESS REQUIRED////////
  // add click rectangles
  fill(255); //fill white
  rect(45+expand,15,10,10);//bs+
  rect(45+expand,55,10,10);//bs=1
  rect(45+expand,90,10,10);//bs-
  fill(255,0,0);//fill red
  //stop rect initially semi-hidden
  fill(204);
  rect(10+expand,55,10,10);//stop
  //redraw it with no strke to get effect
  noStroke();
  rect(10+expand,55,10,10);//stop
  stroke(0);
  fill(255+expand,0,0);//fill red
  rect(80+expand,55,10,10);//play
  
  // Create the font
  f = createFont("ArialNarrow-16.vlw", 12);
  textFont(f);
  textAlign(CENTER, CENTER);

  //add screen captions
  fill(0);
  text("play",85+expand,40);
  text("bs+",50+expand,4);
  text("bs-",50+expand,105);
  text("bs1",50+expand,72);
  text("1",48+expand,40); //print initial "bs" value
}

void sendOscData(int tr,int bs) {
  OscMessage toSend = new OscMessage("/transport");
  toSend.add(tr);
  toSend.add(bs);
  oscP5.send(toSend,sonicPi);
  //println(toSend);//for debugging
}
  
void draw() {
  mx=mouseX;
  my=mouseY;
  if (mousePressed) {
    if ((mx > 44+expand) && (mx <56+expand )&&(my > 89) && (my < 101)){//bs- clicked
      bs-=1;
      if (bs<1){
        bs=1;
      } 
      fill(0,255,0); //set green
      rect(45+expand,90,10,10);//bs-
      //println(bs);//for debugging
      }
    if ((mx > 44+expand) && (mx < 56+expand)&&(my >14) && (my<26)) {//bs+ clicked
      bs+=1;
      fill(0,255,0); //green
      rect(45+expand,15,10,10);//bs+
      //println(bs);//for debugging
     }     
    if ((mx >44+expand)&&(mx<56+expand)&&(my>54) && (my<66)){//bs=1 clicked
      bs=1;
      fill(0,255,0); //set green
      rect(45+expand,55,10,10);//bs=1
      //println(bs);//for debugging
    }

    if ((mx >79+expand)&&(mx<91+expand)&&(my>54) && (my<66)){//play clicked
      if(flag==false){ //only send OSC once per click
        tr=1;
        sendOscData(tr,bs);
        flag=true;

        //switch on stop rectangle in red
        fill(255,0,0);
        rect(10+expand,55,10,10);//stop
        //switch off play rectangle
        fill(204);
        noStroke();
        rect(80+expand,55,10,10);//play
        //clear play text caption
        rect(70+expand,34,28,16);//play text clear rect
        //add stop text caption
        fill(0);
        text("stop",15+expand,40); 
        //println(tr); //for debugging
        //println(bs);
      }     
    }
    
    if ((mx >9+expand)&&(mx<21+expand)&&(my>54) && (my<66)) {//stop clicked
      if(flag==false){ //only send OSC once per click
        tr=-1;
        sendOscData(tr,bs);
        flag=true;
        //switch on play rectangle in red
        fill(255,0,0);
        rect(80+expand,55,10,10);//play
        //switch off stop rectangle
        fill(204);
        noStroke();
        rect(10+expand,55,10,10);//stop
        //clear stop text caption
        rect(1+expand,34,28,16);//stop text clear rect
        //add play text caption
        fill(0);
        text("play",85+expand,40);
        //println(tr); //for debugging
      }
    }

    fill(204); //update bs number on the screen
    noStroke(); //clear last entry with a background rectangle
    rect(30+expand,32,35,16); 
    stroke(0); //change stroke colour to black
    fill(0); //set fill to black
    text(bs,48+expand,40); //print bs value
  }
  else { //mouse now released
    flag=false; //reset flag to allow OSC sending
    //reset "bs" green rectangle
    fill(255); //set white
    rect(45+expand,90,10,10);//bs- 
    rect(45+expand,15,10,10);//bs+
    rect(45+expand,55,10,10);//bs=1
  }


  delay(50); //loop delay
}