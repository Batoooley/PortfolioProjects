#pragma once
#include "ofMain.h"

class  Cluster{
    
public:
    Cluster();
	
		void setup();
		void update();
		void draw(ofColor _col,int _size);
 
    int length;
    ofColor col;

    
};
