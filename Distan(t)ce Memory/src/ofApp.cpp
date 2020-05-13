#include "ofApp.h"
/*
 Blurb:
 "Distan(t)ce Memory" is a video installation exploring memory recollection and the deterioration in relation to distance.
 The installation features a video of a typically romanticised scene of the horizon over the sea. The video is already shot to deliberately create an abstracted image, using an uncommon shooting format and diving the frame into two large block of blue, one for the sea and one for the sky. The image is further abstracted by being drawn over by clusters of lines that display the changing colour of he pixels beneath them to render an abstracted version of the video.
 When further away, the viewer/participant is sees a slightly clearer image, inviting the viewer to come closer to see clearer. However, upon closer inspection the viewer is confronted by a more and more abstracted video.
 The work aims to invoke a relation ship of compromise and acceptance between the video and the participant; creating an experience that parallels that of recalling a memory. The more a memory is called upon, (the closer one looks) the more distorted it grows. The work posits the possibility of accepting the distance necessary for maintaining the form of a past place and time.
 
 
 Code and help Referenced:
 https://talk.olab.io/t/averaging-color-of-video-pixels/839/2
 https://openframeworks.cc/ofBook/chapters/image_processing_computer_vision.html
 OSC Receive example code
 /Applications/of_v0.10.1_osx_release/libs/openFrameworks
 **eventually discarded help:
 https://shiffman.net/p5/kinect/
 https://forum.openframeworks.cc/t/kinect-depth-sensitivity/7223/2
 https://www.i-programmer.info/ebooks/practical-windows-kinect-in-c/3802-using-the-kinect-depth-sensor.html
 
 
 Future Development (what didn't work this time):
 - Use proximity sensor (Arduino) for interaction
 - draw recursive shapes in "cluster" class
 - insert camera video pixels as well, weaved within the sea video to explore overlaying two "spaces"(videos) within the same pixel array.
 
 NOTE:
 This proejct started out using Kinect as the interaction input, but that proved to be the wrong tool to use as a simple proximity sensor, by the time that was changed there was no time to use a proximity sensor and arduino so OSC Hook is a stand-in that works well.
*/

//--------------------------------------------------------------
void ofApp::setup(){
    ofBackground(0);//(0,0,0);
    myCluster.setup();
    
    //VIDEO CODE
    
    // Uncomment this to show movies with alpha channels
    // mov.setPixelFormat(OF_PIXELS_RGBA); //commenting this outs solves memorory ovrride
	ofSetVerticalSync(true);
    mov.load("sea1.mp4");
	mov.setLoopState(OF_LOOP_NORMAL);
	mov.play();
    int numFrames = mov.getTotalNumFrames();
   
    //OSC CODE
    
    // listen on the given port
    //cout << "listening for osc messages on port " << PORT << "\n";
    receiver.setup(PORT);
    
    mouseX = 0;
    mouseY = 0;
    mouseButtonState = "";
    
}

//--------------------------------------------------------------
void ofApp::update(){
    mov.update();
    myCluster.update();
    
    //OSC CODE
    
    if (messageBuffer.size()>maxBufferSize) messageBuffer.pop_back();
    
    // check for waiting messages
    while(receiver.hasWaitingMessages()){
        // get the next message
        ofxOscMessage m;
        receiver.getNextMessage(m);
        
        // check for light sensory on OSC receive
        if(m.getAddress() == "/light"){
            // both the arguments are ints
            mouseX = m.getArgAsInt(0);
            mouseY = m.getArgAsInt(1);
        }
        else {
            // unrecognized message: display on the bottom of the screen
            messageBuffer.push_front(m.getAddress() + ": UNRECOGNIZED MESSAGE");
        }
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    int vidSize = 750;
    ofPixels pixels = mov.getPixels();  //put the video into a pixel object
    pixels.resize(vidSize, vidSize);            //resize pixel object hence resizing video
    mov.setAnchorPercent(0.5, 0.5);     //control the video from the centre
    
    int vidWidth = pixels.getWidth();   //put vid dimensions in variable to use in loops
    int vidHeight = pixels.getHeight();
    
    //less light == bigger clusters == lower 'resolution'
    //must calibrate mouseX values for diffeent installation spaces according to light levels, but keep lower threshhold at 100.
    int dark = 100;
    int bright = 2000;
    int skip = ofMap(mouseX, dark, bright, 200, 2, true);
    
    ofPushMatrix();
    ofTranslate(ofGetWidth()/2, ofGetHeight()/2);
    ofRotate(90); //OF displays the vid on its side, so had to rotate it. this is to to with the video metadate.
//    mov.draw(0, 0, vidSize, vidSize);
    //LOOP FOR DRAWING MAIN VIDEO. CENTRE PEICE:
    for (int i = 0; i < vidWidth; i+=skip){
        for (int j = 0; j < vidHeight; j+=skip){

            ofColor pixelColor = pixels.getColor(i, j);//get the colour of pixel underneath

            ofPushMatrix();
            //note: i and j axis are rotated! remove 'j' from translation if Cluster is lines
            ofTranslate(i - (vidWidth/2),j -(vidHeight/2));
            ofPushStyle();
            clusters(pixelColor, skip);
            ofPopStyle();
            ofPopMatrix();
        }
    }
    //LOOP FOR DRAWING SIDE LINES.LEFT.
     for (int i = 0; i < vidWidth; i+=skip){
         for (int j = 0; j < vidHeight; j+=skip){
             
         ofColor pixelColor = pixels.getColor(i, j);//get the colour of pixel underneath
         
         ofPushMatrix();
         //note: i and j axis are rotated! remove 'j' from translation if Cluster is lines
         ofTranslate(i - (vidWidth/2), -(vidHeight/2));
         ofPushStyle();
             ofSetColor(pixelColor);
             ofDrawRectangle(0, vidWidth, skip, vidWidth);
         ofPopStyle();
         ofPopMatrix();
         }
     }
     //LOOP FOR DRAWING SIDE LINES.RIGHT.
    for (int i = 0; i < vidWidth; i+=skip){
        for (int j = 0; j < vidHeight; j+=skip){
            
            ofColor pixelColor = pixels.getColor(i,j);//get the colour of pixel underneath
            
            ofPushMatrix();
            //note: i and j axis are rotated! remove 'j' from translation if Cluster is lines
            ofTranslate(i - (vidWidth/2), -(vidHeight/2));
            ofPushStyle();
                ofSetColor(pixelColor);
                ofDrawRectangle(0, -vidWidth, skip, vidWidth);
            ofPopStyle();
            ofPopMatrix();
        }
    }
    ofPopMatrix();
    
    // COMMENT THIS IN FOR TESTING OSC SIGNALS, OTHERWISE KEEP COMMENTED OUT
    //    string buf;
    //    buf = "listening for osc messages on port" + ofToString(PORT);
    //    ofDrawBitmapString(buf, 10, 20);
    //
    //    // draw mouse state
    //    buf = "mouse: " + ofToString(mouseX, 4) +  " " + ofToString(mouseY, 4);
    //    ofDrawBitmapString(buf, 430, 20);
    //    ofDrawBitmapString(mouseButtonState, 580, 20);
    //
    //    // read the buffer
    //    for(int i = 0; i < messageBuffer.size(); i++){
    //        ofDrawBitmapString(messageBuffer[i], 10, 40 + 15 * i);
    //    }

}
//--------------------------------------------------------------
    void ofApp::clusters(ofColor _col, int _size){
        col = _col;
        length = _size;
    
        ofSetColor(col);
        ofSetRectMode(OF_RECTMODE_CORNER);
        ofDrawRectangle(0, 0, _size, _size);
    }
