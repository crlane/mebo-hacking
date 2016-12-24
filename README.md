# Hacking the Mebo

The mebo toy robot is controlled by a simple http API.

The api uses the following naming conventions for its components:
```
c == claw
w == wrist
s == arm
move_forward
move_backward
```

Requests are made to a web server on the Mebo at port 80. They are made in the clear with no authentication.

The commands themselves follow a convention of `${component}_{direction}` for arm/wrist/claw and `move_${direction}` for motion

THe command is provided as a request param to the http endpoint, with additional parameters as required to control speed, duration, etc.

## Summary of API Commands
```
|Param|Type|Range|Behavior|
---------------------------
|move_back||||
|move_forward||||
|c_open||||
|c_close|||
|s_up||||
|s_down||||
|w_right||||
|w_left||||
```

## Controlling Mebo via HTTP

### moving the robot
### moving the wrist
### moving the arm
### moving the claw
http://${mebo_ip}/?req=c_open&value=255
http://${mebo_ip}/?req=c_close&value=255&dur=2000&ts=031059

## TBD - A Python API
