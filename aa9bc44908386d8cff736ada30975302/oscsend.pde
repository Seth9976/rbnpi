// Passing on OSC data to Sonic Pi
//This sketch runs on the orginating computer sending the note information
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myBroadcastLocation; 

void setup() {
  background(0);
  frameRate(60);
  size (1,1); // We don’t need to see anything.
  oscP5 = new OscP5(this,8000); // The port to which the soruce Sonic Pi on this machine is set to send
  myBroadcastLocation = new NetAddress("192.168.1.33",8000); // The port/destination ip for the receiving mac processing sketch
}

void draw() {
}

void oscEvent(OscMessage theOscMessage) { // When you receive a message…
println(theOscMessage.arguments());
    oscP5.send(theOscMessage, myBroadcastLocation); // …just send it to the destination
}