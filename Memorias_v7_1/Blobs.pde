class Blobs {

  PImage img;
  OpenCV oCv;

  int thr = 175;
  PImage src, prev;
  ArrayList<Contour> contours;
  ArrayList<PVector> points;
  PVector ratio2FullScreen;
  int w = 320;
  int h = 240;

  //-----------------
  Blobs(OpenCV _cv) {
    oCv = _cv;
    contours = _cv.findContours(false, true);
    ratio2FullScreen = new PVector(float(width)/float(w), float(height)/float(h));
  }

  //-----------------
  Blobs(OpenCV _cv, int _w, int _h) {
    oCv = _cv;
    contours = _cv.findContours(false, true); 
    w = _w;
    h = _h;
    ratio2FullScreen = new PVector(float(width)/float(w), float(height)/float(h));
  }

  //-----------------
  void findBlobs() {
    oCv.threshold(thr);
    //image((PImage)oCv.getOutput(), 0, 0);

    contours = oCv.findContours();
  }

  //-----------------
  void draw() {

    //oCv.threshold(thr);
    //image((PImage)oCv.getOutput(), 0, 0);

    //contours = oCv.findContours();
    findBlobs();

    for (Contour contour : contours) {
      stroke(0, 255, 0);
      //contour.draw();

      if (contour.area() > 200) {
        Rectangle rect = contour.getBoundingBox();
        noFill();
        stroke(255-thr, 0.5*thr, thr);
        float rx = (float)rect.getX() * ratio2FullScreen.x;
        float ry = (float)rect.getY() * ratio2FullScreen.y;
        float rw = (float)rect.getWidth() * ratio2FullScreen.x;
        float rg = (float)rect.getHeight() * ratio2FullScreen.y;
        
        rect(rx, ry, rw, rg);
        
        stroke(thr, 255-thr, 0.5*thr);
        //fill(255);
        beginShape();
        for (PVector point : contour.getPoints ()) 
        {
          float x = point.x * ratio2FullScreen.x;
          float y = point.y * ratio2FullScreen.y;
          vertex(x, y);
        }
        endShape();
      }
    }
  }

  //-----------------
  PImage getImage() {
    return oCv.getOutput();
  }
}

