public class Paddle {
  PVector pos, vel, normal;//vectors for position, velocity, and vector normal to the direction of the paddle
  int xSize, ySize;
  float rotation = 0;
  PVector[] colliders;//the positions of the circles along the length of the paddle that collides with the ball
  int amtColliders = 30;//how many colliders to use (too many causes buggy hit detection)
  public Paddle(PVector position, int xSize, int ySize) {
    pos = position;
    this.xSize = xSize;
    this.ySize = ySize;
    normal = new PVector(0, 1);
    vel = new PVector(0, 0);
    colliders = new PVector[amtColliders];
    for (int i = 0; i<amtColliders; i++) {
      colliders[i] = new PVector(-10, -10);
    }
  }

  public void update() {
    show();
    move();
    spin();
  }

  public void showIndicator() {//method to draw the normal vector
    normal.rotate(rotation-HALF_PI-normal.heading());
    normal.normalize();
    normal.mult(20);
    strokeWeight(3);
    stroke(255);
    line(pos.x, pos.y, pos.x+normal.x, pos.y+normal.y);
  }

  private void show() {//draws the paddle
    noStroke();
    fill(255);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rotation);
    rectMode(CENTER);
    rect(0, 0, xSize, ySize);
    popMatrix();
  }
  private void move() {//sets the paddle to the position of the mouse
    pos.set(mouseX, mouseY);
  }

  public void hitBall(PlainCircle b) {//collides with the ball
    updateColliders();//update the postiion of the colliders
    for (PVector c : colliders) {//iterate through all of the colliders
      if (PVector.dist(c, b.pos)<(ySize/(2*4)+b.siz/2)) {//check if the collider and ball are touching
        b.pos.sub(b.vel);//undo the balls movement
        b.vel.rotate(-2*(PVector.angleBetween(b.vel, normal)));//rotate the balls velocity to follow the law of reflection
        ArrayListAssignment.bounceSound.rewind();//play the bounce sound
        ArrayListAssignment.bounceSound.play();
        break;//stop checking for collisions
      }
    }
  }

  private void updateColliders() {//method to update the positions of the colliders
    showIndicator();
    PVector dir = new PVector(1, 0);//vector used to represent the direction of the paddle
    dir.rotate(rotation);
    float ballSpace = (xSize-ySize/(2f*4f))/colliders.length;//determines the spacing between each collider
    dir.mult(ballSpace);
    PVector offset = new PVector(-xSize/2+ySize/(2*4), 0);//offsets the colliders so they are correctly placed on top of the paddle
    offset.rotate(rotation);
    offset.add(pos.x, pos.y);
    fill(0, 255, 0);
    //ellipse(offset.x, offset.y, ySize, ySize);
    for (int i = 0; i<colliders.length; i++) {
      colliders[i].set(offset.x+(dir.x*i), offset.y+(dir.y*i));//set the collider positions
    }






    //draw the colliders
    fill(0, 0, 255);
    stroke(0);
    strokeWeight(1);
    for (PVector c : colliders) {
      ellipse(c.x, c.y, ySize/4, ySize/4);
    }
  }
  
  private void spin() {//method used to spin the paddle
    if (keyPressed) {
      switch(keyCode) {
      case LEFT:
        if (rotation>radians(-45)) {//prevents the user from spinning too far
          rotation-=radians(3);
        }
        break;
      case RIGHT:
        if (rotation<radians(45)) {//prevents the user from spinning too far
          rotation+=radians(3);
        }
        break;
      }
    }
  }

  public void setRotationDegrees(float rotation) {//method to set the rotation of the paddle in degrees
    this.rotation = radians(rotation);
  }
}