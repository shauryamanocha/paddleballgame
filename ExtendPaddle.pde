public class ExtendPaddle extends PowerUp {
  //powerup that temporarily increases the size of the paddle
  public ExtendPaddle(PVector pos, float siz, ArrayList<BouncingObject> objects, PImage img, int floor) {
    super(pos, siz, objects, img, floor);
  }

  void powerUp() {
    ArrayListAssignment.p.xSize = 300 ;//doubles the size of the paddle
  }
  void reset() {
    ArrayListAssignment.p.xSize = 150;//returns the paddle to regular size
  }
}