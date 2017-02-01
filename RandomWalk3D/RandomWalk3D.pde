import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam cam;
ArrayList<PVector> buffer;
int boxHalfWidth = 40;

void setup() {
  size(600, 600, P3D);
  colorMode(HSB, 255);
  
  cam = new PeasyCam(this, 0, 0, 0, 150);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(200);
  cam.setWheelScale(1);

  buffer = new ArrayList<PVector>();
  buffer.add(new PVector(0, 0, 0));
}

void update() {
  background(0);
  PVector pos = buffer.get(buffer.size()-1).copy();
  if (random(100) < 1) {
    pos.add(PVector.random3D().mult(random(5, 30)));
  } else {
    pos.add(PVector.random3D());
  }
  
  checkBounds(pos);
  surface.setTitle(""+buffer.size());    
  buffer.add(pos); 
}

void checkBounds(PVector pos) {
  if (pos.x < -boxHalfWidth) {
    pos.x = -boxHalfWidth;
  } else if (pos.x > boxHalfWidth) {
    pos.x = boxHalfWidth;
  }   

  if (pos.y < -boxHalfWidth) {
    pos.y = -boxHalfWidth;
  } else if (pos.y > boxHalfWidth) {
    pos.y = boxHalfWidth;
  }

  if (pos.z < -boxHalfWidth) {
    pos.z = -boxHalfWidth;
  } else if (pos.z > boxHalfWidth) {
    pos.z = boxHalfWidth;
  }
}

void draw() {
  update();

  cam.rotateY(0.002);
  cam.rotateX(0.003);
  strokeWeight(1);
  stroke(0, 0, 255, 30);   
  line(0, -boxHalfWidth, 0, 0, boxHalfWidth, 0);
  line(-boxHalfWidth, 0, 0, boxHalfWidth, 0, 0);
  line(0, 0, -boxHalfWidth, 0, 0, boxHalfWidth);
  noFill();
  box(boxHalfWidth*2);

  beginShape();
  for (int  p=buffer.size()-1; p >= 0; p--) {        
      stroke((p/10.0)%255, 255, 255);
      vertex(buffer.get(p).x,buffer.get(p).y,buffer.get(p).z);
  }
  endShape();
  
  if (buffer.size() > 10000) {
    buffer.remove(0);
  }
}