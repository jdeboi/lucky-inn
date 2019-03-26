Marsh marsh;
Palmetto palmetto;
Crab crab;

float windAngle = 0;
float windNoise = 0;

void setup() {
  size(800, 800);
  marsh = new Marsh(50, height, 100, width);
  palmetto = new Palmetto(90, height, 3, width); 
  crab = new Crab(50, 30, 50, 20);
}

void draw() {
  background(0);

  //translate(width/2, height/2); 
  wind();
  crab.display();
  palmetto.display();
  palmetto.grow();
  marsh.display();
  marsh.grow();
  crab.update();
  
}

void wind() {
  float windForce = map(mouseX,0,width,-PI/7,PI/7);
  windAngle =  windForce + windForce/4 * noise(windNoise += 0.01) * sin(millis()/100.0); // 2*PI * sin(mouseX/1000.0);
}
