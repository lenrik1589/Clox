class Button  
{    

  // Button location and size
  float x;   
  float y;   
  float w;   
  float h;   
  // Is the button on or off?
  boolean on;  
  boolean sr;
  String q="ON";

  // Constructor initializes all variables
  Button(float X, float Y, float W, float H, boolean srt, String qt)  
  {    
    x  = X;   
    y  = Y;   
    w  = W;   
    h  = H;   
    on = false;  // Button always starts as off
    sr=srt;
    q=qt;
  }    
  Button(float tempX, float tempY, float tempW, float tempH)  
  {    
    x  = tempX;   
    y  = tempY;   
    w  = tempW;   
    h  = tempH;   
    on = false;  // Button always starts as off
  }    

  void click(int mx, int my) 
  {
    // Check to see if a point is inside the rectangle
    if (mx > x && mx < x + w && my > y && my < y + h) 
    {
      on = !on;
    }
  }

  void MClick() {
    //get loc. of mouse
    int mx=mouseX;
    int my=mouseY;
    // Check to see if a point is inside the rectangle
    if (mx > x && mx < x + w && my > y && my < y + h) {
      on = !on;
    }
  }

  // Draw the rectangle
  void display() {
    rectMode(CORNER);
    if (q=="ON"||q=="on")
      stroke(0);
    else if (q=="OFF"||q=="off")
      noStroke();
    // The color changes based on the state of the button
    if (on) {
      fill(175);
    } else {
      fill(50);
    }
    rect(x, y, w, h);
  }
} 
