## FEATURE: SMART RTL

### Description

The main purpose of this feature is make sure the drone can return to a safe landing position (like HOME or LAND mission item positions)
and choose the shortest and safest way to fly there.

Set RTL_TYPE = 4 (Smart RTL) to enable this feature.
Recommend always enabled by default.

### Modification on mavlink

1. we use MAV_CMD_WAYPOINT_USER_1 (31000 ) from mavlink as NO_RETURN_WAYPOINT, to indicate the middle point of the whole flight path, the middle point is based on flight distance and calculated automatically by Flight Plan Tools, when we convert kml/json files into plan file.
1. we rename MAV_CMD_NAV_LAND_LOCAL (23 ) to MAV_CMD_NAV_PRECLAND (23 ), and use it as quick command from BGC, and separate the scenarios when pilot want to land w/o precland enabled.

### Assumptions

1. FW Land should never be an option in any cases. (MAV_CMD_NAV_CMD_LAND #21 with FW)
1. MAV_CMD_NAV_VTOL_LAND (85 ) is not supported in current PX4 version.
1. MAV_CMD_NAV_LAND (21) contains precland if param2(PRECISION_LAND_MODE) set to 3 (Conditional precland)
1. MAV_CMD_NAV_PRECLAND (23) should be handled separately.
1. landing in rtl is always a LAND command with precland enabled.


### List of scenarios

| Flight Mode Changes | Scenarios | Expected Behaviors | Comments |
|-------------|-----------|---------------------|----------|
| Takeoff -> Return | during takeoff, failsafe triggers return or pilot asked to return | Just land at HOME position | Precland should also work here |
| Mission -> Return | full mission file with land mission item, before no reteurn point, return triggers | reverse the mission and fly back to HOME position | always in AUTO mode |
| Mission -> Return | full mission file with land mission item, after no return point, return triggers | Continue the mission until land at the LAND mission item position | LAND position maybe the same as HOME, maybe not |
| Mission -> Position -> Return | Pilot takeover during mission, then failsafe triggers return or pilot triggers return | same as the behavior above but need to choose the closest mission item to go first | when near HOME or LAND position, should choose them if it's closer than other waypoints(like transition waypoint) |
| Return -> Position -> Return | During return, pilot takeover and triggers return again from a manual mode (only positon?) | Should continue the return mode from closest waypoint | - |
| Mission -> Position -> Land | pilot overtake during mission and then need to land, press the LAND button on joystick | Should just land at current location | - |
| Mission -> Position -> Precland | pilot overtake during mission and move the drone to somewhere that can do precland, press the PRECLAND button on joystick | Should use precland process if possible | - |
