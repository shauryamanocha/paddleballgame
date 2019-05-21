/*
Shaurya Manocha
Last updated May 21 2019
Added a scoreboard that saves a file locally to retain highscores
*/

import ddf.minim.*;
//import minim for sound playback
public static ArrayList<BouncingObject> pieces;
//create an array of all the blocks and powerups
public static Paddle p;
//create the paddle
public static LifeCounter lives;
//create the life indicator
GIFViewer welcomeViewer, gameoverViewer, background;
//create GIF viewers for animated images
enum GameState {
  DEFAULT, 
    ENDLESS, 
    ONELIFE, 
    GAMEOVER, 
    ADD_HIGHSCORE, 
    VIEW_HIGHSCORE, 
    WELCOME
}
//declare variables for the different gamestates
enum ObjectType {
  BOX, 
    CIRCLE, 
    POWERUP
}
//constant variables used to determine what type of object something is
public static Table highScores;
//table that scores usernames and scores for players
int savedScores = 5;
//determines how many high scores to show
HighScoreManager scoreManager;
//object used to show previous high scores and to add new high scores
public static GameState currentState = GameState.WELCOME;
//start the game on the welcome screen
Button defaultPlay, endless, onelife, restart, exit, viewHighscores;
//create all of the menu buttons
public static Minim minim;
//create the minim object
public static AudioPlayer hitBlockSound, bounceSound, gameoverSound, music;
//create audio players for all of the different sounds
public static int score;
void setup() {
  size(600, 600);
  score = 0;
  minim = new Minim(this);
  hitBlockSound = minim.loadFile("hitblocksound.mp3");
  bounceSound = minim.loadFile("bouncesound.mp3");
  gameoverSound = minim.loadFile("sadtrombone.mp3");
  music = minim.loadFile("ambientmusic.mp3");
  //load all the sound files
  music.play();
  music.loop();
  //start playing the ambient music
  pieces = new ArrayList<BouncingObject>();
  //instantiate the arraylist of blocks and powerups
  p = new Paddle(new PVector(mouseX, mouseY), 150, 10);
  //instantiate the paddle
  pieces.add(new PlainCircle(width/2, 20, 30, pieces));
  //add a ball to the array of blocks and powerups
  lives = new LifeCounter(new PVector(0, 0), 25, 3);
  //instantiate the life indicator
  welcomeViewer = new GIFViewer(8, 5, "welcomegif/frame", ".gif");
  gameoverViewer = new GIFViewer(13, 5, "gameovergif/", ".gif");
  background = new GIFViewer(7, 5, "bggif/", ".gif");
  //load the images / instantiate the gif viewers
  highScores = loadTable("data/highScores.csv", "header");
  //get the existing high scores if they exist
  initHighScores();
  //make sure the table is formatted correctly
  scoreManager = new HighScoreManager();
  //instantiate the object to manage and view high scores
  defaultPlay = new Button(new PVector(width/2, 200), new PVector(100, 50), color(155, 51, 51), color(155, 0, 0));
  //instantiate the default menu button
  defaultPlay.setCallback(new onClick() {
    public void click() {
      currentState = GameState.DEFAULT;
      lives.remainingLives = 3;
    }
  }
  );
  //change the game state and set the number of lives if the button is pressed

  endless = new Button(new PVector(width/2, 300), new PVector(100, 50), color(155, 51, 51), color(155, 0, 0));
  endless.setCallback(new onClick() {
    public void click() {
      currentState = GameState.ENDLESS;
    }
  }
  );
  //change the game state if the button is pressed
  exit = new Button(new PVector(width-50, 25), new PVector(100, 50), color(155, 51, 51), color(155, 0, 0));
  exit.setCallback(new onClick() {
    public void click() {
      currentState = GameState.WELCOME;
      pieces.clear();
      pieces.add(new PlainCircle(width/2, 20, 30, pieces));
      score = 0;
    }
  }
  );
  //change the game state and reset the program if the button is pressed

  onelife = new Button(new PVector(width/2, 400), new PVector(100, 50), color(155, 51, 51), color(155, 0, 0));
  onelife.setCallback(new onClick() {
    public void click() {
      currentState = GameState.ONELIFE;
      lives.remainingLives = 1;
    }
  }
  );

  //change the game state and set the number of lives if the button is pressed

  restart = new Button(new PVector(width/2, height/2), new PVector(100, 50), color(155, 51, 51), color(155, 0, 0));
  restart.setCallback(new onClick() {
    public void click() {
      currentState = GameState.WELCOME;
      pieces.clear();
      pieces.add(new PlainCircle(width/2, 20, 30, pieces));
      score = 0;
    }
  }
  );

  viewHighscores = new Button(new PVector(width/2, 500), new PVector(100, 50), color(155, 51, 51), color(155, 0, 0));
  viewHighscores.setCallback(new onClick() {
    public void click() {
      currentState = GameState.VIEW_HIGHSCORE;
    }
  }
  );

  //change the game state if the button is pressed
}

void initHighScores() {//method to make sure the table is correctly formatted
  if (highScores.getColumnCount()<2) {//check if the table has the right columns
    highScores = new Table();//reset the table
    highScores.addColumn("name");
    highScores.addColumn("score");//add the columns
  }
  while (highScores.getRowCount()<savedScores) {//add blank highscores to make sure the table isnt empty
    TableRow blankRow = highScores.addRow();
    blankRow.setString("name", "----");
    blankRow.setInt("score", 0);
  }
  while (highScores.getRowCount()>savedScores) {//remove highscores to make sure there aren't too many table entries
    highScores.removeRow(highScores.getRowCount()-1);
  }
  highScores.setColumnType("score",Table.INT);
  highScores.sortReverse("score");
  saveTable(highScores, "data/highScores.csv");//save the formatted table
  println("high scores initialized as: ");//print the table to the console
  for (TableRow r : highScores.rows()) {
    println(r.getString("name")+", "+r.getInt("score"));
  }
}

void draw() {
  background.show(0, 0, width, height);
  //draw the background gif

  switch(currentState) {
  case DEFAULT:
    defaultGame();
    showGameData();
    break;
  case ENDLESS:
    endless();
    showGameData();
    break;
  case ONELIFE:
    defaultGame();//uses default game function because the only difference is # of lives
    showGameData();
    break;  
  case GAMEOVER:
    gameOver();
    showGameData();
    break;
  case WELCOME:
    welcome();
    break;
  case ADD_HIGHSCORE:
    scoreManager.addScoreInterface();
    break;
  case VIEW_HIGHSCORE:
    fill(255);
    textSize(25);
    for (int i = 0; i<highScores.getRowCount(); i++) {//show all of the high scores
      TableRow r = highScores.getRow(i);
      text(r.getString("name")+ ", "+r.getInt("score"), width/2, 300+i*30);
    }
    exit.update();
    //show the exit button
    fill(255);
    text("Exit", exit.pos.x, exit.pos.y);
    //show text on top of the exit button
    break;
  }
  //run the appropriate function depending on the current game mode
}

void showGameData() {
  exit.update();
  //show the exit button
  fill(255);
  text("Exit", exit.pos.x, exit.pos.y);
  //show text on top of the exit button
  textSize(15);
  text("Score: "+score, 50, 50);
  //display the score
}

void welcome() {
  background(255);
  welcomeViewer.show(0, 0, width, height);
  //draw the welcome screen gif
  textAlign(CENTER, CENTER);
  fill(0);
  textSize(50);
  text("Welcome to PaddleBall!", width/2, 100);
  //draw welcome text
  textSize(25);
  defaultPlay.update();
  endless.update();
  onelife.update();
  viewHighscores.update();
  //show the menu buttons
  fill(0);
  text("Default", defaultPlay.pos.x, defaultPlay.pos.y);
  text("Endless", endless.pos.x, endless.pos.y);
  text("One Life", onelife.pos.x, onelife.pos.y);
  textSize(15);
  text("High Scores", viewHighscores.pos.x, viewHighscores.pos.y);
  //show labels for the menu buttons
}

void defaultGame() {
  updateObjects();//update the ball(s), powerups and blocks
  lives.show();//show how many lives are left
  addBlocks();//add blocks after a certain amount of time has passed
  if (lives.remainingLives == 0) { //check if there are no lives left
    boolean newHighScore = false;
    for (TableRow r : highScores.rows()) {//check if the user has a new high score
      if (r.getInt("score")<score) {//if they have a new high score set the game state for them to save it
        currentState = GameState.ADD_HIGHSCORE;
        newHighScore = true;
        break;
      }
    }
    if (!newHighScore) {//if the user didnt get a new high score show the game over screen
      currentState = GameState.GAMEOVER;//set the game state to game over
      gameoverSound.rewind();
      gameoverSound.play();//play the game over sound
    }
  }
}

void gameOver() {//method used to display the game over screen
  gameoverViewer.show(0, 0, width, height);//show the gameover gif
  fill(255);
  text("Game Over", width/2, 200);//show the game over text
  restart.update();//show the restart button
  fill(0);
  text("Restart", restart.pos.x, restart.pos.y);
  //label the restart button
}


void endless() {//method for running the endless mode
  updateObjects();//update the blocks
  addBlocks();//randomly add blocks/powerups to the screen
}

void addBlocks() {//method used to randomly add new blocks/powerups to the screen
  if (frameCount%60 == 0) {//if one second has passed
    pieces.add(new Box(random(15, width-15), -15, 30, pieces, 200));//add a block to the screen
    if ((int)random(5) == 1) {//1 in 5 chance of creating a powerup
      switch(Math.round(random(2))) {//randomly pick a powerup to add
      case 1:
        pieces.add(new ExtendPaddle(new PVector(random(15, width-15), -15), 30, pieces, loadImage("extendPaddle.png"), 200));//add an extend paddle powerup
        break;
      case 2:
        pieces.add(new MultiBall(new PVector(random(15, width-15), -15), 30, pieces, loadImage("multiball.png"), 200));//add a multi ball powerup
        break;
      }
    }
  }
}

void updateObjects() {//method that updates all game components
  p.update();//update the paddle
  for (int i = 0; i<pieces.size(); i++) {//iterate through all game objects
    pieces.get(i).update();//update the object
    try {//try catch required because sometimes deleting objects would create an indexoutofbounds exception
      if (pieces.get(i).getType() == ObjectType.CIRCLE) {//if the current object is a circle
        PlainCircle c = (PlainCircle)pieces.get(i);
        p.hitBall(c);//have the paddle collide with the ball
      }
    }
    catch(Exception e) {
      //println(e.toString());
    }
  }
}

void keyPressed() {
  if (currentState == GameState.ADD_HIGHSCORE) {
    scoreManager.keyPressed();
  }
}