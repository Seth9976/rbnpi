//Visualiser for use with Sonic Pi 3 written by Robin Newman, September 2017
// based on an original sketch https://github.com/andrele/Starburst-Music-Viz
//THIS VERSION FOR RESIZEABLE SCREEN: CAN BE GRAGGED TO SECOND MONITOR
//Changes: changed to resizable screen, updated for Processing 3, added colour, added rectangle and star shapes
//added OSC input (from Sonic Pi) to alter parameters as it runs, removed slider inputs.
//input OSC:   /viz/float       updates STROKE_MAX, STROKE_MIN and audioThresh
//             /viz/pos         updates XY random offset values (can be zero)
//             /viz/col         updates RGB values
//             /viz/shapes      sets shapes to be used from S, E and R (or combinations thereof)
//             /viz/stardata    sets data for star shapes
//             /viz/rotval      turns rotation of shapes on/off
//             /viz/shift       turns XY shift across screen on/off
//             /viz/stop        initiates sending stop all signal back to Sonic Pi port 4557

import ddf.minim.analysis.FFT;
import ddf.minim.*;
import oscP5.*; //to support OSC server
import netP5.*;

Minim minim;
AudioInput input;
FFT fftLog;

int recvPort = 5000; //can change to whatever is convenient. Match with use_osc comand in Sonic Pi
OscP5 oscP5;
NetAddress myRemoteLocation; //used to send stop command b ack to Sonic PI

// Setup params
color bgColor = color(0, 0, 0);

// Modifiable parameters
float STROKE_MAX = 10;
float STROKE_MIN = 2;
float audioThresh = .9;
float[] circles = new float[29];
float DECAY_RATE = 2;
//variables for OSC input
float [] fvalues = new float[5]; //STROKE_MAX, STROKE_MIN,audioThresh values
int [] cols = new int[3]; //r,g,b colours
int [] positions = new int[2];// random offset scales for X,Y
int [] stardata = new int[4];// data for star shape, number of points, random variation
int shiftflag = 0; //flag to control xy drift across the screen set by OSC message
int two = 0; //variable to force concentric shapes when more than one is displayed
String shapes = "E"; //shapes to be displayed, including multiples from S,E,R
int rotval =0;
int xoffset = 0,yoffset = 0;
int xdirflag = 1,ydirflag = 1;

void setup() { 
 size(400, 400,P2D);
 frame.setResizable(true); 
 //noLoop();
  frameRate(60);
   myRemoteLocation = new NetAddress("127.0.0.1",4557); //address to send commands to Sonic Pi
  minim = new Minim(this);
  input = minim.getLineIn(Minim.MONO, 2048); //nb static field MONO referenced from class not instance hence Minim not minim

  fftLog = new FFT( input.bufferSize(), input.sampleRate()); //setup logarithmic fast fourier transform
  fftLog.logAverages( 22, 3); // see http://code.compartmental.net/minim/fft_method_logaverages.html

  noFill();
  ellipseMode(RADIUS); //first two coords centre,3&4 width/2 and height/2
  fvalues[0]=1.0;
  fvalues[1]=0.0;
  fvalues[2]=0.32;
  cols[0] = 255;
  cols[1]=0;
  cols[2]=150;
  positions[0] = 50;
  positions[1]=40;
  stardata[0]=2;
  stardata[1]=4;
  stardata[2]=3;
  stardata[3]=5;
  /* start oscP5, listening for incoming messages at recvPort */
  oscP5 = new OscP5(this, recvPort);
  background(0);
}

void draw() {
  background(0);
  pushMatrix();
  //calculate changing xy offsets: shiftflag set to 0 to siwtch this off
  xoffset += 10*xdirflag*shiftflag;
  yoffset += 10*ydirflag*shiftflag;
  if(shiftflag==0){xoffset=0;yoffset=0;} //reset offset values to zero if shifting is off
  //reverse directions of shifting when limits reached
  if (xoffset >width/3){xdirflag=-1;}
  if (xoffset < -width/3){xdirflag=1;}
  if (yoffset > height/3){ydirflag=-1;}
  if (yoffset < -height/3){ydirflag=1;}
  //transform to new shift settings
  translate(width/2+xoffset, height/2+yoffset); //half of screen width and height (ie centre) plus shift values

  //optional rotate set by OSC call
  rotate(float(rotval)*(2*PI)/360);
  
  //get limits for stroke values and audiThreshold from OSC data received
  STROKE_MIN=fvalues[0];
  STROKE_MAX=fvalues[1];
  audioThresh=fvalues[2]; 
  //println("fvalues: ",STROKE_MIN,STROKE_MAX,audioThresh); //for debugging

  // Push new audio samples to the FFT
  fftLog.forward(input.left);

  // Loop through frequencies and compute width for current shape stroke widths, and amplitude for size
  for (int i = 0; i < 29; i++) {

    // What is the average height in relation to the screen height?
    float amplitude = fftLog.getAvg(i);

    // If we hit a threshold, then set the "circle" radius to new value (originally circles, but applies to other shapes used)
    if (amplitude < audioThresh) {
      circles[i] = amplitude*(height/2);
    } else { // Otherwise, decay slowly
      circles[i] = max(0, min(height, circles[i]-DECAY_RATE));
    }

    pushStyle();
    // Set colour and opacity for this shape circle. (opacity depneds on amplitude)
    if (1>random(2)) {
      stroke(cols[0], cols[1], cols[2], amplitude*255);
    } else {
      stroke(cols[1], cols[2], cols[0], amplitude*255);
    }
    strokeWeight(map(amplitude, 0, 1, STROKE_MIN, STROKE_MAX)); //weight stroke according to amplitude value

    if (shapes.length()>1) { //if more than one shape being drawn, set two to 0 to draw them concentrically
      two = 0;
    } else {
      two = 1;
    }
    // draw current shapes
    if (shapes.contains("e")) {
      // Draw an ellipse for this frequency
      ellipse(random(-1, 1)*amplitude*positions[0]*two, random(-1, 1)*amplitude*positions[1]*two, 1.4*circles[i], circles[i]);
    }
    if (shapes.contains("r")) {
      rectMode(RADIUS); 
      rect( random(-1, 1)*amplitude*positions[0]*two, random(-1, 1)*amplitude*positions[1]*two, 1.4*circles[i], circles[i]);
    }
    if (shapes.contains("s")) {
      strokeWeight(3); //use fixed stroke weight when drawing stars
      //star data Xcentre,Ycentre,radius1,radius2,number of points
      star(random(-1, 1)*amplitude*positions[0]*two, random(-1, 1)*amplitude*positions[1]*two, circles[i]*stardata[0]*0.25, circles[i]*stardata[1]*0.25, int(stardata[2]+random(stardata[3])));
    }
    popStyle();

    //System.out.println( i+" "+circles[i]); //for debugging
  } //end of for loop
  popMatrix();
}

void oscEvent(OscMessage msg) { //function to receive and parse OSC messages
  System.out.println("### got a message " + msg);
  System.out.println( msg);
  System.out.println( msg.typetag().length());

  if (msg.checkAddrPattern("/viz/float")==true) {
    for (int i =0; i<msg.typetag().length(); i++) {
      fvalues[i] = msg.get(i).floatValue();
      System.out.print("float number " + i + ": " + msg.get(i).floatValue() + "\n");
    }
  }

  if (msg.checkAddrPattern("/viz/pos")==true) {
    for (int i =0; i<msg.typetag().length(); i++) {
      positions[i] = msg.get(i).intValue();
      System.out.print("pos number " + i + ": " + msg.get(i).intValue() + "\n");
    }
  }

  if (msg.checkAddrPattern("/viz/col")==true) {
    for (int i =0; i<msg.typetag().length(); i++) {
      cols[i] = msg.get(i).intValue();
      System.out.print("col number " + i + ": " + msg.get(i).intValue() + "\n");
    }
  }
  if (msg.checkAddrPattern("/viz/shapes")==true) {
    shapes=msg.get(0).stringValue();
    //for(int i =0; i<msg.typetag().length(); i++) {
    // shapes += msg.get(i).stringValue().toLowercase();      
    //}
    System.out.print("shapes code "+ shapes + "\n");
  }
  if (msg.checkAddrPattern("/viz/stardata")==true) {
    for (int i =0; i<msg.typetag().length(); i++) {
      stardata[i] = msg.get(i).intValue();
      System.out.print("stardata number " + i + ": " + msg.get(i).intValue() + "\n");
    }
  }
  if (msg.checkAddrPattern("/viz/rotval")==true) {
    rotval =msg.get(0).intValue();
    System.out.print("rotval code "+ rotval + "\n");
  }
  if (msg.checkAddrPattern("/viz/shift")==true) {
    shiftflag =msg.get(0).intValue();
    System.out.print("shiftflag code "+ shiftflag + "\n");
  }
  if (msg.checkAddrPattern("/viz/stop")==true) {
    kill(); //stop Sonic Pi from running
  }
}

//function to draw a star (and polygons)
void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void kill(){ //function to send stop message to Sonic Pi on local machine
  OscMessage myMessage = new OscMessage("/stop-all-jobs");
   myMessage.add("RBN_GUID"); //any value here. Need guid to make Sonic PI accept command
  oscP5.send(myMessage, myRemoteLocation); 
}