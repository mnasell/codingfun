import java.util.*;

PImage btrain;
PImage ctrain;
ArrayList<Particle> activePoints;
ArrayList<Particle> inactivePoints;

int maxParticles = 1500;

void setup() {
  size(800, 600, P2D);  

  activePoints = new ArrayList<Particle>();
  inactivePoints = new ArrayList<Particle>();  

  ctrain = loadImage("unspecified.jpg");  
  ctrain.loadPixels();
  for (int y = 1; y < ctrain.height-1; y+=3) {
    for (int x = 1; x < ctrain.width-1; x+=3) {
      Particle p = new Particle(x, y, ctrain);
      if (p.isRequired()) {
        inactivePoints.add(p);
      }
    }
  }

  // dark to light
  //inactivePoints.sort(new Comparator<Particle>() {
  //  public int compare(Particle a, Particle b) {      
  //    return Integer.compare(int(red(a.matrix[1][1]) + green(a.matrix[1][1]) + blue(a.matrix[1][1]))
  //      , int(red(b.matrix[1][1]) + green(b.matrix[1][1]) + blue(b.matrix[1][1])));
  //  }
  //}
  //);  

  btrain = createImage(ctrain.width, ctrain.height, RGB);    
  btrain.loadPixels();
  for (int y = 0; y<btrain.height; y++) {
    for (int x = 0; x<btrain.width; x++) {
      btrain.pixels[y*btrain.width+x] = color(255);
    }
  }

  btrain.updatePixels();

  //println(""+inactivePoints.size());
}

void draw() {  
  background(btrain);

  while (inactivePoints.size() > 0 && activePoints.size() < maxParticles) {
    //int ri = floor(random(inactivePoints.size())); // a random one
    //int ri = 0;                                       // from the top
    //int ri = inactivePoints.size()-1;              // from the bottom
    int ri = floor(inactivePoints.size() / 2);     // center
    activePoints.add(inactivePoints.get(ri));
    inactivePoints.remove(ri);
  }

  if (activePoints.size() == 0) {
    println("Done!");
    noLoop();
  }

  for (int i = activePoints.size()-1; i>=0; i--) {
    Particle p = activePoints.get(i);            
    p.show();
    if (p.reachedTarget()) {
      p.updateBackground(btrain);
      activePoints.remove(i);
    }
  }

  //saveFrame("output/ct#####.png");
  //surface.setTitle(frameCount + "/" + int(frameRate) + "/" + inactivePoints.size() + "/" + activePoints.size());
}