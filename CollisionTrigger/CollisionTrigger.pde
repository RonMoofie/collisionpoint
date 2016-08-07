import oscP5.*;
import netP5.*;

OscP5 oscP5;

NetAddress myRemoteLocation;

OscMessage collisionMessage = new OscMessage("/collision");
OscMessage noCollisionMessage = new OscMessage("/nocollision");

int granuleTrigger = 0;

void setup(){
  size(500,500);
  //listening port
  oscP5 = new OscP5(this, 13000);
  //sending port
  myRemoteLocation = new NetAddress("127.0.0.1", 13005);
  //incoing messages forwarding
  oscP5.plug(this, "test", "/test");
}

void draw(){
}

void keyPressed(){
 if (key == 65 || key == 97) {
   granuleTrigger = 1;
   collisionMessage.add(granuleTrigger);
   oscP5.send(collisionMessage, myRemoteLocation);
   println("on");
}

if (key != 65 && key != 97) {
   granuleTrigger = 0;
   noCollisionMessage.add(granuleTrigger);
   oscP5.send(noCollisionMessage, myRemoteLocation);
   println("off");
}
 
}