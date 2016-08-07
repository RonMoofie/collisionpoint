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




OscP5 oscP5;

NetAddress myRemoteLocation;

OscMessage myOscMessage2 = new OscMessage ("/stoprec");
  OscMessage myOscMessage3 = new OscMessage ("/startrec");
  OscMessage myOscMessage1 = new OscMessage("/filenum");

String[] lines;

public void setup() {
  
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
  
  int x = 40;
  
  fill(70);
  noStroke();
  rect((width/2)-x, (height/2)-x, x*2, x*2, 10, 10, 10, 10);
  fill(255,0,0);
  ellipse(width/2, height/2, x*1.5f, x*1.5f);
}

public void keyPressed() {
  
  if (key != 8 && key != 66 && key != 98){
  fileIncrement();
  }
  if (key == 8) {
    
    fileNameReset();
    
  }
  if (key == 66 || key == 98) {
   fileStart() ;
  }
  
   myOscMessage1.add(filename);
   oscP5.send(myOscMessage1, myRemoteLocation);
   
   println("File: " + filename);
   println("Start: " + startcount);
   println("Stop: " + stopcount);
}

public void mousePressed() {
  output.close(); // Finishes the file
  exit(); // Stops the program
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
  myOscMessage3.add(startcount);
  oscP5.send(myOscMessage3, myRemoteLocation);
}

public void fileStart() {
 startcount += 1;
   
   myOscMessage3.add(1);
   oscP5.send(myOscMessage3, myRemoteLocation);
   stopcount = 0;
   
   myOscMessage2.add(stopcount);
   oscP5.send(myOscMessage2, myRemoteLocation); 
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
