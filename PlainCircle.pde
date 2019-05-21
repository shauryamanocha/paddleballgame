class PlainCircle extends BouncingObject {
  color c = color(255);
  //color of the ball
  ArrayList<BouncingObject> boxes;
  //reference to all of the game pieces
  float speed = 5;
  //magnitude of the velocity
  boolean clone = false;
  //determines whether or not the ball was created as a result of the multi ball powerup
  public PlainCircle(PVector pos, ArrayList<BouncingObject>boxes) {
    super(pos);
    c = color(random(255), random(255), random(255));
    this.boxes = boxes;
    vel = PVector.random2D().mult(speed);
  }
  public PlainCircle(float x, float y, ArrayList<BouncingObject>boxes) {
    super(x, y);
    this.boxes = boxes;
    vel = PVector.random2D().mult(speed);
  }
  public PlainCircle(float x, float y, float siz, ArrayList<BouncingObject>boxes) {
    super(x, y, siz);
    this.boxes = boxes;
    vel = PVector.random2D().mult(speed);
  }
  public PlainCircle(PVector pos, float siz, ArrayList<BouncingObject>boxes) {
    super(pos, siz);
    this.boxes = boxes;
    vel = PVector.random2D().mult(speed);
  }
  
  void showVel(){
    stroke(255,0,0);
    strokeWeight(3);
    line(pos.x,pos.y,pos.x+vel.x*30,pos.y+vel.y*30);
  }

  void periodic() {
    for (int i = 0; i<boxes.size(); i++) {//iterate through the game objects
      if (boxes.get(i).getType() == ObjectType.BOX || boxes.get(i).getType() == ObjectType.POWERUP) {//check if the current object is a box or powerup        
        if (boxes.get(i).checkHit(this)) {//check if the ball is hitting the block/powerup
          BouncingObject b = boxes.get(i);

          if (abs(b.pos.x-pos.x)<abs(b.pos.y-pos.y)) {
            //within x range, bounce vertically
            if (b.getType() == ObjectType.BOX) {
              Box box = (Box)boxes.get(i);
              if (!box.dead) {//bounce off of the block
                bounceY();
                ArrayListAssignment.score++;//increase the user's score
                ArrayListAssignment.hitBlockSound.rewind();
                ArrayListAssignment.hitBlockSound.play();//play the hit sound
              }
            } else {
              PowerUp p = (PowerUp)boxes.get(i);
              if (!p.dead) {//bounce off of the block
                bounceY();
                ArrayListAssignment.score++;//increase the user's score
                ArrayListAssignment.hitBlockSound.rewind();
                ArrayListAssignment.hitBlockSound.play();//play the hit sound
              }
            }
          } else {
            //within y range, bounce horizontally
            if (b.getType() == ObjectType.BOX) {
              Box box = (Box)boxes.get(i);
              if (!box.dead) {//bounce off the block
                bounceX();
                ArrayListAssignment.score++;//increase the user's score
                ArrayListAssignment.hitBlockSound.rewind();
                ArrayListAssignment.hitBlockSound.play();//play the hit sound
              }
            } else {
              PowerUp p = (PowerUp)boxes.get(i);
              if (!p.dead) {//bounce off the block
                bounceX();
                ArrayListAssignment.score++;//increase the user's score
                ArrayListAssignment.hitBlockSound.rewind();
                ArrayListAssignment.hitBlockSound.play();//play the hit sound
              }
            }
          }
          if (boxes.get(i).getType() == ObjectType.BOX) {//if the object is a box
            Box box = (Box)boxes.get(i);
            box.vel.x = -vel.x*0.5;//make the box slide when it gets hit
            box.dead = true;
          } else if (boxes.get(i).getType() == ObjectType.POWERUP && !clone) {//if the object is a powerup
            PowerUp p = (PowerUp) boxes.get(i);
            if (!p.dead) {
              p.powerUp();//apply the effects of the powerup
              p.dead = true;
            }
          }
        }
      }
    }
  }
  float getReboundRate() {
    return 0.9;
  }
  ObjectType getType() {
    return ObjectType.CIRCLE;
  }

  void move() {//applies velocity and gravity
    vel.y+=PhysicsVars.GRAVITY;
    pos.add(vel);
  }
  void bounceX() {
    vel.x*=-1;
    ArrayListAssignment.bounceSound.rewind();//play the bounce sound when the ball hits edges
    ArrayListAssignment.bounceSound.play();
  }
  void bounceY() {
    if (clone && pos.y>height-siz/2) {//check if this is a clone created by a powerup and hit the bottom edge
      boxes.remove(this);//delete this
    } else if (pos.y>height-siz/2) {//if this hit the ground and this is not a clone
      ArrayListAssignment.lives.remainingLives--;//remove one life
      ArrayListAssignment.bounceSound.rewind();//play the bounce sound when the ball hits edges
      ArrayListAssignment.bounceSound.play();
    }
    pos.y-=vel.y;
    vel.y*=-1;
  }


  public void show() {//draw ball
    fill(c);
    if (clone) {
      noStroke();
      fill(c, 128);
    }
    ellipse(pos.x, pos.y, siz, siz);
    //showVel();
  }
}