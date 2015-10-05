void keyPressed() 
{
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
      sequences[currentSeq].addFrame();
    }
    break;
//  case 'o':
//    saveVideo(currentSeq);
//    break;
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
    
  case 'e': // EFFECTS, TINT
    sequences[currentSeq].tintFrame();
    break;

  case 'g': // EFFECTS, TINT
    ghostEnabled = true;
    newGhost();
    break;

  case 'h': // EFFECTS, TINT
    ghostEnabled = false;
    noGhost();
    break;
    
    
  case 'q': // QUIT APPLICATION
    if (ENABLE_QUIT) {
      exit();
    }
    break;
  case '0':
    switchToSequence(0);
    break;
  case '1':
    switchToSequence(1);
    break;
  case '2':
    switchToSequence(2);
    break;
  case '3':
    switchToSequence(3);
    break;
  case '4':
    switchToSequence(4);
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