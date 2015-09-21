import SimpleOpenNI.*;
import gab.opencv.*;
import java.awt.*;
import java.util.*;
import toxi.sim.grayscott.*;
import toxi.math.*;
import toxi.color.*;
import ddf.minim.*;



Minim minim;
AudioInput in;
SimpleOpenNI kin;
OpenCV opencv;
Blobs blobs;
Grid grid;
Tintas tintas;
Vector <CuboMind> cubes = new Vector<CuboMind>();
HashMap <String, PVector> skel = new HashMap<String, PVector>();
//Vector <PVector> skel = new Vector<PVector>();
Vector <CuboMind> skelCubos = new Vector<CuboMind>();


int N = 1000;
Particula[] particulas = new Particula[N];
boolean[] inside = new boolean[N];

float[] vtx = new float[8];

//OpenCV blobs;

int kinW = 640;
int kinH = 480;
PImage depth;
PImage mask;
PImage tex;
PImage out;
PImage txImg;
PImage txImg2;

float zoomF = 0.5f;
float rotY = 0.0;
//float thr = 20;

int scene = 4;

boolean cubeDepth = false;
boolean cubeSkel = false;
boolean cubeContours = false;
boolean soundSkel = false;
boolean noiseSkel = false;
boolean spiralSkel = false;
boolean rojo = false;
boolean pencilContours = false;
boolean tintasTodas = false;
boolean partisInContours = true;

float amp = 0;

//---------------------
void setup() {
  size(640, 480, OPENGL);
  //size(displayWidth, displayHeight, OPENGL);
  //size(1920, 1080, OPENGL); //Full HD
  //size(4295, 2415, OPENGL); //Full HD

  kin = new SimpleOpenNI(this);
  tex = loadImage("camposBW.jpg");
  txImg = loadImage("rizoma640_480corte.png");
  txImg2 = loadImage("rizoma640_480corterojo.png");
  tintas = new Tintas();

  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, 512);

  if (kin.isInit() == false) {
    println("¿Te acordaste de conectar el Kinect?");
    exit();
    return;
  }

  kin.setMirror(true);
  kin.enableDepth();
  kin.enableRGB();
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


  for (int j = 0; j < N; j++ ) {    
    particulas[j] = new Particula(int(random(0, width)), int(random(0, height)));
    inside[j] = false;
  }
  //  for (int i=0; i< vtx.length; i++) {
  //    vtx[i] = random(0.001, 0.05);
  //  }
}

//---------------------
void draw() {

  //background(255);

  /*if (frameCount%30 == 0) {
   noStroke();
   fill(255, 20);
   rect(0, 0, width, height);
   }*/

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
  directionalLight(1.0, 1.0, 1.0, cos(frameCount*0.0001), (sin(frameCount*0.0001)), 0);

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
  //blend(mask, 0, 0, 640, 480, 0, 0, width, height, MULTIPLY);

  if (cubeDepth) {
    tintas.update();
    drawCubeDepth();
  }
  if (cubeSkel) {
    tintas.update();
    drawCubeSkel();
  }
  if (cubeContours) {
    tintas.update();
    drawCubeContours();
  }
  if (soundSkel) {
    drawSoundSkel();
  }
  if (noiseSkel) {
    drawNoiseSkel();
  }
  if (spiralSkel) {
    drawSpiralSkel();
  }
  if (pencilContours) {
    drawPencilContours();
  }
  if (tintasTodas) {
    drawTintasTodas();
    tintas.draw();
  }

  if (partisInContours) {
    drawPartisInContours();
  }

  amp = rmsAmp();
  //println("amp: " + amp);
  noFill();
  rect(20, 150-(100*amp), 0, 100*amp);




  //saveFrame("#####-memorias");

  //CuboMind cm = new CuboMind(tintas.getImage());
  //cm.vals(mouseX, mouseY, -500, 100);
  //cm.display(tintas.getImage());

  //  loadPixels();
  //  for (int i=0; i < pixels.length; i++) {
  //    out.pixels[i] = pixels[i];
  //  }
  //  out.updatePixels();
}

//------------------------------
void drawCubeSkel() {
  pushMatrix();
  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  rotateY(rotY);
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

      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, jointPos);
      kin.convertRealWorldToProjective(jointPos, jointPosProyective);
      tintas.update(jointPosProyective.x, jointPosProyective.y);

      drawCubeLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK, 5);
      drawCubeLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER, 5);
      drawCubeLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW, 5);
      drawCubeLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND, 5);

      drawCubeLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER, 5);
      drawCubeLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW, 5);
      drawCubeLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND, 5);

      drawCubeLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO, 5);
      drawCubeLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO, 5);

      drawCubeLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP, 5);
      drawCubeLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE, 5);
      drawCubeLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT, 5);

      drawCubeLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP, 5);
      drawCubeLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE, 5);
      drawCubeLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT, 5);
    }
  }
  //  CuboMind temp = new CuboMind();  
  //  temp.vals(new PVector(0, 0, 1000), 500);
  //  temp.display(tintas.getImage());
  //kin.drawCamFrustum();
  popMatrix();
}

//------------------------------ç
// TintasTodas
//------------------------------
void drawTintasTodas() {

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
      PVector jointPosProyective = new PVector();

      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, jointPos);
      kin.convertRealWorldToProjective(jointPos, jointPosProyective);
      tintas.update(jointPosProyective.x, jointPosProyective.y);

      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, jointPos);
      kin.convertRealWorldToProjective(jointPos, jointPosProyective);
      tintas.update(jointPosProyective.x, jointPosProyective.y);

      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, jointPos);
      kin.convertRealWorldToProjective(jointPos, jointPosProyective);
      tintas.update(jointPosProyective.x, jointPosProyective.y);

      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, jointPos);
      kin.convertRealWorldToProjective(jointPos, jointPosProyective);
      tintas.update(jointPosProyective.x, jointPosProyective.y);

      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, jointPos);
      kin.convertRealWorldToProjective(jointPos, jointPosProyective);
      tintas.update(jointPosProyective.x, jointPosProyective.y);
    }
  }

  //kin.drawCamFrustum();
}


//------------------------------
void drawSoundSkel() {
  pushMatrix();
  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  rotateY(rotY);
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

      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, jointPos);
      kin.convertRealWorldToProjective(jointPos, jointPosProyective);
      tintas.update(jointPosProyective.x, jointPosProyective.y);

      drawSoundLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK, 5);
      drawSoundLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER, 5);
      drawSoundLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW, 5);
      drawSoundLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND, 5);

      drawSoundLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER, 5);
      drawSoundLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW, 5);
      drawSoundLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND, 5);

      drawSoundLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO, 5);
      drawSoundLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO, 5);

      drawSoundLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP, 5);
      drawSoundLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE, 5);
      drawSoundLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT, 5);

      drawSoundLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP, 5);
      drawSoundLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE, 5);
      drawSoundLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT, 5);
    }
  }
  //kin.drawCamFrustum();
  popMatrix();
}

//------------------------------
void drawNoiseSkel() {
  pushMatrix();
  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  rotateY(rotY);
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

      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, jointPos);
      kin.convertRealWorldToProjective(jointPos, jointPosProyective);
      tintas.update(jointPosProyective.x, jointPosProyective.y);

      drawNoiseLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK, 5);
      drawNoiseLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER, 5);
      drawNoiseLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW, 5);
      drawNoiseLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND, 5);

      drawNoiseLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER, 5);
      drawNoiseLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW, 5);
      drawNoiseLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND, 5);

      drawNoiseLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_HIP, 5);
      drawNoiseLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_HIP, 5);

      drawNoiseLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP, 5);
      drawNoiseLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE, 5);
      drawNoiseLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT, 5);

      //drawNoiseLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP,5);
      drawNoiseLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE, 5);
      drawNoiseLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT, 5);
    }
  }
  //kin.drawCamFrustum();
  popMatrix();
}

//------------------------------
void drawSpiralSkel() {
  pushMatrix();
  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  rotateY(rotY);
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

      kin.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, jointPos);
      kin.convertRealWorldToProjective(jointPos, jointPosProyective);
      tintas.update(jointPosProyective.x, jointPosProyective.y);

      drawSpiralLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK, 50);
      drawSpiralLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER, 50);
      drawSpiralLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW, 50);
      drawSpiralLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND, 50);

      drawSpiralLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER, 50);
      drawSpiralLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW, 50);
      drawSpiralLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND, 50);

      drawSpiralLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_HIP, 50);
      drawSpiralLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_HIP, 50);

      drawSpiralLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP, 50);
      drawSpiralLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE, 50);
      drawSpiralLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT, 50);

      //drawNoiseLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP,5);
      drawSpiralLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE, 50);
      drawSpiralLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT, 50);
    }
  }
  //kin.drawCamFrustum();
  popMatrix();
}


////---------------------
//boolean insidePolygon(ArrayList<PVector> polygon, int N, PVector p) {
//
//  int counter = 0;
//  int i;
//  double xinters;
//  PVector p1, p2;
//
//  p1 = polygon[0];
//  for (i=1; i<=N; i++) {
//    p2 = polygon[i % N];
//    if (p.y > MIN(p1.y, p2.y)) {
//      if (p.y <= MAX(p1.y, p2.y)) {
//        if (p.x <= MAX(p1.x, p2.x)) {
//          if (p1.y != p2.y) {
//            xinters = (p.y-p1.y)*(p2.x-p1.x)/(p2.y-p1.y)+p1.x;
//            if (p1.x == p2.x || p.x <= xinters)
//              counter++;
//          }
//        }
//      }
//    }
//    p1 = p2;
//  }
//
//  if (counter % 2 == 0) { 
//
//    return false;
//  } else { 
//
//    return true;
//  }
//}

//---------------------
void drawCubeDepth() {
  pushMatrix();
  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  rotateY(rotY);
  scale(zoomF);
  translate(0, 0, -1000);
  PVector rwPoint;


  int indx = 0;
  for (int y = 0; y < mask.height; y +=int (mask.height/20)) {
    for (int x = 0; x < mask.width; x +=int (mask.width/20)) {
      if (cubes.get(indx) != null ) {
        CuboMind   tmp = cubes.get(indx); 
        color c = mask.get(x, y);
        color d = ((PImage)kin.depthImage()).get(x, y);
        if (red(c) > 0) {          
          int i = int(x + (y*kin.depthWidth()));
          rwPoint = kin.depthMapRealWorld()[i];
          // .vals(float x, float y, float z, float size);
          tmp.vals(rwPoint, 500); 
          tmp.display(txImg);
          //tmp.display(tintas.getImage()); // send image to render on cube;
          indx++;
        }
      }
    }
  }
  popMatrix();
}

//---------------------
void drawCubeContours() {
  pushMatrix();
  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  rotateY(rotY);
  scale(zoomF);
  translate(0, 0, -1000);
  PVector rwPoint;
  blobs.findBlobs();
  int cont = 0;
  for (Contour contour : blobs.contours) {
    if (blobs.areas.get(cont) > 250) {
      //      stroke(0);
      //      beginShape();
      int i = 0;
      for (PVector point : contour.getPoints ()) 
      {
        //    println("cubeDraw");
        int indx = int(point.x*2 + (point.y*2*kin.depthWidth()));
        rwPoint = kin.depthMapRealWorld()[indx];
        fill(rwPoint.z, 70);
        //      vertex(x, y);
        if ( (i%25) == 0 && rwPoint.z != 0) {
          CuboMind temp = new CuboMind();
          temp.vals(rwPoint, 100);
          temp.display(tintas.getImage());
        }
        i++;
      }
      //      endShape();
    }
    cont++;
  }
  popMatrix();
}

//----------------------
void drawPencilContours() {
  pushMatrix();
  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  rotateY(rotY);
  scale(zoomF);
  translate(0, 0, -1000);
  PVector rwPoint;

  blobs.findBlobs();

  for (Contour contour : blobs.contours) {
    if (contour.area() > 250) {     
      stroke(120, 70);
      beginShape();

      for (PVector point : contour.getPoints ()) {
        int indx = int(point.x*2 + (point.y*2*kin.depthWidth()));
        rwPoint = kin.depthMapRealWorld()[indx];
        stroke(255-255*amp, 127);

        //noFill();
        if (rwPoint.z > 80 && rwPoint.z < 4000) {

          fill(map(rwPoint.z, 0, 4000, 0, 255)*(1-amp), 127);
          vertex(rwPoint.x, rwPoint.y, rwPoint.z);
        }
      }
      endShape();
    }
  }

  popMatrix();
}


//----------------------
void drawPartisInContours() {
  //image(blobs.oCv.getOutput(), 0, 0);
  //blobs.findBlobs();
  blobs.draw();
  int count = 0;
  //  for (Contour contour : blobs.contours) {
  //    fill(200, 0, 0);
  //    if (blobs.insidePolygon(contour.getPoints (), contour.getPoints ().size(), new PVector(map(mouseX, 0, width, 0, 320), map(mouseY, 0, height, 0, 240)))) {
  //      fill(0, 200, 0);
  //      rect(mouseX, mouseY, 20, 20);
  //    }
  //
  //    beginShape();
  //    for (PVector point : contour.getPoints ()) 
  //    {
  //      float x = point.x * 2;
  //      float y = point.y * 2;
  //      vertex(x, y, 0);
  //    }
  //    endShape();
  //    count++;
  //  }
  //
  //
  pushMatrix();
  // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  rotateY(rotY);
  scale(zoomF);
  translate(0, 0, -1000);

  for (int i=0; i < N; i++) {
    inside[i] = false;
  }
  PVector rwPoint;

  //busca las partículas que se encuentran fuera de algún blob
  for (Contour contour : blobs.contours) {

    if (blobs.areas.get(count) > 150) {
      stroke(120, 70);
      PVector cen = blobs.centroids.get(count);

      for (int i=0; i < N; i++) {

        PVector particlePos = new PVector(map(particulas[i].pos.x, 0, width, 0, 320), map(particulas[i].pos.y, 0, height, 0, 240));
        if (blobs.insidePolygon(contour.getPoints (), contour.getPoints ().size(), particlePos)) {
          inside[i] = true;
          int indx = int(particulas[i].pos.x + (particulas[i].pos.y*width));
          rwPoint = kin.depthMapRealWorld()[indx];
          if (rwPoint.z < map(mouseX, 0, width, 100, 4000)) {
            noStroke();
            color c = kin.rgbImage().get(int(particulas[i].pos.x), int(particulas[i].pos.y));
            fill(c, 70);
            //            vertex(rwPoint.x, rwPoint.y, rwPoint.z);
            pushMatrix();
            translate(rwPoint.x, rwPoint.y, rwPoint.z);
            box(50);
            popMatrix();
          }
          //rect(particulas[i].pos.x, particulas[i].pos.y);
          //particulas[i].update();
        }
      }
      //endShape();
    }
    count++;
  }

  //actualiza las partículas de acuerdo a su posición   

  for (int i = 0; i < N; i++) {
    if (!inside[i]) {

      if (blobs.centroids.size() > 0) {
        int rnd = int(random(0.0, blobs.centroids.size()));
        //if (blobs.centroids.get(rnd) != null) {

        //particulas[i].setPos(new PVector(map(blobs.centroids.get(rnd).x, 0, 320, 0, 640), map(blobs.centroids.get(rnd).y, 0, 240, 0, 480)));
        particulas[i].setPos(new PVector(random(0, 640), random( 0, 480)));
        particulas[i].vel.set(random(-0.1, 0.1), random( -0.1, 0.1), random( -0.1, 0.1));
        //}
      }
    } else {
      particulas[i].update();
    }
  }




  popMatrix();
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
// drawLimb

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
// drawCubeLimb
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

  //stroke(255, 0, 0, 70);
  //line(jointPos1.x, jointPos1.y, jointPos1.z, 
  //jointPos2.x, jointPos2.y, jointPos2.z);

  for (int i = 0; i < n; i++) {
    PVector walker = new PVector();
    walker = dir.get();
    walker.setMag(paso*i);
    CuboMind temp = new CuboMind();  
    walker.add(jointPos1);
    temp.vals(walker, 100*noise(jointPos1.x, jointPos1.y, jointPos1.z)+150);
    if (rojo) {
      temp.display(txImg2);
    } else {
      temp.display(tintas.getImage());
    }
  }
}

//---------------------
void drawSoundLimb(int userId, int jointType1, int jointType2, int n)
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

  paso = segmento.mag() / float(in.bufferSize());

  dir = segmento.get();
  dir.normalize();

  stroke(255, 0, 0, 70);
  line(jointPos1.x, jointPos1.y, jointPos1.z, 
  jointPos2.x, jointPos2.y, jointPos2.z);

  stroke(frameCount%90, frameCount%180, frameCount%200, 20);
  strokeWeight(5);
  beginShape();
  vertex(jointPos1.x, jointPos1.y, jointPos1.z);
  for (int i = 1; i < in.bufferSize ()-1; i++) {
    PVector walker = new PVector();
    PVector ortho = new PVector();
    walker = dir.get();
    walker.setMag(paso*i); 
    walker.add(jointPos1);
    ortho = walker.cross(segmento);
    ortho.setMag(in.left.get(i)*500);
    ortho.add(walker); 
    fill(ortho.x%255, ortho.y%255, ortho.z%255, 20);
    vertex(ortho.x, ortho.y, ortho.z);
  }
  vertex(jointPos2.x, jointPos2.y, jointPos2.z);
  endShape();
  strokeWeight(1);
}

//---------------------
void drawNoiseLimb(int userId, int jointType1, int jointType2, int n)
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

  paso = segmento.mag() / float(in.bufferSize());

  dir = segmento.get();
  dir.normalize();

  /*
  stroke(255, 0, 0, 70);
   line(jointPos1.x, jointPos1.y, jointPos1.z, 
   jointPos2.x, jointPos2.y, jointPos2.z);
   */

  //stroke(frameCount%90, frameCount%180, frameCount%200, 20);
  strokeWeight(5);
  beginShape();
  stroke(190, 160, 120, 0);    
  curveVertex(jointPos1.x, jointPos1.y, jointPos1.z);
  curveVertex(jointPos1.x, jointPos1.y, jointPos1.z);
  for (int i = 1; i < in.bufferSize ()-1; i+=25) {
    PVector walker = new PVector();
    PVector ortho = new PVector();
    walker = dir.get();
    walker.setMag(paso*i); 
    walker.add(jointPos1);
    ortho = walker.cross(segmento);
    ortho.setMag(in.left.get(i)*250 + (250*noise(0.05*walker.x, 0.07*walker.y, 0.0017*walker.z*frameCount)-125));
    ortho.add(walker); 
    //line(walker.x,walker.y, walker.z, ortho.x, ortho.y, ortho.z );
    colorMode(HSB, 360, 255, 255, 255);
    fill(720*noise(0.001*walker.x, 0.002*walker.y, 0.00017*walker.z)%360, //r
    255*noise(0.002*walker.x, 0.0003*walker.y, 0.00017*walker.z), //g
    255*noise(0.0045*walker.x, 0.00067*walker.y, 0.00017*walker.z), //b
    120*sin(i*(1/1024.0)*TWO_PI));                                   //a
    //fill(ortho.x%255, ortho.y%255, ortho.z%255, 20);
    //noFill();
    curveVertex(ortho.x, ortho.y, ortho.z);
  }
  stroke(190, 160, 120, 0);
  curveVertex(jointPos2.x, jointPos2.y, jointPos2.z);
  curveVertex(jointPos2.x, jointPos2.y, jointPos2.z);
  endShape();
  strokeWeight(1);
  colorMode(RGB);
}

//---------------------
void drawSpiralLimb(int userId, int jointType1, int jointType2, int n)
{
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  PVector segmento  = new PVector();
  PVector dir       = new PVector();

  float  paso;
  float  confidence;
  float  lineWeight = random(0.1, 5);

  // draw the joint position
  confidence = kin.getJointPositionSkeleton(userId, jointType1, jointPos1);
  confidence = kin.getJointPositionSkeleton(userId, jointType2, jointPos2);

  segmento = jointPos2.get();
  segmento.sub(jointPos1);

  paso = segmento.mag() / float(n);

  dir = segmento.get();
  dir.normalize();

  /*
  stroke(255, 0, 0, 70);
   line(jointPos1.x, jointPos1.y, jointPos1.z, 
   jointPos2.x, jointPos2.y, jointPos2.z);
   */

  //stroke(frameCount%90, frameCount%180, frameCount%200, 20);
  strokeWeight(lineWeight);
  //curveTightness(5-10*noise(0.0002*jointPos1.x, 0.0003*jointPos1.y, 0.00017*jointPos1.z));
  beginShape();
  stroke(120, 0);    
  curveVertex(jointPos1.x, jointPos1.y, jointPos1.z);
  curveVertex(jointPos1.x, jointPos1.y, jointPos1.z);
  int count = 0;
  //PVector[] curva = new PVector[4];
  //curva[0] = jointPos1;
  for (int i = 1; i < n; i++) {
    float ang = 10*TWO_PI/n;
    PVector walker = new PVector();
    PVector ortho = new PVector();
    walker = dir.get();
    walker.setMag(paso*i); 
    walker.add(jointPos1);

    float amp = 50.0 + (random(-20, 20)*random(-20, 20) * sin(frameCount*0.01));
    float x = amp*cos(ang*i);
    float z = amp*sin(ang*i);
    walker.set(walker.x+x, walker.y+random(-10, 10), walker.z+z);
    ortho = walker.cross(segmento);
    int sn = int(map(i, 0, n, 0, in.bufferSize()));
    ortho.setMag(in.left.get(sn)*250 + (100*noise(0.05*walker.x, 0.07*walker.y, 0.0017*walker.z*frameCount)-50));
    ortho.add(walker); 
    //    curva[i%4] = new PVector(walker.x+x, walker.y+random(-30,30), walker.z+z);

    //    if(i%4 == 0){
    //      stroke(random(0,127), random(127,255));
    //      strokeWeight(random(0.1,10));
    //      curve(curva[0].x, curva[0].y, curva[0].z,
    //            curva[1].x, curva[1].y, curva[1].z,
    //            curva[2].x, curva[2].y, curva[2].z,
    //            curva[3].x, curva[3].y, curva[3].z);
    //            
    //    }
    //stroke(random(0, 255), random(127, 255));
    //  line(walker.x,walker.y, walker.z, ortho.x, ortho.y, ortho.z );
    //    colorMode(HSB, 360, 255, 255, 255);
    //    stroke(720*noise(0.001*walker.x, 0.002*walker.y, 0.00017*walker.z)%360, //r
    //    255*noise(0.002*walker.x, 0.0003*walker.y, 0.00017*walker.z), //g
    //    255*noise(0.0045*walker.x, 0.00067*walker.y, 0.00017*walker.z), //b
    //    120*sin(i*(1/1024.0)*TWO_PI));                                   //a
    //   
    stroke(random(0, 255), random(0, 155));
    //  noStroke();
    //  strokeWeight(10 * noise(0.0002*walker.x, 0.0003*walker.y, 0.00017*walker.z));
    //  strokeWeight(random(1,10));
    fill(random(0, 255), 255*amp);
    //  noFill();
    //curveVertex(walker.x+x, walker.y+random(-30,30), walker.z+z);
    curveVertex(ortho.x, ortho.y, ortho.z);
    count++;
  }
  stroke(190, 160, 120, 0);
  curveVertex(jointPos2.x, jointPos2.y, jointPos2.z);
  curveVertex(jointPos2.x, jointPos2.y, jointPos2.z);
  endShape();
  strokeWeight(1);
  //colorMode(RGB);
}

//---------------------
float rmsAmp() {
  float rms = 0;
  for (int i=0; i<in.bufferSize (); i++) {
    rms += in.left.get(i)*in.left.get(i);
  }
  return sqrt(rms/in.bufferSize());
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
    //scene = 1;
    cubeDepth = !cubeDepth;
  }
  if (key == 'w') {
    //    perspective(radians(45),
    //              float(width)/float(height),
    //              10,150000);
    perspective();
    //scene = 2;
    cubeSkel = !cubeSkel;
  }
  if (key == 'e') {
    perspective();
    //scene = 3;
    cubeContours = !cubeContours;
  }

  if (key == 'a') {
    perspective();
    //scene = 4;
    soundSkel = !soundSkel;
  }

  if (key == 'd') {
    perspective();
    //scene = 5;
    noiseSkel = !noiseSkel;
  }

  if (key == 'f') {
    perspective();
    //scene = 6;
    spiralSkel = !spiralSkel;
  }

  if (key == 'g') {
    pencilContours = !pencilContours;
  }

  if (key == 'h') {
    tintasTodas = !tintasTodas;
  }

  if (key == 'o') {
    perspective();
    //scene = 6;
    rojo = !rojo;
  }

  if (key == 'j') {
    partisInContours = !partisInContours;
  }

  if (key == 's') {
    saveFrame("#####-memorias");
  }

  switch(keyCode)
  {
  case LEFT:
    rotY += 0.1f;
    break;
  case RIGHT:
    // zoom out
    rotY -= 0.1f;
    break;
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

