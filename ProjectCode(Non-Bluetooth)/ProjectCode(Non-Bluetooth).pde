/**
  * This sketch demonstrates how to use the BeatDetect object in FREQ_ENERGY mode.<br />
  * You can use isKick</code>, <code>isSnare</code>, </code>isHat</code>, <code>isRange</code>,
  * and <code>isOnset(int)</code> to track whatever kind of beats you are looking to track, they will report
  * true or false based on the state of the analysis. To "tick" the analysis you must call <code>detect</code>
  * with successive buffers of audio. You can do this inside of <code>draw</code>, but you are likely to miss some
  * audio buffers if you do this. The sketch implements an <code>AudioListener</code> called <code>BeatListener</code>
  * so that it can call <code>detect</code> on every buffer of audio processed by the system without repeating a buffer
  * or missing one.
  * <p>
  * This sketch plays an entire song so it may be a little slow to load.
  */
  
  /*Firmata is a protocol (set of rules) for communicating with microcontrollers from software on a computer, smartphone, or tablet.
  Standard Firmata is a software library that allows Arduino devices to communicate with your computer using the Firmata protocol.*/

import processing.serial.*;       //Imports the Processing Serial libraries
import ddf.minim.*;               //Imports part of the Minim libraries
import ddf.minim.analysis.*;      //Imports part of the Minim libraries
import cc.arduino.*;              //Imports the Arduino libraries
import java.io.File;              //Imports the Java File libraries

Minim minim;          //Creates a Minim object called minim
AudioPlayer song;     //Creates an AudioPlayer object called song
BeatDetect beat;      //Creates a BeatDetect called beat
BeatListener bl;      //Creates a BeatListener object called bl
Arduino arduino;      //Creates an Arduino object called arduino

int ledPin = 3;       //LED connected to digital pin 3
int ledPin2 = 5;      //LED connected to digital pin 5
int ledPin3 = 6;      //LED connected to digital pin 6

void setup() {      //The main function of the code, loads files, plays the song, and outputs to the Arduino

  File playlist = new File("U:\\HasSongs");      //Makes a new file of the directory of MP3's
  minim = new Minim(this);                                        //Calls Minim so that it can load files from the data directory
  arduino = new Arduino(this, "COM8", 57600);                     //Creates a new arduino, this equals the parent name, COM3 is the port, and 57600 is the connection speed
  
  for(File f : playlist.listFiles()){              //Iterates through the directory of files and gets those files names
     song = minim.loadFile(f.getName(), 2048);     //Loads the next file, f.getName() is the file name and 2048 is the buffer size
     song.play();                                  //Plays the song
     
     beat = new BeatDetect(song.bufferSize(), song.sampleRate());      //Detects the beat of the song using the songs buffer size and sample rate
     beat.setSensitivity(5);                                          //Sets the sensitivity to 10 milliseconds, after a beat has been detected, the algorithm will wait for 10 milliseconds before
                                                                       //allowing another beat to be reported. You can use this to dampen the algorithm if it is giving too many false-positives. The
                                                                       //default value is 10, which is essentially no damping. The sensitivity cannot be less than zero.
                                                                       
     bl = new BeatListener(beat, song);             //Makes a new beat listener which analyzes the song
     arduino.pinMode(ledPin, Arduino.OUTPUT);       //Makes it so that it outputs to digital pin 3 on the Arduino
     arduino.pinMode(ledPin2, Arduino.OUTPUT);      //Makes it so that it outputs to digital pin 5 on the Arduino
     arduino.pinMode(ledPin3, Arduino.OUTPUT);      //Makes it so that it outputs to digital pin 6 on the Arduino
     
     while(song.isPlaying()){      //Loops while the song is playing
       draw();                     //Calls the draw function to light up the LEDs
     }
  }
}

void draw() {
  if(beat.isKick()) arduino.analogWrite(ledPin, 120);       //Sends the value of RGB (0, 120, 0) to the Arduino
                                                                               //lights up green
  if(beat.isSnare()) arduino.analogWrite(ledPin2, 255);     //Sends the value of RGB (255, 0, 0) to the Arduino
                                                                               //lights up red
  if(beat.isHat()) arduino.analogWrite(ledPin3, 200);       //Sends the value of RGB (0, 0, 200) to the Arduino
                                                                               //lights up blue

  arduino.analogWrite(ledPin,0);      //Sends the value of RGB (0, 0, 0) to the Arduino so that the lights will turn off so that the light just flashes
  arduino.analogWrite(ledPin2, 0);    //Sends the value of RGB (0, 0, 0) to the Arduino so that the lights will turn off so that the light just flashes
  arduino.analogWrite(ledPin3, 0);    //Sends the value of RGB (0, 0, 0) to the Arduino so that the lights will turn off so that the light just flashes
  
}

void stop() {                          //This function stops the song and other libraries running and turns off the LEDs

  arduino.analogWrite(ledPin, 0);      //Sends the value of RGB (0, 0, 0) to the Arduino so that the lights will turn off 
  arduino.analogWrite(ledPin2, 0);     //Sends the value of RGB (0, 0, 0) to the Arduino so that the lights will turn off
  arduino.analogWrite(ledPin3, 0);     //Sends the value of RGB (0, 0, 0) to the Arduino so that the lights will turn off
 
  song.close();      //Stops the song
  minim.stop();      //Stops Minim
  super.stop();      //Stops the whole program
  
}
