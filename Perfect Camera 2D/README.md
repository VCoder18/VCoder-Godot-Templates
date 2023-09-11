# Documentation

## Mode
There 3 modes :
_The 1st is Normal, which means the camera will zoom & move to show every targets.
_The 2nd is Stage, the camera show all the level, its automatically set if there are no targets.
_The 3rd is Zoom, the camera will follow the 1st target given in its targets list, automatically set if there is only one target.

## Target Paths
The node paths of the targets, you just need to give em even if they aren't there but will appear later, like you can add characters and when they die they get removed
and after that they get added, since this array is used in runtime, you can update it by using something like $Camera.target_paths.append("my/node/path"), or remove it.

## Camera Shape
It's a CollisionShape2D, just to facilitate the manipulation, it takes a RectangleShape2D, and it will determine the limits of the camera, you can manipulate it to get great things, 
like putting it into an area, and attaching a signal area_entered/exited, to monitor if the player entered the camera zone, can be useful to make warnings or off-camera previews...,
I'd recommend though to have same ratio as viewport.

## Zoom Padding
It's a Vector2 representing pixels to add in consideration to the zoom, might be awkward but here's a clarifying example : when you try to show every player, the sprite might be big, 
and the head isn't visible (the camera uses as reference its global_position), or the body, or any part, you can use this value to add a padding.

## Camera Factor
It's a multiplier you apply on the Camera Shape size, make it smaller or bigger, it's up to you to achieve some nice effects according to your game, change the default shape,
or just debug.

## Max Zoom & Solo Zoom
If you are in Normal mode, you can set a Max Zoom in case the characters aren't that far.
If you are in the Zoom mode, you can set a fixed zoom to the character by editing Solo Zoom.

## Debug Mode
Last thing is debug mode, to show many data used for camera calculation, you can decide where to show em, other things to achieve your dream camera are drag, smoothing, 
and the other Camera2D parameters.

### I might update the code later to add more functionalities & making it easier and maybe some debugging tools.
### If you are interested i will post it here, and if you need tips tricks to get something with it just ask.
