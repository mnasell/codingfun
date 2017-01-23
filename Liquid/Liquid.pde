PImage  imgBackground;
PImage  imgBuffer;

float[]   screenBuffer;
float[]   backBuffer;

int     refractionWidth;
int     dripSize;
float   dripIntensity;
float   damping;

PVector mover;
int     auto = 0;

boolean dragged = false;

void setup() {
  size(800, 600);

  dripSize = 12;
  dripIntensity = 24;
  damping  = 0.98f;
  refractionWidth = 4;

  mover = new PVector(width/2, height/2, 1);

  imgBackground = loadImage("back4_800x600.jpg");  
  imgBackground.loadPixels();

  imgBuffer = createImage(imgBackground.width, imgBackground.height, RGB);

  screenBuffer  = new float[imgBuffer.width * imgBuffer.height];
  backBuffer = new float[imgBuffer.width * imgBuffer.height];
}

void mouseReleased() {
  dragged = false;
}

void mouseDragged() {
  if (dragged)
  {
    drip(mouseX, mouseY, dripIntensity);
  }
}

void mousePressed() {
  dragged = true;
  drip(mouseX, mouseY, dripIntensity);
}

void keyPressed() {
  if (key == ' ') 
  {
    if (++auto > 2) {
      auto = 0;
    }
  }
}

void drip(int x, int y, float intensity) {  
  for (int j = y - dripSize; j < y + dripSize; j++)
  {
    for (int i = x - dripSize; i < x + dripSize; i++)
    {
      if (j > 0 && i > 0 && j < imgBuffer.height && i < imgBuffer.width)
      {        
        float d = (pow(i - x, 2) + pow(j - y, 2));
        if (d < dripSize*dripSize)
        {
          float depth = intensity * (dripSize - sqrt(d)) / dripSize;                    
          backBuffer[j*imgBuffer.width+i] = depth;
        }
      }
    }
  }
}

void updateHeightmap() {  
  for (int y = 2; y < imgBuffer.height - 2; y++)
  {
    for (int x = 2; x < imgBuffer.width - 2; x++)
    {
      float mean = (
        screenBuffer[(y)*imgBuffer.width+(x-2)]
        + screenBuffer[(y)*imgBuffer.width+(x+2)]
        + screenBuffer[(y-2)*imgBuffer.width+(x)]
        + screenBuffer[(y+2)*imgBuffer.width+(x)]
        + screenBuffer[(y)*imgBuffer.width+(x-1)]
        + screenBuffer[(y)*imgBuffer.width+(x+1)]
        + screenBuffer[(y-1)*imgBuffer.width+(x)]
        + screenBuffer[(y+1)*imgBuffer.width+(x)]
        + screenBuffer[(y-1)*imgBuffer.width+(x-1)]
        + screenBuffer[(y-1)*imgBuffer.width+(x+1)]
        + screenBuffer[(y+1)*imgBuffer.width+(x-1)]
        + screenBuffer[(y+1)*imgBuffer.width+(x+1)]
        ) / 6.0;

      backBuffer[y*imgBuffer.width+x] = constrain((mean-backBuffer[y*imgBuffer.width+x])*damping, -127.0, 127.0);
    }
  }
}

void applyHeightmap() {

  float[] temp = screenBuffer;
  screenBuffer = backBuffer;
  backBuffer = temp;

  imgBuffer.loadPixels();

  for (int j = 0; j < imgBuffer.height; j++) 
  {
    for (int i = 0; i < imgBuffer.width; i++) 
    {      
      float offsetX = i;
      float offsetY = j;
      int index = j*imgBuffer.width+i;

      if (i > refractionWidth && i < imgBuffer.width-refractionWidth) 
      {
        offsetX -= screenBuffer[index - refractionWidth];
        offsetX += screenBuffer[index + refractionWidth];
      }

      if (j > refractionWidth && j < imgBuffer.height - refractionWidth) 
      {
        offsetY -= screenBuffer[index - refractionWidth*imgBuffer.width];
        offsetY += screenBuffer[index + refractionWidth*imgBuffer.width];
      }

      offsetX=constrain(offsetX, 0, imgBuffer.width-1);
      offsetY=constrain(offsetY, 0, imgBuffer.height-1);

      color col = imgBackground.pixels[int(offsetY)*imgBuffer.width+int(offsetX)];

      float boost = (screenBuffer[index] > 0 ? 3.0*screenBuffer[index] : screenBuffer[index]);
      int r = constrain(int(boost + red(col)), 0, 255);
      int g = constrain(int(boost + green(col)), 0, 255);
      int b = constrain(int(boost + blue(col)), 0, 255);

      imgBuffer.pixels[index] = color(r, g, b);
    }
  }
  imgBuffer.updatePixels();
}

void update() {    

  if (auto == 1) 
  {    
    mover.z = (height*0.4) * abs(cos(frameCount/240.0));
    mover.x = mover.z * cos(frameCount*8.0*PI/180.0);
    mover.y = mover.z * sin(frameCount*8.0*PI/180.0);     
    drip(int(width/2+mover.x), int(height/2+mover.y), random(20, 50));
  } 
  else if (auto == 2) 
  {
    drip(int(random(1, imgBuffer.width-1)), int(random(1, imgBuffer.height-1)), random(20, 50));
  }

  updateHeightmap();
  applyHeightmap();
}

void draw() {
  update();
  background(imgBuffer);  

  surface.setTitle(""+int(frameRate) + "/" + frameCount);

  //saveFrame("output/codingrain#####.png");
}