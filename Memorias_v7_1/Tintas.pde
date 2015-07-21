class Tintas {
  GrayScott gs;
  ToneMap toneMap;
  ColorGradient grad, grad2;
  //PImage img;
  PGraphics pg; // creamos el render sobre una PImage
  boolean movMouse = false;
  int NUM_ITERATIONS = 3;

  //--------------------------
  Tintas() {

    //img = createImage(500, 300, ARGB);
    pg = createGraphics(64, 64);
    gs=new GrayScott(pg.width, pg.height, false);
    // gs = new PatternedGrayScott(width,height,false);

    //gs.setCoefficients(0.021, 0.076, 0.085, 0.03);
    gs.setCoefficients(0.021, 0.076, 0.098, 0.07);
    grad=new ColorGradient();
    // NamedColors are preset colors, but any TColor can be added
    // see javadocs for list of names:
    // http://toxiclibs.org/docs/colorutils/toxi/color/NamedColor.html
    grad.addColorAt(0, NamedColor.WHITE);//BLACK
    grad.addColorAt(116, NamedColor.CORNSILK);
    grad.addColorAt(123, NamedColor.SLATEGRAY    );
    //grad.addColorAt(23, NamedColor.CRIMSON );
    // grad.addColorAt(128, NamedColor.PINK);
    grad.addColorAt(192, NamedColor.GHOSTWHITE );
    //grad.addColorAt(192, NamedColor.PURPLE);
    grad.addColorAt(129, NamedColor.BLACK);
    grad.addColorAt(220, NamedColor.DARKTURQUOISE   );

    toneMap=new ToneMap(0.0, 0.33, grad);
  }
  //--------------------------
  void update() {

    pg.beginDraw();
    //pg.background(255);
    if (movMouse) {
      gs.setRect(int(map(mouseX,0,width, 0,pg.width)), int(map(mouseY,0,height, 0,pg.height)), 2, 2);
      //gs.setRect(int(map(mouseX, 0, width*4, 0, width)), int(map(mouseY, 0, height*4, 0, height)), 16, 16);
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
    pg.filter(BLUR);
    pg.endDraw();

    //image(pg, 0, 0, width, height);


    movMouse = false;
  }
  
  //--------------------------
  void update(float px, float py) {

    pg.beginDraw();
    //pg.background(255);
    //if (movMouse) {
      gs.setRect(int(map(px, 0, width, 0, pg.width)), int(map(py, 0, height, 0, pg.height)), 2, 2);
      //gs.setRect(int(map(mouseX, 0, width*4, 0, width)), int(map(mouseY, 0, height*4, 0, height)), 16, 16);
      // gs.setCoefficients(0.026,0.08,0.15,0.03);//k = 0.064 - 0.068
      //gs.setRect(int(random(0, width)), height/2, 2, 2);
    //}

    pg.loadPixels();

    for (int i=0; i< NUM_ITERATIONS; i++) {
      gs.update(1);
    }

    for (int i=0; i<gs.v.length; i++) {
      // take a GS v value and turn it into a packed integer ARGB color value
      pg.pixels[i]=toneMap.getARGBToneFor(gs.v[i]);
    }
    pg.updatePixels();
    pg.filter(BLUR);
    pg.endDraw();

    //image(pg, 0, 0, width, height);


    //movMouse = false;
  }

  //-------------------------- 
  void draw() {
    //pg.filter(BLUR);
    image(pg, 0, 0, width, height);
  }

  //------------------------- 
  PImage getImage() {
    PImage img = createImage(pg.width, pg.height, ARGB);
    pg.loadPixels();
    for (int i = 0; i < pg.pixels.length; i++ ) {
      color c = pg.pixels[i];
      //if(red(c) == green(c) && green(c) == blue(c)){
      c = color(red(c), green(c), blue(c), 255-brightness(c));
      //}else{ 
      //  c = color(red(c), green(c), blue(c), alpha(c));
      //}
      img.pixels[i] = c;
    }
    img.updatePixels();
    return img;
  }

  //-------------------------
  void browny() {
    grad=new ColorGradient();
    grad.addColorAt(0, NamedColor.WHITE );//BLACK
    grad.addColorAt(23, NamedColor.PERU);
    grad.addColorAt(192, NamedColor.OLDLACE );
    grad.addColorAt(140, NamedColor.PALETURQUOISE  ); 
    grad.addColorAt(255, NamedColor.BLACK ); 

    toneMap=new ToneMap(0.0, 0.33, grad);
  }

  //-------------------------
  void blaky() {
    grad=new ColorGradient();
    grad.addColorAt(0, NamedColor.WHITE );//BLACK
    grad.addColorAt(23, NamedColor.DARKGRAY);
    grad.addColorAt(255, NamedColor.BLACK ); 

    toneMap=new ToneMap(0.0, 0.33, grad);
  }
  
  //-------------------------
  void metalBlue() {
    grad.addColorAt(0, NamedColor.WHITE);//BLACK
    grad.addColorAt(116, NamedColor.CORNSILK);
    grad.addColorAt(123, NamedColor.SLATEGRAY    );
    grad.addColorAt(129, NamedColor.GHOSTWHITE );    
    grad.addColorAt(192, NamedColor.BLACK);
    grad.addColorAt(220, NamedColor.DARKTURQUOISE   );
    toneMap=new ToneMap(0.0, 0.33, grad);
  }

  //------------------------- 
  PGraphics getGraphics() {

    return pg;
  }
}

