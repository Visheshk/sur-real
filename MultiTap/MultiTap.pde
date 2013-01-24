import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
//import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer player;
AudioInput input;
FFT fft;
HighPassSP hpf;

int tapCount;
int prevTapTime;

float[] fftm;

void setup()
{
  size(640,480);
  smooth();
  background(0);
  strokeWeight(2);
  
  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO, 512);
  
  fft = new FFT(input.bufferSize(), input.sampleRate());
  hpf = new HighPassSP(500, input.sampleRate());
  input.addEffect(hpf);
  tapCount = prevTapTime = 0;
  
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
       
      
       currentTapTime = millis();
       
       if(currentTapTime - prevTapTime > 50){
         //classified as a tap
         
         if(currentTapTime - prevTapTime < 400)  //see if its a multiple one
         {
           prevTapTime = currentTapTime;
           tapCount+=1; //1->2, 2->3
           
         }
         else
         {
           //got a single tap only
           prevTapTime = currentTapTime;
           tapCount = 1;
         }
         println(left[j]+"  " + tapCount);
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
