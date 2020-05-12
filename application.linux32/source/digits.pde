class digit
{
  int[][] x = new int[10][7], y = new int[10][7];
  //ArrayList<ArrayList<PVector>> cel = new ArrayList<ArrayList<PVector>>();
  float[][] rot = new float[10][7];
  int ste = 100; 
  float scl = 5;

  digit() {
  }  
  digit(int st) {
    ste=st;
  }

  void sedup() {
    //0
    addxy( new PVector(1, 0), -1, 0, 0);
    addxy( new PVector(6, 1), 0, 0, 1);
    addxy( new PVector(6, 7), 0, 0, 2);
    addxy( new PVector(1, 12), -1, 0, 3);
    addxy( new PVector(0, 7), 0, 0, 4);
    addxy( new PVector(0, 1), 0, 0, 5);
    addxy( new PVector(6, 1), 0, 0, 6);
    //1
    addxy( new PVector(6, 1), 0, 1, 0);
    addxy( new PVector(6, 1), 0, 1, 1);
    addxy( new PVector(6, 7), 0, 1, 2);
    addxy( new PVector(6, 7), 0, 1, 3);
    addxy( new PVector(6, 7), 0, 1, 4);
    addxy( new PVector(6, 1), 0, 1, 5);
    addxy( new PVector(6, 1), 0, 1, 6);
    //2
    addxy( new PVector(1, 0), -1, 2, 0);
    addxy( new PVector(6, 1), 0, 2, 1);
    addxy( new PVector(6, 7), 1, 2, 2);
    addxy( new PVector(1, 12), -1, 2, 3);
    addxy( new PVector(0, 7), 0, 2, 4);
    addxy( new PVector(1, 0), -1, 2, 5);
    addxy( new PVector(1, 6), -1, 2, 6);
    //3
    addxy( new PVector(1, 0), -1, 3, 0);
    addxy( new PVector(6, 1), 0, 3, 1);
    addxy( new PVector(6, 7), 0, 3, 2);
    addxy( new PVector(1, 12), -1, 3, 3);
    addxy( new PVector(1, 6), -1, 3, 4);
    addxy( new PVector(1, 0), -1, 3, 5);
    addxy( new PVector(1, 6), -1, 3, 6);
    //4
    addxy( new PVector(0, 1), 0, 4, 0);
    addxy( new PVector(6, 1), 0, 4, 1);
    addxy( new PVector(6, 7), 0, 4, 2);
    addxy( new PVector(6, 7), 0, 4, 3);
    addxy( new PVector(1, 6), -1, 4, 4);
    addxy( new PVector(0, 1), 0, 4, 5);
    addxy( new PVector(1, 6), -1, 4, 6);
    //5
    addxy( new PVector(1, 0), -1, 5, 0);
    addxy( new PVector(6, 1), 1, 5, 1);
    addxy( new PVector(6, 7), 0, 5, 2);
    addxy( new PVector(1, 12), -1, 5, 3);
    addxy( new PVector(1, 6), -1, 5, 4);
    addxy( new PVector(0, 1), 0, 5, 5);
    addxy( new PVector(1, 6), -1, 5, 6);
    //6
    addxy( new PVector(1, 0), -1, 6, 0);
    addxy( new PVector(6, 1), 1, 6, 1);
    addxy( new PVector(6, 7), 0, 6, 2);
    addxy( new PVector(1, 12), -1, 6, 3);
    addxy( new PVector(0, 7), 0, 6, 4);
    addxy( new PVector(0, 1), 0, 6, 5);
    addxy( new PVector(1, 6), -1, 6, 6);
    //7
    addxy( new PVector(1, 0), -1, 7, 0);
    addxy( new PVector(6, 1), 0, 7, 1);
    addxy( new PVector(6, 7), 0, 7, 2);
    addxy( new PVector(6, 7), 0, 7, 3);
    addxy( new PVector(6, 7), 0, 7, 4);
    addxy( new PVector(1, 0), -1, 7, 5);
    addxy( new PVector(6, 1), 0, 7, 6);
    //8
    addxy( new PVector(1, 0), -1, 8, 0);
    addxy( new PVector(6, 1), 0, 8, 1);
    addxy( new PVector(6, 7), 0, 8, 2);
    addxy( new PVector(1, 12), -1, 8, 3);
    addxy( new PVector(0, 7), 0, 8, 4);
    addxy( new PVector(0, 1), 0, 8, 5);
    addxy( new PVector(1, 6), -1, 8, 6);
    //9
    addxy( new PVector(1, 0), -1, 9, 0);
    addxy( new PVector(6, 1), 0, 9, 1);
    addxy( new PVector(6, 7), 0, 9, 2);
    addxy( new PVector(1, 12), -1, 9, 3);
    addxy( new PVector(1, 6), -1, 9, 4);
    addxy( new PVector(0, 1), 0, 9, 5);
    addxy( new PVector(1, 6), -1, 9, 6);
  }


  void dis(float xo, float yo, int ms, int ol, int ne, float off, float bri)
  {
    float prog = min((ms%1000)/100.0, 1);
    push();
    translate(xo, yo);
    rectMode(CORNER);
    for (int i = 6; i >= 0; i--)
    {
      push();
      translate(lerp(x[ol][i], x[ne][i], prog)*abs(scl), lerp(y[ol][i]-rot[ol][i]%2, y[ne][i]-rot[ne][i]%2, prog)*abs(scl));
      rotate(lerp(rot[ol][i], rot[ne][i], prog)/2*3.1415926);
      //fill(abs(i*360/7+off)%360, 64 + 191 * bri, 127 + 128 * bri, 255);
      stroke(bri);
      rect(0, 0, scl, 5*scl);
      pop();
    }
    //println(cel);
    rectMode(CORNER);
    //scl=5;
    pop();
    //translate(-x,-y);
  }

  void addxy(PVector a, float r, int i, int j)
  {
    x[i][j] = (int)a.x;
    y[i][j] = (int)a.y;
    rot[i][j] = r;
  }
}
