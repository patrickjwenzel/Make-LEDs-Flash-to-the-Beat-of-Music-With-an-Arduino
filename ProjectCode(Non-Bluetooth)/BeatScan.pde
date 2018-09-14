class BeatListener implements AudioListener{
  private BeatDetect beat;         //Creates a new beat detecting variable
  private AudioPlayer source;      //Isn't used but needs to be included since BeatListener is a class using the AudioListener interface
  
  BeatListener(BeatDetect beat, AudioPlayer source){      //Beat is the beat read in ProjectCode and source is the MP3 file that is playing
    this.source = source;               //Isn't used but needs to be included since BeatListener is a class using the AudioListener interface
    this.source.addListener(this);      //Isn't used but needs to be included since BeatListener is a class using the AudioListener interface
    this.beat = beat;                   //Makes this.beat the beat of the beat parameter
  }
  
  void samples(float[] samps){                       //Isn't used but needs to be included since BeatListener is a class using the AudioListener interface
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR){      //Isn't used but needs to be included since BeatListener is a class using the AudioListener interface
    beat.detect(source.mix);
  }
}
