
import toxi.sim.grayscott.*;
import toxi.math.*;
import toxi.color.*;

GrayScott gs;
ToneMap toneMap;
ColorGradient grad, grad2;
//PImage img;
PGraphics pg; // creamos el render sobre una PImage
boolean movMouse = false;
int NUM_ITERATIONS = 1;
PImage imgA;

int ancho = 800;
int alto = 600;
boolean relleno = true;
CuboMind cubito;
float giradorX = 0;
float giradorMapX = 0;
float giradorY = 0;
float giradorMapY = 0;
float giradorZ = 0;
float giradorMapZ = 0;
float alfa = 250;


void setup() {

  background(255);
  size(800, 600, P3D);
 
  //imgA=loadImage("rizomaX3.png");
  cubito = new CuboMind();
  //img = createImage(500, 300, ARGB);
  pg = createGraphics(200, 150,P3D);
  noStroke();
  gs=new GrayScott(pg.width, pg.height, false);

  // gs = new PatternedGrayScott(width,height,false);

  gs.setCoefficients(0.021, 0.076, 0.098, 0.07);
  //ColorGradient grad=new ColorGradient();
  grad = new ColorGradient();
  // NamedColors are preset colors, but any TColor can be added
  // see javadocs for list of names:
  // http://toxiclibs.org/docs/colorutils/toxi/color/NamedColor.html
  grad.addColorAt(0, NamedColor.WHITE);//BLACK
  grad.addColorAt(16, NamedColor.CORNSILK);
  grad.addColorAt(123, NamedColor.SLATEGRAY    );
   //grad.addColorAt(128, NamedColor.SNOW );
  grad.addColorAt(192, NamedColor.GHOSTWHITE );
  grad.addColorAt(255, NamedColor.DARKTURQUOISE   );

  toneMap=new ToneMap(0.0, 0.33, grad);
  // gs.seedImage(img.pixels, img.width, img.height);
}

void draw() {
background(255);
  //------------movimiento cubito------------------------------ 
  // alfa = map(mouseX, 0, ancho, 0, 100);
  giradorX = (giradorX + 1)%360;
  giradorMapX = map(giradorX, 0, 359, 0, 1);
  giradorY = (giradorY + 0.1)%360;
  giradorMapY = map(giradorY, 0, 359, 0, 1);
  giradorZ = (giradorZ + 0.01)%360;
  giradorMapZ = map(giradorZ, 0, 359, 0, 1);
  //---------------------------------------------------------

  pg.beginDraw(); 
  //pg.background(255);
  //gs.seedImage(imgA.pixels, imgA.width, imgA.height);
  if (movMouse) {
    gs.setRect(int(map(mouseX,0,width*4,0,width)), int(map(mouseY,0,height*4,0,height)), 16, 16);
    // gs.setCoefficients(0.026,0.08,0.15,0.03);//k = 0.064 - 0.068
    //gs.setRect(int(random(0, width)), height/2, 2, 2);
  }

  pg.loadPixels();

  for (int i=0; i< NUM_ITERATIONS; i++) {
    gs.update(1);
  }

  for (int i=0; i<gs.v.length; i++) {
    // take a GS v value and turn it into a packed integer ARGB color value
    pg.pixels[i]= toneMap.getARGBToneFor(gs.v[i]);
  }


  pg.updatePixels();

  pg.endDraw();
  //----------------------------------------------------
  cubito.vals(0, 0, 0, 
  giradorMapX, giradorMapY, giradorMapZ, 
  70, 
  //random(1), random(1), random(1), random(1), random(1), random(1), random(1), random(1)
  1,1,1,1,1,1,1,1);

  //cubito.display(pg);

  //pushMatrix();
  for(int yy = 0; yy< height; yy+=110){
   for(int xx = 0; xx< width; xx+=110) {
    pushMatrix();
  translate(xx, yy);
  cubito.display(pg, 0,0);
  popMatrix();
  }}
 //popMatrix();
  //image(pg, 0, 0);
  movMouse = false;
}

void keyPressed() {
  if (key>='1' && key<='9') {
    gs.setF(0.025+(key-'1')*0.001);
  } 
  if (key== 'r') {
    gs.reset();
  }
  if (key == 't') {
    gs.setCoefficients(0.021, 0.076, 0.12, 0.02);
  }

  if (key == 'c') {
    grad=new ColorGradient();
    grad.addColorAt(0, NamedColor.WHITE );//BLACK
    grad.addColorAt(23, NamedColor.PERU);
    grad.addColorAt(192, NamedColor.OLDLACE );
    grad.addColorAt(140, NamedColor.PALETURQUOISE  ); 
    grad.addColorAt(255, NamedColor.BLACK ); 

    toneMap=new ToneMap(0.0, 0.33, grad);
  } else {
    /*
    grad=new ColorGradient();
    grad.addColorAt(0, NamedColor.WHITE);//BLACK
    grad.addColorAt(16, NamedColor.CORNSILK);
    grad.addColorAt(23, NamedColor.PERU);
    grad.addColorAt(192, NamedColor.GHOSTWHITE );
    grad.addColorAt(255, NamedColor.BLACK);

    toneMap=new ToneMap(0.0, 0.33, grad);
    */
  }

  if (key == 'x') {
    grad=new ColorGradient();
    grad.addColorAt(0, NamedColor.WHITE );//BLACK
    grad.addColorAt(23, NamedColor.DARKGRAY);
    grad.addColorAt(255, NamedColor.BLACK ); 

    toneMap=new ToneMap(0.0, 0.33, grad);
  }
}

void mouseMoved() {

  movMouse = true;
}


class PatternedGrayScott extends GrayScott {
  public PatternedGrayScott(int w, int h, boolean tiling) {
    super(w, h, tiling);
  }

  public float getFCoeffAt(int x, int y) {
    y/=32;
    return 0==y%2 ? f : f-0.005;
  }

  public float getKCoeffAt(int x, int y) {
    return k-x*0.00004;
  }
}

