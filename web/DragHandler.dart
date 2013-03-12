
part of physics_after_dart;

class DragHandler {
  
  vec2 _destionationPos;
  
  vec2 relativeDistanceFromObjectCenter;
  
  DynamicBox _activeObject;
  
  vec2 _mousePosStart;
    
  bool _active = false;
  
  bool rotateLeft = false;
  bool rotateRight = false;
  bool rotateToDefault = false;
  
  void activate(vec2 mousePosStart, DynamicBox obj) {
    this._active = true;
//    if (?obj) {
    this._activeObject = obj;
//    }
    
    this._mousePosStart = mousePosStart;
  }

  void deactivate() {
    this._active = false;
  }

  bool isActive() {
    return this._active;
  }
  
  DynamicBox getActiveObject() {
    if (this.isActive()) {
      return this._activeObject; 
    } else {
      return null;
    }
  }
  
  void setStartPos(vec2 newStartPos) {
    this._mousePosStart = newStartPos;
  }
  
  void setDestination(vec2 point) {
    this._destionationPos = point;
  }
  
  vec2 getCorrectedDestination() {
    return new vec2(this._destionationPos.x - this.relativeDistanceFromObjectCenter.x,
                      this._destionationPos.y - this.relativeDistanceFromObjectCenter.y);
  }
  
  double distanceFromStart(vec2 point) {
    return distance(this._mousePosStart, point);
  }
  
  double distanceFromStartAndUpdate(vec2 point) {
    double dist = distance(this._mousePosStart, point);
    this.setStartPos(point);
    return dist;
  }
    
  double objectDistanceToDestination() {
    if (this.isActive()) {
      return distance(this._activeObject.body.position, this._destionationPos);
    } else {
      return 0.0;
    } 
  }
}

