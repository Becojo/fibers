// F I B E R S

// MIT License
// Copyright (C) 2013 Benoit Côté-Jodoin

// Number of points stored to draw the curve
int pointCount = 70;

// More damp = slower the curve moves
float damp = 2;

// Array that contains every point of the curve
PVector[] points = new PVector[pointCount];

// Stores if the automatic mode is activated
boolean autoMode = false;

// The point that the curve tries to follow when autoMode is true
PVector autoPoint = new PVector(0, 0);

// Maximum distance the point can go from where it was in the last frame
int autoPointVar = 100;

// Which color to use
int colorSchemeId = 0;

// Opacity of the curve
int strokeAlpha = 30;

// Intensity of the turbulence
int turbulence = 0;

// Stores if the sketch is looping
boolean playing = true;

// General counter
int i;

void drawInfo()
{
  text("F I B E R S\n\n\n[ space ] clear\n\n[ p ] pause\n\n[ a ] toggle random/auto mode\n\n[ c ] change color\n\n[ t ] turbulence\n\n[ h ] show this\n\n(click to focus)", 50, 50);
}

void setup()
{
  frameRate(30);
  background(0);

  size(screen.width, screen.height);
  resetPoints();
  drawInfo();
}

void draw()
{
  update();

  if(colorSchemeId == 0)
  {
    // white, green, yellow, light blue
    stroke(200 + sin(frameCount / 40) * 50, 255, 200 + cos(frameCount / 40) * 50, strokeAlpha);
  }
  else if(colorSchemeId == 1)
  {
    // pink, purple
    stroke(200 + sin(frameCount / 40) * 50, 100, 200 + cos(frameCount / 40) * 50, strokeAlpha);
  }
  else if(colorSchemeId == 2)
  {
    // blue, purple
    stroke(75, 100 + sin(frameCount / 40) * 50, 200 + cos(frameCount / 40) * 50, strokeAlpha);
  }
  else if(colorSchemeId == 3)
  {
    // red, orange, yellow
    stroke(255, 100 + sin(frameCount / 40) * 50, 0, 20);
  }
  else if(colorSchemeId == 4)
  {
    // green, yellow, brown
    stroke(200 + sin(frameCount / 40) * 50, 200 + cos(frameCount / 40) * 50, 100, strokeAlpha);
  }
  else if(colorSchemeId == 5)
  {
    // plain white
    stroke(240, 255, 240, strokeAlpha);
  }

  noFill();
  beginShape();

  for(i = 0; i < pointCount - 1; i++)
    vertex(points[i].x, points[i].y);

  endShape();
}

void update()
{

  if(autoMode)
  {
    // Makes sure the point is not out of the bounds of the sketch
    if(autoPoint.x < 50)
    {
      autoPoint.x += random(1, autoPointVar);
    }
    else if(autoPoint.x > innerWidth - 50)
    {
      autoPoint.x -= random(1, autoPointVar);
    }
    else
    {
      autoPoint.x += random(-autoPointVar, autoPointVar);
    }

    if(autoPoint.y < 50)
    {
      autoPoint.y += random(1, autoPointVar);
    }
    else if(autoPoint.y > innerHeight - 50)
    {
      autoPoint.y -= random(1, autoPointVar);
    }
    else
    {
      autoPoint.y += random(-autoPointVar, autoPointVar);
    }

    // the damp is stronger here so that the when the
    // curve moves it looks smoother
    points[0].x += (autoPoint.x - points[0].x) / 20;
    points[0].y += (autoPoint.y - points[0].y) / 20;
  }
  else
  {

    points[0].x += (mouseX - points[0].x) / damp;
    points[0].y += (mouseY - points[0].y) / damp;
  }

  for(i = 1; i < pointCount; i++)
  {
    // Approches each points toward the one it follows
    points[i].x += ((points[i - 1].x + random(-turbulence, turbulence)) - points[i].x) / damp;
    points[i].y += ((points[i - 1].y + random(-turbulence, turbulence)) - points[i].y) / damp;
  }
}

void keyPressed()
{
  switch(key)
  {
    case ' ':
      resetPoints(mouseX, mouseY);
      background(0);
    break;

    case 'a':
      autoMode = !autoMode;

      autoPoint.x = mouseX;
      autoPoint.y = mouseY;
    break;

    case 'h':
      drawInfo();
    break;

    case 'c':
      colorSchemeId++;

      if(colorSchemeId == 6)
      {
        colorSchemeId = 0;
      }
    break;

    case 'p':
      if(playing = !playing)
      {
        loop();
      }
      else
      {
        noLoop();
      }
    break;

    case 't':
      turbulence++;

      if(turbulence >= 4)
      {
        turbulence = 0;
      }
    break;
  }

}

// Redefines every points at the point specified
// by the parameters or at the middle of the sketch
void resetPoints(int x, int y)
{
  x = x || width / 2;
  y = y || height / 2;

  for(i = 0; i < pointCount; i++)
  {
    points[i] = new PVector(x, y);
  }
}
