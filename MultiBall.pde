public class MultiBall extends PowerUp {
  //powerup that adds 2 more balls to the list
  public MultiBall(PVector pos, float siz, ArrayList<BouncingObject> objects, PImage img, int floor) {
    super(pos, siz, objects, img,floor);
  }

  void powerUp() {
    PlainCircle master = null;
    //the master ball 
    for (BouncingObject o : ArrayListAssignment.pieces) {//go through all of the game objectcs
      if (o.getType() ==ObjectType.CIRCLE) {//if the current object is a ball
        PlainCircle c = (PlainCircle)o;
        if (!c.clone) {//if the current ball isn't a clone
          master = c;//declare the master ball
        }
      }
    }
    for (int i = 0; i<2; i++) {//add 2 more balls at the position of the master ball
      if (master!=null) {
        PlainCircle p = new PlainCircle(master.pos.x, master.pos.y, 30, pieces);
        p.clone = true;
        ArrayListAssignment.pieces.add(p);
      }else{
       println("null"); 
      }
    }
  }
  void reset() {//balls automatically get removed when they hit the ground
  }
}