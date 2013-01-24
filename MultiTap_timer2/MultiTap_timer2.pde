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
Robot robot;

class Timer {
 
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  
  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis(); 
  }
  
  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
}


Minim minim;
AudioPlayer player;
AudioInput input;
FFT fft;
HighPassSP hpf;
Timer timer;

int tapCount;
int prevTapTime, waitTime, endTime;

float[] fftm;


void setup()
{
  size(640,480);
  smooth();
  background(0);
  strokeWeight(2);
  timer = new Timer(400);
  timer.start();
  
  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO, 512);
  
  try { 
    robot = new Robot();
  } 
  catch (AWTException e) {
    e.printStackTrace(); 
  }
  
  fft = new FFT(input.bufferSize(), input.sampleRate());
  hpf = new HighPassSP(500, input.sampleRate());
  input.addEffect(hpf);
  tapCount = prevTapTime = 0;
  endTime = 0;  
}

void draw()
{
  int currentTapTime;
  float[] left = input.left.toArray();
  float sum = 0.0;
  
  stroke(255);
  //threshold taps
   for(int j=0; j<left.length ; j++) //detecting taps
   {
 
     if((left[j] > 0.18 && left[j] < 0.25)){
       //println(left[j]);
       
       stroke(0,255,0,255);
       /*
       if(timer.isFinished()){
         println(tapCount);
         tapCount = 0;
       }*/
       
       currentTapTime = millis();
       if(timer.isFinished()){
         println(tapCount);
         timer.start();
         tapCount = 0;
       }
       if(currentTapTime - prevTapTime > 50){
         //tapCount++;
         prevTapTime = currentTapTime;
         if(timer.isFinished()){
            println(tapCount);
            tapCount = 0;
            //timer.start();
         }
         else{
           //timer.start();
           tapCount++;
          }
          timer.start();
       }
     }
     /*if(timer.isFinished()) {
       timer.start();
       println(tapCount);
       if(tapCount == 2){
         //do 2 tap thing
         robot.mousePress( InputEvent.BUTTON1_MASK );
         robot.mouseRelease( InputEvent.BUTTON1_MASK );
       }
       else if (tapCount == 3){
         //do 3 tap thing
         robot.keyPress(KeyEvent.VK_LEFT);
         robot.keyRelease(KeyEvent.VK_LEFT);
       }
       tapCount = 0;
     }*/
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
