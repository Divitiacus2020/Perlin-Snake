class Grid {
  int gridsize;
  float elevation;
  float limit = 9; //limit for wall generation 10 = no wall
  PVector[] walls;
  
  Grid(int tempgridsize){
    gridsize = (width-2*edge)/(tempgridsize);
    walls = new PVector[0];
    elevation=0;
    } 
  
  void coordinates(){
    noiseSeed(int(random(100)));
    PVector w = new PVector(0,0);
      for (int i=0; i < gridsize-2; i ++) {
        for (int j=0; j < gridsize-2; j ++) {
          elevation = map(noise (i,j),0,1,0,10);
          if (elevation > limit){
            w = new PVector(i*gridsteps+edge+itemsize, j*gridsteps+edge+itemsize);
            //keeps area around snake free
            if (w.x < snake.location[0].x-50
              ||
              (w.y < snake.location[0].y-2*itemsize || w.y > snake.location[0].y+2*itemsize)
              ) {
              walls = (PVector[]) append(walls,w);
            }
          }
        }
      }
      
      level.beginShape(POINTS);
      level.strokeWeight(itemsize);
      level.stroke(168,34,38);
      level.strokeCap(PROJECT);
      for (int i=0; i < walls.length-1; i ++) {
          level.vertex(walls[i].x+itemsize/2, walls[i].y+itemsize/2);
       }      
      level.endShape();
  } 
  
  void display(){
    shape(level);
  }
}
