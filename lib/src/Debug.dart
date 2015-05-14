part of physics_after_dart;

class Debug {
  static bool showShadows = true;
  static bool showTextures = true;
  static bool _showWindow = false;

  DivElement debugElm;
  DivElement debugTimingElm;
  DivElement debugTexturesButtonElm;
  DivElement debugShadowsButtonElm;

  int stepElapsedUs = 0;
  int dynamicDrawElapsedUs = 0;
  int staticDrawElapsedUs = 0;
  int shadowElapsedUs = 0;
  int endSolverElapsedUs = 0;

  // Frame count for fps
  int thisSecondframeCount = 0;
  int lastSecondframeCount = 0;

  // For timing the world.step call. It is kept running but reset and polled
  // every frame to minimize overhead.
  Stopwatch physicsStopwatch;
  Stopwatch dynamicDrawStopwatch;
  Stopwatch staticDrawStopwatch;
  Stopwatch shadowsStopwatch;
  Stopwatch endSolverStopwatch;

  Future updateInterval;
  Future fpsInterval;

  Debug() {
    this.debugElm = querySelector("#debug");
    this.debugTimingElm = querySelector("#debug_timing");
    this.debugTexturesButtonElm = querySelector("#debug_textures_button");
    this.debugShadowsButtonElm = querySelector("#debug_shadows_button");

    this.physicsStopwatch = new Stopwatch();
    this.dynamicDrawStopwatch = new Stopwatch();
    this.staticDrawStopwatch = new Stopwatch();
    this.shadowsStopwatch = new Stopwatch();
    this.endSolverStopwatch = new Stopwatch();

    debugTexturesButtonElm.onClick.listen((e) {
      Debug.showTextures = !Debug.showTextures;
      this._updateWindow();
    });

    debugShadowsButtonElm.onClick.listen((e) {
      Debug.showShadows = !Debug.showShadows;
      this._updateWindow();
    });

    this._updateWindow();
    this._updateFPSCounter();
  }

  void showDebugWindow() {
    this.physicsStopwatch.start();
    this.dynamicDrawStopwatch.start();
    this.staticDrawStopwatch.start();
    this.shadowsStopwatch.start();
    this.endSolverStopwatch.start();

    Debug._showWindow = true;

    // var future = new Future.delayed(const Duration(milliseconds: 10), doStuffCallback);
//    this.updateInterval = new Future.delayed(const Duration(seconds: 1), () {
//      this.lastSecondframeCount = thisSecondframeCount;
//      this.thisSecondframeCount = 0;
//    });

    // this.fpsInterval = window.setInterval(() {
//    this.fpsInterval = new Future.delayed(const Duration(milliseconds: 200), () {
//      this._updateWindow();
//      this.fpsInterval.
//    });

    // @TODO: Fix, stop timers with newer Dart SDK
    // this._updateWindow();

    this.debugElm.style.display = "block";
  }

  void hideDebugWindow() {
    this.physicsStopwatch.stop();
    this.shadowsStopwatch.stop();
    this.endSolverStopwatch.stop();
    this.dynamicDrawStopwatch.stop();
    this.staticDrawStopwatch.stop();

    Debug._showWindow = false;
    this.debugElm.style.display = "none";
//    window.clearInterval(this.updateInterval);
//    window.clearInterval(this.fpsInterval);
  }

  static bool isEnabled() {
    return Debug._showWindow;
  }

  void _updateWindow() {
    String str = """fps: $lastSecondframeCount<br>
        physics: ${stepElapsedUs / 1000} ms<br>
        shadow: ${shadowElapsedUs / 1000} ms<br>
        dyn.draw: ${dynamicDrawElapsedUs / 1000} ms<br>
        st.draw: ${staticDrawElapsedUs / 1000} ms<br>
        end: ${endSolverElapsedUs / 1000} ms<br> 
        total: ${(stepElapsedUs + shadowElapsedUs + dynamicDrawElapsedUs + staticDrawElapsedUs + endSolverElapsedUs) / 1000} ms""";
    this.debugTimingElm.innerHtml = str;

    this.debugTexturesButtonElm.text =
        "textures: ${Debug.showTextures ? 'on' : 'off'}";
    this.debugShadowsButtonElm.text =
        "shadows: ${Debug.showShadows ? 'on' : 'off'}";

//    this.updateInterval = new Future.delayed(const Duration(seconds: 1), () {
//    this.fpsInterval = new Future.delayed(const Duration(milliseconds: 200), this._updateWindow);
  }

  void _updateFPSCounter() {
    this.lastSecondframeCount = thisSecondframeCount;
    this.thisSecondframeCount = 0;

//    this.updateInterval = new Future.delayed(const Duration(seconds: 1), this._updateFPSCounter);
  }
}
