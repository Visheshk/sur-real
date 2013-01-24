import ddf.minim.*;

float  x;
float  y;
Minim minim;
AudioInput input;

void  setup  () {
  // Sketch Set
  size (500, 500);
  smooth ();
  stroke (255, 125);
  noFill ();

  // Start Location
  x = 0;
  y = 20;

  // Create Audiotoolkit
  minim = new  Minim (this);
  input = minim.getLineIn (Minim.STEREO, 3000);
  background  (0);
}

void  draw  () {
  float  dim = input.mix.level () * width ;
  // Move x-circle position
  x += input.mix.level () * 20;
  // Draw a circle
  ellipse  (x, y, dim, dim);

  if  (x > width ) {
    x = 0;
    y += 40;
  }
}

