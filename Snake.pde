class Snake{
  PVector[] location;
  PVector move = new PVector (1,0);
  
  Snake(){
    location = new PVector[snakelength];
    location[0] = new PVector (int(map(random(1),0,1,width/4,3*width/4)),int(map(random(1),0,1,height/4,3*height/4)));
    for (int i=1; i < location.length; i++) {
      location[i] = new PVector (location[i-1].x-1, location[i-1].y);
      }
    }
  
  void display(){
    noStroke();
    fill(23,115,69);
    for (PVector i : location) {
      //rectMode(CENTER);
      square(i.x,i.y, itemsize);
    }
  }
  
  void move() {
    if (lost == false){
      for (int i=location.length-1; i > 0 ;i--) {
        location[i].x = location[i-1].x;
        location[i].y = location[i-1].y;
      }
        location[0].add(move);
    }
  }
  
  void collisioncheck(){
    //wall
    if (location[0].x < edge+0.5*itemsize || location[0].x > width-(edge+1.5*itemsize)) { //strokeWeight wall and background
      lost = true;
    }
    if (location[0].y < edge+0.5*itemsize || location[0].y > height-(edge+1.5*itemsize)) { //strokeWeight wall and background
      lost = true;
    }
    //snake
    for (int i=1; i < location.length; i++) {
      if (location[0].x == location[i].x && location[0].y == location[i].y){
        lost =true;
      }
    }
    //grid
    for (PVector k : grid.walls){
      if (k.dist(location[0]) < itemsize*0.75){
        lost = true;
      }
    }
    
    
    
    //food
    for (int i=0; i < foodloc.length; i++) {
      float xd = foodloc[i].dist(location[0]); 
      if (xd < itemsize*0.75){
          location = (PVector[])expand(location,location.length+snakelength);
          points++;
          for (int k=location.length-1; k > location.length-(snakelength+1) ;k--){
        location[k] = new PVector(-100,-100);
      }
    //remove food
    PVector[] foodloctemp;
    foodloctemp = new PVector[0];
    for (int j = 0; j < foodloc.length; j++){
           if(j < i) {
             foodloctemp = (PVector[])append(foodloctemp,foodloc[j]);
           } else {
            if (j > i) {
              foodloctemp = (PVector[]) append(foodloctemp,foodloc[j]);
            }
            }
           }
           foodloc = foodloctemp;
      }
    }
  }
}
