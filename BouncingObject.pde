public abstract class BouncingObject {
  //class that defines basic physics behaviour for boxes / circles
  PVector pos, vel;
  float siz = 10;
  public BouncingObject(PVector pos) {
    this.pos = pos.copy();
    this.vel = new PVector(0, 0);
  }

  public BouncingObject(PVector pos, float siz) {
    this(pos);
    this.siz = siz;
  }
  public BouncingObject(float x, float y) {
    this(new PVector(x, y));
  }

  public BouncingObject(float x, float y, float siz) {
    this(x, y);
    this.siz = siz;
  }

  abstract void show();//show the object
  abstract void periodic();//any additional behaviour that needs to be called every frame
  abstract ObjectType getType();//returns CIRCLE, BOX, or POWERUP
  abstract void bounceX();//bounces in the x-axis, abstract for custom behaviour
  abstract void bounceY();//bounces in the y-axis, abstract for custom behaviour
  abstract void move();//applies velocity/acceleration to, abstract for custom behaviour
  //define abstract methods

  public void update() {
    show();
    periodic();
    hitBounds();
    move();
    //call all necessary methods
  }

  public boolean offScreen() {//returns true if the object is off the screen
    if (pos.x<siz/2 || pos.x>width-siz/2 || pos.y>height-siz/2) {
      return true;
    }
    return false;
  }
  
  public boolean checkHit(BouncingObject b){//returns true if two objects are colliding using square hit detection
    if(abs(pos.x-b.pos.x)<siz/2+b.siz/2 && abs(pos.y-b.pos.y)<siz/2+b.siz/2){
      return true;
    }
    return false;
  }

  private void hitBounds() {//method to bounce off the edges of the screen
    if (pos.y<siz/2) {
      bounceY();
      pos.y = siz/2;
    }
    if (pos.y>=height-siz/2) {
      bounceY();
      pos.y = height-siz/2;
    }

    if (pos.x<siz/2) {
      bounceX();
      pos.x = siz/2;
    }
    if (pos.x>width-siz/2) {
      bounceX();
      pos.x = width-siz/2;
    }
  }
}