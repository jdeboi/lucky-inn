abstract class Plant {
  
  int x, y;
  
  int age = 0;
  float growthRate = 1.0;
  float plantHeight = 0;
  int ageGrowthStops = 1000;
  int ageDeath = int(random(1200, 1600));
  
  
  Plant(int x, int y) {
    this.x = x;
    this. y = y;
  }

  
  float getMaxHeight() {
    return growthRate * ageGrowthStops;
  }
  
  void grow() {
    age++;
    if (age < ageGrowthStops) {
      plantHeight += growthRate;
    }
    if (age > ageDeath) {
      age = 0;
      plantHeight = 0;
    }
  }
  
  abstract void display();
  
}
