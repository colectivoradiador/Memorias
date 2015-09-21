class Particula {

  float posX = 0;
  float posY = 0;
  float posZ = 0;
  PVector pos = new PVector(posX, posY, posZ);
  float incX = 2;
  float incY = 5;
  float incZ = 0;
  PVector inc = new PVector(incX, incY, incZ);
  PVector mouse = new PVector();
  PVector m2p = new PVector();
  PVector g = new PVector(0.0, 0.10, 0.0);
  PVector atr = new PVector(0.0, 0.0, 0.0);
  Vector <PVector> atrs = new Vector<PVector>();
  PVector vel = new PVector(0.0,0.0, 0.0);
  float r, gr, b;
  float damp = 1.0;
  //OscP5 osc;
  //NetAddress sc;

  //----------
  //Particula(OscP5 _osc) {
  Particula() {
    r = 30;
    gr = 90;
    b = 120;
    //sc = new NetAddress("127.0.0.1", 57120); // "127.0.0.1" esta es la dirección del localhost
    //osc = _osc;
  }

  //----------
  //Particula(int x, int y, OscP5 _osc) {
  Particula(int x, int y) {
    posX = x;
    posY = y;
    pos.set(x, y);
    r = 30;
    gr = 90;
    b = 120;
    //sc = new NetAddress("127.0.0.1", 57120); // "127.0.0.1" esta es la dirección del localhost
    //osc = _osc;
  }

  //----------
  Particula(int x, int y, int z) {
    posX = x;
    posY = y;
    posZ = z;
    pos.set(x, y, z);
    r = 30;
    gr = 90;
    b = 120;
    //sc = new NetAddress("127.0.0.1", 57120); // "127.0.0.1" esta es la dirección del localhost
    //osc = _osc;
  }

  //----------
  void update() {
    //background(255);

    /*
    mouse.set(mouseX, mouseY);
     m2p = mouse.get();
     m2p.sub(pos); // vector entre partícula y ratón
     inc = m2p.get();
     inc.normalize(); //
     inc.mult(0.5);  // Este valor define la fuerza de atracción
     
     r = 255*abs(sin(pos.x*0.001));
     gr= 255*abs(cos(pos.y*0.005));
     fill(r, gr, b); //Color de la partícula
     stroke(m2p.mag()*0.5);
     ellipse(pos.x, pos.y, 10, 10);
     
     line(pos.x, pos.y, pos.x+m2p.x, pos.y+m2p.y);
     
     if (m2p.mag() > 50 && m2p.mag() < 250) {
     vel.add(inc); //
     }
     */
    vel.add(g);
    vel.add(atr);
    if (atrs.size()>0) {
      for (PVector nAtr : atrs) {
        vel.add(nAtr);
      }
    }

    vel.mult(damp);
    pos.add(vel);

    fronteras();

    //posX = posX+incX;
    //posY = posY+incY;
  }

  //----------
  void draw() {
    r = 255*abs(sin(pos.x*0.001));
    gr= 255*abs(cos(pos.y*0.005));
    //fill(r, gr, b, 90); //Color de la partícula
    //stroke(120, 90);
    //noStroke();
    //pushMatrix();
    stroke(255, 255);
    line(0,0,0, pos.x, pos.y, pos.z);
    //sphere(10);
    //popMatrix();
  }

  //----------
  void addAtraction(PVector p) {
    PVector dir;
    p.sub(pos); // vector entre partícula y attraction point
    dir = p.get();
    dir.normalize(); //
    dir.mult(0.1);  // Este valor define la fuerza de atracción

    if (p.mag() > 50 ) {
      atrs.add(dir);
    }
  }
  //----------
  void fronteras() {

    if (pos.x < 0) {
      pos.x = 0;
      vel.x = vel.x * -1;
    }
    if (pos.x >= width-1) {
      pos.x = width-1;
      vel.x *= -1;
    }
    if (pos.y < 0) {
      pos.y = 0;
      vel.y *= -1;
    }
    if (pos.y >= height-1) {
      pos.y = height-1;
      vel.y *= -1;
    }
    //++
//    if (pos.z < 0) {
//      pos.z = 0;
//      vel.z *= -1;
//    }
//    if (pos.z > 4000) {
//      pos.z = 4000;
//      vel.z *= -1;
//    }
  } 
  //----------
  void setPos(PVector _p){
    pos.set(_p.x, _p.y, _p.z);
    posX = _p.x;
    posY = _p.y;
    posZ = _p.z;
  }
  
}

