package processing.test.clock;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import shiffman.box2d.*; 
import org.jbox2d.collision.shapes.*; 
import org.jbox2d.common.*; 
import org.jbox2d.dynamics.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Clock extends PApplet {









boolean f=true, prev=true;
int cx, cy, year, mon, day, hr, min, sec, ms, lastT, deltaT, mc, i, cas=0;
int radius, acc=1, g=0;
int[] pos;
float secondsRadius, oR;
float minutesRadius;
float hoursRadius;
float clockDiameter;
float mode2r;
float recta, rectb, mod, frr;
ArrayList<PVector> a = new ArrayList();
digit[] di = new digit[12];
ballclock balls;
GregorianCalendar cdr;
Button[] buttons = new Button[4];
Box2DProcessing box2d;


public void setup() {

  frameRate(25554);

  
  //size(400, 400);
  /* true*/

  stroke(255);

  cdr = new GregorianCalendar();
  lastT = 0;
  deltaT = 0;

  for (int i = 0; i < di.length; i++)
    di[i] = new digit();
  for (digit d : di) {
    d.scl = ((width-width/12.5f*2-20)/(8*6+1)-.2f);
    d.sedup();
  }
  println(di[0].scl);

  radius = min(width, height) / 2;
  secondsRadius = radius * 0.80f;
  oR=secondsRadius*1.04f;
  minutesRadius = secondsRadius * 0.85f;
  hoursRadius = minutesRadius * 0.9f;
  clockDiameter = radius * 1.8f;
  mode2r = clockDiameter;
  recta=width*0.8f;
  rectb=radius*0.8f;

  balls=new ballclock((int)recta, (int)(height*0.8f));
  cx = width / 2;
  cy = height / 2;
  colorMode(HSB, 360, 255, 255, 255);
  background(0, 0, 0, 0);
  

  buttons[0] = new Button(width*1.5f/100, height*1.5f/100, width/12.5f, height/12.5f, true, "off");
  buttons[1] = new Button(width*90.5f/100, height*1.5f/100, width/12.5f, height/12.5f, true, "off");
  buttons[2] = new Button(width*1.5f/100, height*90.5f/100, width/12.5f, height/12.5f, true, "off");
  buttons[3] = new Button(width*90.5f/100, height*90.5f/100, width/12.5f, height/12.5f, true, "off");
  for (int i = 0; i < 720; i++) {
    float an = radians(i/2);
    float x = cos(an) * oR;
    float y = sin(an) * oR;
    a.add(new PVector(x, y));
  }
  textSize(radius/35);
  pos = new int[6];
  pos[0] = 10;
  pos[1] = 10 + 8 * (int)di[0].scl;
  pos[2] = 10 + (8 * 2 + 1) * (int)di[0].scl;
  pos[3] = 10 + (8 * 3 + 1) * (int)di[0].scl;
  pos[4] = 10 + (8 * 4 + 2) * (int)di[0].scl;
  pos[5] = 10 + (8 * 5 + 2) * (int)di[0].scl;
}



public void draw() {
  int bri=(int)map(mod, 1, 0, 0, 255);
  background(180, 255, bri);

  if (keyPressed) 
    if (key=='1'&&!prev) {
      cas++;
      prev=true;
    } else 
    //if (key=='2')cas=cas;
    //else 
    //if (key=='3')cas=cas;
    //else 
    //if (key=='4')cas=cas;
    //else 
    if (key=='5'&&!prev)
    {
      acc=1-acc;
      prev=true;
    } else 
    if (key=='6'&&!prev)
    {
      g=1-g;
      prev=!prev;
    } else 
    if (key=='7') {
      acc=0;
    } else
      if (key=='m'&&!prev) {
        if (acc==1)
          mod=round(1-mod);
        else
          mod=1-mod;
        prev=true;
      } 

  translate(cx, cy);

  //sync
  // Get the elapsed time since the last draw method
  int now = millis();
  deltaT = now - lastT; 
  lastT = now;
  //Update the calendar with the elapsed time
  cdr.add(Calendar.MILLISECOND, 1*deltaT);
  ms = cdr.get(Calendar.MILLISECOND);
  sec = cdr.get(Calendar.SECOND);
  min = cdr.get(Calendar.MINUTE);
  hr = cdr.get(Calendar.HOUR_OF_DAY);
  day = cdr.get(Calendar.DAY_OF_MONTH);
  mon = cdr.get(Calendar.MONTH);
  year = cdr.get(Calendar.YEAR);
  int maxd = mon==2?year%4==0?29:28:mon<8?30+mon%2:31-mon%2;
  float st = sec + ms / 1000.0f, 
    mt = min + norm(st, 0, 60), 
    ht = hr + norm(mt, 0, 60), 
    dt = day - 1 + norm(ht, 0, 24), 
    mot = mon + norm(dt, 0, maxd), 
    yt = year - 1 + norm(mot, 0, 12);


  switch(cas)
  {
  case 0:
    push();
    // Angles for sin() and cos() start at 3 o'clock;
    // subtract HALF_PI to make them start at the top
    float s = map(acc*(sec+ms/1000.0f), 0, 30, 0, -PI);
    float m = map(mt, 0, 61, 0, TWO_PI+PI/30) - HALF_PI; 
    float h = map(ht, 0, 24, 0, PI*2) + HALF_PI;

    // Draw the clock background
    fill(0, 0, bri);
    stroke(127);
    strokeWeight(radius/100);
    ellipse(0, 0, clockDiameter, clockDiameter);


    // Draw the hands of the clock
    if (acc!=0)
    {
      strokeWeight(radius/100);
      stroke((sec+ms/1000.0f+45)*6%360, 255, bri/2+127);
      line(0, 0, -sin(s) * secondsRadius, -cos(s) * secondsRadius);
    }
    //if (sec>15) stroke(((sec+ms/1000)%60)*6-90, 255, bri/2+127); 
    //      else
    strokeWeight(radius/75);
    if (mt>15) stroke(mt*6-90, 255, bri/2+127); 
    else stroke(mt*6+270, 255, bri/2+127);
    line(0, 0, cos(m) * minutesRadius, sin(m) * minutesRadius);

    strokeWeight(radius/50);
    if (ht>6) stroke((ht)*15-90, 255, bri/2+127); 
    else  stroke((ht)*15+270, 255, bri/2+127);
    line(0, 0, cos(PI+h*acc) * hoursRadius, sin(PI+h*acc) * hoursRadius);


    // Draw the circle
    strokeWeight(radius/200);
    beginShape(LINES);
    vertex(oR, 0); 
    for (int i = 0; i < 720; i++) {
      stroke(i/2, 255, bri); 
      vertex(a.get(i).x, a.get(i).y);
    }
    endShape(CLOSE);

    beginShape(LINES); 
    for (int i = 0; i < 720; i++) {
      stroke(i/2, 255, bri); 
      vertex(a.get(i).x, a.get(i).y);
    }
    endShape(CLOSE);


    //minute
    if (radius/75>1) {
      strokeWeight(radius/75);
      beginShape(LINES);
      for (int i = 0; i < 720; i+=12) {
        stroke(i/2, 255, bri); 
        vertex(a.get(i).x, a.get(i).y);
        vertex(a.get(i).x+0.01f, a.get(i).y);
      }
      endShape(CLOSE);
    }

    strokeWeight(radius/40);
    beginShape(LINES);
    for (int i = 0; i < 720; i+=60) {
      stroke(i/2, 255, bri); 
      vertex(a.get(i).x, a.get(i).y);
      vertex(a.get(i).x+0.01f, a.get(i).y);
    }
    endShape(CLOSE);

    strokeWeight(radius/25);
    beginShape(LINES);
    for (int i = 0; i < 720; i+=180) {
      stroke(i/2, 255, bri); 
      vertex(a.get(i).x, a.get(i).y);
      vertex(a.get(i).x+0.01f, a.get(i).y);
    }
    endShape(CLOSE);

    fill(0, 100, bri);
    if (radius/35>=7)
      text(12, -radius/50, -radius*0.825f+radius/350);
    pop();
    break;




  case 1:
    dt--;
    yt--;
    push();
    // Draw the clock background
    fill(0, 0, bri);
    noStroke();
    ellipse(0, 0, clockDiameter, clockDiameter);

    noFill();
    strokeCap(SQUARE);
    strokeWeight(mode2r/60);
    stroke(sec*6 + PApplet.parseFloat(ms) / 500 * 3, 255, bri/2+127);
    arc(0, 0, mode2r*59/60, mode2r*59/60, -HALF_PI, (sec+ms/1000.0f-15)/30*PI);

    stroke(mt*6, 255, bri/2+127);
    strokeWeight(mode2r/40);
    arc(0, 0, mode2r*56.5f/60, mode2r*56.5f/60, -HALF_PI, (min + (sec+PApplet.parseFloat(ms)/1000.0f)/60 - 15)/30*PI);

    stroke(ht*15, 255, bri/2+127);
    strokeWeight(mode2r/30);
    arc(0, 0, mode2r*53/60, mode2r*53/60, -HALF_PI, map(ht, 0, 24, 0, PI*2) - HALF_PI);

    stroke(dt/maxd*360, 255, bri/2+127);
    strokeWeight(mode2r/24);
    arc(0, 0, mode2r*48.5f/60, mode2r*48.5f/60, -HALF_PI, map(dt, 0, maxd, 0, PI*2) - HALF_PI);

    stroke(mot*30, 255, bri/2+127);
    strokeWeight(mode2r/20);
    arc(0, 0, mode2r*43/60, mode2r*43/60, -HALF_PI, map(mot, 0, 12, 0, PI*2) - HALF_PI);

    stroke(yt%4*9, 255, bri/2+127);
    strokeWeight(mode2r*3.5f/60);
    arc(0, 0, mode2r*36.5f/60, mode2r*36.5f/60, -HALF_PI, map(yt%100, 0, 100, 0, PI*2) - HALF_PI);

    stroke((yt/100)%4*9, 255, bri/2+127);
    strokeWeight(mode2r/15);
    arc(0, 0, mode2r*29/60, mode2r*29/60, -HALF_PI, map((yt/100)%100, 0, 100, 0, PI*2) - HALF_PI);

    noFill();
    stroke(127);
    strokeWeight(radius/100);
    ellipse(0, 0, clockDiameter, clockDiameter);
    fill(180, 1110, bri);
    ellipse(0, 0, clockDiameter*5/12, clockDiameter*5/12);

    noFill();
    stroke(127, (1-g)*255);
    strokeWeight(radius/400);
    ellipse(0, 0, clockDiameter-mode2r/30, clockDiameter-mode2r/30);
    ellipse(0, 0, clockDiameter-mode2r/12, clockDiameter-mode2r/12);
    ellipse(0, 0, clockDiameter-mode2r*3/20, clockDiameter-mode2r*3/20);
    ellipse(0, 0, clockDiameter-mode2r*7/30, clockDiameter-mode2r*7/30);
    ellipse(0, 0, clockDiameter-mode2r/3, clockDiameter-mode2r/3);
    ellipse(0, 0, clockDiameter-mode2r*9/20, clockDiameter-mode2r*9/20);
    pop();
    break;




  case 2:
    push();
    ht%=12;
    if (width<height) {
      stroke(127, 10, 80);
      strokeWeight(radius/100);
      rectMode(CENTER);
      fill(0, 0, 255-bri);
      rect(0, 0, recta, height*0.8f);


      for (int g = 0; g < 59; g++)
      {
        if ((g+1)%15==0) {
          stroke(125, 255, bri);
          strokeWeight(radius/100);
        } else if ((g+1)%5==0) {
          stroke(0, 255, bri);
          strokeWeight(radius/100);
        } else {
          stroke(240, 255, bri);
          strokeWeight(radius/250);
        }
        line( -recta/2, (height*0.8f)*(g-29)/60, recta/2, (height*0.8f)*(g-29)/60);
      }
      noFill(); 
      stroke(127, 10, 80); 
      strokeWeight(radius/80); 
      rect(0, 0, recta*1.002f, height*0.802f);


      rectMode(CORNER);
      noStroke();
      fill(sec*6 + PApplet.parseFloat(ms) / 500 * 3, 255, bri, 220);
      rect( -width*0.4f, height*0.4f, recta/6, map((sec+PApplet.parseFloat(ms)/1000), 0, 60, 0, -0.8f*height));
      fill(mt*6, 255, bri, 220);
      rect( -width*0.4f+recta/6, height*0.4f, recta/3, map(mt, 0, 60, 0, -0.8f*height));
      fill(ht*30, 255, bri, 220);
      rect(0, height*0.4f, recta/2, map(ht, 0, 12, 0, -0.8f*height));
    } else


    {
      fill(0, 0, 255-bri);
      noStroke();
      rectMode(CENTER);
      rect(0, 0, recta, height*0.8f);


      for (int g = 0; g < 59; g++)
      {
        if ((g+1)%15==0) {
          stroke(125, 255, bri, 127);
          strokeWeight(radius/100);
        } else if ((g+1)%5==0) {
          stroke(0, 255, bri, 127);
          strokeWeight(radius/100);
        } else {
          stroke(240, 255, bri, 127);
          strokeWeight(radius/250);
        }
        line(recta*(g-29)/60, -rectb, recta*(g-29)/60, rectb);
      }
      noFill(); 
      stroke(127, 10, 80); 
      strokeWeight(radius/80); 
      rect(0, 0, recta*1.002f, height*0.802f);


      rectMode(CORNER);
      noStroke();
      fill(sec*6 + PApplet.parseFloat(ms) / 500 * 3, 255, bri, 220);
      rect( -recta/2, -rectb, map((sec+PApplet.parseFloat(ms)/1000), 0, 60, 0, recta), height*4/30);
      fill(mt*6, 255, bri, 220);
      rect( -recta/2, -rectb/3*2, map(mt, 0, 60, 0, recta), height*8/30);
      fill(ht%12*30, 255, bri, 220);
      rect( -recta/2, 0, map(ht % 12, 0, 12, 0, recta), height*12/30);

      noFill();
      stroke(127, 10, 80);
      strokeWeight(radius/100);
      rectMode(CENTER);
      rect(0, 0, recta, height*0.8f);
    }
    pop();

    break;




  case 3:
    push();
    mot++;
    float 
      hy = -(ht / 24.0f)  * radius/2, 
      mx =  (mt / 60.0f) * radius * cos(PI/6)/2, 
      my =  (mt / 60.0f) * radius * sin(PI/6)/2, 
      sx = -(st / 60.0f) * radius * cos(PI/6)/2, 
      sy =  (st / 60.0f) * radius * sin(PI/6)/2, 
      yy = -(yt%100 / 100.0f) * radius/2, 
      mox = (mot/12.0f) * radius*cos(PI/6)/2, 
      moy = (mot/12.0f) * radius*sin(PI/6)/2, 
      dx = -(dt/maxd)*radius*cos(PI/6)/2, 
      dy =  (dt/maxd)*radius*sin(PI/6)/2;

    float[] len = {radius/100, st, mt, ht, dt, mot, yt};
    for (int i=1; i<len.length; i++)len[i]*=radius/2;
    float small=min(len)/3, big=min(len);
    strokeJoin(ROUND);
    stroke(360-bri);
    fill(360-bri);

    translate(-radius/2, 0);
    for (int i = floor(ht); i<25; i++) {
      strokeWeight(i%4==0?big:small);
      point(0, -radius*i/48);
    }
    text(24, 0, -radius/2-big);
    for (int i = floor(mt); i<61; i++) {
      strokeWeight(i%5==0?big:small);
      point(radius*i/120*cos(PI/6), radius*i/120*sin(PI/6));
    }
    text(60, radius*0.5f*cos(PI/6), radius*0.5f*sin(PI/6));
    for (int i = floor(st); i<61; i++) {
      strokeWeight(i%5==0?big:small);
      point(-radius*i/120*cos(PI/6), radius*i/120*sin(PI/6));
    }
    text(60, -radius*0.5f*cos(PI/6)-20, radius*0.5f*sin(PI/6));

    colorMode(RGB, 60, 60, 24);
    fill(st, mt, ht);
    strokeWeight(min(len)/2);
    beginShape();
    vertex(0, hy);
    vertex(mx, hy + my);
    vertex(mx + sx, hy + my + sy);
    vertex(sx, hy + sy);
    endShape(CLOSE);
    beginShape();
    vertex(sx, sy);
    vertex(sx + mx, sy + my);
    vertex(sx + mx, sy + my + hy);
    vertex(sx, sy + hy);
    endShape(CLOSE);
    beginShape();
    vertex(mx, my);
    vertex(sx+mx, sy+my);
    vertex(sx+mx, sy+my+hy);
    vertex(mx, my+hy);
    endShape(CLOSE);

    translate(radius, 0);
    stroke(60-bri/6);
    fill(60-bri/6);
    for (int i = floor(yt+1)%100; i<=100; i++) {
      strokeWeight(i%10==0?big:small);
      point(i%2==0?i%10==0?0:big:-big, -radius*i/200);
    }
    text(floor(yt/100+1)*100+1, 0, -radius/2-big);
    for (int i = floor(mot); i<=12; i++) {
      strokeWeight(i%3==0?big:small);
      point(radius*i/24*cos(PI/6), radius*i/24*sin(PI/6));
    }
    text(13, radius*0.5f*cos(PI/6), radius*0.5f*sin(PI/6));
    for (int i = floor(dt); i<=maxd; i++) {
      strokeWeight(i%7==0?big:small);
      point(-(radius*i/maxd)/2*cos(PI/6), (radius*i/maxd)/2*sin(PI/6));
    }
    text(maxd+1, -radius*0.5f*cos(PI/6)-20, radius*0.5f*sin(PI/6));

    colorMode(RGB, maxd, 12, 100);
    fill(dt, mot, yt%100);
    strokeWeight(min(len)/2);
    beginShape();
    vertex(0, yy);
    vertex(mox, yy+moy);
    vertex(mox+dx, yy+moy+dy);
    vertex(dx, yy+dy);
    endShape(CLOSE);
    beginShape();
    vertex(dx, dy);
    vertex(dx+mox, dy+moy);
    vertex(dx+mox, dy+moy+yy);
    vertex(dx, dy+yy);
    endShape(CLOSE);
    beginShape();
    vertex(mox, moy);
    vertex(dx+mox, dy+moy);
    vertex(dx+mox, dy+moy+yy);
    vertex(mox, moy+yy);
    endShape(CLOSE);
    pop();
    break;

  case 4:
    push();
    stroke(0);
    strokeWeight(1);  
    translate(width/12.5f-cx, height/12.5f-cy);
    float off = millis()/123.70f;

    {
      boolean roll = false;
      float secr = 10 + di[0].scl * 14;
      strokeWeight(di[0].scl/10);
      di[5].dis(pos[5], 10, ms, (sec+9)%10, sec%10, 150+off, bri);
      roll = sec % 10 == 0;
      if (roll) 
        di[4].dis(pos[4], 10, ms, (sec/10+5)%6, (sec/10)%6, 120+off, bri);
      else
        di[4].dis(pos[4], 10, ms, sec/10, sec/10, 120+off, bri);

      roll = roll && sec / 10 == 0;
      if (roll) 
        di[3].dis(pos[3], 10, ms, (min+9)%10, min%10, 90+off, bri);
      else
        di[3].dis(pos[3], 10, ms, min%10, min%10, 90+off, bri);

      roll = roll && min % 10 == 0;
      if (roll) 
        di[2].dis(pos[2], 10, ms, (min/10+5)%6, (min/10)%6, 60+off, bri);
      else
        di[2].dis(pos[2], 10, ms, min/10, min/10, 60+off, bri);

      roll = roll && min / 10 == 0;
      if (roll) 
        di[1].dis(pos[1], 10, ms, (hr-1)%10, hr%10, 30+off, bri);
      else 
      di[1].dis(pos[1], 10, ms, hr%10, hr%10, 30+off, bri);

      roll = roll && hr % 10 == 0;
      if (roll)
        di[0].dis(pos[0], 10, ms, (hr/10+2)%3, (hr/10)%3, off, bri);
      else
        di[0].dis(pos[0], 10, ms, hr/10, hr/10, off, bri);

      roll = roll && hr /10 == 0;
      if (roll)
        di[11].dis(pos[5], secr, ms, (day+9)%10, day%10, 180+off, bri);
      else
        di[11].dis(pos[5], secr, ms, day%10, day%10, 180+off, bri);

      roll = roll && day % 10 == 0;
      if (roll)
        di[10].dis(pos[4], secr, ms, (day/10+3)%4, (day/10)%4, 210+off, bri);
      else
        di[10].dis(pos[4], secr, ms, day/10, day/10, 210+off, bri);

      roll = roll && day / 10 == 0;
      if (roll)
        di[9].dis(pos[3], secr, ms, (mon+9)%10, mon%10, 240+off, bri);
      else
        di[9].dis(pos[3], secr, ms, mon%10, mon%10, 240+off, bri);

      roll = roll && mon % 10 == 0;
      if (roll)
        di[8].dis(pos[2], secr, ms, (mon/10+1)%2, mon/10, 270+off, bri);
      else
        di[8].dis(pos[2], secr, ms, mon/10, mon/10, 270+off, bri);

      roll = roll && mon / 10 == 0;
      if (roll)
        di[7].dis(pos[1], secr, ms, (year+9)%10, year%10, 300+off, bri);
      else
        di[7].dis(pos[1], secr, ms, year%10, year%10, 300+off, bri);
      roll = roll && year % 10 == 0;
      if (roll)
        di[6].dis(pos[0], secr, ms, (year/10+9)%10, year/10, 330+off, bri);
      else
        di[6].dis(pos[0], secr, ms, year/10%10, year/10%10, 330+off, bri);
    }

    pop();
    break;

  default:
    //fill(bri);
    //text("Here must be an error!", 0, 0);
    cas=0;
    break;
  }
  if (acc==0) {
    mod=min(max(mod+sin(frameCount*57/10000)/306*(1-acc), 0), 1.2f);
    strokeWeight(12);
    point(0, 0);
    stroke(mod*100);
    point(0, -mod*10);
  }

  translate(-cx, -cy);

  stroke(127);
  fill(127);
  for (int n=0; n<4; n++) buttons[n].display();

  if (mousePressed)
  {
    if (!prev)
    {
      for (i = 0; i < buttons.length; i++) {
        buttons[i].MClick();
        prev=true;

        if (buttons[i].on&&i==0)
          cas++;
        if (buttons[i].on&&i==1)
          if (acc==1)
            mod=round(1-mod);
          else
            mod=1-mod;
        if (buttons[i].on&&i==2)
          acc=1-acc;
      }
    }
  } else
  {
    for (Button button : buttons) if (button.sr) button.on=false;
    if (!keyPressed)
      prev=false;
  }

  fill(0, 0, 255-bri);
  String time=yt+" "+mot+" "+dt+" "+ht+" "+mt+" "+st+" "+acc + " " + mod+'\n'+frameRate; 


  //println(mouseX+" "+mouseY+"   "+buttons[0].x+" "+buttons[0].y+"   "+buttons[1].x+" "+buttons[1].y+"   "+buttons[2].x+" "+buttons[2].y+"   "+buttons[3].x+" "+buttons[3].y+"   "+buttons[4].x+" "+buttons[4].y+"   "+buttons[5].x+" "+buttons[5].y);
  if (frr<frameRate) {
    //println(time);
    frr=frameRate;
  }
  text(time, width*1.5f/100+width/12.5f, height*1.5f/100);
}

public void keyPressed() {
  if (key=='s')noLoop();
  if (key=='r')loop();
}
public void push() {
  pushMatrix();
  pushStyle();
}
public void pop() {
  popMatrix();
  popStyle();
}
class ball {
  Body body;
  PVector pos;
  PVector vel=new PVector(0, 0);
  PVector grav=new PVector(0, 0.1f);
  int d;
  ball(float x, float y, float dt) {
    pos=new PVector(x, y);
    println(x, y, pos);
    d=(int)dt;
  }
  public void display(float bri) {
    text(""+grav+'\n'+vel, 0, 0);
    fill(255-bri);
    stroke(bri);
    strokeWeight(1);
    ellipse(pos.x, pos.y, d, d);
  }
}
class ballclock {
  class Boundary {

    // A boundary is a simple rectangle with x,y,width,and height
    float x;
    float y;
    float w;
    float h;
    // But we also have to make a body for box2d to know about it
    Body b;

    Boundary(float x_, float y_, float w_, float h_, float a) {
      x = x_;
      y = y_;
      w = w_;
      h = h_;

      // Define the polygon
      PolygonShape sd = new PolygonShape();
      // Figure out the box2d coordinates
      float box2dW = box2d.scalarPixelsToWorld(w/2);
      float box2dH = box2d.scalarPixelsToWorld(h/2);
      // We're just a box
      sd.setAsBox(box2dW, box2dH);


      // Create the body
      BodyDef bd = new BodyDef();
      bd.type = BodyType.STATIC;
      bd.angle = a;
      bd.position.set(box2d.coordPixelsToWorld(x, y));
      b = box2d.createBody(bd);

      // Attached the shape to the body using a Fixture
      b.createFixture(sd, 1);
    }

    // Draw the boundary, it doesn't move so we don't have to ask the Body for location
    public void display() {
      fill(0);
      stroke(0);
      strokeWeight(1);
      rectMode(CENTER);
      float a = b.getAngle();
      pushMatrix();
      translate(x, y);
      rotate(-a);
      rect(0, 0, w, h);
      popMatrix();
    }
  }

  ball[] balls;
  int[][] walls;
  int width, height;
  ballclock(int w, int h) {
    width = w;
    height = h;
    balls=new ball[1];
    float d=min(width, height)/20;
    for (int i=0; i<balls.length; i++) {
      print(i+1, " ");
      balls[i]=new ball(30, 30, d);
    }
  }
  public void render(int bri, int ms, int sec, int min, int hr) {
    stroke(127, 10, 80);
    strokeWeight(radius/100);
    rectMode(CENTER);
    fill(0, 0, 255-bri);
    rect(0, 0, width, height);
    translate(-width/2, -height/2);
    translate(width/2, height/2);
  }
}
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

  public void click(int mx, int my) 
  {
    // Check to see if a point is inside the rectangle
    if (mx > x && mx < x + w && my > y && my < y + h) 
    {
      on = !on;
    }
  }

  public void MClick() {
    //get loc. of mouse
    int mx=mouseX;
    int my=mouseY;
    // Check to see if a point is inside the rectangle
    if (mx > x && mx < x + w && my > y && my < y + h) {
      on = !on;
    }
  }

  // Draw the rectangle
  public void display() {
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

  public void sedup() {
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


  public void dis(float xo, float yo, int ms, int ol, int ne, float off, float bri)
  {
    float prog = min((ms%1000)/100.0f, 1);
    push();
    translate(xo, yo);
    rectMode(CORNER);
    for (int i = 6; i >= 0; i--)
    {
      push();
      translate(lerp(x[ol][i], x[ne][i], prog)*abs(scl), lerp(y[ol][i]-rot[ol][i]%2, y[ne][i]-rot[ne][i]%2, prog)*abs(scl));
      rotate(lerp(rot[ol][i], rot[ne][i], prog)/2*3.1415926f);
      fill(abs(i*360/7+off)%360, 64 + 191 * bri, 127 + 128 * bri, 255);
      rect(0, 0, scl, 5*scl);
      pop();
    }
    //println(cel);
    rectMode(CORNER);
    //scl=5;
    pop();
    //translate(-x,-y);
  }

  public void addxy(PVector a, float r, int i, int j)
  {
    x[i][j] = (int)a.x;
    y[i][j] = (int)a.y;
    rot[i][j] = r;
  }
}
  public void settings() {  fullScreen();  smooth(8); }
}
