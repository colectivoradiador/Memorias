class Particula {

  float posX = 300;
  float posY = 200;
  PVector pos = new PVector(posX, posY);
  float incX = 2;
  float incY = 5;
  PVector inc = new PVector(incX, incY);
  PVector mouse = new PVector();
  PVector m2p = new PVector();
  PVector g = new PVector(0.0, 0.0);
  PVector atr = new PVector(0.0, 0.0);
  PVector vel = new PVector(0, 0);
  float r, gr, b;
  float damp = 0.99;
  int listoFlag = 0; 
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
  void draw() {
    //background(255);

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

    vel.add(g);
    vel.add(atr);
    vel.mult(damp);
    pos.add(vel);

    fronteras();
    listoFlag++;
    //posX = posX+incX;
    //posY = posY+incY;
  }

  //----------
  void fronteras() {

    if (pos.x < 0) {
      pos.x = 0;
      vel.x = vel.x * -1;
      //OscMessage msg = new OscMessage("/frontera");
      //msg.add(pos.x);
      //msg.add(vel);
      if (vel.mag() > 2) {
        //osc.send(msg, sc);
        listoFlag = 0;
      }
    }
    if (pos.x > width) {
      pos.x = width;
      vel.x *= -1;
      //OscMessage msg = new OscMessage("/frontera");
      //msg.add(pos.x);
      if (vel.mag() > 2) {
        //osc.send(msg, sc);
        listoFlag = 0;
      }
    }
    if (pos.y < 0) {
      pos.y = 0;
      vel.y *= -1;
      //OscMessage msg = new OscMessage("/frontera");
      //msg.add(pos.x);
      if (vel.mag() > 2) {
        //osc.send(msg, sc);
        listoFlag = 0;
      }
    }
    if (pos.y > height) {
      pos.y = height;
      vel.y *= -1;
      //OscMessage msg = new OscMessage("/frontera");
      //msg.add(pos.x);
      if (vel.mag() > 2) {
        //osc.send(msg, sc);
        listoFlag = 0;
      }
    }
  } 
  //----------
}

