/* Plasma Demo ... */
// Message stuff
String fontname = "Arial Black";
String message="--- HELLO CODINGTRAIN COMMUNITY ... ALWAYS HAPPY CODING ... GREETINGS TO ALL ... AND HAVE A GREAT DAY ... SPECIAL THANKS TO \"DAN\" FOR HIS GREAT WORK ---                ";
float msgidx = 0;
float charWidth;

// Plasma Stuff
float[][] plasma;

// Palette Stuff
color[] palette;
boolean showPalette=false;

// helping Vars
int halfWidth;
int halfHeight;
int doubleWidth;
int doubleHeight;

void setup() {
  size(1024, 576); 

  halfWidth=width/2;
  halfHeight=height/2;
  doubleWidth=width*2;
  doubleHeight=height*2;

  // Generate a Rainbow Palette
  palette = createPalette(color(211, 3, 201), color(122, 3, 229), color(3, 104, 255), color(3, 188, 63), color(255, 255, 3), color(255, 127, 3), color(255, 3, 3), color(211, 3, 201));

  // Generate Plasma Waves double of screen width and height, so they can be easily moved arround 
  plasma = new float[4][doubleWidth*doubleHeight];   
  for (int y = 0; y < doubleHeight; y++) {
    for (int x = 0; x < doubleWidth; x++) {      
      // Vertical
      plasma[0][y*doubleWidth+x] = (128.0 + (128.0 * sin(x / 64.0)));
      // Horizontal
      plasma[1][y*doubleWidth+x] = (128.0 + (128.0 * sin(y / 128.0)));
      // Diagonal
      plasma[2][y*doubleWidth+x] = (128.0 + (128.0 * sin((x + y) / 128.0)));
      // Centric
      plasma[3][y*doubleWidth+x] = (128.0 + (128.0 * sin(sqrt((x - width) * (x - width) + (y - height) * (y - height)) / 64.0)));
    }
  }

  // choose a cool font
  fontname = "DF Scratch";  
  textFont(createFont(fontname, 60));  
  textAlign(CENTER, CENTER);
  // constant width for chars
  charWidth=textWidth("O"); 
}

void keyReleased() {
  // Shows palette on top of screen
  if (key == 's') {
    showPalette=!showPalette;
  }

  // create a new random palette
  if (key == 'p') {
    palette = randomPalette(int(random(2, 8)));
  }

  // choose a random font
  if (key == 'f') {
    String[] fontlist = PFont.list();
    fontname = fontlist[int(random(fontlist.length))];
    textFont(createFont(fontname, 60));  
    textAlign(CENTER, CENTER); 
    charWidth=textWidth("O");
  }
}

void draw() {
  int pseudoTimer = frameCount/3; // a simple dummy timer
  int paletteShift = int(pseudoTimer*10); // rotate palette 

  // Draw Plasma
  loadPixels();
  // shift vertical stripes periodically left and right
  int plasmaShiftX0=floor(halfWidth+halfWidth*sin(radians(pseudoTimer)));
  int plasmaShiftY0=halfHeight;

  // shift horizontally stripes periodically up and down
  int plasmaShiftX1=halfWidth;
  int plasmaShiftY1=floor(halfHeight+halfHeight*sin(radians(pseudoTimer)));

  // rotation circle/elliptic clockwise
  int plasmaShiftX2=floor(halfWidth+halfWidth*cos(radians(pseudoTimer)));
  int plasmaShiftY2=floor(halfHeight+halfHeight*sin(radians(pseudoTimer)));

  // rotate centric/elliptic in an eight shaped way anti clockwise
  int plasmaShiftX3=floor(halfWidth+halfWidth*sin(radians(pseudoTimer*2.0)));
  int plasmaShiftY3=floor(halfHeight+halfHeight*cos(radians(pseudoTimer)));

  // aggregate the several plasma images to screen, and also shift the palette 
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int tgtPos=y*width+x;        
      int srcPos0=((y+plasmaShiftY0)*doubleWidth)+x+plasmaShiftX0;
      int srcPos1=((y+plasmaShiftY1)*doubleWidth)+x+plasmaShiftX1;
      int srcPos2=((y+plasmaShiftY2)*doubleWidth)+x+plasmaShiftX2;
      int srcPos3=((y+plasmaShiftY3)*doubleWidth)+x+plasmaShiftX3;
      pixels[tgtPos] =  palette[(floor(plasma[0][srcPos0] + plasma[1][srcPos1] + plasma[2][srcPos2] + plasma[3][srcPos3])+paletteShift)%256];
    }
  }
  updatePixels();

  // Dim Background behind text in shape
  noStroke();
  fill(0, 150);
  beginShape(TRIANGLE_STRIP);  
  vertex(width, halfHeight+(sin(pseudoTimer/6.0)*(height>>2)*(sin(pseudoTimer*0.01)))-50); 
  for (int j=1; j<message.length(); j++) {      
    int idx = j-1;         
    float x = width-idx*charWidth;
    float y = halfHeight+(sin((pseudoTimer+idx)/6.0)*(height>>2)*(sin(pseudoTimer*0.01)));
    vertex(x, y+50);
    idx = j;         
    x = width-idx*charWidth;
    y = halfHeight+(sin((pseudoTimer+idx)/6.0)*(height>>2)*(sin(pseudoTimer*0.01)));
    vertex(x, y-50);
  }
  endShape();

  // Draw Text along sine with variations
  fill(255);    
  for (int j=0; j<message.length(); j++) {      
    char c = message.charAt(message.length()-1-j);
    float idx = (msgidx+j)%message.length();      
    float x = width-(idx*charWidth);
    float y = halfHeight+(sin((pseudoTimer+idx)/6.0)*(height>>2)*(sin(pseudoTimer*0.01)));
    if (x>0 && x < width) {
      pushMatrix();    
      translate(x, y); 
      text(c, 0, 0);
      popMatrix();
    }
  }

  //// draw palette at top if enabled
  if (showPalette) {    
    float step = (float)width/(float)palette.length;  
    fill(0);
    stroke(0);
    rect(0, 0, width, step*4);  
    for (int i=0; i < palette.length; i++) {
      fill(palette[i]);
      stroke(palette[i]);
      rect(i*step, step, step, step*2);
    }
  }

  // increment the message movement, and choose a new random palette
  msgidx+=0.1; // shifts message
  if (msgidx > message.length()) {
    msgidx=0;    
    palette = randomPalette(int(random(2, 8)));
  }
        
  // surface.setTitle(fontname + " / " + int(frameRate));
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

// Helper to create a random palette of an amount of colors
color[] randomPalette(int amount) {
  color[] tmp = new color[amount+1];
  for (int i = 0; i<amount; i++) {
    tmp[i] = color(random(255), random(255), random(255));
  }
  tmp[amount] = tmp[0];
  //println("------------------------");
  //for (int i=0; i < tmp.length; i++) {
  //  println("color(" + red(tmp[i]) + ",", green(tmp[i]) + ",", blue(tmp[i]) + ")");
  //} 
  return createPalette(tmp);
}
