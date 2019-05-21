public class Box extends BouncingObject {
  ArrayList<BouncingObject> objects;
  //reference to arraylist of all game objects
  float floorLevel = height;//determines where blocks will stack
  float deathTicks = 30;//how many frames the block appears broken before disappearing
  float deathCounter = 0;//used to count how many frames left until the box should be deleted
  PImage sprite = loadImage("blockSprite.png");//loads the sprite
  public boolean dead = false;
  public Box(PVector pos, ArrayList<BouncingObject> objects) {
    super(pos);
    this.objects = objects;
    vel.y = 0;
  }
  public Box(float x, float y, ArrayList<BouncingObject> objects) {
    super(x, y);
    this.objects = objects;
    vel.y = 0;
  }

  public Box(float x, float y, float siz, ArrayList<BouncingObject> objects, float floor) {
    super(x, y, siz);
    this.objects = objects;
    vel.y = 0;
    floorLevel = floor;
  }

  public Box(float x, float y, float siz, ArrayList<BouncingObject> objects) {
    super(x, y, siz);
    this.objects = objects;
    vel.y = 0;
  }

  public Box(PVector pos, float siz, ArrayList<BouncingObject> objects) {
    super(pos, siz);
    this.objects = objects;
    vel.y = 0;
  }

  void periodic() {
    vel.limit(siz/2);//limit the velocity
    for (BouncingObject b : objects) {//cycle through all game pieces
      if ((b.getType() == ObjectType.POWERUP || b.getType() == ObjectType.BOX) && b!=this) {//if the current object is a box or powerup
        if (pos.y+siz/2>b.pos.y-b.siz/2 && b.pos.y>pos.y  && abs(pos.x-b.pos.x)<=siz/2+b.siz/2) {//if the two blocks are hitting each other
          pos.y-=vel.y;//undo the last movement
          vel.y = 0;//stop falling
        }
        if (abs(b.pos.x-pos.x)<b.siz/2+siz/2 && vel.x!=0) {//if two blocks slide into each other
          b.vel.x = vel.x/2;
          vel.x = -vel.x/2;//make both blocks reflect off each other
        }
      }
    }
    if (dead) {
      sprite = loadImage("brokenBlockSprite.png");//if the block has been hit change its sprite
      deathCounter++;//count how many frames the block has been dead for
      if (deathCounter>deathTicks) {//if the block has been dead for 30 frames, remove it
        die();//used a function so that powerups can override it
      }
    }
  }
  float getReboundRate() {
    return PhysicsVars.BOX_REBOUND;
  }
  ObjectType getType() {
    return ObjectType.BOX;
  }
  
  void die(){
    objects.remove(this);
  }
  
  

  void move() {//function used to move the block
    if (pos.y<floorLevel-siz/2) {//if the block isnt on the ground apply gravity
      vel.y+=PhysicsVars.GRAVITY;
      pos.y+=vel.y;
    }else{
     pos.y = floorLevel-siz/2; 
    }
    pos.x+=vel.x;
    if (abs(vel.x)>0) {//reduce x velocity over time to simulate friction
      vel.x*=0.9;
    }
  }
  void bounceX() {//empty bounce functions because the blocks stack instead of bouncing
  }
  void bounceY() {
  }

  void show() {//method used to draw the box
    rectMode(CENTER);
    stroke(255);
    strokeWeight(3);
    fill(255, 248, 122, 200);
    //rect(pos.x, pos.y, siz, siz);
    sprite.resize((int)siz*2, (int)siz*2);
    imageMode(CENTER);
    image(sprite, pos.x, pos.y);
    textAlign(CENTER, CENTER);
    fill(0, 128);
    textSize(siz*(3.0/4.0));
    //text(vel.x, pos.x, pos.y);
  }
}