import processing.serial.*;       //Imports the Processing Serial libraries
import ddf.minim.*;               //Imports part of the Minim libraries
import ddf.minim.analysis.*;      //Imports part of the Minim libraries
import cc.arduino.*;              //Imports the Arduino libraries
import java.io.File;              //Imports the Java File libraries

Minim minim;          //Creates a Minim object called minim
AudioPlayer song;     //Creates an AudioPlayer object called song
BeatDetect beat;      //Creates a BeatDetect called beat
BeatListener bl;      //Creates a BeatListener object called bl
Serial s;             //Creates a new Serial object called s

int ledPin = 3;       //LED connected to digital pin 3
int ledPin2 = 5;      //LED connected to digital pin 5
int ledPin3 = 6;      //LED connected to digital pin 6
String colors;             //String that will be used for the color that the LEDs will light up to

void setup() {        //The main function of the code, loads files, plays the song, and outputs to the Arduino

  File playlist = new File("U:\\HasSongs");      //Makes a new file of the directory of MP3's
  minim = new Minim(this);                       //Calls Minim so that it can load files from the data directory
  s = new Serial(this, "COM9", 38400);           //Initializes the new Serial device object to send it to, COM9 is the port and 38400 is the baud rate
  
  for(File f : playlist.listFiles()){              //Iterates through the directory of files and gets those files names
     song = minim.loadFile(f.getName(), 2048);     //Loads the next file, f.getName() is the file name and 2048 is the buffer size
     song.play();                                  //Plays the song
     
     beat = new BeatDetect(song.bufferSize(), song.sampleRate());      //Detects the beat of the song using the songs buffer size and sample rate
     beat.setSensitivity(50);                                          //Sets the sensitivity to 10 milliseconds, after a beat has been detected, the algorithm will wait for 10 milliseconds before
                                                                       //allowing another beat to be reported. You can use this to dampen the algorithm if it is giving too many false-positives. The
                                                                       //default value is 10, which is essentially no damping. The sensitivity cannot be less than zero.
                                                                       
     bl = new BeatListener(beat, song);             //Makes a new beat listener which analyzes the song
     
     while(song.isPlaying()){      //Loops while the song is playing
       draw();                     //Calls the draw function to light up the LEDs
     }
  }
}

void draw() {
  if(beat.isKick()){         //Checks if it is a hat   
    colors = "255,0,0";      //Makes 'colors' a string for the color blue
    s.write(colors);      //Sends this over Bluetooth
  }
                                                                               
  if(beat.isSnare()){        //Checks if it is a hat 
    colors = "0,255,0";      //Makes 'colors' a string for the color blue
    s.write(colors);      //Sends this over Bluetooth
  }
                                                                               
  if(beat.isHat()){          //Checks if it is a hat    
    colors = "0,0,255";      //Makes 'colors' a string for the color blue
    s.write(colors);      //Sends this over Bluetooth
  }
}

void stop() {                 //This function stops the song and other libraries running and turns off the LEDs
  s.clear();         //Clears the serial's memory of all the strings
  s.stop();          //Stops the serial connection
  song.close();      //Stops the song
  minim.stop();      //Stops Minim
  super.stop();      //Stops the whole program
  
}
