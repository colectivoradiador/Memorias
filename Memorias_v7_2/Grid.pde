class Grid{
  float rows = 10;
  float cols = 10;
  PVector step;
  
  Grid(){
    step = new PVector(width/rows, height/cols);
    
  }
  
  void draw(){
    stroke(87, 255);
    for(int x = 0; x < cols; x++){
      line(x*step.x, 0, x*step.x, height);
      for(int y = 0; y < rows; y++){
        line(0, y*step.y, width, y*step.y);
      }
    }
  }
  
}
