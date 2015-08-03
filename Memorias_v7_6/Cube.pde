class Cube {

  PVector pos = new PVector();
  PImage img;
  float w, h, d, sz;
  float rotx = PI/4;
  float roty = PI/4;
  float phase = 0.01;

  //--------------------------
  Cube(float _x, float _y, float _sz, PGraphics _img) {
    pos.set(_x, _y);
    sz = _sz;
    img = _img;
    textureMode(NORMAL);
    w = h = d = sz;
  }
  
  //--------------------------
  Cube(float _x, float _y, float _sz, PImage _img) {
    pos.set(_x, _y);
    sz = _sz;
    img = _img;
    textureMode(NORMAL);
    w = h = d = sz;
  }

  //--------------------------
  void draw(float _x, float _y, float _sz) {
    pos.set(_x, _y);
    sz = _sz;
    noStroke();
    pushMatrix();
    translate(pos.x, pos.y, 0);
    rotateX(rotx+frameCount*phase);
    rotateY(roty+frameCount*phase);
    scale(sz);
    texCube(img);
    popMatrix();
  }

  //--------------------------
  void draw(float _x, float _y, float _z, float _sz) {
    pos.set(_x, _y, _z);
    sz = _sz;
    noStroke();
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateX(rotx+frameCount*phase);
    rotateY(roty+frameCount*phase);
    scale(sz);
    texCube(img);
    popMatrix();
  }

  //--------------------------
  void draw(float _x, float _y, float _z, float _sz, PImage _img) {
    pos.set(_x, _y, _z);
    sz = _sz;
    noStroke();
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateX(rotx+frameCount*phase);
    rotateY(roty+frameCount*phase);
    scale(sz);
    texCube(_img);
    popMatrix();
  }

//--------------------------
  void draw(float _x, float _y, float _z, float _sz, PGraphics _img) {
    pos.set(_x, _y, _z);
    sz = _sz;
    noStroke();
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateX(rotx+frameCount*phase);
    rotateY(roty+frameCount*phase);
    scale(sz);
    texCube(_img);
    popMatrix();
  }

  //--------------------------
  void draw() {
    noStroke();
    pushMatrix();
    translate(pos.x, pos.y, 0);
    rotateX(rotx+frameCount*0.001);
    rotateY(roty);
    scale(sz);
    texCube(img);
    popMatrix();
  }

  //--------------------------
  void texCube(PImage _img) {
    beginShape(QUADS);
    texture(_img);
    // +Z "front" face
    vertex(-1, -1, 1, 0, 0);
    vertex( 1, -1, 1, 1, 0);
    vertex( 1, 1, 1, 1, 1);
    vertex(-1, 1, 1, 0, 1);

    // -Z "back" face
    vertex( 1, -1, -1, 0, 0);
    vertex(-1, -1, -1, 1, 0);
    vertex(-1, 1, -1, 1, 1);
    vertex( 1, 1, -1, 0, 1);

    // +Y "bottom" face
    vertex(-1, 1, 1, 0, 0);
    vertex( 1, 1, 1, 1, 0);
    vertex( 1, 1, -1, 1, 1);
    vertex(-1, 1, -1, 0, 1);

    // -Y "top" face
    vertex(-1, -1, -1, 0, 0);
    vertex( 1, -1, -1, 1, 0);
    vertex( 1, -1, 1, 1, 1);
    vertex(-1, -1, 1, 0, 1);

    // +X "right" face
    vertex( 1, -1, 1, 0, 0);
    vertex( 1, -1, -1, 1, 0);
    vertex( 1, 1, -1, 1, 1);
    vertex( 1, 1, 1, 0, 1);

    // -X "left" face
    vertex(-1, -1, -1, 0, 0);
    vertex(-1, -1, 1, 1, 0);
    vertex(-1, 1, 1, 1, 1);
    vertex(-1, 1, -1, 0, 1);

    endShape();
  }
}

