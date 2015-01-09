/**
 One sequence (bin)
 */
class ToonSequence
{
  int captureFrameNum = 0; //the next captured frame number ... might wrap around
  int playFrameNum = 0;
 // PImage[] images = new PImage[LOOP_MAX_NUM_FRAME];
  PGraphics[] images = new PGraphics[LOOP_MAX_NUM_FRAME];
  int seqFrameRate = FRAME_RATE;
  int getFrameRate() 
  {
    return seqFrameRate;
  }
  void setFrameRate(int r)
  {
    seqFrameRate = r;
  }
  void ToonSequence()
  {
  }
  void resetMovie() 
  {
    captureFrameNum = 0;
  }
  void deleteFrame()
  {
    // the former frame goes to the garbage collector
    if (captureFrameNum > 0) 
    {
      captureFrameNum--;
    }
  }
  void addFrame() 
  {
    if (captureFrameNum < LOOP_MAX_NUM_FRAME) 
    {
      //tint(0, 153, 204);
    //  if (is_tinting_the_image == 1) {

      //create a new PGraphics every time you add a frame
        PGraphics pg=createGraphics(LOOP_WIDTH, LOOP_HEIGHT);
        println("!");
     // } else {
        pg.beginDraw();
        pg.tint(255, 0, 0);
        // We use new here, because it was not possible to overwrite an existing image.
        pg.image(cam, 0, 0, LOOP_WIDTH, LOOP_HEIGHT);
        images[captureFrameNum] = pg;
        pg.endDraw();
        
      //  image(pg,0,0);

        //images[captureFrameNum] = new PImage(LOOP_WIDTH, LOOP_HEIGHT);
        //images[captureFrameNum].copy(cam, 0, 0, LOOP_WIDTH, LOOP_HEIGHT, 0, 0, LOOP_WIDTH, LOOP_HEIGHT);
    //  }
     // images[captureFrameNum].copy(pg, 0, 0, LOOP_WIDTH, LOOP_HEIGHT, 0, 0, LOOP_WIDTH, LOOP_HEIGHT);
      //images[captureFrameNum].blend(cam, 0, 0, LOOP_WIDTH, LOOP_HEIGHT, 0, 0, LOOP_WIDTH, LOOP_HEIGHT, ADD);
      //images[captureFrameNum].
        //image(images[captureFrameNum],0,0);

      captureFrameNum++;
      //isFlashing = 1;
    } else {
      println("Reached max number of frames : " + LOOP_MAX_NUM_FRAME);
    }
  }
  void loopFrame() 
  {
    if (playFrameNum < captureFrameNum - 1) 
    {
      playFrameNum++;
    } else {
      playFrameNum = 0;
    }
  }
  void tintFrame()
  {

    if (is_tinting_the_image ==0) 
    {
      is_tinting_the_image = 1;
      println("tint");
      tint(0, 153, 204);
    } else {
      is_tinting_the_image = 0;
      noTint();
    }
  }
}
