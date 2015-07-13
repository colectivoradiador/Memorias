class CuboMind {

float x, y, z, rotX, rotY, rotZ, tama,
vec1,vec2,vec3,vec4,vec5,vec6,vec7,vec8;

//PImage img;
/*
CuboMind(PImage _img){
  img = _img;
  }
  */
  
void vals(
float xpos, float ypos, float zpos,
float rotateX, float rotateY, float rotateZ,
float tamano,
float mulv1, float mulv2, float mulv3, float mulv4,
float mulv5, float mulv6, float mulv7, float mulv8
) {
x = xpos;
y = ypos;
z = zpos;
rotX = map(rotateX, 0, 1, 0, PI*2);
rotY = map(rotateY, 0, 1, 0, PI*2);
rotZ = map(rotateZ, 0, 1, 0, PI*2);
tama = tamano/2;
vec1 = mulv1;
vec2 = mulv2;
vec3 = mulv3;
vec4 = mulv4;
vec5 = mulv5;
vec6 = mulv6;
vec7 = mulv7;
vec8 = mulv8;


}


void display(PImage img, int x, int y) {
  //img = _img;
  pushMatrix();
 // translate(map(mouseX,0,ancho,ancho*0.35,ancho*0.65)-ancho/2,map(mouseY,0,alto,alto*0.35,alto*0.65)-alto/2);
  //translate(mouseX,mouseY);
  translate(x,y);
  
  
  rotateX(rotX);
  rotateY(rotY);
  rotateZ(rotZ);

/*cara cubo 1*/
  beginShape();
  tint(255,alfa);
  texture(img);
  vertex((x-tama)*vec1,(y-tama)*vec1,(z+tama)*vec1,0,0);//v1
  vertex((x-tama)*vec4,(y+tama)*vec4,(z+tama)*vec4,0,img.height);//v4
  vertex((x+tama)*vec3,(y+tama)*vec3,(z+tama)*vec3,img.width,img.height);//v3
  vertex((x+tama)*vec2,(y-tama)*vec2,(z+tama)*vec2,img.width,0);//v2
  endShape();
  
  /*cara cubo 2*/
  beginShape();
  tint(255,alfa);
  texture(img);
  vertex((x+tama)*vec2,(y-tama)*vec2,(z+tama)*vec2,0,0);//v2
  vertex((x+tama)*vec3,(y+tama)*vec3,(z+tama)*vec3,0,img.height);//v3
  vertex((x+tama)*vec7,(y+tama)*vec7,(z-tama)*vec7,img.width,img.height);//v7
  vertex((x+tama)*vec6,(y-tama)*vec6,(z-tama)*vec6,img.width,0);//v6
  endShape();
  
  /*cara cubo 3*/
  beginShape();
  tint(255,alfa);
  texture(img);
  vertex((x-tama)*vec5,(y-tama)*vec5,(z-tama)*vec5,img.width,0);//v5
  vertex((x+tama)*vec6,(y-tama)*vec6,(z-tama)*vec6,0,0);//v6
  vertex((x+tama)*vec7,(y+tama)*vec7,(z-tama)*vec7,0,img.height);//v7
  vertex((x-tama)*vec8,(y+tama)*vec8,(z-tama)*vec8,img.width,img.height);//v8
  endShape();
  
  /*cara cubo 4*/
  beginShape();
  tint(255,alfa);
  texture(img);
  vertex((x-tama)*vec1,(y-tama)*vec1,(z+tama)*vec1,img.width,0);//v1
  vertex((x-tama)*vec5,(y-tama)*vec5,(z-tama)*vec5,0,0);//v5
  vertex((x-tama)*vec8,(y+tama)*vec8,(z-tama)*vec8,0,img.height);//v8
  vertex((x-tama)*vec4,(y+tama)*vec4,(z+tama)*vec4,img.width,img.height);//v4
  endShape();
  
  /*cara cubo 5*/
  beginShape();
  tint(255,alfa);
  texture(img);
  vertex((x-tama)*vec1,(y-tama)*vec1,(z+tama)*vec1,0,img.height);//v1
  vertex((x+tama)*vec2,(y-tama)*vec2,(z+tama)*vec2,img.width,img.height);//v2
  vertex((x+tama)*vec6,(y-tama)*vec6,(z-tama)*vec6,img.width,0);//v6
  vertex((x-tama)*vec5,(y-tama)*vec5,(z-tama)*vec5,0,0);//v5
  endShape();
  
  /*cara cubo 6*/
  beginShape();
  tint(255,alfa);
  texture(img);
  vertex((x+tama)*vec3,(y+tama)*vec3,(z+tama)*vec3,img.width,0);//v3
  vertex((x-tama)*vec4,(y+tama)*vec4,(z+tama)*vec4,0,0);//v4
  vertex((x-tama)*vec8,(y+tama)*vec8,(z-tama)*vec8,0,img.height);//v8
  vertex((x+tama)*vec7,(y+tama)*vec7,(z-tama)*vec7,img.width,img.height);//v7
  endShape();
  
  popMatrix();

}

}
