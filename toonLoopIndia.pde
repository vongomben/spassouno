/**
 * Toonloop :: Live Stop Motion Animation Tool. 
 * @version Toonloop Lite version 0.15 Cleaned up.
 * @author Alexandre Quessy <alexandre@quessy.net>
 * @license GNU Public License version 2
 * @url http://www.toonloop.com
 * 
 * In the left window, you can see what is seen by the live camera.
 * In the right window, it is the result of the stop motion loop.
 * 
 * Usage : 
 *  - Press  bar to grab a frame.
 *  - Press DELETE or BACKSPACE to delete the last frame.
 *  - Press 'r' to reset and start the current sequence. (an remove all its frames)
 *  - Press 's' to save the current sequence as a QuickTime movie.
 *  - Press 'p' to open the Quicktime video camera settings dialog. (if available)
 *  - Press 'a' to toggle on/off the auto recording. (it records one frame on every frame)
 *  - Press 'q' to quit (disabled)
 *  - Press UP to increase frame rate
 *  - Press DOWN to decrease frame rate
 *  - Press numbers from 0 to 9 to switch to an other sequence.
 */

// UNCOMMENT If on Mac or Windows:
//import processing.video.*;
//Capture cam;
// UNCOMMENT If on GNU/Linux:

//import processing.opengl.*;
import codeanticode.gsvideo.*;
import java.io.*;

import ddf.minim.*;

GSCapture cam;
Minim minim;

int LOOP_MAX_NUM_FRAME = 500;
int NUM_SEQUENCES = 10; 
int LOOP_WIDTH = 640; //1280; //1024
int LOOP_HEIGHT = 480; //720;  //768
int FRAME_RATE = 8;
float WINDOW_SIZE_RATIO = 2;
int SAVED_MESSAGE_DURATION = 30;
float SAVED_MESS_SIZE_RATIO = 0.5;
int TEXT_FONT_SIZE = 24;
boolean ENABLE_QUIT = false;
int ONION_PEEL_ALPHA = 63;
// UNCOMMENT if on Mac or Windows:
// -------------------------------
//Choose only one of the followings: 
//int LOOP_CODEC = MovieMaker.H263;
//int LOOP_CODEC = MovieMaker.H264;
//int LOOP_CODEC = MovieMaker.MOTION_JPEG_A;
//int LOOP_CODEC = MovieMaker.MOTION_JPEG_B;
//int LOOP_CODEC = MovieMaker.ANIMATION;
// --------------------------------
//Choose only one of the followings: 
//int LOOP_QUALITY = MovieMaker.HIGH;
//int LOOP_QUALITY = MovieMaker.BEST;
//int LOOP_QUALITY = MovieMaker.LOSSLESS;

// EXTRA GSVideo Codecs
// --------------------------------
//Choose only one of the followings: 
int LOOP_CODEC = GSMovieMaker.THEORA;
// --------------------------------
//Choose only one of the followings: 
//int LOOP_QUALITY = MovieMaker.HIGH;
//int LOOP_QUALITY = MovieMaker.BEST;
//int LOOP_QUALITY = MovieMaker.LOSSLESS; 
int LOOP_QUALITY = GSMovieMaker.BEST;


GSMovieMaker movieOut;
int currentSeq = 0;
PFont font;
int is_auto_recording = 0;
int isFlashing = 0;
int is_displaying_saved_message = 0;

String saved_file_name;
ToonSequence sequences[] = new ToonSequence[NUM_SEQUENCES];

int toonloopStatus = 0; //0 = toonloop; 1 = info; 2 = save

AudioPlayer audioSave, audioDel;

PGraphics pg;
PImage infoPage, savePage;
boolean showInfoFlag, saveVideoFlag;
long showInfoTimer = 6000; //milliseconds

long timer = 0;
//03124

color rosso = color(255, 0, 0);
color blue = color(0, 0, 255);
color verde = color(0, 255, 0);
color arancione = color(255, 200, 0);
color nero = color(0, 0, 0);
color sfondo;

void setup() 
{
  //size((int)(LOOP_WIDTH*2*WINDOW_SIZE_RATIO), (int)(LOOP_HEIGHT*2*WINDOW_SIZE_RATIO), P3D);
  //size((int)(LOOP_WIDTH*2*WINDOW_SIZE_RATIO), (int)(LOOP_HEIGHT*2*WINDOW_SIZE_RATIO), OPENGL); 

  //  size(1280, 1000);
  size(1920, 1080); 
  pg = createGraphics(LOOP_WIDTH, LOOP_HEIGHT);
  infoPage = loadImage("info.png"); 
  savePage = loadImage("save.jpg");


  minim = new Minim(this);

  audioSave = minim.loadFile("click.mp3");
  //audioDel = minim.loadFile("marcus_kellis_theme.mp3");

  frameRate(FRAME_RATE);
  // UNCOMMENT If on Mac or Windows:
  // cam = new Capture(this, LOOP_WIDTH, LOOP_HEIGHT);
  // println("Available cameras :");
  // print(Capture.list());
  // end of Mac or Windows 
  // UNCOMMENT If on GNU/Linux:

  cam = new GSCapture(this, LOOP_WIDTH, LOOP_HEIGHT, "/dev/video1");
  // cam = new GSCapture(this, LOOP_WIDTH, LOOP_HEIGHT);

  cam.start();
  println("Cannot list cameras on GNU/Linux");

  // end of GNU/Linux
  for (int i = 0; i < sequences.length; i++) {
    sequences[i] = new ToonSequence();
  }
  font = loadFont("CourierNewPSMT-24.vlw");
  println("Welcome to ToonLoop ! The Live Stop Motion Animation Tool.");
  println(")c( Alexandre Quessy 2008");
  println("http://alexandre.quessy.net");
  sfondo = color(nero);
}

void draw() 
{
  background(sfondo);

  if (showInfoFlag) {
    //info image
    image(infoPage, 0, 0, width, height);
    if (millis() - timer > showInfoTimer) {
      showInfoFlag = false;
    }
  } 
  else {  

    if (cam.available() == true) 
    {
      cam.read();
    }
    noTint(); // alpha 100%
    textFont(font, TEXT_FONT_SIZE);
    //  if (is_auto_recording == 1) 
    //  {
    //    sequences[currentSeq].addFrame();
    //    fill(255, 0, 0, 255);
    //    String warningText = "AUTO RECORDING";
    //    text(warningText, (int)(LOOP_WIDTH/(4*WINDOW_SIZE_RATIO)), (int)(LOOP_HEIGHT*1.7*WINDOW_SIZE_RATIO));
    //  } 
    //  else {
    //    fill(255, 255, 255, 255);
    //    if (isFlashing == 1) 
    //    {
    //      isFlashing = 0;
    //      rect(0, (LOOP_HEIGHT/2)*WINDOW_SIZE_RATIO, LOOP_WIDTH*WINDOW_SIZE_RATIO, LOOP_HEIGHT*WINDOW_SIZE_RATIO);
    //      tint(255, 191); // alpha 75%
    //    }
    //  }
    //tint(255, 255, 255, 255);

    // display image
    image(cam, 0, 150, 960, 600); //1371 1.428571429 
    //  (int)(LOOP_WIDTH*WINDOW_SIZE_RATIO), (int)(LOOP_HEIGHT*WINDOW_SIZE_RATIO));

    //  image(cam, 0, (int)((LOOP_HEIGHT/2)*WINDOW_SIZE_RATIO), 
    //  (int)(LOOP_WIDTH*WINDOW_SIZE_RATIO), (int)(LOOP_HEIGHT*WINDOW_SIZE_RATIO));


    //tint(255, 255, 255, 255); 
    fill(127);
    textFont(font, TEXT_FONT_SIZE);
    int y = (int)(LOOP_HEIGHT*1.6*WINDOW_SIZE_RATIO);
    if (sequences[currentSeq].captureFrameNum > 0)
    {
      text(""+sequences[currentSeq].captureFrameNum, (int)((LOOP_WIDTH/2)*WINDOW_SIZE_RATIO), y);
      text(""+(sequences[currentSeq].playFrameNum+1), (int)((LOOP_WIDTH*3/2.0)*WINDOW_SIZE_RATIO), y);
    }
    fill(127, 0, 0); // darker
    text(""+(currentSeq+1), (int)((LOOP_WIDTH)*WINDOW_SIZE_RATIO), y);
    fill(255);
    // Image at the current offset in the loop on the right:
    noTint();

    // display Loop

    if (sequences[currentSeq].captureFrameNum > 0) 
    { 
      image(
      sequences[currentSeq].images[sequences[currentSeq].playFrameNum], 
      width/2, 150, 960, 600);//(0, 0, LOOP_WIDTH, LOOP_HEIGHT);
      //    (int)(LOOP_WIDTH*WINDOW_SIZE_RATIO), (int)((LOOP_HEIGHT/2)*WINDOW_SIZE_RATIO), 
      //    (int)(LOOP_WIDTH*WINDOW_SIZE_RATIO), (int)(LOOP_HEIGHT*WINDOW_SIZE_RATIO));
      sequences[currentSeq].loopFrame();
      /*
    if (mousePressed == true) {
       String pic_name;
       pic_name = "toonloop_"+String.valueOf(year())
       +"_"+String.valueOf(month())
       +"_"+String.valueOf(day())
       +"_"+String.valueOf(hour())
       +"h"+String.valueOf(minute())
       +"picNum_"
       +"######";
       println("saving to "+pic_name+" :");
       
       image(
       sequences[currentSeq].images[sequences[currentSeq].playFrameNum], 
       0, 0, 1280, 720); 
       //   (int)(LOOP_WIDTH*WINDOW_SIZE_RATIO), (int)(LOOP_HEIGHT*WINDOW_SIZE_RATIO));
       sequences[currentSeq].loopFrame();
       saveFrame(pic_name);
       println("foto");
       }
       */
    } 


    // SAVED message
    textFont(font, (int)(TEXT_FONT_SIZE*SAVED_MESS_SIZE_RATIO));
    if (is_displaying_saved_message > 0)
    {
      is_displaying_saved_message--; // decrement duration
      int x = (int)((LOOP_WIDTH/4)*WINDOW_SIZE_RATIO); 
      int the_y = (int)(LOOP_HEIGHT*1.7*WINDOW_SIZE_RATIO);
      fill(255, 0, 0, 255);
      text("Saved to "+saved_file_name + ". ("+LOOP_WIDTH +"x"+ LOOP_HEIGHT+")", x, the_y);
    }
  }
}


// switches to an other sequence
void switchToSequence(int i) 
{
  if (NUM_SEQUENCES > i && i >= 0)
  {
    currentSeq = i;
    FRAME_RATE = sequences[currentSeq].getFrameRate();
    frameRate(FRAME_RATE);
  }
}
void cameraPreferences()
{
  println("Opening the settings window. (if available)");
  // Works only on Mac and Windows:
  //cam.settings();
}

void increaseFrameRate() 
{
  changeFrameRate(sequences[currentSeq].getFrameRate()+1);
}

void decreaseFrameRate() 
{
  changeFrameRate(sequences[currentSeq].getFrameRate()-1);
}

void changeFrameRate(int r) 
{
  if (r > 0 && r <= 60) 
  {
    FRAME_RATE = r;
    frameRate(FRAME_RATE);
    sequences[currentSeq].setFrameRate(FRAME_RATE);
  }
}

void toggleAutoRecording()
{
  if (is_auto_recording ==0) 
  {
    is_auto_recording = 1;
  } 
  else {
    is_auto_recording = 0;
  }
}

void saveVideo(int currentSeq) {

  int seqNum = currentSeq;

  for (int i = 0; i < sequences[seqNum].captureFrameNum; i++) 
  {
    print(i+" ");
    // image(
    // sequences[currentSeq].images[sequences[seqNum].playFrameNum], 
    // (int)(LOOP_WIDTH*WINDOW_SIZE_RATIO), (int)((LOOP_HEIGHT/2)*WINDOW_SIZE_RATIO), 
    // (int)(LOOP_WIDTH*WINDOW_SIZE_RATIO), (int)(LOOP_HEIGHT*WINDOW_SIZE_RATIO));
    // sequences[seqNum].loopFrame();
    // loadPixels();
    //            movieOut.addFrame(sequences[seqNum].images[i].pixels, LOOP_WIDTH, LOOP_HEIGHT);
    // movieOut.addFrame(sequences[seqNum].images[i].pixels);
    sequences[currentSeq].record();
    //    saveFrame("ciao#####.jpg");
  }

  println("done saving");
}

boolean sketchFullScreen() {
  return true;
}

