void keyPressed() 
{
  println(key);

  switch (keyCode)
  {
  case UP:
    increaseFrameRate();
    break;
  case DOWN:
    decreaseFrameRate();
    break;
  case LEFT:
    break;
  case RIGHT:
    break;
  }

  switch (key)
  {

  case ' ': // ADD FRAME
    if (is_auto_recording == 0) {
      audioSave.play();
      sequences[currentSeq].addFrame();
      audioSave.rewind();
    }
    break;
  case 'o':
    saveVideo(currentSeq);
    break;
  case 'p': // SETTINGS
    cameraPreferences();
    break;
  case 'r': // RESET
    sequences[currentSeq].resetMovie();
    break;
  case 's':
    if (is_auto_recording == 0) {
      saveMovie();
    }
    break;   
  case 'i':
    timer = millis();
    showInfoFlag = true; 
    break;
  case 'c':    
  case BACKSPACE: // DELETE ONE FRAME
  case DELETE:
    sequences[currentSeq].deleteFrame();
    break;
  case 'a': // AUTO RECORD
    toggleAutoRecording();
    break;
  case 'q': // QUIT APPLICATION
    if (ENABLE_QUIT) {
      exit();
    }
    break;
  case '0':
  //03124
    switchToSequence(0);
    sfondo = color(rosso);
    break;
  case '1':
    switchToSequence(1);
     sfondo = color(verde);
    break;
  case '2':
    switchToSequence(2);
     sfondo = color(arancione);
    break;
  case '3':
    switchToSequence(3);
     sfondo = color(blue);
    break;
  case '4':
    switchToSequence(4);
     sfondo = color(nero);
    break;
  case '5':
    switchToSequence(5);
    break;
  case '6':
    switchToSequence(6);
    break;
  case '7':
    switchToSequence(7);
    break;
  case '8':
    switchToSequence(8);
    break;
  case '9':
    switchToSequence(9);
    break;
  }
}

