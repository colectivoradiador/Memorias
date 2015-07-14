class CuboMind {

  float x, y, z, rotX, rotY, rotZ, tama, 
  vec1, vec2, vec3, vec4, vec5, vec6, vec7, vec8;
  PImage img; 
  float[] vtx = new float[8];
  float giradorMapX = 0;
  float giradorMapY = 0;
  float giradorMapZ = 0;
  float alfa = 10;

  //-----------------------------
  CuboMind(PImage _img) {
    img = _img;
    for (int i=0; i< vtx.length; i++) {
      vtx[i] = random(0.001, 0.015);
      //vtx[i] = random(0.1, 1.0);
    }
  }

  //-----------------------------
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
    rotX = map(rotateX, 0, 1, 0, TWO_PI);
    rotY = map(rotateY, 0, 1, 0, TWO_PI);
    rotZ = map(rotateZ, 0, 1, 0, TWO_PI);
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

  //-----------------------------
  void vals(float xpos, float ypos, float zpos, float tamano) {

    alfa = 255;
    giradorMapX = map(int(frameCount*1)%360, 0, 359, 0, TWO_PI);
    giradorMapY = map(int(frameCount*1)%360, 0, 359, 0, TWO_PI);     
    giradorMapZ = map(int(frameCount*1)%360, 0, 359, 0, TWO_PI);
    x = xpos;
    y = ypos;
    z = zpos;
    rotX = giradorMapX;
    rotY = giradorMapY;
    rotZ = giradorMapZ;
    tama = tamano/2;
  float nScale = 1.0;
    vec1 = nScale*noise(x, y, sin(frameCount*vtx[0])); 
    vec2 = nScale*noise(x, y, sin(frameCount*vtx[1]));
    vec3 = nScale*noise(x, y, sin(frameCount*vtx[2])); 
    vec4 = nScale*noise(x, y, sin(frameCount*vtx[3])); 
    vec5 = nScale*noise(x, y, sin(frameCount*vtx[4])); 
    vec6 = nScale*noise(x, y, sin(frameCount*vtx[5])); 
    vec7 = nScale*noise(x, y, sin(frameCount*vtx[6])); 
    vec8 = nScale*noise(x, y, sin(frameCount*vtx[7]));
  }

  //-----------------------------
  void vals(PVector pos, float tamano) {

    alfa = 255;
    giradorMapX = map(int(frameCount*1)%360, 0, 359, 0, TWO_PI);
    giradorMapY = map(int(frameCount*1)%360, 0, 359, 0, TWO_PI);     
    giradorMapZ = map(int(frameCount*1)%360, 0, 359, 0, TWO_PI);
    x = pos.x;
    y = pos.y;
    z = pos.z;
    rotX = giradorMapX;
    rotY = giradorMapY;
    rotZ = giradorMapZ;
    tama = tamano/2;
    float nScale = 1.0;
    vec1 = nScale*noise(x, y, sin(frameCount*vtx[0])); 
    vec2 = nScale*noise(x, y, sin(frameCount*vtx[1]));
    vec3 = nScale*noise(x, y, sin(frameCount*vtx[2])); 
    vec4 = nScale*noise(x, y, sin(frameCount*vtx[3])); 
    vec5 = nScale*noise(x, y, sin(frameCount*vtx[4])); 
    vec6 = nScale*noise(x, y, sin(frameCount*vtx[5])); 
    vec7 = nScale*noise(x, y, sin(frameCount*vtx[6])); 
    vec8 = nScale*noise(x, y, sin(frameCount*vtx[7]));
  }

  //-----------------------------
  void display(PImage _img) {

    img = _img;
    noStroke();

    println(giradorMapX);

    pushMatrix();
    //translate(map(mouseX, 0, width, width*0.35, width*0.65)-width/2, map(mouseY, 0, height, height*0.35, height*0.65)-height/2);
    translate(x, y, z);
    rotateX(rotX);
    //rotateX(map(mouseX, 0, width, 0, TWO_PI));
    rotateY(rotY);
    rotateZ(rotZ);

    /*cara cubo 1*/
    beginShape();
    //tint(255, alfa);
    texture(img);
    vertex((-tama)*vec1, (-tama)*vec1, (tama)*vec1, 0, 0);//v1
    vertex((-tama)*vec4, (tama)*vec4, (tama)*vec4, 0, img.height);//v4
    vertex((tama)*vec3, (tama)*vec3, (tama)*vec3, img.width, img.height);//v3
    vertex((tama)*vec2, (-tama)*vec2, (tama)*vec2, img.width, 0);//v2
    endShape();

    /*cara cubo 2*/
    beginShape();
    //tint(255, alfa);
    texture(img);
    vertex((tama)*vec2, (-tama)*vec2, (tama)*vec2, 0, 0);//v2
    vertex((tama)*vec3, (tama)*vec3, (tama)*vec3, 0, img.height);//v3
    vertex((tama)*vec7, (tama)*vec7, (-tama)*vec7, img.width, img.height);//v7
    vertex((tama)*vec6, (-tama)*vec6, (-tama)*vec6, img.width, 0);//v6
    endShape();

    /*cara cubo 3*/
    beginShape();
    //tint(255, alfa);
    texture(img);
    vertex((-tama)*vec5, (-tama)*vec5, (-tama)*vec5, img.width, 0);//v5
    vertex((tama)*vec6, (-tama)*vec6, (-tama)*vec6, 0, 0);//v6
    vertex((tama)*vec7, (tama)*vec7, (-tama)*vec7, 0, img.height);//v7
    vertex((-tama)*vec8, (tama)*vec8, (-tama)*vec8, img.width, img.height);//v8
    endShape();

    /*cara cubo 4*/
    beginShape();
    //tint(255, alfa);
    texture(img);
    vertex((-tama)*vec1, (-tama)*vec1, (tama)*vec1, img.width, 0);//v1
    vertex((-tama)*vec5, (-tama)*vec5, (-tama)*vec5, 0, 0);//v5
    vertex((-tama)*vec8, (tama)*vec8, (-tama)*vec8, 0, img.height);//v8
    vertex((-tama)*vec4, (tama)*vec4, (tama)*vec4, img.width, img.height);//v4
    endShape();

    /*cara cubo 5*/
    beginShape();
    //tint(255, alfa);
    texture(img);
    vertex((-tama)*vec1, (-tama)*vec1, (tama)*vec1, 0, img.height);//v1
    vertex((tama)*vec2, (-tama)*vec2, (tama)*vec2, img.width, img.height);//v2
    vertex((tama)*vec6, (-tama)*vec6, (-tama)*vec6, img.width, 0);//v6
    vertex((-tama)*vec5, (-tama)*vec5, (-tama)*vec5, 0, 0);//v5
    endShape();

    /*cara cubo 6*/
    beginShape();
    //tint(255, alfa);
    texture(img);
    vertex((tama)*vec3, (tama)*vec3, (tama)*vec3, img.width, 0);//v3
    vertex((-tama)*vec4, (tama)*vec4, (tama)*vec4, 0, 0);//v4
    vertex((-tama)*vec8, (tama)*vec8, (-tama)*vec8, 0, img.height);//v8
    vertex((tama)*vec7, (tama)*vec7, (-tama)*vec7, img.width, img.height);//v7
    endShape();

    popMatrix();
  }
}

