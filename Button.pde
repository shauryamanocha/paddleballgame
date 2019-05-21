public class Button {
  PVector pos, size;
  onClick interfaceClass;//interface used to define what happens when the button is pressed
  boolean release = true;//true if the button has been unpressed since the last frame
  color hover, unpressed;//colors used for when the block is unpressed and hovered over
  public Button(PVector pos, PVector size, color unpressed, color pressed, onClick interfaceClass) {
    this.pos = pos;
    this.size = size;
    this.interfaceClass = interfaceClass;
    rectMode(CENTER);
    this.hover = pressed;
    this.unpressed = unpressed;
  }
  public Button(PVector pos, PVector size, color unpressed, color pressed) {
    this.pos = pos;
    this.size = size;
    rectMode(CENTER);
    this.hover = pressed;
    this.unpressed = unpressed;
  }


  public void setCallback(onClick listener) {//used to define what interface to use when pressed
    this.interfaceClass = listener;
  }
  public void update() {//method used to draw the button and check if the button is pressed
    rectMode(CENTER);
    noStroke();
    if (mousePressed && release && withinBoundingBox(pos, size)) {//if the mouse was pressed and wasn't pressed in the previous frame, and the mouse is within the button
      release = false;
      interfaceClass.click();//run the user specified functionality for when the button is pressed
    }
    if (withinBoundingBox(pos, size)) {//if the user is hovering over the button
      fill(hover);//change the fill
      rect(pos.x,pos.y,size.x+15,size.y+15);//draw the button larger
    } else {
      fill(unpressed);
      rect(pos.x, pos.y, size.x, size.y);
    }

    release = !mousePressed;//reset whether or not the mouse has been released since the last frame
  }

  boolean withinBoundingBox(PVector center, PVector size) {//returns true if the mouse is within the button
    return (center.x-(size.x/2)<=mouseX && mouseX<=center.x+(size.x/2) && center.y-(size.y/2)<= mouseY && mouseY<= center.y+(size.y/2));
  }
}