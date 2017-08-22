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

import org.gwoptics.graphics.*;
import org.gwoptics.graphics.camera.*;
import org.gwoptics.graphics.graph3D.*;
import org.gwoptics.graphics.graph3D.SquareGridMesh;
import org.gwoptics.graphics.GWColour; 

Camera3D cam;
SurfaceGraph3D g3d;
SquareGridMesh sMesh;
GWColour fillColour;

import processing.serial.*;
Serial myPort;

int row = 12;
int cols = 12;

int addRow = 0;
int addCols = 0;

int maxNumberOfSensors = row*cols;     
float[] sensorValue = new float[maxNumberOfSensors];    // global variable for storing mapped sensor values

void setup() {
  size(600, 600, OPENGL); 

  cam = new Camera3D(this);
  PVector cam_pos = new PVector(400f,400f,400f);
  cam.setPosition(cam_pos);

  String portName = "/dev/cu.usbmodem1421";
  myPort = new Serial(this, portName, 115200);
  myPort.clear();
  myPort.bufferUntil('\n');  // don't generate a serialEvent() until you get a newline (\n) byte

  // Constructor arguments are:
  // PApplet parent, float xLength, float yLength, float zLength
  g3d = new SurfaceGraph3D(this, 500, 500,200);    
  
  /*g3d.setYAxisTickSpacing(1f);
  g3d.setXAxisTickSpacing(1f);
  g3d.setZAxisTickSpacing(1f);*/
  
  g3d.setXAxisMin(0);    
  g3d.setXAxisMax(12);
  g3d.setZAxisMin(0);
  g3d.setZAxisMax(20);    
  g3d.setYAxisMin(0);    
  g3d.setYAxisMax(12);
  
  g3d.setXAxisLabelAccuracy(0);
  g3d.setYAxisLabelAccuracy(0);
  g3d.setZAxisLabelAccuracy(0);
  
  sMesh = new SquareGridMesh(11,11,46,46,this);
}

void draw() {
  for(int i=0; i<=maxNumberOfSensors-1; i++){
    if(i % cols == 0 && i != 0){
      addCols++;
      addRow = 0;
    }
    
    sMesh.setZValue(addRow,addCols,sensorValue[i]);
    sMesh.setVertexColour(addRow,addCols,new GWColour(255,0,255));
    
    addRow++;
  }
  
  addRow = 0;
  addCols = 0;
  
  background(255);
  pushMatrix();
  // centre the graph for rotating
  translate(-250,0,-250);
  g3d.draw();
  
  fill(0,255,0);
  sMesh.draw();
  popMatrix();
}

void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');  // get the ASCII string

  if (inString != null) {  // if it's not empty
    
    inString = trim(inString);  // trim off any whitespace
    try{
      int incomingValues[] = int(split(inString, ","));
      for (int i = 0; i < incomingValues.length; i++) {
        
        if(incomingValues[i] > 10 && incomingValues[i] < 20){
          sensorValue[i] = map(incomingValues[i], 10, 20, 0, 255);
        } else {
          sensorValue[i] = 0;
        }
      }
    } catch(Exception e){
      //e.printStackTrace();
    }
  }
}