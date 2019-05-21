public class GIFViewer{
  //object to display animated gifs
  int frames;//how many frames are in the animation
  String dir,extension;//declare the directory for the files and the filetype
  PImage current;//current frame
  int frameLen = 1;
  public GIFViewer(int frames, int frameLen, String dir, String extension){
    this.frames = frames;
    this.dir = dir;
    this.extension = extension;
    this.frameLen = frameLen;
  }
  
  public void show(int x, int y,int xSize,int ySize){
    current = loadImage(dir+frameCount/frameLen%frames+extension);//get the current image
    current.resize(xSize,ySize);//scale the image to the desired size
    imageMode(CORNER);
    image(current,x,y);//draw the image
  }
}