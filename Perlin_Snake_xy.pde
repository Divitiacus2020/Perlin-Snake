PFont mono;
PFont kobata;
Snake snake;
Grid grid;
Table highscore;
boolean lost = false;
PShape level;
int levelno=1;
int points=0;
String playername="";
int state = 0;
//variable parameters
PVector[] foodloc = new PVector[0];
int foodamount = 5;//amount of food
int itemsize =12; //size of food and width of snake
int snakelength = 50; //startsize and growth after food uptake
int speed = 1;
int gridsteps = 9;
int edge;

void setup(){
  size(700, 700);
  edge = 50;
  mono = createFont("JuliaMono-Medium.ttf", 32);
  kobata = createFont("Kobata-Regular.otf", 32);
}

void draw(){
  if (frameCount == 1){
    startscreen();
  }
  background(125);
  textFont(mono);
  //Top display
  textSize(20);
  fill(168, 34, 38);
  textAlign(LEFT);
  text("Level: "+levelno, edge-10, 30);
  textAlign(RIGHT);
  text("Points: "+points, width-(edge-10), 30);
  
  strokeWeight(20);
  stroke(168, 34, 38);
  fill(255);
  rectMode(CORNER);
  rect(edge,edge,float(width-2*edge), float(height-2*edge));
  
  grid.display();
  
  noStroke();
  fill(254,190,20);
  for (PVector i : foodloc) {
    square(i.x,i.y, itemsize);
  }
  
  snake.display();
  snake.move();
  snake.collisioncheck();
  
  if (lost == true) {
    endl();
  }
  
  if (foodloc.length == 0) {
    endw();
  }
  
  control();
  if (frameCount == 1){
    startscreen();
  }
}

void control(){
  if (keyPressed == true && keyCode == DOWN && snake.move.y != -speed){
    snake.move.x = 0;
    snake.move.y = speed;
  }
  if (keyPressed == true && keyCode == UP && snake.move.y != speed){
    snake.move.x = 0;
    snake.move.y = -speed;
  }
  if (keyPressed == true && keyCode == LEFT && snake.move.x != speed){
    snake.move.x = -speed;
    snake.move.y = 0;
  }
  if (keyPressed == true && keyCode == RIGHT && snake.move.x != -speed){
    snake.move.x = speed;
    snake.move.y = 0;
  }
}
  void keyPressed() {
    if (keyPressed == true && (key == 'C' || key == 'c') && foodloc.length == 0 ){
      levelno++;
      if (levelno < 4){
        grid.limit -= 0.5;
      } else {
          grid.limit -= 0.25;
        }
      snake = new Snake();
      grid.coordinates();
      food();
      loop();
  }
  if (keyPressed == true && (key == 'S' || key == 's' & frameCount == 2)){
        loop();
  }
  if (lost == true && highscore.getInt(4, "Points") < points && key==ENTER || key == RETURN){
   state=1; 
  } else {
    if (lost == true){
      playername += key;
    }
  }
  if (keyPressed == true && key == 'H' || key =='h' & lost == true){
    frameCount = 1;
    loop();
  }
  }
      



  void endl () {
    snake.move.x = 0;
    snake.move.y = 0;
    fill(255);
    rectMode(CENTER);
    rect (float(width/2),float(height/2), width-(2*edge+20), 150);
    textSize(50);
    textAlign(CENTER,CENTER);
    fill (166,3,19);
    text ("Game over", float(width/2), float(height/2)-20);
    if (highscore.getInt(4, "Points") < points){
      switch(state){
        case(0):
          textSize(15);
          text("Enter your name", float(width/2), float(height/2+20));
          text(playername,float(width/2), float(height/2+40));
          break;
        
        case(1):
          highscore.addRow();
          highscore.setString(highscore.getRowCount()-1,"Name", playername);
          highscore.setInt(highscore.getRowCount()-1,"Level", levelno);
          highscore.setInt(highscore.getRowCount()-1,"Points", points);
          highscore.sortReverse("Points");
          highscore.removeRow(highscore.getRowCount()-1);
          saveTable(highscore, "plhs.csv");
          textSize(15);
          text("Press h for homescreen",float(width/2), float(height/2+30));
          noLoop();
          break;
      }
    } else {
      textSize(15);
      text("Press h for homescreen",float(width/2), float(height/2+30));
      noLoop();
    }
  }
  
  void endw () {
    snake.move.x = 0;
    snake.move.y = 0;
    fill(255);
    rectMode(CENTER);
    rect (float(width/2),float(height/2+50), width-(2*edge+20), 250);
    textSize(50);
    textAlign(CENTER,CENTER);
    fill (166,3,19);
    text ("Level finished", float(width/2), float(height/2));
    textSize(15);
    text ("Press c to continue with the next level", float(width/2), float(height/2+50));
    noLoop();
  }
  
  void food() {
    PVector f;
    boolean ftest = true;
    for (int i = 0; foodloc.length < foodamount; i++){
      f = new PVector (int(map(random(1),0,1,edge+20,width-edge-20)), int(map(random(1),0,1,edge+20,height-edge-20)));
      for (PVector k : grid.walls){
        if (k.dist(f) < 1.5*itemsize) {
              ftest = false;
        }
      }
      if (ftest == true){
        foodloc = (PVector[])append(foodloc,f);
      } else { 
          ftest = true;
        }
    }
  }
  
  void startscreen(){
   //reset of variables
   lost = false;
   levelno=1;
   points=0;
   playername="";
   state = 0; 
   //start of new games
   level = createShape();
   snake = new Snake();
   grid = new Grid(gridsteps);
   grid.coordinates();
   food();
   highscore = loadTable("plhs.csv","header");
   highscore.setColumnType("Points", Table.INT);
   highscore.setColumnType("Level", Table.INT);
   
   background(255);
   fill(168, 34, 38);
   textFont(kobata);
   textSize(100);
   textAlign(CENTER);
   text("Perlin Snake", width/2, height/4);
   textSize(10);
   textFont(mono);
   text("Press s to start", width/2, height*6/8);
   text("Highscores", width/2, height*9/24);
   
   textSize(20);
   textAlign(LEFT);
   text("Name", width*5/18, height*11/24);
   textAlign(CENTER);
   text("Level", width*10/18, height*11/24);
   text("Points", width*13/18, height*11/24);
   for(int i=0; i < highscore.getRowCount(); i++){
     TableRow row = highscore.getRow(i);
       textAlign(LEFT);
       text(row.getString("Name"), width*5/18, height*12/24+i*20);
       textAlign(CENTER);
       text(row.getInt("Level"), width*10/18, height*12/24+i*20);
       text(row.getInt("Points"), width*13/18, height*12/24+i*20);
   }
   
   textAlign(LEFT);
   textSize(10);
   text("Fonts: \nJuliaMono Typeface (cormullion) \nKobata (Ariel Martin Perez) \nwww.fontesk.com", 50, height*7/8);
   noLoop();
  }
  
