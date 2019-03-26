class Palmetto {
  ArrayList<Palm>palms;

  Palmetto(int x, int y, int num, int sep) {
    palms = new ArrayList<Palm>();
    for (int i = 0; i < num; i++) {
      palms.add(new Palm(int(x + random(x-sep/2, x + sep/2)), y));
    }
  }

  void display() {
    for (Palm p : palms) {
      p.display();
    }
  }

  void grow() {
    for (Palm p : palms) {
      p.grow();
    }
  }
}


class Palm extends Plant {

  int stemH = 80;
  int stemW = 4;
  int numBlades = 16;
  int bladeW = 8;
  int bladeH = 80;

  Palm(int x, int y) {
    super(x, y);
    growthRate = random(1.0, 3);
    ageGrowthStops = 1000;
    ageDeath = int(random(4000, 8000));
  }

  void display() {
    noFill();
    stroke(255, 100);
    pushMatrix();

    translate(x, y);
    rotate(windAngle/4);
    scale(map(plantHeight, 0, getMaxHeight(), 0, 3));
    rect(-stemW/2, -stemH, stemW, stemH);
    translate(0, -stemH);
    rotate(windAngle);
    for (int i = 0; i < numBlades; i++) {
      pushMatrix();
      float minAngle = -PI/1.8;
      float maxAngle = minAngle * -1;
      float angleSpread = abs(minAngle)*2;
      float angle = minAngle + i * angleSpread / numBlades;
      if (angle < 0) angle -= map(angle, minAngle, 0, .4, 0); 
      else angle += map(angle, 0, maxAngle, 0, .4); 
      angle += (noise(angle/10) - .5)*.1;
      rotate(angle);

      float lenLongerInMiddle = map(abs(angle), maxAngle, 0, 0, -50);
      float widerInMiddle = map(abs(angle), maxAngle, 0, 0, 4);

      line(0, 0, 0, -bladeH + lenLongerInMiddle);
      triangle(0-(bladeW + widerInMiddle)/2, 0, 0, -bladeH + lenLongerInMiddle, (bladeW + widerInMiddle)/2, 0);
      popMatrix();
    }
    popMatrix();
  }
}
