// UNCOMMENT If under Mac or Windows:  
// Starts a thread to save a movie of the current sequence in the background.
void OLDsaveMovie() 
{
  SaveThread t = new SaveThread(this, currentSeq);
  t.start();
}
// One thread to save a movie
class SaveThread extends Thread 
{
  PApplet theParent;
  int seqNum;
  // Args: PApplet "this", sequence number
  SaveThread(PApplet p, int sequenceNum) 
  {
    seqNum = sequenceNum;
    theParent = p;
    println("saving " + seqNum);
  }
  public void run() 
  {
    // Create MovieMaker object with size, filename,
    // compression codec and quality, framerate
    String file_name;
    if (sequences[seqNum].captureFrameNum == 0) 
    {
      println("no frame to save!");
    } 
    else 
    {
      file_name = "toonloop_"+String.valueOf(year())
        +"_"+String.valueOf(month())
          +"_"+String.valueOf(day())
            +"_"+String.valueOf(hour())
              +"h"+String.valueOf(minute())
                +"m"+String.valueOf(second())
                  +".ogg";
      println("saving to "+file_name+" :");
      is_displaying_saved_message = SAVED_MESSAGE_DURATION;
      saved_file_name = file_name;

      //        movieOut = new GSMovieMaker(theParent, LOOP_WIDTH, LOOP_HEIGHT, file_name, FRAME_RATE, LOOP_CODEC, LOOP_QUALITY);
      movieOut = new GSMovieMaker(theParent, LOOP_WIDTH, LOOP_HEIGHT, file_name, LOOP_CODEC, LOOP_QUALITY, FRAME_RATE);
      for (int i = 0; i < sequences[seqNum].captureFrameNum; i++) 
      {
        print(i+" ");
        loadPixels();
        //            movieOut.addFrame(sequences[seqNum].images[i].pixels, LOOP_WIDTH, LOOP_HEIGHT);
        movieOut.addFrame(sequences[seqNum].images[i].pixels);
        //  saveFrame("ciao#####.jpg");
      }
      println();
      movieOut.finish();
      println("done saving");
      //movieOut = null;
    }
  }
}
// end of Mac or Windows
