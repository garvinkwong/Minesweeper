import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 5; 
public final static int NUM_COLS = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS]; // first call to new 
  for (int row = 0; row<NUM_ROWS; row++) {
    for (int col = 0; col<NUM_COLS; col++) {
      buttons[row][col] = new MSButton(row, col); // second call to new
    }
  }
  setMines();
}
public void setMines()
{
  for (int m = 0; m<3; m++) {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon() {
  for (int row = 0; row < NUM_ROWS; row++) {
    for (int col = 0; col < NUM_COLS; col++) {
      if (mines.contains(buttons[row][col])) {
        if (!buttons[row][col].isFlagged()) {
          return false;
        }
      } else {
        if (buttons[row][col].isFlagged()) {
          return false;
        }
      }
    }
  }
  return true;
}

public void displayLosingMessage()
{
  buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("YOU LOST");
}
public void displayWinningMessage()
{
  buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("YOU WON");
}
public boolean isValid(int r, int c)
{
  if (r<NUM_ROWS && r>=0 && c<NUM_COLS && c>=0) {
    return true;
  } else {
    return false;
  }
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = row-1; r<=row+1; r++)
    for (int c = col-1; c<=col+1; c++)
      if (isValid(r, c) && mines.contains(buttons[r][c]))
        numMines++;
  if (mines.contains(buttons[row][col]))
    numMines--;
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    if (mouseButton == RIGHT) {
      if (flagged == true) {
        flagged = false;
        clicked = false;
      }
      if (flagged == false) {
        flagged = true;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(countMines(myRow, myCol));
    } else {
      if (isValid(myRow-1, myCol-1) && !buttons[myRow-1][myCol-1].clicked) {
        buttons[myRow-1][myCol-1].mousePressed();
      }
      if (isValid(myRow-1, myCol) && !buttons[myRow-1][myCol].clicked) {
        buttons[myRow-1][myCol].mousePressed();
      }
      if (isValid(myRow-1, myCol+1) && !buttons[myRow-1][myCol+1].clicked) {
        buttons[myRow-1][myCol+1].mousePressed();
      }
      if (isValid(myRow, myCol-1) && !buttons[myRow][myCol-1].clicked) {
        buttons[myRow][myCol-1].mousePressed();
      }
      if (isValid(myRow, myCol+1) && !buttons[myRow][myCol+1].clicked) {
        buttons[myRow][myCol+1].mousePressed();
      }
      if (isValid(myRow+1, myCol-1) && !buttons[myRow+1][myCol-1].clicked) {
        buttons[myRow+1][myCol-1].mousePressed();
      }
      if (isValid(myRow+1, myCol) && !buttons[myRow+1][myCol].clicked) {
        buttons[myRow+1][myCol].mousePressed();
      }
      if (isValid(myRow+1, myCol+1) && !buttons[myRow+1][myCol+1].clicked) {
        buttons[myRow+1][myCol+1].mousePressed();
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
