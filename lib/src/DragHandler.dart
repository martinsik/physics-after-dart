
part of physics_after_dart;

class DragHandler {
  
  Vector2 _destionationPos;
  
  Vector2 relativeDistanceFromObjectCenter;
  
  DynamicBox _activeObject;
  
  Vector2 _mousePosStart;
    
  bool _active = false;
  
  bool rotateLeft = false;
  bool rotateRight = false;
  bool rotateToDefault = false;
  
  void activate(Vector2 mousePosStart, DynamicBox obj) {
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
  
  void setStartPos(Vector2 newStartPos) {
    this._mousePosStart = newStartPos;
  }
  
  void setDestination(Vector2 point) {
    this._destionationPos = point;
  }
  
  Vector2 getCorrectedDestination() {
    return new Vector2(this._destionationPos.x - this.relativeDistanceFromObjectCenter.x,
                      this._destionationPos.y - this.relativeDistanceFromObjectCenter.y);
  }
  
  double distanceFromStart(Vector2 point) {
    return distance(this._mousePosStart, point);
  }
  
  double distanceFromStartAndUpdate(Vector2 point) {
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

