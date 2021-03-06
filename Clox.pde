import g4p_controls.*;

import java.util.*;

boolean f = true, prev = true, resized = false, drawSecondsHand = true, indexLock = false; 
boolean[] usedDebugOverlays={false, true, true, true, true, true};
int cx, cy, year, mon, day, hr, min, sec, ms, lastT, deltaT, mc, i, clockIndex = 0, savedClockIndex, passed = 0;
int radius, g = 0, pw, cells = 20, rand = 144, rbri = 70, sat = 255, ps, calls, lastKeyCode;
int[] pos;
long [] _5x7digits = { 15621211694L/*0*/, 2350975042L/*1*/, 15603929375L/*2*/, 15603926574L/*3*/, 2359917634L/*4*/, 33854359086L/*5*/, 15620589102L/*6*/, 33320667202L/*7*/, 15621113390L/*8*/, 15621129774L/*9*/, 16793600L/*:*/};
float secondsRadius, oR;
float minutesRadius;
float hoursRadius;
float clockDiameter;
float mode2r;
float recta, rectb, mod;
ArrayList<PVector> a = new ArrayList();
Settings settings;
digit di;
GregorianCalendar cdr;
Button[] buttons = new Button[4];


void setup() {
	frameRate(-1);

	prepareExitHandler();

	createGUI();
	resButton.setVisible(false);
	settingsWidth.setVisible(false);
	settingsHeight.setVisible(false);
	useDebug.setVisible(false);
	FPSShown.setVisible(false);
	DateTimeShown.setVisible(false);
	showOquadCalls.setVisible(false);
	showHandAndMod.setVisible(false);
	fullscreenButton.setVisible(false);
	settings = new Settings();
	settings.loadFromFile("data/settings.json");
	settings.apply("current");
	settingsWidth.setText(""+width);
	settingsHeight.setText(""+height);

	stroke(255);

	cdr = new GregorianCalendar();
	lastT = 0;
	deltaT = 0;

	di = new digit();
	update();
	smooth(1);
	ps = second();
	if (!focused)
		((java.awt.Canvas) surface.getNative()).requestFocus();
	surface.setTitle("Clox");
}



void draw() {
	if (frameCount == 2)
		surface.setLocation((displayWidth-width)/2, (displayHeight-height)/2);
	int bri=clockIndex!=5?(int)map(mod, 1, 0, 0, 255):0;

	if (keyPressed) { 
		if (!prev) {
			switch(lastKeyCode) {
			case 49:
				if (!indexLock) {
					clockIndex++;
					updateSettings();
					prev=true;
				}
				break;
			case 53:
				drawSecondsHand=!drawSecondsHand;
				prev=true;
				break;
			case 54:
				g=1-g;
				prev=!prev;
				break;
			case 77:
				if (drawSecondsHand)
					mod=round(1-mod);
				else
					mod=1-mod;
				prev=true;
				break;
			}
		}
		switch(lastKeyCode) {
		case 55:
			drawSecondsHand = true;
			break; 
		case 82:
			passed=0;
			break;
		}
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
	mon = cdr.get(Calendar.MONTH)+1;
	year = cdr.get(Calendar.YEAR);
	int maxd = mon==2?year%4==0?29:28:mon<8?30+mon%2:31-mon%2;
	float st = sec + ms / 1000.0, 
		mt = min + norm(st, 0, 60), 
		ht = hr + norm(mt, 0, 60), 
		dt = day + norm(ht, 0, 24), 
		mot = mon + norm(dt, 1, maxd+1), 
		yt = year + norm(mot, 1, 13);
	

	switch(clockIndex) {
	case 0:
		gen(bri);
		push();
		{
			textSize(radius/35);
			// Angles for sin() and cos() start at 3 o'clock;
			// subtract HALF_PI to make them start at the top
			float m = map(mt, 0, 61, 0, TWO_PI+PI/30) - HALF_PI; 
			float h = map(ht, 0, 24, 0, PI*2) + HALF_PI;

			// Draw the clock background
			fill(0, 0, bri);
			stroke(127);
			strokeWeight(radius/100);
			ellipse(0, 0, clockDiameter, clockDiameter);


			//Draw the hands of the clock
			if (drawSecondsHand)
			{
				float s = map(sec+ms/1000.0, 0, 30, 0, -PI);
				strokeWeight(radius/100);
				stroke((sec+ms/1000.0+45)*6%360, 255, bri/2+127);
				line(0, 0, -sin(s) * secondsRadius, -cos(s) * secondsRadius);
			}
			strokeWeight(radius/75);
			if (mt>15) stroke(mt*6-90, 255, bri/2+127); 
			else stroke(mt*6+270, 255, bri/2+127);
			line(0, 0, cos(m) * minutesRadius, sin(m) * minutesRadius);

			strokeWeight(radius/50);
			if (ht>6) stroke((ht)*15-90, 255, bri/2+127); 
			else  stroke((ht)*15+270, 255, bri/2+127);
			line(0, 0, cos(PI+h) * hoursRadius, sin(PI+h) * hoursRadius);


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
					vertex(a.get(i).x+0.01, a.get(i).y);
				}
				endShape(CLOSE);
			}

			strokeWeight(radius/40);
			beginShape(LINES);
			for (int i = 0; i < 720; i+=30) {
				stroke(i/2, 255, bri); 
				vertex(a.get(i).x, a.get(i).y);
				vertex(a.get(i).x+0.01, a.get(i).y);
			}
			endShape(CLOSE);

			strokeWeight(radius/25);
			beginShape(LINES);
			for (int i = 0; i < 720; i+=90) {
				stroke(i/2, 255, bri); 
				vertex(a.get(i).x, a.get(i).y);
				vertex(a.get(i).x+0.01, a.get(i).y);
			}
			endShape(CLOSE);

			fill(0, 100, bri);
			if (radius/35>=7)
				text(12, -radius/50, -radius*0.825+radius/350);
		}
		pop();
		break;




	case 1:
		gen(bri);
		push();
		{
			float enda = (sec+ms/1000.0-15)/30*PI;
			noFill();
			strokeCap(ROUND);
			strokeWeight(mode2r/60);
			stroke(360);
			arc(0, 0, mode2r*59/60, mode2r*59/60, 0, TWO_PI);
			stroke(sec*6 + float(ms) / 500 * 3, 255, bri/2+127);
			arc(0, 0, mode2r*59/60, mode2r*59/60, (min%2==1?enda:-HALF_PI), (min%2==0?enda:TWO_PI-HALF_PI));

			enda = (min + (sec+float(ms)/1000.0)/60 - 15)/30*PI;
			strokeWeight(mode2r/40);
			stroke(360);
			arc(0, 0, mode2r*56.5/60, mode2r*56.5/60, 0, TWO_PI);
			stroke(mt*6, 255, bri/2+127);
			arc(0, 0, mode2r*56.5/60, mode2r*56.5/60, (hr%2==1?enda:-HALF_PI), (hr%2==0?enda:TWO_PI-HALF_PI));

			enda = map(ht, 0, 24, 0, PI*2) - HALF_PI;
			strokeWeight(mode2r/30);
			stroke(360);
			arc(0, 0, mode2r*53/60, mode2r*53/60, 0, TWO_PI);
			stroke(ht*15, 255, bri/2+127);
			arc(0, 0, mode2r*53/60, mode2r*53/60, (day%2==1?enda:-HALF_PI), (day%2==0?enda:TWO_PI-HALF_PI));

			enda = map(dt, 0, (maxd+1), 0, PI*2) - HALF_PI;
			strokeWeight(mode2r/24);
			stroke(360);
			arc(0, 0, mode2r*48.5/60, mode2r*48.5/60, 0, TWO_PI);
			stroke(dt/(maxd+1)*360, 255, bri/2+127);
			arc(0, 0, mode2r*48.5/60, mode2r*48.5/60, (mon%2==1?enda:-HALF_PI), (mon%2==0?enda:TWO_PI-HALF_PI));

			enda = map(mot, 0, 13, 0, PI*2) - HALF_PI;
			strokeWeight(mode2r/20);
			stroke(360);
			arc(0, 0, mode2r*43/60, mode2r*43/60, 0, TWO_PI);
			stroke(mot*360/13., 255, bri/2+127);
			arc(0, 0, mode2r*43/60, mode2r*43/60, (year%2==1?enda:-HALF_PI), (year%2==0?enda:TWO_PI-HALF_PI));

			enda = map(yt%100, 0, 100, 0, PI*2) - HALF_PI;
			strokeWeight(mode2r*3.5/60);
			stroke(360);
			arc(0, 0, mode2r*36.5/60, mode2r*36.5/60, 0, TWO_PI);
			stroke((yt%100)*18/5, 255, bri/2+127);
			arc(0, 0, mode2r*36.5/60, mode2r*36.5/60, ((year/100)%2==1?enda:-HALF_PI), ((year/100)%2==0?enda:TWO_PI-HALF_PI));

			enda = map((yt/100)%100, 0, 100, 0, PI*2) - HALF_PI;
			strokeWeight(mode2r/15);
			stroke(360);
			arc(0, 0, mode2r*29/60, mode2r*29/60, 0, TWO_PI);
			stroke(((yt/100)%100)*18/5, 255, bri/2+127);
			arc(0, 0, mode2r*29/60, mode2r*29/60, ((year/10000)%2==1?enda:-HALF_PI), ((year/10000)%2==0?enda:TWO_PI-HALF_PI));

			noFill();
			stroke(127);
			strokeWeight(radius/100);
			ellipse(0, 0, clockDiameter, clockDiameter);
			//fill(180, 1110, bri);
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
		}
		pop();
		break;




	case 2:
		gen(bri);
		push();
		ht%=12;
		if (width<height) {
			stroke(127, 10, 80);
			strokeWeight(radius/100);
			rectMode(CENTER);
			fill(0, 0, 255-bri);
			rect(0, 0, recta, height*0.8);


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
				line( -recta/2, (height*0.8)*(g-29)/60, recta/2, (height*0.8)*(g-29)/60);
			}
			noFill(); 
			stroke(127, 10, 80); 
			strokeWeight(radius/80); 
			rect(0, 0, recta*1.002, height*0.802);


			rectMode(CORNER);
			noStroke();
			fill(sec*6 + float(ms) / 500 * 3, 255, bri, 220);
			rect( -width*0.4, height*0.4, recta/6, map((sec+float(ms)/1000), 0, 60, 0, -0.8*height));
			fill(mt*6, 255, bri, 220);
			rect( -width*0.4+recta/6, height*0.4, recta/3, map(mt, 0, 60, 0, -0.8*height));
			fill(ht*30, 255, bri, 220);
			rect(0, height*0.4, recta/2, map(ht, 0, 12, 0, -0.8*height));
		} else


		{
			fill(0, 0, 255-bri);
			noStroke();
			rectMode(CENTER);
			rect(0, 0, recta, height*0.8);


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
			rect(0, 0, recta*1.002, height*0.802);


			rectMode(CORNER);
			noStroke();
			fill(sec*6 + float(ms) / 500 * 3, 255, bri, 220);
			rect( -recta/2, -rectb, map((sec+float(ms)/1000), 0, 60, 0, recta), height*4/30);
			fill(mt*6, 255, bri, 220);
			rect( -recta/2, -rectb/3*2, map(mt, 0, 60, 0, recta), height*8/30);
			fill(ht%12*30, 255, bri, 220);
			rect( -recta/2, 0, map(ht % 12, 0, 12, 0, recta), height*12/30);

			noFill();
			stroke(127, 10, 80);
			strokeWeight(radius/100);
			rectMode(CENTER);
			rect(0, 0, recta, height*0.8);
		}
		pop();

		break;




	case 3:
		background(180, 255, bri);

		push();
		float 
			hy = -(max(ht, .5) / 24.0)  * radius/2, 
			mx =  (max(mt, .5) / 60.0) * radius * cos(PI/6)/2, 
			my =  (max(mt, .5) / 60.0) * radius * sin(PI/6)/2, 
			sx = -(st / 60.0) * radius * cos(PI/6)/2, 
			sy =  (st / 60.0) * radius * sin(PI/6)/2, 
			yy = -(yt%100 / 100.0) * radius/2, 
			mox = (max(mot, .5)/12.0) * radius*cos(PI/6)/2, 
			moy = (max(mot, .5)/12.0) * radius*sin(PI/6)/2, 
			dx = -(max(dt, .5)/maxd)*radius*cos(PI/6)/2, 
			dy =  (max(dt, .5)/maxd)*radius*sin(PI/6)/2;

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
		text(60, radius*0.5*cos(PI/6), radius*0.5*sin(PI/6));
		for (int i = floor(st); i<61; i++) {
			strokeWeight(i%5==0?big:small);
			point(-radius*i/120*cos(PI/6), radius*i/120*sin(PI/6));
		}
		text(60, -radius*0.5*cos(PI/6)*1.1, radius*0.5*sin(PI/6));

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
		text(13, radius*0.5*cos(PI/6), radius*0.5*sin(PI/6));

		for (int i = floor(dt); i<=maxd; i++) {
			strokeWeight(i%5==0?big:small);
			point(-(radius*i/maxd)/2*cos(PI/6), (radius*i/maxd)/2*sin(PI/6));
		}
		text(maxd+1, -radius*0.5*cos(PI/6)*1.1, radius*0.5*sin(PI/6));

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
		gen(bri);
		push();
		stroke(0);
		strokeWeight(1);  
		translate(width/12.5-cx, height/12.5-cy);
		float off = millis()/123.70;

		{
			boolean roll = false;
			float secr = 10 + di.scl * 14;
			strokeWeight(di.scl/10);
			di.dis(pos[5], 10, ms, (sec+9)%10, sec%10, 150+off, bri);
			roll = sec % 10 == 0;
			if (roll) 
				di.dis(pos[4], 10, ms, (sec/10+5)%6, (sec/10)%6, 120+off, bri);
			else
				di.dis(pos[4], 10, ms, sec/10, sec/10, 120+off, bri);

			roll = roll && sec / 10 == 0;
			if (roll) 
				di.dis(pos[3], 10, ms, (min+9)%10, min%10, 90+off, bri);
			else
				di.dis(pos[3], 10, ms, min%10, min%10, 90+off, bri);

			roll = roll && min % 10 == 0;
			if (roll) 
				di.dis(pos[2], 10, ms, (min/10+5)%6, (min/10)%6, 60+off, bri);
			else
				di.dis(pos[2], 10, ms, min/10, min/10, 60+off, bri);

			roll = roll && min / 10 == 0;
			if (roll) 
				di.dis(pos[1], 10, ms, (hr-1)%10, hr%10, 30+off, bri);
			else 
			di.dis(pos[1], 10, ms, hr%10, hr%10, 30+off, bri);

			roll = roll && hr % 10 == 0;
			if (roll)
				di.dis(pos[0], 10, ms, (hr/10+2)%3, (hr/10)%3, off, bri);
			else
				di.dis(pos[0], 10, ms, hr/10, hr/10, off, bri);

			roll = roll && hr /10 == 0;
			if (roll)
				di.dis(pos[5], secr, ms, (day+9)%10, day%10, 180+off, bri);
			else
				di.dis(pos[5], secr, ms, day%10, day%10, 180+off, bri);

			roll = roll && day % 10 == 0;
			if (roll)
				di.dis(pos[4], secr, ms, (day/10+3)%4, (day/10)%4, 210+off, bri);
			else
				di.dis(pos[4], secr, ms, day/10, day/10, 210+off, bri);

			roll = roll && day / 10 == 0;
			if (roll)
				di.dis(pos[3], secr, ms, (mon+9)%10, mon%10, 240+off, bri);
			else
				di.dis(pos[3], secr, ms, mon%10, mon%10, 240+off, bri);

			roll = roll && mon % 10 == 0;
			if (roll)
				di.dis(pos[2], secr, ms, (mon/10+1)%2, mon/10, 270+off, bri);
			else
				di.dis(pos[2], secr, ms, mon/10, mon/10, 270+off, bri);

			roll = roll && mon / 10 == 0;
			if (roll)
				di.dis(pos[1], secr, ms, (year+9)%10, year%10, 300+off, bri);
			else
				di.dis(pos[1], secr, ms, year%10, year%10, 300+off, bri);
			roll = roll && year % 10 == 0;
			if (roll)
				di.dis(pos[0], secr, ms, (year/10+9)%10, year/10, 330+off, bri);
			else
				di.dis(pos[0], secr, ms, year/10%10, year/10%10, 330+off, bri);
		}

		pop();
		break;


	case 5:
		calls = 0;
		if (ps != sec) {
			passed = min(passed + 1, 16);
			ps = sec;
		}
		float ah = height * 3 / 8, ax = width / 6;
		background(0, 0, bri);
		float one = width/(5*7+9*2);
		push();
		{
			translate(-cx, -cy);

			strokeCap(ROUND);

			strokeWeight(1);
			for (int i = passed; i > 0; i--) {
				float col = (map(i, 15, 0, 0, 360)+(sec+min*60+hr*3600+day*87600)*15)%360;
				fill(col, 100, 255, 50);
				stroke(col, 100, 255);
				odigit(ax, ah, i, one, int((86400+hr*3600+min*60+sec-i)%86400/36000));
			}
			fill(360, 80);
			strokeWeight(2);
			stroke(0, 0, 255-bri);
			odigit(ax, ah, 0, one, hr/10);

			strokeWeight(1);                                                            // hour digits
			for (int i = passed; i > 0; i--) {
				float col = (map(i, 15, 0, 0, 360)+(sec+min*60+hr*3600+day*87600)*15)%360;
				fill(col, 100, 255, 50);
				stroke(col, 100, 255);
				odigit(one*6+ax, ah, i, one, (36000+hr*3600+min*60+sec-i)/3600%10);
			}
			fill(360, 80);
			strokeWeight(2);
			stroke(0, 0, 255-bri);
			odigit(one*6+ax, ah, 0, one, hr%10);

			trail(one*12 + ax, ah, one, bri);

			strokeWeight(1);                                                            // tens of minutes
			for (int i = passed; i > 0; i--) {
				float col = (map(i, 15, 0, 0, 360)+(sec+min*60+hr*3600+87600)*15)%360;
				fill(col, 100, 255, 50);
				stroke(col, 100, 255);
				odigit(one*14 + ax, ah, i, one, (3600+min*60+sec-i)/600%6);
			}
			fill(360, 80);
			strokeWeight(2);
			stroke(0, 0, 255-bri);
			odigit(one*14 + ax, ah, 0, one, min/10);

			strokeWeight(1);                                                            //digits of minutes
			for (int i = passed; i > 0; i--) {
				float col = (map(i, 15, 0, 0, 360)+(sec+min*60+hr*3600)*15)%360;
				fill(col, 100, 255, 50);
				stroke(col, 100, 255);
				odigit(one*20 + ax, ah, i, one, (3600+min*60+sec-i)/60%10);
			}
			fill(360, 80);
			strokeWeight(2);
			stroke(0, 0, 255-bri);
			odigit(one*20 + ax, ah, 0, one, min%10);

			trail(one*26 + ax, ah, one, bri);
			//trail(one*28, sec/10, one, bri);
			strokeWeight(1);                                                            // tens of seconds
			for (int i = passed; i > 0; i--) {
				float col = (map(i, 15, 0, 0, 360)+(sec+min*60+hr*3600+day*87600)*15)%360;
				fill(col, 100, 255, 50);
				stroke(col, 100, 255);
				odigit(one*28 + ax, ah, i, one, (60+sec-i)%60/10);
			}
			fill(360, 80);
			strokeWeight(2);
			stroke(0, 0, 255-bri);
			odigit(one*28 + ax, ah, 0, one, sec/10);

			//trail(one*34, sec%10, one, bri);
			strokeWeight(1);                                                            // digits of seconds
			for (int i = passed; i > 0; i--) {
				float col = (map(i, 15, 0, 0, 360)+(sec+min*60+hr*3600+day*87600)*15)%360;
				fill(col, 100, 255, 50);
				stroke(col, 100, 255);
				odigit(one * 34 + ax, ah, i, one, (10+sec-i)%10);
			}
			fill(360, 80);
			strokeWeight(2);
			stroke(0, 0, 255-bri);
			odigit(one * 34 + ax, ah, 0, one, sec%10);
		}
		pop();
		break;

		//case 6:
		//  push();
		//  gen(bri);
		//  translate(-width/2, -height/2);
		//  pop();
		//  break;

	default:
		clockIndex=0;
		break;

	case -1:
		gen(bri);
		textSize(radius/12);
		text("settings", -40, -height/20*9);
		break;
	}

	translate(-cx, -cy);

	stroke(127);
	fill(127);
	if (clockIndex>-1) {
		if (clockIndex==0)
			buttons[2].display();
		buttons[0].display();
		if (clockIndex!=5)
			buttons[1].display();
	}
	buttons[3].display();
	if (mousePressed)
	{
		if (!prev)
		{
			for (int i=3-3*(1+min(0, clockIndex)); i < buttons.length; i++) {
				buttons[i].MClick();
				prev=true;

				if (buttons[i].on&&i==0)
					clockIndex++;
				updateSettings();
				if (buttons[i].on&&i==1&&clockIndex!=5)
					if (drawSecondsHand)
						mod=round(1-mod);
					else
						mod=1-mod;
				if (buttons[i].on&&i==2&&clockIndex==0)
					drawSecondsHand=!drawSecondsHand;
				if (buttons[i].on&&i==3) {
					if (clockIndex==-1) {
						clockIndex=savedClockIndex;
						resButton.setVisible(false);
						settingsWidth.setVisible(false);
						settingsHeight.setVisible(false);
						useDebug.setVisible(false);
						FPSShown.setVisible(false);
						DateTimeShown.setVisible(false);
						showOquadCalls.setVisible(false);
						showHandAndMod.setVisible(false);
						//fullscreenButton.setVisible(false);
						indexLock = false;
					} else
					{
						resButton.setVisible(true);
						//fullscreenButton.setVisible(true);
						settingsWidth.setVisible(true);
						settingsHeight.setVisible(true);
						useDebug.setVisible(true);
						FPSShown.setVisible(usedDebugOverlays[0]);
						DateTimeShown.setVisible(usedDebugOverlays[0]);
						showOquadCalls.setVisible(usedDebugOverlays[0]);
						showHandAndMod.setVisible(usedDebugOverlays[0]);
						savedClockIndex=clockIndex;
						clockIndex = -1;
						indexLock = true;
					}
				}
			}
		}
	} else
	{
		for (Button button : buttons) if (button.sr) button.on=false;
		if (!keyPressed)
			prev=false;
	}
	if (clockIndex>-1) {
		fill(0, 0, 255-bri);
		String debug = "" + 
			(usedDebugOverlays[1]?(int)frameRate+"\n":"")+
			(usedDebugOverlays[2]?(year+"/"+mon+"/"+day+"-"+hr+":"+min+":"+sec+"."+ms+"\n"):"")+
			((usedDebugOverlays[2]&&clockIndex==3)?(yt + " " + mot + " " + dt + " " + ht + " " + mt + " " + st + " " + mod+'\n'):"")+
			(usedDebugOverlays[4]?(drawSecondsHand + " " + mod+'\n'):"")+
			((usedDebugOverlays[3]&&clockIndex==5)?(calls + '\n'):""); 
		textSize(radius/35*1.4);
		if (usedDebugOverlays[0])
			text(debug, width*1.5/100+width/12.5, height*1.5/100);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void updateSettings() {
	settings.currentSettings.setBoolean("drawSecondsHand", true);
	JSONArray UsedDebugOverlays = new JSONArray();
	UsedDebugOverlays.setBoolean(0, usedDebugOverlays[0]);
	UsedDebugOverlays.setBoolean(1, usedDebugOverlays[1]);
	UsedDebugOverlays.setBoolean(2, usedDebugOverlays[2]);
	UsedDebugOverlays.setBoolean(3, usedDebugOverlays[3]);
	UsedDebugOverlays.setBoolean(4, usedDebugOverlays[4]);
	settings.currentSettings.setJSONArray("usedDebugOverlays", UsedDebugOverlays );
	settings.currentSettings.setBoolean("fullScreen", false);
	settings.currentSettings.setInt("Width", width);
	settings.currentSettings.setInt("Height", height);
	settings.currentSettings.setBoolean("fullScreen", f);
	if (clockIndex>-1)
		settings.currentSettings.setInt("clockIndex", clockIndex);
}

void trail(float x, float y, float one, float bri) {
	strokeWeight(1);
	for (int i = passed; i > 0; i--) {
		float col = (map(i, 15, 0, 0, 360)+(sec+min*60+hr*3600+day*87600)*15)%360;
		fill(col, 100, 255, 50);
		stroke(col, 100, 255);
		odigit(x, y, i, one, 10);
	}
	fill(360, 80);
	strokeWeight(2);
	stroke(0, 0, 255-bri);
	odigit(x, y, 0, one, 10);
}

void keyPressed() {
	lastKeyCode = keyCode;
	switch(keyCode) {
	case ESC:
		key=0;
		if (clockIndex==-1) {
			clockIndex=savedClockIndex;
			resButton.setVisible(false);
			settingsWidth.setVisible(false);
			settingsHeight.setVisible(false);
			useDebug.setVisible(false);
			FPSShown.setVisible(false);
			DateTimeShown.setVisible(false);
			showOquadCalls.setVisible(false);
			showHandAndMod.setVisible(false);
			//fullscreenButton.setVisible(false);
			indexLock = false;
		} else
		{
			resButton.setVisible(true);
			//fullscreenButton.setVisible(true);
			settingsWidth.setVisible(true);
			settingsHeight.setVisible(true);
			useDebug.setVisible(true);
			FPSShown.setVisible(usedDebugOverlays[0]);
			DateTimeShown.setVisible(usedDebugOverlays[0]);
			showOquadCalls.setVisible(usedDebugOverlays[0]);
			showHandAndMod.setVisible(usedDebugOverlays[0]);
			savedClockIndex=clockIndex;
			clockIndex = -1;
			indexLock = true;
		}
		break;
	case 114: //F3
		usedDebugOverlays[0] = !usedDebugOverlays[0];
		useDebug.setSelected(usedDebugOverlays[0]);
		updateSettings();
		break;
	case 83:
		println("———————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————\n"+settings.currentSettings);
		break;
	}
}

private void prepareExitHandler() {
	Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
		public void run() {
			println("SHUTDOWN HOOK");
			settings.saveToFile("data/settings.json");
		}
	}
	));
}

void push() {
	pushStyle();
	pushMatrix();
}

void pop() {
	popMatrix();
	popStyle();
}

void update() {
	di.scl = ((width-width/12.5*2-20)/(8*6+1)-.2);
	di.sedup();

	radius = min(width, height) / 2;
	secondsRadius = radius * 0.80;
	oR=secondsRadius*1.04;
	minutesRadius = secondsRadius * 0.85;
	hoursRadius = minutesRadius * 0.9;
	clockDiameter = radius * 1.8;
	mode2r = clockDiameter;
	recta=width*0.8;
	rectb=radius*0.8;

	cx = width / 2;
	cy = height / 2;
	colorMode(HSB, 360, 255, 255, 255);
	background(0, 0, 0, 0);

	buttons[0] = new Button(width*1.5/100, height*1.5/100, width/12.5, height/12.5, true, "off");
	buttons[1] = new Button(width*90.5/100, height*1.5/100, width/12.5, height/12.5, true, "off");
	buttons[2] = new Button(width*1.5/100, height*90.5/100, width/12.5, height/12.5, true, "off");
	buttons[3] = new Button(width*90.5/100, height*90.5/100, width/12.5, height/12.5, true, "off");
	a.clear();
	for (int i = 0; i < 720; i++) {
		float an = radians(i/2);
		float x = cos(an) * oR;
		float y = sin(an) * oR;
		a.add(new PVector(x, y));
	}
	textSize(radius/35);
	pos = new int[6];
	pos[0] = 10;
	pos[1] = 10 + 8 * (int)di.scl;
	pos[2] = 10 + (8 * 2 + 1) * (int)di.scl;
	pos[3] = 10 + (8 * 3 + 1) * (int)di.scl;
	pos[4] = 10 + (8 * 4 + 2) * (int)di.scl;
	pos[5] = 10 + (8 * 5 + 2) * (int)di.scl;
}

void gen(int bri) {
	push();
	translate(-width/2, -height/2);
	bri= int(255-(255-bri)/1.7);
	int cell = height/cells, w = ceil(width/(cell*1.)), h = cells;
	float offs = millis()/2000.;
	background(255);
	for (int y = 0; y < h; y++) {
		for (int x = 0; x < w; x++) {
			noStroke();
			float brig = 255-pow(max(0, noise(offs+x*10000+y*10) / 1.5), 2)*rbri;
			fill((y * 360.0 / h + noise(offs/25+x*10000+y*10+7000) * rand / 2 + 360)%360, 
				max( 
				255 - pow(.3+noise(offs/7.5+x*10000+y*10+123213) / 2, 2) * sat, 
				255 - pow(brig/255, 4) * 255
				), 
				brig/255*bri
				);
			beginShape();
			vertex(    x*cell, (y+pow(-1, (x+y+1)%2)*.5+.5)*cell);
			vertex((x+1)*cell, (y+pow(-1, (x+y  )%2)*.5+.5)*cell);
			vertex((x+1)*cell, (y+pow(-1, (x+y+1)%2)*.5+.5)*cell);
			endShape(CLOSE);
			brig = 255-pow(.5+noise(offs+x*10000+y*10-1000) / 2, 2)*rbri;
			fill((y * 360.0 / h + noise(offs/25+x*10000+y*10+75476) * rand / 2 + 360)%360, 
				max( 
				255 - pow(.3+noise(offs/7.5+x*10000+y*10+5432) / 2, 2) * sat, 
				255 - pow(brig/255, 4) * 255
				), 
				brig/255*bri
				);
			beginShape();
			vertex(    x*cell, (y+pow(-1, (x+y+1)%2)*.5+.5)*cell);
			vertex((x+1)*cell, (y+pow(-1, (x+y  )%2)*.5+.5)*cell);
			vertex(    x*cell, (y+pow(-1, (x+y  )%2)*.5+.5)*cell);
			endShape(CLOSE);
		}
	}
	pop();
}

void oquad(float x, float y, float z, float w, float h) {
	if (x + w * z * 2.5 < width && y + (x / w - .5) * 3 - w * z * 2.5 + w > 0 )
	{  
		calls ++;
		vertex(x/**/, y /**/+ (x / w/**/) * 3);
		vertex(x/**/, y + h + (x / w/**/) * 3);
		vertex(x + w, y + h + (x / w + 1) * 3);
		vertex(x + w, y /**/+ (x / w + 1) * 3);
	}
}

void odigit(float x, float y, float z, float w, int digit) {
	push();
	if (3 - z * w * 2.5 > - (y + w * 7)) 
	{
		translate(w * z * 2.5, -w * z * 2.5);
		beginShape(QUADS);
		long mask = _5x7digits[digit];
		for (int i = 0; i < 7; i++)
			for (int j = 0; j < 5; j++)
				if ((mask>>(34-i*5-j)&1)==1)
				oquad(x+w*j,y+w*i,z,w,w);
		endShape();
	}
	pop();
}
