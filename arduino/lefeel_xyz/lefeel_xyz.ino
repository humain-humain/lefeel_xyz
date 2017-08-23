/* ----------------------------------------------------------------------------------------------------
 * LeFeel (XYZ version), 2017
 * Update: 02/08/17
 * 
 * TODO : print MaxData à la fin d'une session d'utilisation pour connaitre les valeurs
 * 
 * V1.05
 * Written by Bastien DIDIER
 * more info : https://github.com/humain-humain/lefeel
 *
 * ----------------------------------------------------------------------------------------------------
 */ 
 
#include <Wire.h>
#include "Adafruit_MPR121.h"

// You can have up to 4 on one i2c bus
Adafruit_MPR121 row = Adafruit_MPR121();
Adafruit_MPR121 col = Adafruit_MPR121();

// Keeps track of the last pins touched
// so we know when buttons are 'released'
uint16_t lasttouchedROW = 0;
uint16_t currtouchedROW = 0;

uint16_t lasttouchedCOL = 0;
uint16_t currtouchedCOL = 0;

int row_data[12];
int max_row_data[12];
int min_row_data[12];

int col_data[12];
int max_col_data[12];
int min_col_data[12];

int threshold = 15;
int pixel_at_threshold = 0;

void setup() {
  Serial.begin(115200);

  while (!Serial) { // needed to keep leonardo/micro from starting too fast!
    delay(10);
  }
  
  Serial.println("Adafruit MPR121 Capacitive Touch sensor test"); 
  
  // Default address is 0x5A, if tied to 3.3V its 0x5B
  // If tied to SDA its 0x5C and if SCL then 0x5D  
  if (!row.begin(0x5A)) {
    Serial.println("MPR121 : ROW not found, check wiring?");
    while (1);
  }
  Serial.println("MPR121 : ROW found!");
  
  if (!col.begin(0x5B)) {
    Serial.println("MPR121 : COL not found, check wiring?");
    while (1);
  }
  Serial.println("MPR121 : COL found!");

  for (uint8_t i=0; i<12; i++) {
  
    row_data[i] = row.filteredData(i);
    col_data[i] = col.filteredData(i);

    max_row_data[i] = min_row_data[i] = row_data[i];
    max_col_data[i] = min_col_data[i] = col_data[i];
  }
  
  static_data();
  
  Serial.println("lefeel begin…");
}

void loop() {

  //raw / filtered / base / +++
  //lefeel.stream("filtered");
  
  for (uint8_t i=0; i<12; i++) {
    for (uint8_t j=0; j<12; j++) {
      
      row_data[i] = row.filteredData(i);
    
      if(row_data[i] > max_row_data[i]){max_row_data[i]=row_data[i];}
      //else if(row_data[i] < min_row_data[i]){min_row_data[i]=row_data[i];}
    
      col_data[j] = col.filteredData(j);
  
      if(col_data[j] > max_col_data[j]){max_col_data[j]=col_data[j];}
      //else if(col_data[j] < min_col_data[j]){min_col_data[j]=col_data[j];}

      if(map(row_data[i], max_row_data[i],min_row_data[i], 0,9)+map(col_data[j], max_col_data[j],min_col_data[j], 0,9) >= threshold){
        pixel_at_threshold++;  
      }
      
      Serial.print(map(row_data[i], max_row_data[i],min_row_data[i], 0,9)+map(col_data[j], max_col_data[j],min_col_data[j], 0,9));
      Serial.print(",");
    }
  }
  Serial.println(); 

  //TODO
  if(pixel_at_threshold = 0){
    Serial.print("… Static Data");
    static_data();
  }

  pixel_at_threshold=0;
}


void static_data(){

  int nb_sample = 100;
  
  for (uint8_t i=0; i<12; i++) {
    for(uint8_t i=0; i<=nb_sample; i++){
      row_data[i] = row.filteredData(i);
      col_data[i] = col.filteredData(i);
      
      min_row_data[i] += row_data[i];
      min_col_data[i] += col_data[i];
    }
  }

  for (uint8_t i=0; i<12; i++) {    
      min_row_data[i] = min_row_data[i]/nb_sample;
      min_col_data[i] = min_col_data[i]/nb_sample;
  }
}
