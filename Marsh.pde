class Marsh {

  ArrayList<GrassBlade>grasses;

  Marsh(int x, int y, int num, int sep) {
    grasses = new ArrayList<GrassBlade>();
    for (int i = 0; i < num; i++) {
      grasses.add(new GrassBlade(int(x + random(x-sep/2, x + sep/2)), y));
    }
  }

  void display() {
    for (GrassBlade g : grasses) {
      g.display();
    }
  }

  void grow() {
    for (GrassBlade g : grasses) {
      g.grow();
    }
  }
}

class GrassBlade extends Plant {

  float curveAngle;
  float stemAngle;
  

  GrassBlade(int x, int y) {
    super(x, y);
    growthRate = random(.08, .15);
    ageGrowthStops = 1000;
    ageDeath = int(random(1200, 1600));

    stemAngle = radians(random(-5, 5));
    curveAngle = radians(random(-10, 10));
  }

  void display() {
    stroke(255, 150);
    //drawStem();
    //drawCurve();
    pushMatrix();
    translate(x, y);
    float angle = stemAngle + windAngle/3.0;
    angle = constrain(angle, -10, 10);
    rotate(angle);
    branch(plantHeight);
    popMatrix();
  }


  // Daniel Shiffman Nature of Code http://natureofcode.com
  void branch(float len) {
    // Each branch will be 2/3rds the size of the previous one




    float sw = map(len, 2, 120, 1, 10);
    strokeWeight(sw);

    line(0, 0, 0, -len);
    // Move to the end of that line
    translate(0, -len);

    len *= 0.66;
    // All recursive functions must have an exit condition!!!!
    // Here, ours is when the length of the branch is 2 pixels or less
    if (len > 2) {
      pushMatrix();    // Save the current state of transformation (i.e. where are we now)
      float angle = curveAngle + windAngle;
      angle = constrain(angle, -PI/7, PI/7);
      rotate(angle);   
      branch(len);       // Ok, now call myself to draw two new branches!!
      popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    }
  }

  
}
