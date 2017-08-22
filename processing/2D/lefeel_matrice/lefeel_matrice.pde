/* ----------------------------------------------------------------------------------------------------
 * LeFeel (XYZ version), 2017
 * Update: 22/08/17
 * 
 * V0
 * Written by Bastien DIDIER
 * more info : https://github.com/humain-humain/lefeel
 *
 * ----------------------------------------------------------------------------------------------------
 */ 

import org.gwoptics.graphics.graph2D.Graph2D;
import org.gwoptics.graphics.graph2D.traces.Blank2DTrace;

import processing.serial.*;
Serial myPort;

int rectSize = 30;
int row = 12;
int cols = 12;

int addRow = 0;
int addCols = 0;

int mapWidth = rectSize*row;
int mapHeight = rectSize*cols;

int maxNumberOfSensors = row*cols;     
float[] sensorValue = new float[maxNumberOfSensors];    // global variable for storing mapped sensor values
//float[] previousValue = new float[maxNumberOfSensors];  // array of previous values

float barycentreX,barycentreY,last_barycentreX,last_barycentreY;
int ellipsCount = 0;

int threshold = 180;

/***************************/

Graph2D g;
int graph_size = 350;

void setup(){
  size(600,600, P2D);
  //fullScreen(P2D);
  
  String portName = "/dev/cu.usbmodem1421";
  myPort = new Serial(this, portName, 115200);
  myPort.clear();
  myPort.bufferUntil('\n');  // don't generate a serialEvent() until you get a newline (\n) byte

  graph_setup();
}
    
void draw(){
  background(255);
  g.draw();
  
  for(int i=0; i<=maxNumberOfSensors-1; i++){
    if(i % cols == 0 && i != 0){
      addCols++;
      addRow = 0;
    }

    noStroke();
    fill(sensorValue[i]);
    rect((width/2-mapWidth/2)+addRow*rectSize, (height/2-mapHeight/2)+addCols*rectSize, rectSize,rectSize);
    
    if(sensorValue[i] > threshold){
      
      barycentreX += ((width/2-mapWidth/2)+addRow*rectSize)+rectSize/2;
      barycentreY +=((height/2-mapHeight/2)+addCols*rectSize)+rectSize/2;
      
      //fill(168,223,242);
      //rect(((width/2-mapWidth/2)+addRow*rectSize), ((height/2-mapHeight/2)+addCols*rectSize), rectSize,rectSize);
      
      ellipsCount++;
    }
    addRow++;
  }
  
  //Barycentre
  barycentreX = barycentreX/ellipsCount;
  barycentreY = barycentreY/ellipsCount;
  println("x : "+barycentreX+" y : "+barycentreY);
  
  /*if (Float.isNaN(barycentreX)){
    barycentreX = width/2-graph_size/2;
  } else if (Float.isNaN(barycentreY)){
    barycentreY = height/2-graph_size/2;
  }*/
  
  stroke(244,155,157);
  strokeWeight(3);
  line(barycentreX+10,barycentreY,barycentreX-10,barycentreY);
  line(barycentreX,barycentreY+10,barycentreX,barycentreY-10);
  
  stroke(168,223,242);
  line(last_barycentreX,last_barycentreY,barycentreX,barycentreY);

  
  addRow = 0;
  addCols = 0;
  ellipsCount = 0;
  
  //if (barycentreX != Float.NaN){
    last_barycentreX = barycentreX;
  //} else if (barycentreY != Float.NaN){
    last_barycentreY = barycentreY;
  //}
  
  barycentreX = 0;
  barycentreY = 0;
}

void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');  // get the ASCII string

  if (inString != null) {  // if it's not empty
    
    inString = trim(inString);  // trim off any whitespace
    try{
      int incomingValues[] = int(split(inString, ","));
      for (int i = 0; i < incomingValues.length; i++) {
        sensorValue[i] = map(incomingValues[i], 0, 20, 0, 255);
      }
    } catch(Exception e){
      //e.printStackTrace();
    }
  }
}
 
void graph_setup(){
  g = new Graph2D(this, graph_size,graph_size, true);
  //g.setAxisColour(0,0,0);
  //g.setFontColour(0,0,0);
        
  g.position.y = width/2-graph_size/2;
  g.position.x = height/2-graph_size/2;
        
  g.setYAxisTickSpacing(1f);
  g.setXAxisTickSpacing(1f);
  //g.setXAxisMinorTicks(1);
    
  g.setYAxisMin(0f);
  g.setYAxisMax(12f);
  g.setYAxisLabelAccuracy(0);
  
  g.setXAxisMin(0f);
  g.setXAxisMax(12f);
  g.setXAxisLabelAccuracy(0);
}