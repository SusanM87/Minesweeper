import de.bezier.guido.*;            

public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 40;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>();//ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton [NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++)
    {
        for(int c = 0; c < NUM_COLS; c++)
            buttons[r][c] = new MSButton(r,c);
    }
    
    setBombs();
}

public void setBombs()
{
    int ranRow;
    int ranCol;
    while(bombs.size() < NUM_BOMBS)
    {
        ranRow = (int)(Math.random()*NUM_ROWS);
        ranCol = (int)(Math.random()*NUM_COLS);
        if(!bombs.contains(buttons[ranRow][ranCol]))
        {
            bombs.add(buttons[ranRow][ranCol]);
            //System.out.println(ranRow + ", " + ranCol);
        }
    }

}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}

public boolean isWon()
{
    int counter = 0;
    for(int r = 0; r < buttons.length; r++)
    {
        for(int c = 0; c < buttons[r].length; c++)
        {
            if(buttons[r][c].marked == true || buttons[r][c].clicked == true)
                counter++;
        }
    }
    if(counter == 360)
        return true;
    return false;
}

public void displayLosingMessage()
{
    for(int r = 0; r < buttons.length; r++)
    {
        for(int c = 0; c < buttons[r].length; c++)
            buttons[r][c].setLabel("");
    }
    buttons[9][8].setLabel("Y");
    buttons[9][9].setLabel("O");
    buttons[9][10].setLabel("U");
    buttons[10][7].setLabel("L");
    buttons[10][8].setLabel("O");
    buttons[10][9].setLabel("S");
    buttons[10][10].setLabel("E");
}

public void displayWinningMessage()
{
    for(int r = 0; r < buttons.length; r++)
    {
        for(int c = 0; c < buttons[r].length; c++)
            buttons[r][c].setLabel("");
    }
    buttons[9][8].setLabel("Y");
    buttons[9][9].setLabel("O");
    buttons[9][10].setLabel("U");
    buttons[10][8].setLabel("W");
    buttons[10][9].setLabel("I");
    buttons[10][10].setLabel("N");
    buttons[10][11].setLabel("!");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT)
        {
            if(buttons[r][c].isMarked() == false)
                marked = true;
            else 
            {
                marked = false;
                clicked = false;
            }
        }
                
        else if(bombs.contains(this))
        {
            displayLosingMessage();
            
        }
        else if(countBombs(r,c) > 0)
        {
            String temp = "" + countBombs(r,c);
            setLabel(temp);
        }
        else
        {
            if(isValid(r-1,c-1) == true && buttons[r-1][c-1].isClicked() == false)
                buttons[r-1][c-1].mousePressed();
            if(isValid(r-1,c) == true && buttons[r-1][c].isClicked() == false)
                buttons[r-1][c].mousePressed();
            if(isValid(r-1,c+1) == true && buttons[r-1][c+1].isClicked() == false)
                buttons[r-1][c+1].mousePressed();
            if(isValid(r,c+1) == true && buttons[r][c+1].isClicked() == false)
                buttons[r][c+1].mousePressed();
            if(isValid(r+1,c+1) == true && buttons[r+1][c+1].isClicked() == false)
                buttons[r+1][c+1].mousePressed();
            if(isValid(r+1,c) == true && buttons[r+1][c].isClicked() == false)
                buttons[r+1][c].mousePressed();
            if(isValid(r+1,c-1) == true && buttons[r+1][c-1].isClicked() == false)
                buttons[r+1][c-1].mousePressed();
            if(isValid(r,c-1) == true && buttons[r][c-1].isClicked() == false)
                buttons[r][c-1].mousePressed();
        }
            
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill(100);

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r < NUM_ROWS && 0 <= r)
        {
            if(c < NUM_COLS && 0 <= c)
                return true;
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;

        if(isValid(row-1,col-1) == true && bombs.contains(buttons[row-1][col-1]) == true)
            numBombs++;
        if(isValid(row-1,col) == true && bombs.contains(buttons[row-1][col]) == true)
            numBombs++;
        if(isValid(row-1,col+1) == true && bombs.contains(buttons[row-1][col+1]) == true)
            numBombs++;
        if(isValid(row,col+1) == true && bombs.contains(buttons[row][col+1]) == true)
            numBombs++;
        if(isValid(row+1,col+1) == true && bombs.contains(buttons[row+1][col+1]) == true)
            numBombs++;
        if(isValid(row+1,col) == true && bombs.contains(buttons[row+1][col]) == true)
            numBombs++;
        if(isValid(row+1,col-1) == true && bombs.contains(buttons[row+1][col-1]) == true)
            numBombs++;
        if(isValid(row,col-1) == true && bombs.contains(buttons[row][col-1]) == true)
            numBombs++;

        return numBombs;
    }
}
