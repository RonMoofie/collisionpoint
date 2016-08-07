package processing.test.incrementtest;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class IncrementTest extends PApplet {

PrintWriter output;
int filename;
int startcount;
int stopcount;

int StartCount1 = 0;
int counter1 = 0;

  int x = 40;
  
  int sendmode = 0;
  
boolean recButton;
boolean stopButton;
boolean stoppress;




OscP5 oscP5;

NetAddress myRemoteLocation;

OscMessage myOscMessage2 = new OscMessage ("/stoprec");
  OscMessage myOscMessage3 = new OscMessage ("/startrec");
  OscMessage myOscMessage1 = new OscMessage("/filenum");
  OscMessage myOscMessage4 = new OscMessage("/filereset");
  OscMessage myOscMessage5 = new OscMessage("/startrec2");

String[] lines;

public void setup() {
  
  StartCount1 = 0;
  counter1 = 0;
  stoppress = false;
  sendmode = 0;
  
  lines = loadStrings("filename.txt");
  println("there are " + lines.length + " lines");
  println(lines);
  // Create a new file in the sketch directory
  output = createWriter("filename.txt"); 
  filename = lines.length;
  if (filename < 1) {
   filename = 1; 
  }
  
  for (int i = 0; i < lines.length; i++) {
    output.println(lines[i]);
  }
  
  
   //listening port
  oscP5 = new OscP5(this, 13000);
  //sending port
  myRemoteLocation = new NetAddress("127.0.0.1", 13002);
  //incoing messages forwarding
  oscP5.plug(this, "test", "/test");
  
  
  background(loadImage("background.png"));
  
  
  
}

public void draw() {
  //output.println(filename); // Write the coordinate to the file
  
  if (StartCount1 == 0){
  fill(70, 10);
  noStroke();
  rect((width/2)-x, (height/2)-x, x*2, x*2, 10, 10, 10, 10);
  fill(255,0,0, 10);
  ellipse(width/2, height/2, x*1.5f, x*1.5f);
  
  recButton = true;
  }
  
  if (StartCount1 == 1 && counter1 < 200) {
    counter1 +=1;
    recButton = false;
  }
  
  if (counter1 > 0 && counter1 < 100) {
  fill(0, 40);
  noStroke();
  rect((width/2)-x, (height/2)-x, x*2, x*2, 10, 10, 10, 10);
  }
 
  if (stoppress == true){
  
     myOscMessage4.add(0);
   oscP5.send(myOscMessage4, myRemoteLocation);
   myOscMessage5.add(0);
   oscP5.send(myOscMessage5, myRemoteLocation);
   
   stoppress = false;
   StartCount1 = 0;
   counter1 = 0;
  }
  
  noStroke();
  fill(100);
  rect(30,30,30,30, 5, 5, 5, 5);
  stroke(0);
  strokeWeight(2);
  fill(0);
  line(30,30,60,60);
  line(60,30,30,60);
  
  
}

public void keyPressed() {
  
  
  if (key == 8) {
    
    fileNameReset();
    
  }
  if (key == 66 || key == 98) {
   StartCount1 = 0;
   counter1 = 0;
  }
  
   myOscMessage1.add(filename);
   oscP5.send(myOscMessage1, myRemoteLocation);
   
   println("File: " + filename);
   println("Start: " + startcount);
   println("Stop: " + stopcount);
}

public void mousePressed() {
 
  
  if (mouseX < 61 && mouseX > 29 && mouseY < 61 && mouseY > 29){
     output.close(); // Finishes the file
     exit(); // Stops the program
  }
  
  if (recButton == true && mouseX < (width/2 + 21) &&  mouseX > (width/2 - 21) && mouseY < (height/2 + 21) && mouseY > (height/2) - 21){
  fileIncrement();
  fileStart();
  println("itwork");
  fill(150);
  noStroke();
  rect((width/2)-x, (height/2)-x, x*2, x*2, 10, 10, 10, 10);
  fill(255,0,0, 10);
  ellipse(width/2, height/2, x*1.5f, x*1.5f);
  StartCount1 = 1;

  
  myOscMessage1.add(filename);
   oscP5.send(myOscMessage1, myRemoteLocation);
   
   println("File: " + filename);
   println("Start: " + startcount);
   println("Stop: " + stopcount);
   
  }
  
}

public void fileNameReset() {
    filename = 1;
    output = createWriter("filename.txt"); 
    startcount = 0;
    stopcount = 0; 
}

public void fileIncrement() {
  output.println(filename); // Write the coordinate to the file
  filename ++;
  println(filename);
  output.flush(); // Writes the remaining data to the file
  startcount = 0;
  stopcount = 0;
  
  myOscMessage2.add(stopcount);
  oscP5.send(myOscMessage2, myRemoteLocation);

}

public void fileStart() {
 startcount += 1;
 println("startcount" + startcount);
   
   myOscMessage3.add(1);
   oscP5.send(myOscMessage3, myRemoteLocation);
   stopcount = 0;
   
   myOscMessage2.add(stopcount);
   oscP5.send(myOscMessage2, myRemoteLocation); 
}

public void oscEvent(OscMessage theOscMessage) {
  // get and print the address pattern and the typetag of the received OscMessage
  //println("### received an osc message with addrpattern "+theOscMessage.addrpattern()+" and typetag "+theOscMessage.typetag());
  //theOscMessage.print();
  if (sendmode == 0) {
  stoppress = true;
  sendmode = 1;
  println("stopped and moved on");
  } else if (sendmode == 1) {
   println("started recording"); 
   sendmode = 0;
  }
}
  public void settings() {  size(1280,800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "IncrementTest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
