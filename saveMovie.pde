void saveMovie() {
  //lock screen
  background(0);
  image(savePage, 0, 0, LOOP_WIDTH, LOOP_HEIGHT);
  
  String pic_name;
  int capturedFrames = sequences[currentSeq].captureFrameNum;

  print("Total frames: ");
  println(capturedFrames);

  if (capturedFrames > 0) {
    for (int i=0; i< capturedFrames; i++) {

      pic_name = "toonloop_"+ currentSeq    
        +"__"+String.valueOf(year())
        +"_"+String.valueOf(month())
          +"_"+String.valueOf(day())
            +"__"+String.valueOf(hour())
              +"_"+String.valueOf(minute())
                + "__" + String.format("%03d", i)
                  + ".jpg";

      //println("saving to "+pic_name+" :");

      pg.image(
      sequences[currentSeq].images[i], 
//      0, 0, width, height); 
      0, 0, LOOP_WIDTH, LOOP_HEIGHT); 

      //saveFrame(pic_name);
      pg.save(pic_name);
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


