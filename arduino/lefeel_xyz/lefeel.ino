
//void lefeel_sensor(Adafruit_MPR121 mpr121){
//
//}

//mpr121_begin(row,0x5A);

void mpr121_begin(Adafruit_MPR121 mpr121, byte addr){
  if (!mpr121.begin(addr)) {
    Serial.println("MPR121 : not found at : "+String(addr)+", check wiring?");
    while (1);
  }
  Serial.println("MPR121 : found at : "+String(addr)+"!");
}

void mpr121_static_data(Adafruit_MPR121 mpr121){
  for (uint8_t i=0; i<12; i++) {  
    //row_data[i] = mpr121.filteredData(i);
    //static_row_data[i] = max_row_data[i] = min_row_data[i] = row_data[i];
  }
}
