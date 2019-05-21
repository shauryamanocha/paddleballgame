class HighScoreManager {
  String username = "----";//the players username
  Table scoreTable;//table that stores all high scores
  public HighScoreManager() {
    scoreTable = ArrayListAssignment.highScores;//set the local table to a reference of the main table
  }

  public void addScoreInterface() {//method to show 
    textAlign(CENTER, CENTER);
    colorMode(HSB);
    textSize(40);
    fill((frameCount*2)%255,255,255);
    text("NEW HIGH SCORE!!!",width/2,200);
    colorMode(RGB);
    fill(255);
    textSize(30);
    text(username, width/2, height/2);
  }

  void keyPressed() {
    if (keyCode == ENTER && username!="") {//if the user has submitted a valid name
      TableRow row = scoreTable.addRow();//create the row for the users score
      row.setString("name", username);
      row.setInt("score",ArrayListAssignment.score);
      //add the users information to the row
      scoreTable.sortReverse(1);
      //sort the table by score
      scoreTable.removeRow(scoreTable.getRowCount()-1);
      //remove the remaining lowest score
      saveTable(scoreTable,"data/highScores.csv");
      //save the updated table
      ArrayListAssignment.currentState = GameState.VIEW_HIGHSCORE;
      //update the game state
    }

    if (keyCode == BACKSPACE) {//if the user is deleting part of their username
      if (username.length()>0) {//if there is text left to delete
        username = username.substring(0, username.length()-1);//delete the last character
      }
    } else {
      if (username == "----") {//if the name is left default delete it
        username ="";
      }
      if (username.length()<4) {//limits the length of the username
        username+=str(key);
      }
    }
  }
}