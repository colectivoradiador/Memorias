import SimpleOpenNI.*;
import gab.opencv.*;
import java.awt.*;
import java.util.*;
import toxi.sim.grayscott.*;
import toxi.math.*;
import toxi.color.*;


SimpleOpenNI kin;
OpenCV opencv;
Blobs blobs;
Grid grid;
Tintas tintas;
Vector <CuboMind> cubes = new Vector<CuboMind>();
HashMap <String, PVector> skel = new HashMap<String, PVector>();
//Vector <PVector> skel = new Vector<PVector>();
Vector <CuboMind> skelCubos = new Vector<CuboMind>();


int N = 100;
Particula[] particulas = new Particula[N];
float[] vtx = new float[8];

//OpenCV blobs;

int kinW = 640;
int kinH = 480;
PImage depth;
PImage mask;
PImage tex;
PImage out;
PImage txImg;

float giradorX = 0;
float giradorMapX = 0;
float giradorY = 0;
float giradorMapY = 0;
float giradorZ = 0;
float giradorMapZ = 0;
float alfa = 10;
//float thr = 20;

//---------------------
void setup() {
  size(640, 480, OPENGL);
  //size(displayWidth, displayHeight, OPENGL);
  kin = new SimpleOpenNI(this);
  tex = loadImage("camposBW.jpg");
  txImg = loadImage("rizoma640_480corte.png");
  tintas = new Tintas();

  if (kin.isInit() == false) {
    println("¿Te acordaste de conectar el Kinect?");
    exit();
    return;
  }

  kin.setMirror(true);
  kin.enableDepth();
  //kin.enableRGB();
  kin.enableUser();

  depth = createImage(320, 240, ALPHA);
  mask = createImage(640, 480, RGB);
  out = createImage(640, 480, ARGB);

  grid = new Grid();
  opencv = new OpenCV(this, 320, 240);
  blobs = new Blobs(opencv);
  for (int i = 0; i< 400; i++) {
    cubes.add(new CuboMind(txImg));
  }

  skel.put("cabeza", new PVector());
  skel.put("manoD", new PVector());
  skel.put("manoI", new PVector());
  skel.put("pieD", new PVector());
  skel.put("pieI", new PVector());


  /*  for (int i=0; i < N; i++) {
   particulas[i] = new Particula(int(random(0, width)), int(random(0, height)));
   }
   */

  //  for (int i=0; i< vtx.length; i++) {
  //    vtx[i] = random(0.001, 0.05);
  //  }
}

//---------------------
void draw() {
  //background(255);

  //cubes.clear();
  //tint(0, 200);
  float a = map(mouseX, 0, width, -TWO_PI, TWO_PI);
  //float b = map(mouseY, 0, height, -TWO_PI, TWO_PI);
  float b = map(mouseY, 0, height, -1000, 0);
  camera(
  width*cos(a), height/2, width*sin(a), 
  width/2.0, height/2.0, b, 
  0, 1, 0); 

  lights();
  directionalLight(1.0, 1.0, 1.0, 0, -1, 0);

  kin.update();
  tintas.update();
  //image(kin.userImage(), 0, 0);
  depth.copy(kin.depthImage(), 
  0, 0, kinW, kinH, 
  0, 0, 320, 240);
  //depth.resize(320, 240);
  mask.copy(kin.depthImage(), 
  0, 0, kinW, kinH, 
  0, 0, kinW, kinH);
  mask.filter(THRESHOLD, blobs.thr/255.0);
  //image(depth, 0, 0);
  //depth.filter(THRESHOLD, thr);
  //image(depth, 0, 0, width, height);
  opencv.loadImage(depth);
  //blobs.findBlobs();
  //blobs.findBlobs();
  //mask = blobs.getImage();
  //blobs.draw();
  //image(mask, 0, 0);
  //image(kin.depthImage(),0,0);
  //image(kin.rgbImage(),0,0);
  //grid.draw();
  //blend(mask, 0, 0, 640, 480, 0, 0, width, height, MULTIPLY);

  //blobs.draw();
  /*for(int i=0; i < N; i++){
   particulas[i].draw();
   }
   */
  //tint(255, 50);
  //tintas.draw();

  //drawCubeShadow();
  drawCubeSkel();
  //CuboMind cm = new CuboMind(tintas.getImage());
  //cm.vals(mouseX, mouseY, -500, 100);
  //cm.display(tintas.getImage());
  
  //  loadPixels();
  //  for (int i=0; i < pixels.length; i++) {
  //    out.pixels[i] = pixels[i];
  //  }
  //  out.updatePixels();
}

void drawCubeSkel() {

  // draw the skeleton if it's available
  int[] userList = kin.getUsers();
  for (int i=0; i<userList.length; i++)
  {
    int userId = userList[i];
    println("traqueando esqueletos: " + kin.isTrackingSkeleton(userId) + " kin.size: " + userList.length);
    if (kin.isTrackingSkeleton(userId))
    {
      println("sí estoy traqueando esqueletos");
      stroke(0, 190);
      PVector jointPos = new PVector();
      CuboMind temp = new CuboMind(tintas.getImage());

      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, jointPos);
      //ellipse(jointPos.x, jointPos.y, jointPos.z, 30);
      temp.vals(jointPos.x*1, -1*jointPos.y, -0.1*jointPos.z, 200);
      temp.display(tintas.getImage());

      temp = new CuboMind(tintas.getImage());
      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, jointPos);
      temp.vals(jointPos.x, -1*jointPos.y, -0.1*jointPos.z, 100);
      temp.display(tintas.getImage());

      temp = new CuboMind(tintas.getImage());
      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, jointPos);
      temp.vals(jointPos.x, -1*jointPos.y, -0.1*jointPos.z, 100);
      temp.display(tintas.getImage());
      //
      //      temp = new CuboMind(tintas.getImage());
      //      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, jointPos);
      //      temp.vals(jointPos, 100);
      //      temp.display(tintas.getImage());
      //
      //      temp = new CuboMind(tintas.getImage());
      //      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, jointPos);
      //      temp.vals(jointPos, 100);
      //      temp.display(tintas.getImage());
    }
  }
}


//---------------------
void drawCubeShadow() {

  int indx = 0;
  for (int y = 0; y < mask.height; y +=int (mask.height/20)) {
    for (int x = 0; x < mask.width; x +=int (mask.width/20)) {
      if (cubes.get(indx) != null ) {
        CuboMind   tmp = cubes.get(indx); 
        color c = mask.get(x, y);
        color d = ((PImage)kin.depthImage()).get(x, y);
        if (red(c) > 0) {          

          // .vals(float x, float y, float z, float size);
          tmp.vals(x, y, map(red(d), blobs.thr, 255, -100, -600), 100); 
          //tmp.display(txImg);
          tmp.display(tintas.getImage()); // send image to render on cube;
          indx++;
        }
      }
    }
  }
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  println("onVisibleUser - userId: " + userId);
}

//---------------------
void mouseMoved() {
  tintas.movMouse = true;
}

//---------------------
void keyPressed() {
  switch(key) {
  case '+':
    blobs.thr++;
    println("thr: " + blobs.thr);
    if (blobs.thr > 255) {
      blobs.thr = 255;
    }
    break;
  case '-':
    blobs.thr--;
    println("thr: " + blobs.thr);
    if (blobs.thr < 0) {
      blobs.thr = 0;
    }
  }
  //------
  if (key>='1' && key<='9') {
    tintas.gs.setF(0.025+(key-'1')*0.001);
  } 
  if (key == 't') {
    tintas.gs.setCoefficients(0.021, 0.076, 0.12, 0.02);
  }
  if (key == 'r') {
    tintas.gs.reset();
  }
}

