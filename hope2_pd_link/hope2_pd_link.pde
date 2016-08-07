import SimpleOpenNI.*;
import oscP5.*;
import netP5.*;


OscP5 oscP5;

NetAddress myRemoteLocation;


SimpleOpenNI kinect;
// Frame
PImage currentFrame;
color trackColor1;
color trackColor2;

int frames = 0;
int framtrack = 0;
int[] adjustX1 = new int[20];
int[] adjustY1 = new int[20];
int[] adjustX2 = new int[20];
int[] adjustY2 = new int[20];
int totX1;
int totY1;
float avX1;
float avY1;
float totX2;
float totY2;
float avX2;
float avY2;
float Diff1;
float Diff2;

float balldifX;
float balldifY;
float balldiftot;
int near;
int nearcount;

  float prevX1 = 0;
  float prevX2 = 0;
  float prevY1 = 0;
  float prevY2 = 0;
  
float X1Diff = 0;
float X2Diff = 0;
float Y1Diff = 0;
float Y2Diff = 0;

float X1Diffa = 0;
float X2Diffa = 0;
float Y1Diffa = 0;
float Y2Diffa = 0;

float chan1send1;
float chan2send1;
float chan3send1;
float chan4send1;

float chan1send2;
float chan2send2;
float chan3send2;
float chan4send2;

float highX;
float highY;

float Xtran = 90.0/515.0;
float Ytran = 90.0/390.0;

int colTol1;
int colTol2;

int nearTolerance;

int motion1;
int motion2;

int collisionproxtest = 0;
 
void setup()
{
  
 near = 0;
 nearcount = 0;
 nearTolerance = 20;
 
 motion1 = 20;
 motion2 = 20;
  
 size(1280, 480);
 kinect = new SimpleOpenNI(this);
 kinect.enableRGB();
 
 trackColor1 = color (255,0,0);
 trackColor2 = color (255,0,0);
 smooth ();
 
 colTol1 = 20;
 colTol2 = 20;
 
 currentFrame = createImage (640,480, RGB);
 //listening port
  oscP5 = new OscP5(this, 12000);
  //sending port
  myRemoteLocation = new NetAddress("127.0.0.1", 12897);
  //incoing messages forwarding
  oscP5.plug(this, "test", "/test");
  
  chan1send1 = 0;
  chan2send1 = 0;
  chan3send1 = 0;
  chan4send1 = 0;
  
  chan1send2 = 0;
  chan2send2 = 0;
  chan3send2 = 0;
  chan4send2 = 0;
 
  highX = 0;
  highY = 0;
}
 
void draw()
{
 noStroke();
 fill(200,20);
 rect(width/2,0,width/2,height);
 frames += 1; 
  
 kinect.update();
 
 currentFrame = kinect.rgbImage ();
 image(currentFrame,0,0);
 
 currentFrame.loadPixels();
 
 // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
 float worldRecord1 = 500;
 float worldRecord2 = 500;
 // XY coordinate of closest color
 int closestX1 = 0;
 int closestY1 = 0;
 int closestX2 = 0;
 int closestY2 = 0;
 
 // Begin loop to walk through every pixel
 for (int x = 0; x < currentFrame.width; x ++ ) {
 for (int y = 0; y < currentFrame.height; y ++ ) {
 int loc = x + y*currentFrame.width;
 // What is current color
 color currentColor = currentFrame.pixels[loc];
 float r1 = red(currentColor);
 float g1 = green(currentColor);
 float b1 = blue(currentColor);
 float r2 = red(trackColor1);
 float g2 = green(trackColor1);
 float b2 = blue(trackColor1);
 float r3 = red(trackColor2);
 float g3 = green(trackColor2);
 float b3 = blue(trackColor2);
 
// Using euclidean distance to compare colors
 float d1 = dist(r1,g1,b1,r2,g2,b2); // We are using the dist( ) function to compare the current color with the color we are tracking.
 float d2 = dist(r1,g1,b1,r3,g3,b3);
 
// If current color is more similar to tracked color than
 // closest color, save current location and current difference
 if (d1 < worldRecord1) {
 worldRecord1 = d1;
 closestX1 = x;
 closestY1 = y;
 }
 if (d2 < worldRecord2) {
 worldRecord2 = d2;
 closestX2 = x;
 closestY2 = y;
 }
 }
 }
framtrack = frames%5;
if (framtrack != 0) {
  adjustX1[(framtrack-1)] = closestX1;
  adjustY1[(framtrack-1)] = closestY1;
  totX1 = 0;
  totY1 = 0;
}
if (framtrack == 0) {
  for (int i = 0; i < 5; i ++){
   totX1 += adjustX1[i];
   totY1 += adjustY1[i]; 
  }
  avX1 = totX1/5;
  avY1 = totY1/5;
//  println(avX1);
  
  
}if (framtrack != 0) {
  adjustX2[(framtrack-1)] = closestX2;
  adjustY2[(framtrack-1)] = closestY2;
  totX2 = 0;
  totY2 = 0;
}
if (framtrack == 0) {
  for (int i = 0; i < 5; i ++){
   totX2 += adjustX2[i];
   totY2 += adjustY2[i]; 
  }
  avX2 = totX2/5;
  avY2 = totY2/5;
//  println(avX2);
}
 
 
 
// We only consider the color found if its color distance is less than 10.
 // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
 if (worldRecord1 < colTol1) {
 // Draw a circle at the tracked pixel
 fill(trackColor1);
 strokeWeight(4.0);
 stroke(0);
 ellipse(closestX1,closestY1,16,16);
 ellipse(avX1+640,avY1, 16,16);
 }
 if (worldRecord2 < colTol2) {
 // Draw a circle at the tracked pixel
 fill(trackColor2);
 strokeWeight(4.0);
 stroke(0);
 ellipse(closestX2,closestY2,16,16);
 ellipse(avX2+640,avY2, 16,16);
// println(totX2);
 }
 
 tracker();
 
}
void mousePressed(){
//color c = get(mouseX, mouseY);
color c = color(55,88,125);
// println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
 
// Save color where the mouse is clicked in trackColor variable
// int loc = mouseX + mouseY*(currentFrame.width);
// println (loc);
 
// trackColor = currentFrame.pixels[loc];
trackColor1 = color(63,90,104);
trackColor2 = color(167,118,29);
}

void tracker(){
if (framtrack == 0) {
  if (prevX1 != 0) {
    X1Diffa = prevX1 - int(avX1);
    X1Diff = abs(prevX1 - int(avX1));
  }
  if (prevX2 != 0) {
    X2Diffa = prevX2 - avX2;
    X2Diff = abs(prevX2 - avX2);
  }
  if (prevY1 != 0) {
    Y1Diffa = prevY1 - avY1;
    Y1Diff = abs(prevY1 - avY1);
  }
  if (prevY2 != 0) {
    Y2Diffa = prevY2 - avY2;
    Y2Diff = abs(prevY2 - avY2);
  }
  
  Diff1 = X1Diff + Y1Diff;
  Diff2 = X2Diff + Y2Diff;
  
  balldifX = abs(avX1 - avX2);
  balldifY = abs(avY1 - avY2);
  balldiftot = balldifX + balldifY;
  
  if (balldiftot < nearTolerance) {
   if (balldiftot < 5) {
     collisionproxtest = 1;
   } else {
    collisionproxtest = 0; 
   }
  } else {
   near = 0; 
   collisionproxtest = 0;
  }
  
  
  //20 is tolerance for movement
  if(Diff1 > motion1) {
   strokeWeight(Diff1/2);
   line(prevX1 + 640, prevY1, avX1 + 640, avY1);
   println("MOVEMENT DETECTED 1: " + Diff1); 
   
   
   //sending to Pd
   
//   OscMessage myOscMessage1 = new OscMessage("/1chanvol");
//   myOscMessage1.add(chan1send);
//   oscP5.send(myOscMessage1, myRemoteLocation);
//  } else {
//   
//   chan1send = 0; 
//   chan2send = 0;
//    
//   OscMessage myOscMessage1 = new OscMessage("/1chanvol");
//   myOscMessage1.add(chan1send);
//   oscP5.send(myOscMessage1, myRemoteLocation);
  }
  
  
  if(Diff2 > motion2) {
   strokeWeight(Diff2/2);
   line(prevX2 + 640, prevY2, avX2 + 640, avY2);
//   println("MOVEMENT DETECTED 2: " + Diff2); 
   
//   OscMessage myOscMessage2 = new OscMessage("/2chanvol");
//   myOscMessage2.add(1));
//   oscP5.send(myOscMessage2, myRemoteLocation);
//   
//  } else {
//   OscMessage myOscMessage2 = new OscMessage("/2chanvol");
//   myOscMessage2.add(0);
//   oscP5.send(myOscMessage2, myRemoteLocation); 
//  }
}
}

if (Diff1 > motion1) {
  
 chan1send1 = (((cos(radians(Xtran*avX1)))/2)-0.25) + (((cos(radians(Ytran*avY1)))/2)-0.25);
 chan2send1 = (((cos(radians((Xtran*avX1)+270)))/2)-0.25) + (((cos(radians(Ytran*avY1)))/2)-0.25);
 chan3send1 = (((cos(radians(Xtran*avX1)))/2)-0.25) + (((cos(radians((Ytran*avY1)+270)))/2)-0.25);
 chan4send1 = (((cos(radians((Xtran*avX1)+270)))/2)-0.25) + (((cos(radians((Ytran*avY1)+270)))/2)-0.25);
 
 checkzero();

//println("avX1: " + avX1);
//println("avY1: " + avY1);
println("chan1: " + chan1send1);
println("chan2: " + chan2send1);
println("chan3: " + chan3send1);
println("chan4: " + chan4send1);
 
// chan1send *= Diff1/300;
// chan2send *= Diff1/600;
// chan3send *= Diff1/600;
// chan4send *= Diff1/600;
 
 
 
 OscMessage myOscMessage1 = new OscMessage("/1chan1vol");
   myOscMessage1.add(chan1send1);
   oscP5.send(myOscMessage1, myRemoteLocation);
   
OscMessage myOscMessage2 = new OscMessage("/1chan2vol");
   myOscMessage2.add(chan2send1);
   oscP5.send(myOscMessage2, myRemoteLocation); 
  
OscMessage myOscMessage3 = new OscMessage("/1chan3vol");
   myOscMessage3.add(chan3send1);
   oscP5.send(myOscMessage3, myRemoteLocation); 

OscMessage myOscMessage4 = new OscMessage("/1chan4vol");
   myOscMessage4.add(chan4send1);
   oscP5.send(myOscMessage4, myRemoteLocation);    
   
  } else {
//   
   chan1send1 = 0; 
   chan2send1 = 0;
   chan3send1 = 0;
   chan4send1 = 0;
//    
   OscMessage myOscMessage1 = new OscMessage("/1chan1vol");
   myOscMessage1.add(chan1send1);
   oscP5.send(myOscMessage1, myRemoteLocation);
//   
OscMessage myOscMessage2 = new OscMessage("/1chan2vol");
   myOscMessage2.add(chan2send1);
   oscP5.send(myOscMessage2, myRemoteLocation); 
//   
   OscMessage myOscMessage3 = new OscMessage("/1chan3vol");
   myOscMessage3.add(chan3send1);
   oscP5.send(myOscMessage3, myRemoteLocation); 
//
OscMessage myOscMessage4 = new OscMessage("/1chan4vol");
   myOscMessage4.add(chan4send1);
   oscP5.send(myOscMessage4, myRemoteLocation);
//  
  }
  
  if (Diff2 > motion2) {
  
 chan1send2 = (((cos(radians(Xtran*avX2)))/2)-0.25) + (((cos(radians(Ytran*avY2)))/2)-0.25);
 chan2send2 = (((cos(radians((Xtran*avX2)+270)))/2)-0.25) + (((cos(radians(Ytran*avY2)))/2)-0.25);
 chan3send2 = (((cos(radians(Xtran*avX2)))/2)-0.25) + (((cos(radians((Ytran*avY2)+270)))/2)-0.25);
 chan4send2 = (((cos(radians((Xtran*avX2)+270)))/2)-0.25) + (((cos(radians((Ytran*avY2)+270)))/2)-0.25);
 
 checkzero();

//println("avX2: " + avX2);
//println("avY2: " + avY2);
 
// chan1send *= Diff1/300;
// chan2send *= Diff1/600;
// chan3send *= Diff1/600;
// chan4send *= Diff1/600;
 
 
 
 OscMessage myOscMessage5 = new OscMessage("/2chan1vol");
   myOscMessage5.add(chan1send2);
   oscP5.send(myOscMessage5, myRemoteLocation);
   
OscMessage myOscMessage6 = new OscMessage("/2chan2vol");
   myOscMessage6.add(chan2send2);
   oscP5.send(myOscMessage6, myRemoteLocation); 
  
OscMessage myOscMessage7 = new OscMessage("/2chan3vol");
   myOscMessage7.add(chan3send2);
   oscP5.send(myOscMessage7, myRemoteLocation); 

OscMessage myOscMessage8 = new OscMessage("/2chan4vol");
   myOscMessage8.add(chan4send2);
   oscP5.send(myOscMessage8, myRemoteLocation);    
   
  } else {
//   
   chan1send2 = 0; 
   chan2send2 = 0;
   chan3send2 = 0;
   chan4send2 = 0;
//    
   OscMessage myOscMessage5 = new OscMessage("/2chan1vol");
   myOscMessage5.add(chan1send2);
   oscP5.send(myOscMessage5, myRemoteLocation);
//   
OscMessage myOscMessage6 = new OscMessage("/2chan2vol");
   myOscMessage6.add(chan2send2);
   oscP5.send(myOscMessage6, myRemoteLocation); 
//   
   OscMessage myOscMessage7 = new OscMessage("/2chan3vol");
   myOscMessage7.add(chan3send2);
   oscP5.send(myOscMessage7, myRemoteLocation); 
//
OscMessage myOscMessage8 = new OscMessage("/2chan4vol");
   myOscMessage8.add(chan4send2);
   oscP5.send(myOscMessage8, myRemoteLocation);
//  
  }
 
if (avY1 > highY) {
 highY = avY1;
} 
 
//println("avX1: " + avX1);
//println("Chan1: " + chan1send);
//println("HighY: " + highY);


  ///resets
  prevX1 = int(avX1);
  prevX2 = avX2;
  prevY1 = avY1;
  prevY2 = avY2;
  

}

void checkzero() {
 
 if (chan1send1 < 0) {
  chan1send1 = 0; 
 }
 if (chan2send1 < 0) {
  chan2send1 = 0; 
 }
 if (chan3send1 < 0) {
  chan3send1 = 0; 
 }
 if (chan4send1 < 0) {
  chan4send1 = 0; 
 }
 
 if (chan1send2 < 0) {
  chan1send2 = 0; 
 }
 if (chan2send2 < 0) {
  chan2send2 = 0; 
 }
 if (chan3send2 < 0) {
  chan3send2 = 0; 
 }
 if (chan4send2 < 0) {
  chan4send2 = 0; 
 }
  
}