PImage  imgBackground;

float   lightMap[][]; 
PVector bumpMap[][];

int lightRadius=400;
boolean auto = true;

void setup() {
  size(800, 600);
  imgBackground = loadImage("background.jpg");

  //initVideoCapture(sketchPath("") + "/bumpmap2d.avi",25);

  lightMap = new float[lightRadius*2][lightRadius*2];
  for (int x = 0; x < lightRadius*2; x++)
  {
    for (int y = 0; y < lightRadius*2; y++)
    {
      lightMap[x][y] = constrain((1.0 - sqrt(pow((x - (float)lightRadius) / (float)lightRadius, 2.0) + pow((y - (float)lightRadius) / (float)lightRadius, 2.0))), 0.0, 1.0);
    }
  }

  imgBackground.loadPixels();
  int heightMapThreshold = 160 ;
  float heightMap[][] = new float[imgBackground.width][imgBackground.height];
  for (int x = 0; x < imgBackground.width; x++)
  {
    for (int y = 0; y < imgBackground.height; y++)
    {
      color c = imgBackground.pixels[y*imgBackground.width+x];      
      // convert to grayscale
      //      float lightness = ((max(red(c), green(c), blue(c)) + min(red(c), green(c), blue(c))) / 2.0);
      //      float average = (red(c) + green(c) + blue(c)) / 3.0;
      //      float ntsc = 0.2989*red(c)+0.5870*green(c)+0.1140*blue(c);
      float luminosity =  0.21*red(c) + 0.72*green(c) + 0.07*blue(c);
      heightMap[x][y] = (luminosity < heightMapThreshold) ? 0 : luminosity;
    }
  } 

  bumpMap = new PVector[imgBackground.width][imgBackground.height]; 
  for (int x = 0; x < imgBackground.width; x++)
  {
    for (int y = 0; y < imgBackground.height; y++)
    {
      if (x>0 && x < imgBackground.width - 1 && y>0 && y < imgBackground.height - 1) 
      {
        bumpMap[x][y] = new PVector(heightMap[x-1][y] - heightMap[x+1][y], heightMap[x][y-1] - heightMap[x][y+1]);
      } else { 
        bumpMap[x][y] = new PVector(heightMap[x][y], heightMap[x][y]);
      }
    }
  }
}

void keyPressed() {
  if (keyCode == ' ') {
    auto = !auto;
  }
}

void draw() {
  int timer=millis();

  int lightX=mouseX;
  int lightY=mouseY;
  int lightX2=mouseX;
  int lightY2=mouseY;

  if (auto) {    
    lightX = width/2+int(width/2 * cos(degrees(timer*0.00001)));
    lightY = height/2+int(height/2 * sin(degrees(timer*0.00001)));
    lightX2 = width/2+int(width/2 * cos(degrees(180+(timer*0.00001))));
    lightY2 = height/2+int(height/2 * sin(degrees(180+(timer*0.00001))));
  }

  float modShininess = 1.0;// 2.0+sin(millis()*0.001);
  float modB = 1.0+sin(timer*0.001);
  float modR = 1.0+cos(timer*0.0005);
  
  loadPixels();
  for (int y = 0; y < imgBackground.height; y++)
  {    
    for (int x = 0; x < imgBackground.width; x++)
    {
      int normalx = int(constrain(lightRadius+bumpMap[x][y].x + lightX - x, 0, lightRadius*2-1));
      int normaly = int(constrain(lightRadius+bumpMap[x][y].y + lightY - y, 0, lightRadius*2-1));
      float shininess = map(lightMap[normalx][normaly], 0.0, 1.0, 0.0, modShininess);
      if (auto) {
        int normalx2 = int(constrain(lightRadius+bumpMap[x][y].x + lightX2 - x, 0, lightRadius*2-1));
        int normaly2 = int(constrain(lightRadius+bumpMap[x][y].y + lightY2 - y, 0, lightRadius*2-1));     
        shininess += map(lightMap[normalx2][normaly2], 0.0, 1.0, 0.0, modShininess);
      }

      color col = imgBackground.pixels[y*imgBackground.width+x];                
      pixels[y*imgBackground.width+x] = color(red(col)*shininess*modR, green(col)*shininess, blue(col)*shininess*modB);
    }
  }
  updatePixels();

  //addFrame();
  //saveFrame("output/b#####.jpg");
  surface.setTitle(""+int(frameRate) + "/" + frameCount);
}