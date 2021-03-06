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

float zoomF = 0.5f;
float giradorX = 0;
float giradorMapX = 0;
float giradorY = 0;
float giradorMapY = 0;
float giradorZ = 0;
float giradorMapZ = 0;
float alfa = 10;
//float thr = 20;

int scene = 2;

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
  float a = map(mouseX, 0, width, 0, PI);
  //float b = map(mouseY, 0, height, -TWO_PI, TWO_PI);
  float b = map(mouseY, 0, height, -1000, 0);
  /*
  camera(
   (width/2.0)+2*width*cos(a), height/2, b+width*sin(a), 
   width/2.0, height/2.0, b, 
   0, 1, 0);
   */
   lights();
   directionalLight(1.0, 1.0, 1.0, 0, -1, 0);
   
  kin.update();
  //tintas.update();
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
  //blend(mask, 0, 0, 640, 480, 0, 0, width, height, MULTIPLY);

  if (scene == 1) {
    tintas.update();
    drawCubeDepth();
  }
  if (scene == 2) {
    drawCubeSkel();
  }
  if (scene == 3) {
    tintas.update();
    drawCubeContours();
  }

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
  pushMatrix();
  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  //rotateY(rotY);
  scale(zoomF);
  translate(0, 0, -1000);
  // draw the skeleton if it's available
  int[] userList = kin.getUsers();
  for (int i=0; i<userList.length; i++)
  {
    int userId = userList[i];
    println("traqueando esqueletos: " + kin.isTrackingSkeleton(userId) + " kin.size: " + userList.length);
    if (kin.isTrackingSkeleton(userId))
    {
      println("sí estoy traqueando esqueletos");
      stroke(0);

      PVector jointPos = new PVector();
      PVector jointPos2 = new PVector();
      PVector jointPosProyective = new PVector();
      CuboMind temp = new CuboMind(tintas.getImage());

      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, jointPos);      
      //line(jointPos.x, jointPos.y, jointPos.z, width/2, height/2, 0);
      //temp.vals(300+0.25*jointPos.x, 245-0.25*jointPos.y, -jointPos.z, 200);
      temp.vals(jointPos.x, 1*jointPos.y, jointPos.z, 500);
      temp.display(tintas.getImage());

      temp = new CuboMind(tintas.getImage());
      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, jointPos);
      kin.convertRealWorldToProjective(jointPos, jointPosProyective);
      tintas.update(jointPosProyective.x, jointPosProyective.y);
      //line(jointPos.x, jointPos.y, jointPos.z, width/2, height/2, 0);
      //temp.vals(300+0.25*jointPos.x, 245-0.25*jointPos.y, -jointPos.z, 200);
      temp.vals(jointPos.x, 1*jointPos.y, jointPos.z, 500);
      temp.display(tintas.getImage());

      drawCubeLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_LEFT_HAND, 5);

      temp = new CuboMind(tintas.getImage());
      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, jointPos);
      //line(jointPos.x, jointPos.y, jointPos.z, width/2, height/2, 0);
      //temp.vals(300+0.25*jointPos.x, 245-0.25*jointPos.y, -jointPos.z, 200);
      temp.vals(jointPos.x, 1*jointPos.y, jointPos.z, 500);
      temp.display(tintas.getImage());

      drawCubeLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_RIGHT_HAND, 5);

      temp = new CuboMind(tintas.getImage());
      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, jointPos);
      //line(jointPos.x, jointPos.y, jointPos.z, width/2, height/2, 0);
      //temp.vals(300+0.25*jointPos.x, 245-0.25*jointPos.y, -jointPos.z, 200);
      temp.vals(jointPos.x, 1*jointPos.y, jointPos.z, 500);
      temp.display(tintas.getImage());

      temp = new CuboMind(tintas.getImage());
      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, jointPos);
      //line(jointPos.x, jointPos.y, jointPos.z, width/2, height/2, 0);
      //temp.vals(300+0.25*jointPos.x, 245-0.25*jointPos.y, -jointPos.z, 200);
      temp.vals(jointPos.x, 1*jointPos.y, jointPos.z, 500);
      temp.display(tintas.getImage());
      drawCubeLimb(userId, SimpleOpenNI.SKEL_LEFT_FOOT, SimpleOpenNI.SKEL_RIGHT_FOOT, 5);
    }
  }
  kin.drawCamFrustum();
  popMatrix();
}


//---------------------
void drawCubeDepth() {

  int indx = 0;
  for (int y = 0; y < mask.height; y +=int (mask.height/20)) {
    for (int x = 0; x < mask.width; x +=int (mask.width/20)) {
      if (cubes.get(indx) != null ) {
        CuboMind   tmp = cubes.get(indx); 
        color c = mask.get(x, y);
        color d = ((PImage)kin.depthImage()).get(x, y);
        if (red(c) > 0) {          

          // .vals(float x, float y, float z, float size);
          tmp.vals(x, y, -200, 100); 
          //tmp.display(txImg);
          tmp.display(tintas.getImage()); // send image to render on cube;
          indx++;
        }
      }
    }
  }
}

//---------------------
void drawCubeContours() {

  blobs.findBlobs();
  for (Contour contour : blobs.contours) {
    if (contour.area() > 250) {
      //      stroke(0);
      //      beginShape();
      int i = 0;
      for (PVector point : contour.getPoints ()) 
      {
        //    println("cubeDraw");
        float x = map(point.x, 0, blobs.w, 0, width);
        float y = map(point.y, 0, blobs.h, 0, height);
        //      vertex(x, y);
        if ( (i%25) == 0) {
          CuboMind temp = new CuboMind();
          temp.vals(x, y, -200, 100);
          temp.display(tintas.getImage());
        }
        i++;
      }
      //      endShape();
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
void drawLimb(int userId, int jointType1, int jointType2)
{
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float  confidence;

  // draw the joint position
  confidence = kin.getJointPositionSkeleton(userId, jointType1, jointPos1);
  confidence = kin.getJointPositionSkeleton(userId, jointType2, jointPos2);

  stroke(255, 0, 0, confidence * 200 + 55);
  line(jointPos1.x, jointPos1.y, jointPos1.z, 
  jointPos2.x, jointPos2.y, jointPos2.z);
}

//---------------------
void drawCubeLimb(int userId, int jointType1, int jointType2, int n)
{
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  PVector segmento  = new PVector();
  PVector dir       = new PVector();

  float  paso;
  float  confidence;

  // draw the joint position
  confidence = kin.getJointPositionSkeleton(userId, jointType1, jointPos1);
  confidence = kin.getJointPositionSkeleton(userId, jointType2, jointPos2);
  
  segmento = jointPos2.get();
  segmento.sub(jointPos1);

  paso = segmento.mag() / float(n);

  dir = segmento.get();
  dir.normalize();

  stroke(255, 0, 0, confidence * 200 + 55);
  line(jointPos1.x, jointPos1.y, jointPos1.z, 
  jointPos2.x, jointPos2.y, jointPos2.z);

  for (int i = 0; i < n; i++) {
    PVector walker = new PVector();
    walker = dir.get();
    walker.setMag(paso*i);
    CuboMind temp = new CuboMind(tintas.getImage());  
    walker.add(jointPos1);
    temp.vals(walker, 500);
    temp.display(tintas.getImage());
  }
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

  if (key == 'c') {
    tintas.browny();
  }

  if (key == 'x') {
    tintas.blaky();
  }

  if (key == 'm') {
    tintas.metalBlue();
  }

  if (key == 'n') {
    fill(255);
    rect(0, 0, width, height);
  }

  if (key == 'q') {
    perspective();
    scene = 1;
  }
  if (key == 'w') {
    //    perspective(radians(45),
    //              float(width)/float(height),
    //              10,150000);
    perspective();
    scene = 2;
  }
  if (key == 'e') {
    perspective();
    scene = 3;
  }

  if (key == 's') {
    saveFrame("#####-memorias");
  }

  switch(keyCode)
  {

  case UP:
    zoomF += 0.01f; 
    break;

  case DOWN:
    zoomF -= 0.01f;
    if (zoomF < 0.01)
      zoomF = 0.01;
    break;
  }
}

