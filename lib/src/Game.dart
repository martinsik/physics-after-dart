part of physics_after_dart;


class Game {
  
  static const double GRAVITY = -50.0;
  static const num TIME_STEP = 1/60;
  static const int VELOCITY_ITERATIONS = 10;
  static const int POSITION_ITERATIONS = 10;
  static const double VIEWPORT_SCALE = 10.0;
  static const int MOVE_VELOCITY = 5;
  static const int CRITTER_SPAWN_RADIUS = 6;
  static const int CANVAS_WIDTH = 1000;
  static const int CANVAS_HEIGHT = 700;
  static const double DEGRE_TO_RADIAN = 0.0174532925;
  static const int WORLD_POOL_SIZE = 100;
  static const int WORLD_POOL_CONTAINER_SIZE = 10;

  // view transformation from physics world coordinates to canvas
  static ViewportTransform viewport;

  static Vector2 canvasCenter;
  static Vector2 canvasOffset;
  
  // All of the bodies in a simulation.
  List<GameObject> grounds;
  List<GameObject> dynamicObjects;
  List<Critter> critters;
  
  int canvasFpsCounter = 0;
  double canvasWorldStepTime = 0.0;
  
  // The debug drawing tool.
  DebugDraw debugDraw;

  // The physics world.
  World world;

  // The drawing canvas.
  CanvasElement canvas;
  CanvasElement shadowCanvas;
  
  DivElement mainButtonElm;
  DivElement wrapperElm;
  DivElement progressElm;
  DivElement doneElm;
  
  // The canvas rendering context.
  CanvasRenderingContext2D ctx;
  
  math.Random randomGenerator;

//  double groundHeight = 2.0;
  double groundLevel = 0.0;
  
  Debug debug;
  
  // The transform abstraction layer between the world and drawing canvas.
//  IViewportTransform viewport;
  
  LightEngine lightEngine;
  
  GameEventHandlers eventHandler;
  
  Vector2 sun;
  
  EndSolver endSolver;
  
  double groundHeight = 1.0;
  
  Map level;
  
  bool running = false;
  
  List<String> quotes = [ 'nice job!', 'congratulations!', 'done!', 'great job!' ];
  
  
  void init() {
//    print(window.screen.width);
//    print(window.screen.height);
    
    
    this.eventHandler = new GameEventHandlers(this);
    
//    fpsCounter = query("#fps-counter");
//    worldStepTimeCounter = query("#step-time-counter");
    
    // init HTML elements
    this.canvas = querySelector("#main_canvas");
    this.shadowCanvas = querySelector("#shadow_canvas");
    this.mainButtonElm = querySelector("#start_critters");
    this.wrapperElm = querySelector("#wrapper");
    this.progressElm = querySelector("#level_progess");
    this.doneElm = querySelector("#done");
    
    this.debug = new Debug();
    
    this.ctx = canvas.getContext("2d");
    resizeCanvas();
    
    this.loadLevel(0);
    
    this._initListeners();

    // Create the viewport transform with the center at extents.
    final extents = new Vector2(this.canvas.width / 2, this.canvas.height / 2);
    viewport = new CanvasViewportTransform(extents, extents);
    viewport.scale = VIEWPORT_SCALE;
    
    // Create our canvas drawing tool to give to the world.
    debugDraw = new CanvasDraw(viewport, ctx);

    // Have the world draw itself for debugging purposes.
    world.debugDraw = debugDraw;
        
//    Body ground;
//    ground = world.createBody(bd);
    
  }
  
  void loadLevel([int level]) {
    if (level == null) {
      level = 0;
    }
    
    this.resetUI();
    
    // create physics world
    Vector2 gravity = new Vector2(0.0, GRAVITY);
    this.world = new World.withPool(gravity, new DefaultWorldPool(WORLD_POOL_SIZE, WORLD_POOL_CONTAINER_SIZE));
    
    this.running = false;
    this.doneElm.style.display = "none";
    this.progressElm.hidden = true;
    
    this.grounds = new List<GameObject>();
    this.dynamicObjects = new List<GameObject>();
    this.critters = new List<Critter>(); 
    
    this.groundLevel = -Game.canvasCenter.y / Game.VIEWPORT_SCALE;
//    this._createGround(groundHeight);
    
    this.lightEngine = new LightEngine(querySelector("#shadow_canvas"), this.ctx, this.groundLevel + groundHeight);

    this.level = Levels.getLevel(level);
    
    this.sun = new Vector2(this.level['sun_x'], Game.canvasCenter.y / Game.VIEWPORT_SCALE);
    this.lightEngine.add(this.sun);
    
    this._createBoxes(this.level['boxes']);
    this._createGround(this.groundHeight, this.level['grounds']);
    this.wrapperElm.style.backgroundImage = "url(./images/${this.level['background']})";
    double aspect = this.canvas.height / 1000.0;
    this.wrapperElm.style.backgroundSize = "${aspect * 1500}px ${aspect * 1000}px";
    
    // add start and end triangles
//    List points = level['start'];
    List<Vector2> endVectorPoints = new List<Vector2>();
    for (List point in this.level['end']) {
      endVectorPoints.add(new Vector2(point[0], point[1]));
    }

    this.endSolver = new EndSolver(endVectorPoints,
        new Vector2(this.level['critters']['spawn_point'][0], this.level['critters']['spawn_point'][1]),
        this.critters, this);
    
    this.randomGenerator = new math.Random(this.level['critters']['seed']);
    
//    print(Levels.getLevel(0));
  }
  
  void _initListeners() {
    
    this.shadowCanvas.onMouseDown.listen((e) {
      eventHandler.onMouseDown(e);
    });
    
    this.shadowCanvas.onMouseUp.listen((e) {
      eventHandler.onMouseUp(e);
    });

    this.shadowCanvas.onMouseMove.listen((e) {
      if (!running) {
        eventHandler.onMouseMove(e);
      }
    });
    
    window.onKeyDown.listen((e) {
      if (this.eventHandler.dragHandler.isActive()) {
        if (e.keyCode == 37) { // left arrow
          this.eventHandler.dragHandler.rotateLeft = true;
        } else if (e.keyCode == 39) { // right arrow
          this.eventHandler.dragHandler.rotateRight = true;
        } else if (e.keyCode == 32) { // space
          // @TODO: rotate to default position
        }
      }
      
      if (e.keyCode == 68) {
        if (Debug.isEnabled()) {
          this.debug.hideDebugWindow();
        } else {
          this.debug.showDebugWindow();
        }
//        Debug.showWindow = !Debug.showWindow;
        
      }
//      print(e.keyCode);
    });

    window.onKeyUp.listen((e) {
      if (this.eventHandler.dragHandler.isActive()) {
        if (e.keyCode == 37) { // left arrow
          this.eventHandler.dragHandler.rotateLeft = false;
        } else if (e.keyCode == 39) { // right arrow
          this.eventHandler.dragHandler.rotateRight = false;
        } else if (e.keyCode == 32) { // space
          // @TODO: rotate to default position
        }
        
        this.eventHandler.dragHandler.getActiveObject().body.angularVelocity = 0.0;
      }
    });

    window.onResize.listen((e) {
      resizeCanvas();
    });
    
    // bind start button click
    this.mainButtonElm.onClick.listen((e) {
      if (running) {
        this.stopCritters();
        this.resetUI();
      } else {
        this.startCritters();
        this.mainButtonElm.text = 'stop';
        this.progressElm.style.display = "block";
        this.updateProgressElm();
      }
    });
    
    document.querySelector('#play_again').onClick.listen((e) {
      this.loadLevel(level['id']);
    });
    
    for (DivElement elm in document.querySelectorAll('.level')) {
      elm.onClick.listen((e) {
        DivElement elm = e.target;
        loadLevel(int.parse(elm.text) - 1);
      });
    }
    
    // debug
//    this.debugTexturesButtonElm.onClick.listen((e) {
//      this.progressElm.style.display = "none";
//    });
  }
  
  void resetUI() {
    this.mainButtonElm.text = 'start';
    this.progressElm.style.display = "none";
  }
  
  void _createGround(double height, List moreGrounds) {
    StaticBox ground;
    ground = new StaticBox(new Vector2(50.0, height / 2), new Vector2(0.0, this.groundLevel + height / 2));
    ground.addObjectToWorld(this.world);
    this.grounds.add(ground);
    
    ground = new StaticBox(new Vector2(50.0, 1.0), new Vector2(0.0, Game.canvasCenter.y / Game.VIEWPORT_SCALE));
    ground.addObjectToWorld(this.world);
    this.grounds.add(ground);

    ground = new StaticBox(new Vector2(1.0, (Game.canvasCenter.y * 2) / Game.VIEWPORT_SCALE), new Vector2(Game.canvasCenter.x / Game.VIEWPORT_SCALE, 0.0));
    ground.addObjectToWorld(this.world);
    this.grounds.add(ground);

    ground = new StaticBox(new Vector2(1.0, (Game.canvasCenter.y * 2) / Game.VIEWPORT_SCALE), new Vector2(-Game.canvasCenter.x / Game.VIEWPORT_SCALE, 0.0));
    ground.addObjectToWorld(this.world);
    this.grounds.add(ground);
    
    for (List groundDefinition in moreGrounds) { 
      ground = new StaticBox(new Vector2(groundDefinition[2], groundDefinition[3]),
                             new Vector2(groundDefinition[0], groundDefinition[1]),
                             groundDefinition[4]);
      ground.addObjectToWorld(this.world);
      this.grounds.add(ground);
      this.dynamicObjects.add(ground);
    }
    
  }
  
  void _createBoxes(List boxes) {
    DynamicBox box;
    
    for (List boxDefinition in boxes) {
      
//      double test = boxDefinition[4];
      
      box = new DynamicBox(new Vector2(boxDefinition[2], boxDefinition[3]),
                           new Vector2(boxDefinition[0], boxDefinition[1]),
                           boxDefinition[5], boxDefinition[6], boxDefinition[4]);
      box.addObjectToWorld(this.world);
      box.setTexture("./images/${boxDefinition[7]}");
      
      this.dynamicObjects.add(box);
    }
        
  }
  

  void resizeCanvas() {
//    print('resize: [${window.innerWidth}, ${window.innerHeight}]');
//    int height = window.innerHeight > 706 ? 706 : ;
//    int height = 700;
//    int width = 1000;
    this.canvas.width = CANVAS_WIDTH;
    this.canvas.height = CANVAS_HEIGHT;
//    this.shadowCanvas.width = CANVAS_WIDTH;
//    this.shadowCanvas.height = CANVAS_HEIGHT;
    this.shadowCanvas.width = CANVAS_WIDTH ~/ 2; // ~/ integer division
    this.shadowCanvas.height = CANVAS_HEIGHT ~/ 2;
    this.wrapperElm.style.width = "${CANVAS_WIDTH}px";
    this.wrapperElm.style.height = "${CANVAS_HEIGHT}px";
    
    Game.canvasCenter = new Vector2(CANVAS_WIDTH / 2, CANVAS_HEIGHT / 2);
    Game.canvasOffset = new Vector2((window.innerWidth - CANVAS_WIDTH) / 2, (window.innerHeight - CANVAS_HEIGHT) / 2);
    
    this.wrapperElm.style.top = "${canvasOffset.y}px";
    this.wrapperElm.style.left = "${canvasOffset.x}px";
    
  }
  
  void startCritters() {
    this.running = true;
    
    Map crittersSettings = this.level['critters'];
    Vector2 spawnPoint = new Vector2(crittersSettings['spawn_point'][0], crittersSettings['spawn_point'][1]);
    
    for (int i=0; i < crittersSettings['count']; i++) {
      Vector2 randomPosition = new Vector2.copy(spawnPoint);
      randomPosition.x = randomPosition.x + this.randomGenerator.nextDouble() * CRITTER_SPAWN_RADIUS;
      randomPosition.y = randomPosition.y + this.randomGenerator.nextDouble() * CRITTER_SPAWN_RADIUS;
      
      Critter critter = new Critter(2.0, randomPosition);
      critter.addObjectToWorld(this.world);
      
      this.dynamicObjects.add(critter);
      this.critters.add(critter);
    }
  }
  
  void stopCritters() {
    this.running = false;
    for (Critter c in this.critters) {
      this.world.destroyBody(c.body);
      this.dynamicObjects.remove(c);
    }
    this.critters.clear();
  }
  
  /** Advances the world forward by timestep seconds. */
  void _step(num timestamp) {
    if (Debug.isEnabled()) {
      this.debug.physicsStopwatch.reset();
    }
    
    world.stepDt(TIME_STEP, VELOCITY_ITERATIONS, POSITION_ITERATIONS);
    
    if (Debug.isEnabled()) {
      this.debug.stepElapsedUs = this.debug.physicsStopwatch.elapsedMicroseconds;
    }

    // am I draging something?
    if (this.eventHandler.dragHandler.isActive()) {
//      double dist = this.eventHandler.dragHandler.objectDistanceToDestination();
      GameObject obj = this.eventHandler.dragHandler.getActiveObject(); 
      Vector2 diffVector = new Vector2.copy(this.eventHandler.dragHandler.getCorrectedDestination());
      diffVector.sub(obj.body.position);
      
      obj.body.linearVelocity = new Vector2(diffVector.x * Game.MOVE_VELOCITY, diffVector.y * Game.MOVE_VELOCITY);
      
      if (this.eventHandler.dragHandler.rotateLeft) {
        obj.body.angularVelocity = 1.5;
      } else if (this.eventHandler.dragHandler.rotateRight) {
        obj.body.angularVelocity = -1.5;
      } else {
        obj.body.angularVelocity = obj.body.angularVelocity / 1.05;
      }
      
    }
    
    window.requestAnimationFrame((num time) {
      _step(time);
      _draw();
      
      if (Debug.isEnabled()) {
        this.debug.endSolverStopwatch.reset();
      }
      this.endSolver.check();
      if (Debug.isEnabled()) {
        this.debug.endSolverElapsedUs = this.debug.endSolverStopwatch.elapsedMicroseconds;
      }

//      print('bodies: ${bodies.length}');
//      print('bodies[1]: [${bodies[1].linearVelocity.x}, ${bodies[1].linearVelocity.y}]');
    });
  }
  
  void _draw() {
    // Clear the animation panel and draw new frame.
//    ctx.fillStyle = "#fff";
//    ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    this.canvas.width = this.canvas.width;
    
    // draw debug rectangles
    if (Debug.showTextures) {
      // draw sun
      Vector2 sunPos = new Vector2(this.sun.x, this.sun.y);
      Game.convertWorldToCanvas(sunPos);
      this.ctx.beginPath();
      this.ctx.arc(sunPos.x, 3, 10, 0, 2 * math.PI, false);
      this.ctx.lineWidth = 15;
      this.ctx.strokeStyle = '#fff';
      this.ctx.stroke();
      this.ctx.closePath();
  
      if (Debug.isEnabled()) {
        this.debug.staticDrawStopwatch.reset();
      }
      for (StaticBox ground in this.grounds) {
        ground.draw(this.ctx);
      }
      this.endSolver.draw(this.ctx);
      
      if (Debug.isEnabled()) {
        this.debug.staticDrawElapsedUs = this.debug.staticDrawStopwatch.elapsedMicroseconds;
      }
    } else {
      world.drawDebugData();
    }
    

    
    // can't remove critter from list inside iteration (Dart's feature)
    Critter removeMe;
    bool itemToRemove = false;
    
    // draw dnamic objects
    if (Debug.isEnabled()) {
      this.debug.dynamicDrawStopwatch.reset();
    }
    for (GameObject object in this.dynamicObjects) {
      if (Debug.showTextures) {
        object.draw(this.ctx);
      }
      
      if (object is Critter) {
        if (object.opacity < 0.05) {
          world.destroyBody(object.body);
          removeMe = object;
          itemToRemove = true;
        }
      }
    }
    if (itemToRemove) {
      dynamicObjects.remove(removeMe);
      critters.remove(removeMe);
      this.updateProgressElm();
      this.handleDone();
    }
    
//    if (Debug.showShadows) {
      if (Debug.isEnabled()) {
        this.debug.dynamicDrawElapsedUs = this.debug.dynamicDrawStopwatch.elapsedMicroseconds;
        this.debug.shadowsStopwatch.reset();
      }
      // draw shadowns
      this.lightEngine.draw(this.dynamicObjects);
      if (Debug.isEnabled()) {
        this.debug.shadowElapsedUs = this.debug.shadowsStopwatch.elapsedMicroseconds;
        this.debug.thisSecondframeCount++;
      }
//    }
  }
  
  void updateProgressElm() {
    int crittersPassed = this.level['critters']['count'] - this.critters.length;
    this.progressElm.text = "${crittersPassed}/${this.level['critters']['count']}";
  }
  
  void handleDone() {
    if (this.critters.length == 0) {
      this.quotes = Common.shuffle(this.quotes);
      document.querySelector('#stripe h2').text = this.quotes[0];
      this.doneElm.style.display = "block";
    }
  }
  
//  void _drawDebugInfo() {
//    this.ctx.fillStyle = '#ddd';
//    this.ctx.font = '12px courier';
//    this.ctx.textBaseline = 'bottom';
//    this.ctx.fillText("fps: ${this.canvasFpsCounter}, physics step: ${this.canvasWorldStepTime} ms", 5, 20);
//  }
  
  static Vector2 convertCanvasToWorld(Vector2 canvasVectorOrPoint) {
    return new Vector2((canvasVectorOrPoint.x - Game.canvasCenter.x) / Game.VIEWPORT_SCALE,
                      (Game.canvasCenter.y - canvasVectorOrPoint.y) / Game.VIEWPORT_SCALE);
  }

  static void convertWorldToCanvas(Vector2 worldVectorOrPoint) {
    worldVectorOrPoint.x = worldVectorOrPoint.x * Game.VIEWPORT_SCALE + Game.canvasCenter.x;
    worldVectorOrPoint.y = -worldVectorOrPoint.y * Game.VIEWPORT_SCALE + Game.canvasCenter.y;
  }
  
  /**
   * Starts running the demo as an animation using an animation scheduler.
   */
  void run() {
//    this.stopwatch.start();
    window.requestAnimationFrame((num time) { _step(time); });
  }
  
}

