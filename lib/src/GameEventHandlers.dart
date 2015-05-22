part of physics_after_dart;

class GameEventHandlers {
  DragHandler dragHandler;
  Game game;

  GameEventHandlers(Game game)
      : this.dragHandler = new DragHandler(),
        this.game = game;

  void onObjectGrab(int x, int y) {
    double scale = (Game.CANVAS_WIDTH / game.canvas.offsetWidth);

    Vector2 canvasPos =
        new Vector2(x - Game.canvasOffset.x, y - Game.canvasOffset.y);
    Vector2 pointClicked = Game.convertCanvasToWorld(canvasPos * scale);
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

        Vector2 diffFromObjectCenter = new Vector2.copy(pointClicked);
        diffFromObjectCenter.sub(o.body.position);
        this.dragHandler.relativeDistanceFromObjectCenter =
            diffFromObjectCenter;
//          print("tag: ${o.tag}");
        break;
      }
    }
  }

//  void
//
//  void onMouseDown(MouseEvent e) => onObjectDrag(e.client.x, e.client.y);

  void onObjectReleased() {
    if (this.dragHandler.isActive()) {
      this.dragHandler.getActiveObject().highlight = false;
      this.dragHandler.deactivate();
    }
  }

  void onMouseMove(int x, int y) {
    for (GameObject o in game.dynamicObjects) {
      o.hovered = false;
    }
//    print(e.client.x, e.client.y);

    ClickedFixture callback = new ClickedFixture();
    double scale = (Game.CANVAS_WIDTH / game.canvas.offsetWidth);

    Vector2 canvasPos =
        new Vector2(x - Game.canvasOffset.x, y - Game.canvasOffset.y);

    Vector2 worldPos = Game.convertCanvasToWorld(canvasPos * scale);

//    print("Center: ${Game.canvasCenter.toString()}");
//    print("${canvasPos.toString()}, ${worldPos.toString()}");

    callback.mousePos = worldPos;

    var aabb = new AABB.withVec2(worldPos, worldPos);
    game.world.queryAABB(callback, aabb);

    if (this.dragHandler.isActive()) {
      this.dragHandler.setDestination(worldPos);
//        double distance = mouseDragHandler.distanceFromStartAndUpdate(mousePos);
//        print("distance: $distance");
    }
  }
}
