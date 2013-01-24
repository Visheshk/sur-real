/* Written by Arpit Agarwal
*/
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
//import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.AWTException;
import java.awt.event.KeyEvent;
 
Minim minim;
AudioPlayer player;
AudioInput input;
FFT fft;
HighPassSP hpf;
int prevKnockTime;
int tapTime;
Robot robot;

float[] fftm;
 
 
void setup()
{
  size(640,480);
  smooth();
  background(0);
  strokeWeight(2);
  try { 
    robot = new Robot();
  } 
  catch (AWTException e) {
    e.printStackTrace(); 
  }
  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO, 512);
  
  fft = new FFT(input.bufferSize(), input.sampleRate());
  hpf = new HighPassSP(500, input.sampleRate());
  input.addEffect(hpf);
  
  tapTime = 0;
}
 
void draw()
{
  
  int currentTapTime;
  float[] left = input.left.toArray();
  float sum = 0.0;
  
  stroke(255);
  //threshold taps
   for(int j=0; j<left.length ; j++)
   {
 
     if((left[j] > 0.1 && left[j] < 0.3)){
       //println(left[j]);
       stroke(0,255,0,255);
       currentTapTime = millis();
       if(currentTapTime - tapTime > 50){
         if(currentTapTime - tapTime <400){
           println("Double tap");
           /*robot.mousePress( InputEvent.BUTTON1_MASK );
           robot.mouseRelease( InputEvent.BUTTON1_MASK );*/
           robot.keyPress(KeyEvent.VK_LEFT);
           robot.keyRelease(KeyEvent.VK_LEFT);
         }
         println("Tap at : "+left[j]);
         tapTime = currentTapTime;
       } 
       
     }
   }
   
  
   //waveform
   for(int i=0; i<input.bufferSize()-1; i++)
   {
     line(i,50+input.left.get(i)*50, i+1, 50+input.left.get(i+1)*50);
     //line(i, 150+input.right.get(i)*50, i+1, 150+input.right.get(i+1)*50);
   }
   
  //fft graph 
   fft.forward(input.left);
   stroke(255,0,0,128);  
   for( int i =0; i < fft.specSize(); i++)
   {  
       line(i, height, i, height - fft.getBand(i)*4);
   }
   
}
 
void stop()
{
  player.close();
  input.close();
  minim.stop();
  super.stop();
}
