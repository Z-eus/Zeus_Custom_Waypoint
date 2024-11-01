# Zeus Custom Waypoint
**Zeus Custom Waypoint** is a script that allows customizing map waypoints.

**Features;**

**Change Waypoint Color:** The color of the line for the waypoint on the map can be changed.

**Add Waypoint Blip:** You can select a blip for the end point of the waypoint. This provides a more personalized look on the map.

**Change Waypoint Blip Color/Style:** You can change the blip color and style (e.g. pulse effect).

**Add Waypoint Marker:** You can add a 3D marker for the end point of the waypoint that you can see.

**Change Waypoint Marker Color/Style:** You can change the marker color and style.

## Installation
- Throw it into your `resources` folder
- Add `ensure Zeus_Custom_Waypoint` to your `server.cfg`

## NOTE
- Dependency `Standalone`
- Almost everything can be configured in `config.lua`
- The script takes the coordinate of your waypoint and creates a new route. Therefore, your scripts that need the waypoint location may not work properly.

## UPDATE
- v0.1
    - Removed the “BLIP_NAME” text that appears with the Indicator after marking another location on the map
    - Added waypoint can be deleted with key combination
    - Small improvements
  
- v0.2
    - The waypoint will be automatically deleted when the character reaches the marked location
    - 3D marker can now be added to the location you mark on the map
    - Debug added

## SHOWCASE

[VIDEO](https://youtu.be/LZuCqHCqu0Q)
