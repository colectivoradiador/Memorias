class Tintas {
  GrayScott gs;
  ToneMap toneMap;
  //PImage img;
  PGraphics pg; // creamos el render sobre una PImage
  boolean movMouse = false;
  int NUM_ITERATIONS = 1;
  
  //--------------------------
  Tintas() {
    gs=new GrayScott(64, 64, false);
    //img = createImage(500, 300, ARGB);
    pg = createGraphics(64, 64);
    // gs = new PatternedGrayScott(width,height,false);

    gs.setCoefficients(0.021, 0.076, 0.085, 0.03);
    ColorGradient grad=new ColorGradient();
    // NamedColors are preset colors, but any TColor can be added
    // see javadocs for list of names:
    // http://toxiclibs.org/docs/colorutils/toxi/color/NamedColor.html
    grad.addColorAt(0, NamedColor.WHITE);//BLACK
    grad.addColorAt(16, NamedColor.CORNSILK);
    grad.addColorAt(23, NamedColor.CRIMSON );
    // grad.addColorAt(128, NamedColor.PINK);
    grad.addColorAt(192, NamedColor.PURPLE);
    grad.addColorAt(255, NamedColor.BLACK);

    toneMap=new ToneMap(0.0, 1.0, grad);
  }
  //--------------------------
  void update() {

    pg.beginDraw();
    //pg.background(255);
    if (movMouse) {
      gs.setRect(int(map(mouseX,0,width, 0,pg.width)), int(map(mouseY,0,height, 0,pg.height)), 3, 3);
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
  void draw(){
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
  PGraphics getGraphics() {
    
    return pg;
  }
}

