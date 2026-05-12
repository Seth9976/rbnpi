import oscP5.*;
// This sketch runs on the receiving computer which will play the received notes
// Passing on OSC data to Sonic Pi
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myBroadcastLocation; 

void setup() {
  background(0);
  frameRate(100);
  size (1,1); // We don’t need to see anything.
  oscP5 = new OscP5(this,8000); // The port tothe source Soninc which the source processing app sends
  myBroadcastLocation = new NetAddress("127.0.0.1",4559); // The port on which Sonic Pi listens to incoming messages. 
}

void draw() {
}

void oscEvent(OscMessage theOscMessage) { // When you receive a message…
//println(theOscMessage);
println(theOscMessage.arguments());
oscP5.send(theOscMessage, myBroadcastLocation); //send it to Sonic Pi on this machine.
}