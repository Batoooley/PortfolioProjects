#include "Cluster.h"
Cluster::Cluster(){
    
};
//--------------------------------------------------------------
void Cluster::setup(){
 
}

//--------------------------------------------------------------
void Cluster::update(){

}

//--------------------------------------------------------------
void Cluster::draw(ofColor _col, int _length){
    col = _col;
    length = _length;
    
    ofSetColor(col);
    ofSetRectMode(OF_RECTMODE_CORNER);
    ofDrawRectangle(0, 0, _length, _length);

}
