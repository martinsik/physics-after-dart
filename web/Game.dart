library physics_after_dart;

import 'dart:html';
import 'dart:math' as Math;
import 'dart:json' as json;
import 'dart:async';
import 'package:box2d/box2d_browser.dart';

part 'GameObject.dart';
part 'BasicBoxObject.dart';
part 'StaticBox.dart';
part 'DynamicBox.dart';
part 'Color.dart';
part 'ClickedFixture.dart';
part 'DragHandler.dart';
part 'LightEngine.dart';
part 'GameEventHandlers.dart';
part 'Levels.dart';
part 'Circle.dart';
part 'Critter.dart';
part 'EndSolver.dart';
part 'Common.dart';
part 'Debug.dart';


class Game {
  
  static const num GRAVITY = -50;
  static const num TIME_STEP = 1/60;
  static const int VELOCITY_ITERATIONS = 10;
  static const int POSITION_ITERATIONS = 15;
  static const int VIEWPORT_SCALE = 10;
  static const int MOVE_VELOCITY = 5;
  static const int CRITTER_SPAWN_RADIUS = 6;
  static const int CANVAS_WIDTH = 1000;
  static const int CANVAS_HEIGHT = 700;
  static const double DEGRE_TO_RADIAN = 0.0174532925;

  // view transformation from physics world coordinates to canvas
  static ViewportTransform viewport;

  static vec2 canvasCenter;
  static vec2 canvasOffset;
  
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
  
  Math.Random randomGenerator;

//  double groundHeight = 2.0;
  double groundLevel = 0.0;
  
  Debug debug;
  
  // The transform abstraction layer between the world and drawing canvas.
//  IViewportTransform viewport;
  
  LightEngine lightEngine;
  
  GameEventHandlers eventHandler;
  
  vec2 sun;
  
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
    this.canvas = query("#main_canvas");
    this.shadowCanvas = query("#shadow_canvas");
    this.mainButtonElm = query("#start_critters");
    this.wrapperElm = query("#wrapper");
    this.progressElm = query("#level_progess");
    this.doneElm = query("#done");
    
    this.debug = new Debug();
    
    this.ctx = canvas.getContext("2d");
    resizeCanvas();
    
    this.loadLevel(0);
    
    this._initListeners();

    // Create the viewport transform with the center at extents.
    final extents = new vec2(this.canvas.width / 2, this.canvas.height / 2);
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
    if (!?level) {
      level = 0;
    }
    
    this.resetUI();
    
    // create physics world
    vec2 gravity = new vec2(0, GRAVITY);
    this.world = new World(gravity, true, new DefaultWorldPool());
    
    this.running = false;
    this.doneElm.style.display = "none";
    this.progressElm.hidden = true;
    
    this.grounds = new List<GameObject>();
    this.dynamicObjects = new List<GameObject>();
    this.critters = new List<Critter>(); 
    
    this.groundLevel = -Game.canvasCenter.y / Game.VIEWPORT_SCALE;
//    this._createGround(groundHeight);
    
    this.lightEngine = new LightEngine(query("#shadow_canvas"), this.ctx, this.groundLevel + groundHeight);

    this.level = Levels.getLevel(level);
    
    this.sun = new vec2(this.level['sun_x'], Game.canvasCenter.y / Game.VIEWPORT_SCALE);
    this.lightEngine.add(this.sun);
    
    this._createBoxes(this.level['boxes']);
    this._createGround(this.groundHeight, this.level['grounds']);
    this.wrapperElm.style.backgroundImage = "url(./images/${this.level['background']})";
    double aspect = this.canvas.height / 1000.0;
    this.wrapperElm.style.backgroundSize = "${aspect * 1500}px ${aspect * 1000}px";
    
    // add start and end triangles
//    List points = level['start'];
    List<vec2> endVectorPoints = new List<vec2>();
    for (List point in this.level['end']) {
      endVectorPoints.add(new vec2(point[0], point[1]));
    }

    this.endSolver = new EndSolver(endVectorPoints,
        new vec2(this.level['critters']['spawn_point'][0], this.level['critters']['spawn_point'][1]),
        this.critters, this);
    
    this.randomGenerator = new Math.Random(this.level['critters']['seed']);
    
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
    
    document.query('#play_again').onClick.listen((e) {
      this.loadLevel(level['id']);
    });
    
    for (DivElement elm in document.queryAll('.level')) {
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
    ground = new StaticBox(new vec2(50.0, height / 2), new vec2(0.0, this.groundLevel + height / 2));
    ground.addObjectToWorld(this.world);
    this.grounds.add(ground);
    
    ground = new StaticBox(new vec2(50.0, 1.0), new vec2(0.0, Game.canvasCenter.y / Game.VIEWPORT_SCALE));
    ground.addObjectToWorld(this.world);
    this.grounds.add(ground);

    ground = new StaticBox(new vec2(1.0, (Game.canvasCenter.y * 2) / Game.VIEWPORT_SCALE), new vec2(Game.canvasCenter.x / Game.VIEWPORT_SCALE, 0));
    ground.addObjectToWorld(this.world);
    this.grounds.add(ground);

    ground = new StaticBox(new vec2(1.0, (Game.canvasCenter.y * 2) / Game.VIEWPORT_SCALE), new vec2(-Game.canvasCenter.x / Game.VIEWPORT_SCALE, 0));
    ground.addObjectToWorld(this.world);
    this.grounds.add(ground);
    
    for (List groundDefinition in moreGrounds) { 
      ground = new StaticBox(new vec2(groundDefinition[2], groundDefinition[3]),
                             new vec2(groundDefinition[0], groundDefinition[1]),
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
      
      box = new DynamicBox(new vec2(boxDefinition[2], boxDefinition[3]),
                           new vec2(boxDefinition[0], boxDefinition[1]),
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
    
    Game.canvasCenter = new vec2(CANVAS_WIDTH / 2, CANVAS_HEIGHT / 2);
    Game.canvasOffset = new vec2((window.innerWidth - CANVAS_WIDTH) / 2, (window.innerHeight - CANVAS_HEIGHT) / 2);
    
    this.wrapperElm.style.top = "${canvasOffset.y}px";
    this.wrapperElm.style.left = "${canvasOffset.x}px";
    
  }
  
  void startCritters() {
    this.running = true;
    
    Map crittersSettings = this.level['critters'];
    vec2 spawnPoint = new vec2(crittersSettings['spawn_point'][0], crittersSettings['spawn_point'][1]);
    
    for (int i=0; i < crittersSettings['count']; i++) {
      vec2 randomPosition = new vec2.copy(spawnPoint);
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
    
    world.step(TIME_STEP, VELOCITY_ITERATIONS, POSITION_ITERATIONS);
    
    if (Debug.isEnabled()) {
      this.debug.stepElapsedUs = this.debug.physicsStopwatch.elapsedMicroseconds;
    }

    // am I draging something?
    if (this.eventHandler.dragHandler.isActive()) {
      double dist = this.eventHandler.dragHandler.objectDistanceToDestination();
      GameObject obj = this.eventHandler.dragHandler.getActiveObject(); 
      vec2 diffVector = new vec2.copy(this.eventHandler.dragHandler.getCorrectedDestination());
      diffVector.sub(obj.body.position);
      
      obj.body.linearVelocity = new vec2(diffVector.x * Game.MOVE_VELOCITY, diffVector.y * Game.MOVE_VELOCITY);
      
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
      vec2 sunPos = new vec2(this.sun.x, this.sun.y);
      Game.convertWorldToCanvas(sunPos);
      this.ctx.beginPath();
      this.ctx.arc(sunPos.x, 3, 10, 0, 2 * Math.PI, false);
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
      document.query('#stripe h2').text = this.quotes[0];
      this.doneElm.style.display = "block";
    }
  }
  
//  void _drawDebugInfo() {
//    this.ctx.fillStyle = '#ddd';
//    this.ctx.font = '12px courier';
//    this.ctx.textBaseline = 'bottom';
//    this.ctx.fillText("fps: ${this.canvasFpsCounter}, physics step: ${this.canvasWorldStepTime} ms", 5, 20);
//  }
  
  static vec2 convertCanvasToWorld(vec2 canvasVectorOrPoint) {
    return new vec2((canvasVectorOrPoint.x - Game.canvasCenter.x) / Game.VIEWPORT_SCALE,
                      (Game.canvasCenter.y - canvasVectorOrPoint.y) / Game.VIEWPORT_SCALE);
  }

  static void convertWorldToCanvas(vec2 worldVectorOrPoint) {
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

void main() {
  final game = new Game();
  game.init();
  game.run();
}
