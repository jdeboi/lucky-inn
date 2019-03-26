// adapted from Raven Kwok
// https://www.openprocessing.org/sketch/429719
PShape bodyImg;
PShape bottomLeg;
PShape topLeg;
PShape claw;
PShape pincher;
int minAng = 0;
int minAng2 = 80;

class Crab {


  Leg [] legsR, legsL;

  PVector pos, vel, acc, tgt;
  PVector [] vts;
  float w, h, legL, hFromG, decay, force;
  float rdns;

  Feet [] feet;

  Crab(int w, int h, int legL, int hFromG) {
    bodyImg = loadShape("assets/crabbody.svg");
    bottomLeg = loadShape("assets/bottomleg.svg");
    topLeg = loadShape("assets/topleg.svg");
    claw = loadShape("assets/claw.svg");
    pincher = loadShape("assets/topclaw.svg");
    this.w = w;
    this.h = h;
    this.legL = legL;
    this.hFromG = hFromG;
    pos = new PVector(0, 0);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    tgt = new PVector(0, 0);

    vts = new PVector[4];
    for (int i=0; i<vts.length; i++) {
      vts[i] = new PVector(0, 0);
    }

    feet = new Feet[3];
    for (int i=0; i<feet.length; i++) {
      feet[i] = new Feet();
    }

    legsR = new Leg[3];
    legsL = new Leg[3];
    for (int i=0; i<legsR.length; i++) {
      legsR[i] = new Leg(vts[2], 0, legL);
      legsL[i] = new Leg(vts[3], 1, legL);
    }

    rectMode(CENTER);

    decay = .8;
  }

  void update() {
    tgt.set(
      mouseX, height-h-hFromG//constrain(mouseY, height-h*2+map(constrain(vel.mag(), 0, 15), 0, 15, -h*.2, h*.2), height-h*.8)
      );
    acc = PVector.sub(tgt, pos);
    force = acc.mag();
    acc.normalize();
    acc.mult(force*.025);
    vel.add(acc);
    pos.add(vel);
    vel.mult(decay);

    rdns = map(constrain(vel.x, -25, 25), -25, 25, -PI*.0625, PI*.0625);

    vts[0].set(-w*.5, -h*.5);
    vts[1].set(w*.5, -h*.5);
    vts[2].set(w*.5, h*.5);
    vts[3].set(-w*.5, h*.5);
    for (int i=0; i<vts.length; i++) {
      vts[i].rotate(rdns);
      vts[i].add(pos);
    }

    if (frameCount == 1) {
      for (int i=0; i<feet.length; i++) {
        feet[i].fR.set(vts[2].x+random(25, 75), height);
        feet[i].fL.set(vts[3].x+random(-75, -25), height);
      }
    }

    for (int i=0; i<feet.length; i++) {
      feet[i].update(vts[3].x, vts[2].x, vel.mag());
    }


    for (int i=0; i<legsR.length; i++) {
      legsR[i].update(feet[i].fR);
      legsL[i].update(feet[i].fL);
    }
  }

  void display() {
    claw.disableStyle();
    pincher.disableStyle();
    displayClaws();
    
    bottomLeg.disableStyle();
    topLeg.disableStyle();
    strokeWeight(4);
    stroke(255);
    fill(0);

    for (int i=0; i<legsR.length; i++) {
      legsR[i].display();
      legsL[i].display();
    }
 
    bodyImg.disableStyle();
    fill(0);
    displayBody();
  }
  
  void displayClaws() {
    float factor = 0.3;
    shape(claw, vts[0].x-45, vts[0].y-65, claw.width*factor, claw.height*factor);
    pushMatrix();
    scale(-1.0, 1.0);
    shape(claw, -vts[0].x-45-claw.width*factor, vts[0].y-65, claw.width*factor, claw.height*factor);
    popMatrix();
  }

  void displayBody() {
    
    fill(0);
    strokeWeight(4);
    stroke(255);
    float factor = 0.8;
    shape(bodyImg, vts[0].x-bodyImg.width*factor/2 + w/2, vts[0].y - bodyImg.height*factor/2+5, bodyImg.width*factor, bodyImg.height*factor);
  }
}

class Feet {

  PVector fL, fR;

  float stepLength, stepHeight, stepF, sXL, sXR;
  boolean triggerStepL, triggerStepR, turnR = true;

  Feet() {
    fL = new PVector(0, 0);
    fR = new PVector(0, 0);
  }

  void update(float xL, float xR, float velMag) {
    if (turnR) {
      if (!triggerStepR && fR.x - xR > 150) {
        triggerStepR = true;
        stepLength = (xR - fR.x)+random(10, 150);
        stepHeight = abs(stepLength * random(.4, .6));
        sXR = fR.x;
        stepF = 0;
      } else if (!triggerStepR && fR.x - xR < minAng) {
        triggerStepR = true;
        stepLength = (xR - fR.x)+random(55, 155);
        stepHeight = abs(stepLength * random(.4, .6));
        sXR = fR.x;
        stepF = 0;
      }
      if (triggerStepR) {
        stepR(fR, stepLength, stepHeight, velMag);
      }
    } else {
      if (!triggerStepL && fL.x - xL < -150) {
        triggerStepL = true;
        stepLength = (xL - fL.x)+random(-150, -10);
        stepHeight = abs(stepLength * random(.4, .6));
        sXL = fL.x;
        stepF = 0;
      } else if (!triggerStepL && fL.x - xL > 25) {
        triggerStepL = true;
        stepLength = (xL - fL.x)-random(55, 155);
        stepHeight = abs(stepLength * random(.4, .6));
        sXL = fL.x;
        stepF = 0;
      }
      if (triggerStepL) {
        stepL(fL, stepLength, stepHeight, velMag);
      }
    }
  }

  void stepR(PVector foot, float stepLength, float stepHeight, float velMag) {
    float itp = map(constrain(velMag, 0, 15), 0, 15, .25, .75);
    stepF = lerp(stepF, PI, itp);
    foot.x = sXR + stepLength*stepF/PI;
    foot.y = sin(stepF)*-stepHeight+height;

    if (stepF >= PI-.01) {
      stepF = PI;
      triggerStepR = false;
      turnR = !turnR;
    }
  }

  void stepL(PVector foot, float stepLength, float stepHeight, float velMag) {
    float itp = map(constrain(velMag, 0, 15), 0, 15, .25, .75);
    stepF = lerp(stepF, PI, itp);
    foot.x = sXL + stepLength*stepF/PI;
    foot.y = sin(stepF)*-stepHeight+height;

    if (stepF >= PI-.01) {
      stepF = PI;
      triggerStepL = false;
      turnR = !turnR;
    }
  }
}

class Leg {

  float legLength;
  PVector vS, vM, vE;
  int mode;//0 - right, 1 - left

  Leg(PVector vS, int mode, int legLength) {

    this.legLength = legLength;

    this.vS = vS;
    this.mode = mode;
    vE = new PVector(0, 0);
    vM = new PVector(0, 0);
  }

  void update(PVector target) {

    PVector diff = PVector.sub(target, vS);
    float d = diff.mag();

    if (d>=2*legLength) {
      //diff.normalize();
      //diff.mult(legLength);
      diff.x *= legLength/d;
      diff.y *= legLength/d;
      vM.set(vS.x+diff.x, vS.y+diff.y);
      vE.set(vM.x+diff.x, vM.y+diff.y);
    } else {

      vE.set(target.x, target.y);
      if (mode == 0) diff.set(diff.y, -diff.x);
      else diff.set(-diff.y, diff.x);
      diff.x *= sqrt(sq(legLength)-sq(d*.5))/d;
      diff.y *= sqrt(sq(legLength)-sq(d*.5))/d;
      //diff.normalize();
      //diff.mult(sqrt(sq(legLength)-sq(d*.5)));
      vM.set((vS.x+vE.x)*.5+diff.x, (vS.y+vE.y)*.5+diff.y);
    }
  }

  void display() {

    

    displayFoot();
    displayTopLeg();
  }

  void displayTopLeg() {
    //ellipse(vS.x, vS.y, 30, 30);
    

    float factor = 0.36;

    // right legs
    if (mode == 0) {

      float y = vM.y - vS.y;
      float x = vM.x - vS.x;
      float ang = atan2(x, y);

      pushMatrix();
      translate(vS.x, vS.y);
      rotate(-ang + PI/2);
      shape(topLeg, 0, -4, topLeg.width*factor, topLeg.height*factor);
      popMatrix();

      // left legs
    } else {
      float y = vM.y - vS.y;
      float x = vS.x - vM.x;
      float ang = atan2(x, y);

      pushMatrix();
      translate(vS.x, vS.y);
      rotate(ang + PI/2);
      shape(topLeg, 0, 0, topLeg.width*factor, topLeg.height*factor);
      popMatrix();
    }
  }

  void displayFoot() {
    float factor = 0.4;
    

    // right foot
    if (mode == 0) {
      float y = vE.y - vM.y;
      float x = vM.x - vE.x;
      float ang = atan2(x, y);
      pushMatrix();
      translate(vM.x, vM.y);
      rotate(ang + PI/2);
      shape(bottomLeg, -3, -4, bottomLeg.width*factor, bottomLeg.height*factor);
      popMatrix();
    }
    // left foot
    else {
      float y = vE.y - vM.y;
      float x = vE.x - vM.x;
      float ang = atan2(x, y);
      pushMatrix();
      translate(vM.x, vM.y);
      rotate(-ang + PI/2);
      scale(1.0, -1.0);
      shape(bottomLeg, -9, 8-bottomLeg.height*factor, bottomLeg.width*factor, bottomLeg.height*factor);
      popMatrix();
    }
    //line(vS.x, vS.y, vM.x, vM.y);
    //line(vE.x, vE.y, vM.x, vM.y);
  }
}
