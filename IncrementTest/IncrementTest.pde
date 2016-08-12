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
boolean recstart;

int firsttime = 0;

int minutes = 0;
int seconds = 0;
int milseconds = 0;
float mil2seconds;
int mil3seconds;

String sminutes;
String sseconds;
String smilseconds;


import oscP5.*;
import netP5.*;

OscP5 oscP5;
OscP5 oscP52;

NetAddress myRemoteLocation;
NetAddress myRemoteLocation2;

  OscMessage myOscMessage1 = new OscMessage("/filenum");
  OscMessage myOscMessage2 = new OscMessage ("/stoprec");
  OscMessage myOscMessage3 = new OscMessage ("/startrec");
  OscMessage myOscMessage4 = new OscMessage("/filereset");
  OscMessage myOscMessage5 = new OscMessage("/startrec2");
  OscMessage myOscMessage6 = new OscMessage("/fileadder");

String[] lines;
int tempint = 0;
int counter2 = 0;

void setup() {
  
  StartCount1 = 0;
  counter1 = 0;
  stoppress = false;
  sendmode = 0;
  recstart = false;
  counter2 = 0;
  
  
  frameRate(60);
  
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
  //oscP52 = new OscP5(this, 13010);
  //sending port
  myRemoteLocation = new NetAddress("127.0.0.1", 13303);
  //myRemoteLocation2 = new NetAddress("127.0.0.1", 13012);
  //incoing messages forwarding
  oscP5.plug(this, "test", "/test");
  
  size(1280,800);
  background(loadImage("background.png"));
  
  firsttime = 0;
    
}

void draw() {
  //output.println(filename); // Write the coordinate to the file
  
  if (recstart == false) {
   milseconds = 0;
   seconds = 0;
   minutes = 0;
  }
  
  if (StartCount1 == 0){
  fill(70, 10);
  noStroke();
  rect((width/2)-x, (height/2)-x, x*2, x*2, 10, 10, 10, 10);
  fill(255,0,0, 10);
  ellipse(width/2, height/2, x*1.5, x*1.5);
  
  recButton = true;
  }
  
  if (StartCount1 == 1 && counter1 < 200) {
    counter1 +=1;
    recButton = false;
    
  }
  
  if (counter1 > 0) {
  fill(0, 255);
  noStroke();
  rect((width/2)-100, (height/2)-(x+20), x*8, x*3, 20, 10, 10, 10);
  }
  
  if (counter1 > 1 || recstart == true) {
   fill(255, 150);
   textSize(50);
   
   if (recstart == true) {
     if (milseconds < 59) {
      milseconds +=1; 
     } else if (milseconds == 59) {
      milseconds = 0;
      if (seconds < 59) {
       seconds += 1; 
      } else if (seconds  == 59) {
        seconds = 0;
        minutes += 1; 
       }
      }
     }
   }
   
   mil2seconds = float(milseconds) * 1.667;
   mil3seconds = int(mil2seconds);
   
   if (minutes < 10) {
    sminutes = "0" + str(minutes); 
   } else if (minutes > 9) {
    sminutes = str(minutes); 
   }
   if (seconds < 10) {
    sseconds = "0" + str(seconds); 
   } else if (seconds > 9) {
    sseconds = str(seconds); 
   }
   if (mil3seconds < 10) {
    smilseconds = "0" + str(mil3seconds); 
   } else if (mil3seconds > 9) {
    smilseconds = str(mil3seconds); 
   }
   
   if (counter1 > 1) {
   
   text(sminutes + ":" + sseconds + "." + smilseconds, width/2-100, height/2 - 5);
   
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

void keyPressed() {
  
  
  if (key == 8) {
    
    fileNameReset();
    
  }
  if (key == 66 || key == 98) {
   StartCount1 = 0;
   counter1 = 0;
  }
   
   myOscMessage1.add(filename);
   oscP5.send(myOscMessage1, myRemoteLocation);
   
   println("File2: " + filename);
   println("Start: " + startcount);
   println("Stop: " + stopcount);
}

void mousePressed() {
 
  
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
  ellipse(width/2, height/2, x*1.5, x*1.5);
  StartCount1 = 1;

  println("LOOK FOR THIS " + filename);
  
  myOscMessage1.clearArguments();
  myOscMessage1.add(filename);
  myOscMessage1.print();
  oscP5.send(myOscMessage1, myRemoteLocation);
  

   
   println("File: " + filename);
   println("Start: " + startcount);
   println("Stop: " + stopcount);
   
  }
  
}

void fileNameReset() {
    filename = 1;
    output = createWriter("filename.txt"); 
    startcount = 0;
    stopcount = 0; 
}

void fileIncrement() {
  output.println(filename); // Write the coordinate to the file
  filename ++;
  println("file: " + filename);
  output.flush(); // Writes the remaining data to the file
  startcount = 0;
  stopcount = 0;
  
  myOscMessage2.add(stopcount);
  oscP5.send(myOscMessage2, myRemoteLocation);

}

void fileStart() {
 startcount += 1;
 println("startcount" + startcount);
   
   myOscMessage3.add(1);
   oscP5.send(myOscMessage3, myRemoteLocation);
   stopcount = 0;
   
   myOscMessage2.add(stopcount);
   oscP5.send(myOscMessage2, myRemoteLocation); 
}

void oscEvent(OscMessage theOscMessage) {
  // get and print the address pattern and the typetag of the received OscMessage
  //println("### received an osc message with addrpattern "+theOscMessage.addrpattern()+" and typetag "+theOscMessage.typetag());
  //println("received something...");
  theOscMessage.print();
  String sendtype = theOscMessage.addrPattern();
  println(sendtype);
  if (sendtype.equals("/test")) {
    if (sendmode == 0) {
    stoppress = true;
    sendmode = 1;
    println("stopped and moved on");
    recstart = false;
    } else if (sendmode == 1) {
     println("started recording"); 
     sendmode = 0;
    }
  }
  if (sendtype.equals("/test2")) {
    recstart = true;
    println("TEST2WORKS");
  }
  
}