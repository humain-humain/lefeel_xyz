## lefeel XYZ

#### Draw sensors matrix

![Draw sensors matrix](../img/matrice1.gif)

```java
for(int i=0; i<=maxNumberOfSensors-1; i++){
	if(i % cols == 0 && i != 0){
		addCols++;
		addRow = 0;
	}
	fill(sensorValue[i]);
	rect((width/2-mapWidth/2)+addRow*rectSize, (height/2-mapHeight/2)+addCols*rectSize, rectSize,rectSize);
	addRow++;
}  
```

#### Draw points where pressure is high

![Draw points where pressure is high](../img/matrice2.gif)

```java
int threshold = 180;
int thresholdCount = 0;

if(sensorValue[i] > threshold){
  fill(168,223,242);
  rect(((width/2-mapWidth/2)+addRow*rectSize), ((height/2-mapHeight/2)+addCols*rectSize), rectSize,rectSize);
  thresholdCount++;
}
```

#### Search for the barycenter of these points

![Search for the barycenter of these points](../img/barycentre.gif)

```java
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
   
   thresholdCount++;
  }
   addRow++;
}

//Barycentre
barycentreX = barycentreX/thresholdCount;
barycentreY = barycentreY/thresholdCount;
println("x : "+barycentreX+" y : "+barycentreY);
```