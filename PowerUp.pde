abstract class PowerUp extends Box {
  PImage img;//image to indicate the powerup type
  int time = 0;//how long the powerup has been active for
  int effectTime = 300;//how long the powerup remains active
  public PowerUp(PVector pos, ArrayList<BouncingObject> objects, PImage img) {
    super(pos, objects);
    this.img = img;
  }
  public PowerUp(PVector pos, float siz, ArrayList<BouncingObject> objects, PImage img) {
    super(pos, siz, objects);
    this.img = img;
  }
  public PowerUp(PVector pos, float siz, ArrayList<BouncingObject> objects, PImage img, int floor) {
    super(pos.x, pos.y, siz, objects, floor);
    this.img = img;
  }

  void show() {//used to draw / update the powerup
    if (!dead) {
      fill(0, 255, 0);
      noStroke();
      rect(pos.x, pos.y, siz, siz);
      img.resize((int)siz, (int)siz);
      imageMode(CENTER);
      image(img, pos.x, pos.y);
    } else {//if this is dead, it has been hit --> start the timer
      time++;
    }

    if (time>effectTime) {//if the powerup has been applied for a certain amount of time
      reset();//undo the effects of the powerup
      ArrayListAssignment.pieces.remove(this);//delete this
    }
  }

  ObjectType getType() {
    return ObjectType.POWERUP;
  }

  abstract void powerUp();
  abstract void reset();

  void die() {
  }
}