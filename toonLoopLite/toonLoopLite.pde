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

// UNCOMMENT If on Mac or Windows 
// or if you are using the latest video library in Processing

import processing.video.*;
Capture cam;

// UNCOMMENT If on GNU/Linux:

//import processing.opengl.*;
//import codeanticode.gsvideo.*;
//import java.io.*;
//GSCapture cam;

int LOOP_MAX_NUM_FRAME = 500;
int NUM_SEQUENCES = 10; 
int LOOP_WIDTH = 640; //1280; //1024
int LOOP_HEIGHT = 480; // 720;  //768

int FRAME_RATE = 8;
float WINDOW_SIZE_RATIO = 1.5; // 0.5625 ? 
int SAVED_MESSAGE_DURATION = 30;
float SAVED_MESS_SIZE_RATIO = 0.5;
int TEXT_FONT_SIZE = 32;
boolean ENABLE_QUIT = false;
int ONION_PEEL_ALPHA = 63;


int currentSeq = 0;
PFont font;
int is_auto_recording = 0;
int is_tinting_the_image = 0; // variable to store the tint condition
int isFlashing = 0;
int is_displaying_saved_message = 0;

String saved_file_name;
ToonSequence sequences[] = new ToonSequence[NUM_SEQUENCES];

int toonloopStatus = 0; //0 = toonloop; 1 = info; 2 = save

PGraphics pg;

PImage ghost;
boolean ghostEnabled=false;

// trying to add filtered export images
PImage img = createImage(66, 66, RGB);
PImage infoPage, savePage;
boolean showInfoFlag, saveVideoFlag;
long showInfoTimer = 3000; //milliseconds

long timer = 0;

void setup() 
{
  //size((int)(LOOP_WIDTH*2*WINDOW_SIZE_RATIO), (int)(LOOP_HEIGHT*2*WINDOW_SIZE_RATIO), P3D);
  //size((int)(LOOP_WIDTH*2*WINDOW_SIZE_RATIO), (int)(LOOP_HEIGHT*2*WINDOW_SIZE_RATIO), OPENGL); 

  //  size(1280, 1000);
  size(LOOP_WIDTH*2, LOOP_HEIGHT*2); 
  pg = createGraphics(LOOP_WIDTH, LOOP_HEIGHT);

  infoPage = loadImage("info.jpg"); 
  savePage = loadImage("save.jpg");

  frameRate(FRAME_RATE);
  // UNCOMMENT If on Mac or Windows:
  // cam = new Capture(this, LOOP_WIDTH, LOOP_HEIGHT);
  // println("Available cameras :");
  // print(Capture.list());
  // end of Mac or Windows 
  // UNCOMMENT If on GNU/Linux:

  cam = new Capture(this, LOOP_WIDTH, LOOP_HEIGHT);
  cam.start();
  //println("Cannot list cameras on GNU/Linux");

  // end of GNU/Linux
  for (int i = 0; i < sequences.length; i++) {
    sequences[i] = new ToonSequence();
  }
  font = loadFont("CourierNewPSMT-24.vlw");
  //println("Welcome to ToonLoop ! The Live Stop Motion Animation Tool.");
  //println(")c( Alexandre Quessy 2008");
  //println("http://alexandre.quessy.net");
  ghost=createImage(LOOP_WIDTH, LOOP_HEIGHT, RGB);
}

void draw() 
{
  background(0);

  // * Show information page to the user 
  if (showInfoFlag) {
    //info image
    image(infoPage, 0, 0, LOOP_WIDTH, LOOP_HEIGHT);
    if (millis() - timer > showInfoTimer) {
      showInfoFlag = false;
    }
  } else {  

    if (cam.available() == true) 
    {
      cam.read();
    }
    //noTint(); // alpha 100%

    // display image
    //tint(255, 0, 255);
    //image(cam, 0, 150, 1065, 750); //1371 1.428571429 


    //sequences[currentSeq].tintFrame();  <--- an attempt to add an effect to the loop. Try to uncomment and laugh
    image(cam, 0, 150, LOOP_WIDTH, LOOP_HEIGHT); //1371 1.428571429 

    if (ghost!=null) {
     tint(255, 126);
      image(ghost, 0, 150, LOOP_WIDTH, LOOP_HEIGHT);
    }

    // y is the height of the text for frames and sequence information
    // int y = (int)(LOOP_HEIGHT*1.6*WINDOW_SIZE_RATIO);
    int y = LOOP_HEIGHT + 200;
    if (sequences[currentSeq].captureFrameNum > 0)
    {
      text("frame: "+sequences[currentSeq].captureFrameNum+"/"+LOOP_MAX_NUM_FRAME, (int)((LOOP_WIDTH/2)), y);
      text("frame: "+(sequences[currentSeq].playFrameNum+1)+"/"+LOOP_MAX_NUM_FRAME, (int)((LOOP_WIDTH*WINDOW_SIZE_RATIO)-100), y);
    }
    text("sequence "+(currentSeq+1), (int)((LOOP_WIDTH*WINDOW_SIZE_RATIO)+100), y);

    // Image at the current offset in the loop on the right:

    // display Loop

    if (sequences[currentSeq].captureFrameNum > 0) 
    { 

      //image(sequences[currentSeq].images[sequences[currentSeq].playFrameNum], width/2, 150, 1075, 750);
      image(sequences[currentSeq].images[sequences[currentSeq].playFrameNum], width/2, 150, LOOP_WIDTH, LOOP_HEIGHT);
      //println(sequences[currentSeq].playFrameNum);
      // keep the loop going increasing playFrameNum by one
      sequences[currentSeq].loopFrame();
    } 


    //    // SAVED message
    //    textFont(font, (int)(TEXT_FONT_SIZE*SAVED_MESS_SIZE_RATIO));
    //    if (is_displaying_saved_message > 0)
    //    {
    //      is_displaying_saved_message--; // decrement duration
    //      int x = (int)((LOOP_WIDTH/4)*WINDOW_SIZE_RATIO); 
    //      int the_y = (int)(LOOP_HEIGHT*1.7*WINDOW_SIZE_RATIO);
    //      fill(255, 0, 0, 255);
    //      text("Saved to "+saved_file_name + ". ("+LOOP_WIDTH +"x"+ LOOP_HEIGHT+")", x, the_y);
    //    }
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
  } else {
    is_auto_recording = 0;
  }
}

// New "Save Video" by Pitusso aka Mirco Piccin 

void saveMovie() {
  //lock screen
  background(0);
  //image(savePage, 0, 0, LOOP_WIDTH, LOOP_HEIGHT);

  // notifying recording by stupid red dot
  smooth();
  fill(255, 0, 0);
  ellipse(40, 40, 40, 40);

  String pic_name;
  int capturedFrames = sequences[currentSeq].captureFrameNum;

  print("Total frames: ");
  println(capturedFrames);

  if (capturedFrames > 0) {
    for (int i=0; i< capturedFrames; i++) {

      pic_name = "toonloop_"   
        +"w"+LOOP_WIDTH+"h"+LOOP_HEIGHT
        +"__"+String.valueOf(year())
        +"_"+String.valueOf(month())
          +"_"+String.valueOf(day())
            +"__"+String.valueOf(hour())
              +"_"+String.valueOf(minute())
                + "_Seq" + String.format("%2d", currentSeq)
                  + "_Frm" + String.format("%03d", i)
                    + ".jpg";


      println("saving to "+pic_name+" :");

      // a naive attempt to display the saved image name...
      text("Saved to "+pic_name, width/2, (height/4)*3);

      pg.image(sequences[currentSeq].images[i], 0, 0, LOOP_WIDTH, LOOP_HEIGHT); 
      //saveFrame(pic_name);
      pg.save(pic_name);
      // saveFrame();
      //  is_displaying_saved_message++;
    }

    /*
    //build the movie and delete images
     try {
     Runtime.getRuntime().exec(new String[]{sketchPath("") + "data/makeMovie.sh", "-s", Integer.toString(currentSeq)});            
     } 
     catch (IOException e) {  
     println(e.getMessage());
     }
     */
  }
}
void showInfo() {
  int showTime = 3*1000; //show info page for 10 seconds

  background(0);
  //image(infoPage, 0, 0, LOOP_WIDTH, LOOP_HEIGHT);

  /*
  for (int i=0; i<showTime; i++) {
   fill(0);
   text("Wait " + i, 200, 200);  
   }
   */
  delay(showTime);
}

void newGhost() {
  
  ghost.copy(cam, 0, 0, LOOP_WIDTH, LOOP_HEIGHT, 0, 0, LOOP_WIDTH, LOOP_HEIGHT);
//(  image(ghost,0,0);
}

//boolean sketchFullScreen() {
//  return true;
//}

