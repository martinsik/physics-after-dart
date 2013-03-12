Physics After Dart
=================

This game is my Geeva Hackathon 2013 project in [Dart] [0] and [dartbox2d] [1]. 

It's a simple puzzle game based of physics. I managed to make only 3 levels during the hackathon and your goal is to help 3 or 5 balls to get to the white triangle. Pretty simple :).

[You can try live demo here] [2].

For best experience I recommend using Chrome or Chronium with native support for Dart. It works on Firefox as well, just framerate won't as good as in Chrome.

![Screenshot #1](https://raw.github.com/martinsik/physics-after-dart/master/screenshots/small1.jpg)
![Screenshot #2](https://raw.github.com/martinsik/physics-after-dart/master/screenshots/small2.jpg)
![Screenshot #3](https://raw.github.com/martinsik/physics-after-dart/master/screenshots/small3.jpg)
![Screenshot #4](https://raw.github.com/martinsik/physics-after-dart/master/screenshots/small4.jpg)

Known issues
------------

There are some small issues right now:   
 - Window size is fixed 1000x700, I think I should be easy to just scale canvas but I'm not sure how it's going to look like.  
 - Shadow casting isn't very efficient. It's the most performance critical part of the game. Right now it's rendered in 500x350 canvas and then scaled to 1000x700. This helped a lot! On my MacBook Pro 2.5 GHz I have constant 60 fps in all levels. I think there's still a lot to improve.  
 - By pressing 'd' key you can enable debug menu that I used to debug shadow casting and where you can disable textures or shadows. You can try it if you have problems with frame rate.

About
-----

When I saw [indie game Thomas Was Alone] [3] I absolutely loved how each object casts shadow. It's such a simple effect but it enhances the entire game experience so much so I wanted to make something similar.  
Well, I did although the algorhitm I'm using right now isn't very efficient. It's based on three canvases that has to be copied on the top of each other (there are some limitation by the canvas element itself). I belive that this part can be improved significantly. I'll try to explain how the shadow casting work on my blog soon.

I want to keep this repo as an open source "game engine" and build on top of it standalone game that I'll publish on Chrome App (probably for money).

I called this game "PhysicsAfterDark" first but I think this name is more stylish :).

Licence
-------

Physics After Dart is licensed under the [Beerware license] [4].

The only things I didn't make on my own are [dartbox2d] [1] physics engine and box textures.


  [0]: http://www.dartlang.org/ "Dart"
  [1]: https://code.google.com/p/dartbox2d/ "dartbox2d"
  [2]: http://martinsikora.com/physics-after-dart/web/index.html "live demo"
  [3]: http://store.steampowered.com/app/220780/ "Thomas Was Alone"
  [4]: http://en.wikipedia.org/wiki/Beerware#License "Beerware license"


