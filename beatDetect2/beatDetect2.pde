/**
 * This sketch demonstrates how to use the BeatDetect object song SOUND_ENERGY mode.<br />
 * You must call <code>detect</code> every frame and then you can use <code>isOnset</code>
 * to track the beat of the music.
 * <p>
 * This sketch plays an entire song, so it may be a little slow to load.
 */

import ddf.minim.*;
import ddf.minim.analysis.*;

class BeatListener implements AudioListener {
  private BeatDetect beat;
  private AudioInput source;

  BeatListener(BeatDetect beat, AudioInput source) {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }

  void samples(float[] samps) {
    beat.detect(source.mix);
  }

  void samples(float[] sampsL, float[] sampsR) {
    beat.detect(source.mix);
  }
}

Minim minim;
//AudioPlayer song;
AudioInput song;
AudioRecorder record;
BeatDetect beat;
int tap1 = 0, tap2 = 0;

float eRadius;
int beatNo = 0;

void setup()
{
  size(200, 200, P3D);
  minim = new Minim(this);
  /*song = minim.loadFile("song.MP3", 2048);
   song.play();*/
  song = minim.getLineIn(Minim.STEREO, 1024);
  record = minim.createRecorder(song, "myrec.wav", true);
  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  beat = new BeatDetect();
  beat.setSensitivity(500);
  beat.isRange(400, 500, 90);
  /*(int CENTER_RADIUS = (int) eRadius;
  ellipseMode(CENTER_RADIUS);
  eRadius = 20;*/
}

void draw()
{
  background(0);
  beat.detect(song.mix);
  float a = map(eRadius, 20, 80, 60, 255);
  fill(60, 255, 0, a);
  if (beat.isOnset()) {
    eRadius = 80;
    if(tap1 == 0){ 
      tap1 = millis();
      print(tap1 + " " + tap2 + " Beat 1  ");
    }
    else //if (millis() != tap1){ 
    {  tap2 = millis();
    }
    
    if((tap2 - tap1) <= 1000){
      beatNo++;
      print(tap1 + " " + tap2 + " Double Tap registered  ");
      tap1 = 0;
    }
    //print(beatNo + " beat at" + millis() + "\t");
    //beatNo++;
  }
  beatNo = 0;
  ellipse(width/2, height/2, eRadius, eRadius);
  eRadius *= 0.95;
  if ( eRadius < 20 ) eRadius = 20;
}

void stop()
{
  // always close Minim audio classes when you are finished with them
  song.close();
  // always stop Minim before exiting
  minim.stop();

  super.stop();
}

