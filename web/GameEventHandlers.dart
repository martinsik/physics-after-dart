
part of droidtowers;

class GameEventHandlers {
  
  DragHandler dragHandler;
  Game game;

  GameEventHandlers(Game game) :
    this.dragHandler = new DragHandler(),
    this.game = game;
  
  void onMouseDown(MouseEvent e) {
//      Vector pointClicked = new Vector((e.clientX - Game.canvasCenter.x) / Game.VIEWPORT_SCALE, (Game.canvasCenter.y - e.clientY) / Game.VIEWPORT_SCALE);
    Vector pointClicked = Game.convertCanvasToWorld(new Vector(e.clientX, e.clientY));
    this.dragHandler.deactivate();
    
    for (GameObject o in game.dynamicObjects) {
      if (o is! DynamicBox) {
        continue;
      }
      if (o.hovered) {
        o.highlight = true;
//          Vector destPoint = new Vector();
        
        this.dragHandler.activate(pointClicked, o);
        this.dragHandler.setDestination(pointClicked);
        
        Vector diffFromObjectCenter = new Vector.copy(pointClicked);
        diffFromObjectCenter.subLocal(o.body.position);
        this.dragHandler.relativeDistanceFromObjectCenter = diffFromObjectCenter;
//          print("tag: ${o.tag}");
        break;
      }
    }
  }
  
  void onMouseUp(MouseEvent e) {
    if (this.dragHandler.isActive()) {
      this.dragHandler.getActiveObject().highlight = false;
      this.dragHandler.deactivate();
    }
  }

  void onMouseMove(MouseEvent e) {
    for (GameObject o in game.dynamicObjects) {
      o.hovered = false;
    }
    ClickedFixture callback = new ClickedFixture();
    Vector mousePos = Game.convertCanvasToWorld(new Vector(e.clientX, e.clientY));
//      callback.mousePos = new Vector((e.clientX - Game.canvasCenter.x) / Game.VIEWPORT_SCALE, (Game.canvasCenter.y - e.clientY) / Game.VIEWPORT_SCALE);
    callback.mousePos = mousePos;
    
    AxisAlignedBox aabb = new AxisAlignedBox(mousePos, mousePos);
    game.world.queryAABB(callback, aabb);
    
    if (this.dragHandler.isActive()) {
      this.dragHandler.setDestination(mousePos);
//        double distance = mouseDragHandler.distanceFromStartAndUpdate(mousePos);
//        print("distance: $distance");
    }
  }
  
}

