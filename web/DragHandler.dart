
part of droidtowers;

class DragHandler {
  
  Vector _destionationPos;
  
  Vector relativeDistanceFromObjectCenter;
  
  DynamicBox _activeObject;
  
  Vector _mousePosStart;
    
  bool _active = false;
  
  bool rotateLeft = false;
  bool rotateRight = false;
  bool rotateToDefault = false;
  
  void activate(Vector mousePosStart, DynamicBox obj) {
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
  
  void setStartPos(Vector newStartPos) {
    this._mousePosStart = newStartPos;
  }
  
  void setDestination(Vector point) {
    this._destionationPos = point;
  }
  
  Vector getCorrectedDestination() {
    return new Vector(this._destionationPos.x - this.relativeDistanceFromObjectCenter.x,
                      this._destionationPos.y - this.relativeDistanceFromObjectCenter.y);
  }
  
  double distanceFromStart(Vector point) {
    return this._mousePosStart.distanceBetween(point);
  }
  
  double distanceFromStartAndUpdate(Vector point) {
    double dist = this._mousePosStart.distanceBetween(point);
    this.setStartPos(point);
    return dist;
  }
    
  double objectDistanceToDestination() {
    if (this.isActive()) {
      return this._activeObject.body.position.distanceBetween(this._destionationPos);
    } else {
      return 0.0;
    } 
  }
}

