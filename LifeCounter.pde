public class LifeCounter {
  //class that displays how many lives the player has
  PImage life, noLife;//images that show a heart and the abscence of a heart
  PVector pos;//where to draw the hearts
  int lives;//how many total lives the user has
  int remainingLives;//how many lives the user has left
  int scale;//how big to draw the hearts
  public LifeCounter(PVector pos, int scale, int lives) {
    this.pos = pos.copy();
    life = loadImage("fullheart.png");
    noLife = loadImage("emptyheart.png");
    this.lives = lives;
    this.scale = scale;
    remainingLives = lives;
  }

  public void show() {//method to draw the hearts
    for (int i = 0; i<lives; i++) {//draw all of the empty hearts
      imageMode(CORNER);
      noLife.resize(scale*2,scale*2);
      image(noLife,pos.x+(scale+15)*i,pos.y);
    }
    
    for (int i = 0; i<remainingLives; i++) {//draw a full heart for every remaining life
      imageMode(CORNER);
      life.resize(scale*2,scale*2);
      image(life,pos.x+(scale+15)*i,pos.y);
    }
  }
}