
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
PImage img;

void setup() {
  size(320, 240);

  gs=new GrayScott(width, height, false);

  //img=loadImage("rizomaX3.png");
  //img = createImage(500, 300, ARGB);
  pg = createGraphics(320, 240);
  // gs = new PatternedGrayScott(width,height,false);

  gs.setCoefficients(0.021, 0.076, 0.098, 0.06);
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

  pg.beginDraw();
 // gs.seedImage(img.pixels, img.width, img.height);

  if (movMouse) {
    gs.setRect(mouseX, mouseY, 16, 16);
    // gs.setCoefficients(0.026,0.08,0.15,0.03);//k = 0.064 - 0.068
    //gs.setRect(int(random(0, width)), height/2, 2, 2);
  }


  pg.loadPixels();

  for (int i=0; i< NUM_ITERATIONS; i++) {
    gs.update(1);
  }

  for (int i=0; i<gs.v.length; i++) {
    // take a GS v value and turn it into a packed integer ARGB color value
    pg.pixels[i]=toneMap.getARGBToneFor(gs.v[i]);
  }


  pg.updatePixels();
  pg.endDraw();

  image(pg, 0, 0);


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
   
  }

  if (key == 'x') {
    grad=new ColorGradient();
    grad.addColorAt(0, NamedColor.WHITE);//BLACK
  grad.addColorAt(16, NamedColor.CORNSILK);
  grad.addColorAt(123, NamedColor.SLATEGRAY    );
   //grad.addColorAt(128, NamedColor.SNOW );
  grad.addColorAt(192, NamedColor.GHOSTWHITE );
  grad.addColorAt(255, NamedColor.DARKTURQUOISE   );

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

