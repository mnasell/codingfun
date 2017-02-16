/* Plasma Demo */
String fontname = "Arial Black";
String message="... HALLO CODINGTRAIN COMMUNITY ... ALWAYS HAPPY CODING ... GREETINGS TO ALL ... AND HAVE A GREAT DAY ... SPECIAL THANKS TO DAN FOR HIS GREAT WORK ...              ";
float msgidx = 0;
float charWidth;

float[][] plasma;
color[][] palette;
// use for palette fading
//color[]currPalette;
//int currPaletteIndex=0;
//int prevpaletteCounter=0;

int paletteCounter=0;

int halfWidth;
int halfHeight;

boolean showPalette=false;

void setup() {
  size(960, 540);

  halfWidth=width/2;
  halfHeight=height/2;

  // Generate Palette
  palette = new color[12][256];

  //palette[0] = randomPalette(5);
  // Rainbow coding colors  
  palette[0] = createPalette(color(211, 3, 201), color(122, 3, 229), color(3, 104, 255), color(3, 188, 63), color(255, 255, 3), color(255, 127, 3), color(255, 3, 3), color(211, 3, 201));   
  palette[1] = createPalette(color(232, 0, 232)
                            , color(243, 175, 243)
                            , color(232, 0, 232)
                            , color(243, 175, 243)
                            , color(232, 0, 232));

  palette[3] = createPalette(color(0, 0, 255)
                            ,color(255, 128, 64)
                            ,color(0, 0, 255)
                            ,color(255, 128, 64)
                            , color(0, 0, 255));
                            
  palette[5] = createPalette(color( 0, 0, 0)
                            , color(0, 0, 128)
                            , color(255, 0, 0)
                            , color(255, 255, 0)
                            , color(255, 255, 255)
                            , color(255, 255, 0)
                            , color(255, 0, 0)
                            , color(0, 0, 128)
                            , color( 0, 0, 0)                            
                            );

  
  for (int i = 0; i<palette[1].length; i++) {
    palette[2][i] = color(128.0 + 128 * sin(PI * i / 128.0), 0, 128.0 + 128 * cos(PI * i / 128.0));      
    palette[4][i] = color(128.0 + 128 * sin(PI * i / 32.0), 128.0 + 128 * sin(PI * i / 64.0), 128.0 + 128 * sin(PI * i / 128.0));
    colorMode(HSB);     
    palette[6][i] = color(i, 255, 255);    
    colorMode(RGB);    
    palette[7][i] = color(0, 128.0 + 128 * sin(PI * i / 128.0), 128.0 + 128 * cos(PI * i / 128.0));
    palette[8][i] = color(128.0 + 128 * sin(PI * i / 64.0), 0, 0);    
    palette[9][i] = color(128.0 - 128 * sin(PI * i /128.0), 128.0  - 128 * sin(PI * i / 64.0), 128.0 + 128 * sin(PI * i / 32.0));        
    palette[10][i] = color(0, 128.0 + 128 * sin(PI * i / 64.0), 0);    
    palette[11][i] = color(0, 0, 128.0 + 128 * sin(PI * i / 64.0));    
  } 
  
  // init if palette fading
  //currPalette = new color[256];
  //for (int i = 0;i<currPalette.length;i++) {
  //  currPalette[i] = palette[0][i]; 
  //}

  // generate Plasma Waves
  plasma = new float[4][width*height*4];   
  for (int y = 0; y < height*2; y++) {
    for (int x = 0; x < width*2; x++) {
      plasma[0][(y*width*2)+x] = (128.0 + (128.0 * sin(x / 64.0)));
      plasma[1][(y*width*2)+x] = (128.0 + (128.0 * sin(y / 128.0)));             
      plasma[2][(y*width*2)+x] = (128.0 + (128.0 * sin((x + y) / 128.0)));
      plasma[3][(y*width*2)+x] = (128.0 + (128.0 * sin(sqrt((x - width) * (x - width) + (y - height) * (y - height)) / 64.0)));
    }
  }

  fontname = "DF Scratch";  
  PFont myFont = createFont(fontname, 60);
  textFont(myFont);  
  textAlign(CENTER, CENTER);
  charWidth=textWidth("O");
}

void keyReleased() {
  // Switch to next palette
  if (key == 'p') {
    paletteCounter = (paletteCounter+1) % palette.length;
  }

  // Shows palette at the top
  if (key == 's') {
    showPalette=!showPalette;
  }

  if(key == 'r') {
    palette[0] = randomPalette(int(random(2,8)));
  }

  // choose a random font
  if (key == 'f') {
    String[] fontlist = PFont.list();
    fontname = fontlist[int(random(fontlist.length))];
    PFont myFont = createFont(fontname, 60);
    textFont(myFont);  
    textAlign(CENTER, CENTER); 
    charWidth=textWidth("O");
  }
}

void draw() {
  int timer = floor(millis()*0.025);
  int paletteShift = int(timer*10); 

  // fading one palette into another . makes only sense if the palettes have aligned colors 
  //if (prevpaletteCounter != paletteCounter) {
  //  for (int i = 1; i < currPalette.length;i++) {
  //    currPalette[i-1] = currPalette[i];
  //  }
  //  currPalette[currPalette.length-1] = palette[paletteCounter][currPaletteIndex];
  //  currPaletteIndex++;
  //  if (currPaletteIndex > 255) {
  //    currPaletteIndex=0;
  //    prevpaletteCounter = paletteCounter;      
  //    paletteCounter = (paletteCounter+1) % palette.length;
  //  }
  //}  

  // Draw Plasma
  loadPixels();
  int shiftx1=floor(halfWidth+halfWidth*sin(radians(timer)));
  int shifty1=halfHeight;

  int shiftx2=halfWidth;
  int shifty2=floor(halfHeight+halfHeight*sin(radians(timer)));

  int shiftx3=halfWidth;
  int shifty3=floor(halfHeight+halfHeight*sin(radians(timer*2.0)));

  int shiftx4=floor(halfWidth+halfWidth*sin(radians(timer*2.0)));
  int shifty4=floor(halfHeight+halfHeight*cos(radians(timer)));

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int idx=y*width+x;        
      int idx1=((y+shifty1)*(width*2))+x+shiftx1;
      int idx2=((y+shifty2)*(width*2))+x+shiftx2;
      int idx3=((y+shifty3)*(width*2))+x+shiftx3;
      int idx4=((y+shifty4)*(width*2))+x+shiftx4;
      // pixels[idx] =  currPalette[ // palette fading
      pixels[idx] =  palette[paletteCounter][      
        (( floor(plasma[0][idx1])
        +floor(plasma[1][idx2])
        +floor(plasma[2][idx3])
        +floor(plasma[3][idx4])
        )+paletteShift)%256];
    }
  }
  updatePixels();

  // Dim Background behind text
  noStroke();
  fill(0, 150);
  beginShape(TRIANGLE_STRIP);  
  vertex(width, halfHeight+(cos(timer/6.0)*(height/4.0)*(sin(timer/100.0)))-50); 
  for (int j=1; j<message.length(); j++) {      
    int idx = j-1;         
    float x = width-idx*charWidth;
    float y = halfHeight+(cos((timer+idx)/6.0)*(height/4.0)*(sin(timer/100.0)));
    vertex(x, y+50);
    idx = j;         
    x = width-idx*charWidth;
    y = halfHeight+(cos((timer+idx)/6.0)*(height/4.0)*(sin(timer/100.0)));
    vertex(x, y-50);
  }
  endShape();

  // Draw Text along sine
  fill(255);    
  for (int j=0; j<message.length(); j++) {      
    char c = message.charAt(message.length()-1-j);
    float idx = (msgidx+j)%message.length();      
    float x = width-(idx*charWidth);
    float y = halfHeight+(cos((timer+idx)/6.0)*(height/4.0)*(sin(timer/100.0)));
    if (x>0 && x < width) {
      pushMatrix();    
      translate(x, y); 
      text(c, 0, 0);
      popMatrix();
    }
  }

  //// draw palette at top
  if (showPalette) {    
    float step = (float)width/(float)palette[paletteCounter].length;  
    fill(0);
    stroke(0);
    rect(0, 0, width, step*4);  
    for (int i=0; i < palette[paletteCounter].length; i++) {
      fill(palette[paletteCounter][i]);
      stroke(palette[paletteCounter][i]);
      // for palette fading use this
      //fill(currPalette[i]); 
      //stroke(currPalette[i]);           
      rect(i*step, step, step, step*2);
    }
  }


  msgidx+=0.1; // shifts message
  if (msgidx > message.length()) {
    msgidx=0;    
    //paletteCounter = (paletteCounter+1) % palette.length;
  }
  
  surface.setTitle(fontname + " / " + paletteCounter + " / " + int(frameRate));
}

//-----------------------------------------------------------------------------------------
// Helper to create a colorramp
color[] createPalette(color... colors) {
  color[] ret = new color[256];  
  if (colors.length < 2) {
    println("createPalette: needs at least two colors");
    return ret;
  }

  int split = 256/(colors.length-1);
  int idx=0;
  for (int i = 0; i < ret.length; i++) {
    ret[i] = lerpColor(colors[idx], colors[idx+1], map(i, split*(idx), split*(idx+1), 0.0, 1.0));
    if (i > split*(idx+1) && (idx+2) < colors.length) {
      idx++;
    }
  }
  return ret;
}

color[] randomPalette(int amount) {
  color[] tmp = new color[amount+1];
  for (int i = 0;i<amount;i++) {
    tmp[i] = color(random(255),random(255),random(255));
  }
  tmp[amount] = tmp[0];
  
  println("------------------------");
  for (int i=0;i < tmp.length;i++) {
    println("color(" + red(tmp[i]) + ",",green(tmp[i]) + ",",blue(tmp[i]) + ")");
  }
  
  return createPalette(tmp);
}
