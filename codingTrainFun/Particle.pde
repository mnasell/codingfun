class Particle {    
  PVector target;
  color[][] matrix;

  ArrayList<PVector> path; 
  int pathcount;

  Particle(int x, int y, PImage img) {    
    target = new PVector(x, y);
    matrix = new color[3][3];
    for (int i = -1; i<=1; i++) {
      for (int j = -1; j<=1; j++) {
        matrix[i+1][j+1] = img.pixels[(y+i) * img.width + (x+j)];
      }
    }

    PVector pos;    
    //random startpos
    //int startingPosition = int(random(4)); 
    //if (startingPosition == 0) {
    //  pos = new PVector(floor(width/2), 0);
    //} else if (startingPosition == 1) {
    //  pos = new PVector(floor(width/2), height);
    //} else if (startingPosition == 2) {
    //  pos = new PVector(0, floor(height/2));
    //} else {
    //  pos = new PVector(width, floor(height/2));
    //}

    pos = new PVector(random(width/2-20, width/2+20), height+10);

    int steps = 50+int(random(50));
    pathcount = 0;
    path=new ArrayList<PVector>();

    float x1;
    float x2;
    float y1;
    float y2;

    if (target.x > width/2) {
      x1 = random(width/2);
      x2 = (width/2)+random(width/2);
    } else {
      x1 = (width/2)+random(width/2);
      x2 = random(width/2);
    }

    y1 = target.y/2;
    y2 = target.y;

    for (int j = 0; j <= steps; j++) {
      float t  = j / float(steps);
      float px = bezierPoint(pos.x, x1, x2, target.x, t);
      float py = bezierPoint(pos.y, y1, y2, target.y, t);
      path.add(new PVector(px, py));
    }
  }

  boolean isRequired() {
    boolean req = false;
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        if ( matrix[i][j] != color(255)) {
          req = true;
        }
      }
    }  
    return req;
  }

  void updateBackground(PImage back) {
    back.loadPixels();
    for (int i = -1; i <=1; i++) {
      for (int j = -1; j <=1; j++) {
        back.pixels[int((target.y+i)*back.width+(target.x+j))] = matrix[i+1][j+1];
      }
    }
    back.updatePixels();
  }

  boolean reachedTarget() {
    return pathcount >= path.size()-1;
  }

  void show() {           
    strokeWeight(2);
    for (int i = 2; i >= 0; i--) {
      if (pathcount-i > 1) {
        stroke(matrix[1][1], 100);
        line(path.get(pathcount-i-1).x, path.get(pathcount-i-1).y, path.get(pathcount-i).x, path.get(pathcount-i).y);
      }
    }

    fill(matrix[1][1], 100);    
    noStroke();
    ellipse(path.get(pathcount).x, path.get(pathcount).y, 4, 4);

    if (!reachedTarget())
      pathcount++;
  }
}