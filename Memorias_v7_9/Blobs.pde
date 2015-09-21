class Blobs {

  PImage img;
  OpenCV oCv;

  int thr = 175;
  PImage src, prev;
  ArrayList<Contour> contours;
  ArrayList<PVector> points;
  ArrayList<PVector> centroids = new ArrayList<PVector>();
  ArrayList<Integer> areas = new ArrayList<Integer>();
  PVector ratio2FullScreen;
  int w = 320;
  int h = 240;

  //-----------------
  Blobs(OpenCV _cv) {
    oCv = _cv;
    contours = _cv.findContours(true, true);
    ratio2FullScreen = new PVector(float(width)/float(w), float(height)/float(h));
  }

  //-----------------
  Blobs(OpenCV _cv, int _w, int _h) {
    oCv = _cv;
    contours = _cv.findContours(true, true); 
    w = _w;
    h = _h;
    ratio2FullScreen = new PVector(float(width)/float(w), float(height)/float(h));
  }

  //-----------------
  void findBlobs() {
    oCv.threshold(thr);
    //image((PImage)oCv.getOutput(), 0, 0);
    src = (PImage)oCv.getOutput();
    contours = oCv.findContours();
    //image((PImage)oCv.getOutput(), 0, 0);
    centroids.clear();
    areas.clear();

    for (Contour contour : contours) {

      Rectangle rect = contour.getBoundingBox();
      float rx = (float)rect.getX();
      float ry = (float)rect.getY();
      float rw = (float)rect.getWidth();
      float rh = (float)rect.getHeight();
      int area = 0;


      PVector cen = new PVector(0.0, 0.0);

      // calcula coordenada XY del centroide 
      int countY = 0;
      int countX = 0;
      for (int y = int (ry); y < int(ry + rh); y++) {
        for (int x = int (rx); x < int(rx + rw); x++) {
          color c = src.get(x, y);
          if (green(c) == 255) {
            countY+=y;
            countX+=x;
            area++;
          }
        }
      }

      if (area != 0) {
        cen.set(countX/area, countY/area);
      }
      centroids.add(cen);
      areas.add(area);
    }
  }

  //-----------------
  void draw() {

    //oCv.threshold(thr);
    //image((PImage)oCv.getOutput(), 0, 0);

    //contours = oCv.findContours();
    findBlobs();
    println("centroids Size() = " + centroids.size());
    println("contours Size() = " + contours.size());
    int indx = 0;
    for (Contour contour : contours) {
      stroke(0, 255, 0, 127);
      //contour.draw();

      if (areas.get(indx) > 10) {
        Rectangle rect = contour.getBoundingBox();
        noFill();
        stroke(255-thr, 0.5*thr, thr, 0127);
        float rx = (float)rect.getX() * ratio2FullScreen.x;
        float ry = (float)rect.getY() * ratio2FullScreen.y;
        float rw = (float)rect.getWidth() * ratio2FullScreen.x;
        float rh = (float)rect.getHeight() * ratio2FullScreen.y;

        rect(rx, ry, rw, rh);

        stroke(thr, 255-thr, 0.5*thr, 127);
        noFill();
        //fill(255);
        beginShape();
        for (PVector point : contour.getPoints ()) 
        {
          float x = point.x * ratio2FullScreen.x;
          float y = point.y * ratio2FullScreen.y;
          vertex(x, y, 0);
        }
        endShape();

        PVector cen = centroids.get(indx);
        //fill(0, 255, 0); 
        ellipse(cen.x*ratio2FullScreen.x, cen.y*ratio2FullScreen.y, 10, 10);
      }

      indx++;
    }
  }

  //-----------------
  PImage getImage() {
    return oCv.getOutput();
  }

  //---------------------
  boolean insidePolygon(ArrayList<PVector> polygon, int N, PVector p) {

    int counter = 0;
    int i;
    double xinters;
    PVector p1, p2;
    int inc = 1;
    
    if(N > 25){
      inc = int(N/25);
    }

    p1 = polygon.get(0);
    for (i=1; i<N; i+=inc) {
      p2 = polygon.get(i % N);
      if (p.y > min(p1.y, p2.y)) {
        if (p.y <= max(p1.y, p2.y)) {
          if (p.x <= max(p1.x, p2.x)) {
            if (p1.y != p2.y) {
              xinters = (p.y-p1.y)*(p2.x-p1.x)/(p2.y-p1.y)+p1.x;
              if (p1.x == p2.x || p.x <= xinters)
                counter++;
            }
          }
        }
      }
      p1 = p2;
    }

    if (counter % 2 == 0) { 

      return false;
    } else { 

      return true;
    }
  }
}

