# Hacking the Mebo

## Mebo v1

The Mebo toy robot via controlled by a simple http API.

Requests are made to a web server on the Mebo at port 80. They are made in the clear with no authentication.

The commands themselves follow a convention of `${component}_{direction}` for arm/wrist/claw and `move_${direction}` for motion

THe command is provided as a request param to the http endpoint, with additional parameters as required to control speed, duration, etc.

The api uses the following naming conventions for its components:
```
c == claw
w == wrist
s == arm
move_forward
move_backward
```


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

## Examples of Controlling Mebo via HTTP

### moving the robot
- `http://${mebo_ip}/?req=move_left&value=255&dur=2000&ts=020539`
- `http://${mebo_ip}/?req=move_right&value=134&dur=2000&ts=020540`
- `http://${mebo_ip}/?req=inch_right&ts=020533`
- `http://${mebo_ip}/?req=move_backward_right&value=130&dur=2000&ts=020536`
- `http://${mebo_ip}/?req=move_backward&value=164&dur=2000&ts=020537`
- `http://${mebo_ip}/?req=move_backward&value=217&dur=2000&ts=020537`
- `http://${mebo_ip}/?req=move_backward&value=255&dur=2000&ts=020537`
- `http://${mebo_ip}/?req=move_forward_right&value=127&dur=2000&ts=020536`
### moving the wrist
- `http://${mebo_ip}/?req=w_left&value=255&dur=2000&ts=020602`
- `http://${mebo_ip}/?req=w_right&value=133&dur=2000&ts=020557`
- `http://${mebo_ip}/?req=inch_w_left&ts=020621`
### moving the arm
- `http://${mebo_ip}/?req=s_up&value=241&dur=2000&ts=020609`
- `http://${mebo_ip}/?req=s_down&value=240&dur=2000&ts=020613`
### moving the claw
- `http://${mebo_ip}/?req=c_open&value=255`
- `http://${mebo_ip}/?req=c_close&value=255&dur=2000&ts=031059`
### Set Speaker Volume
- `http://${mebo_ip}/?req=set_spk_volume&value=6`

## Capturing traffic
Using rvictl to capture pcaps

`./setup_for_capture $IPHONE_UDID /path/to/pcap`

## setup docker network
`docker network create --subnet 10.69.12.0/24 --aux-address "DefaultGatewayIPv4=10.69.12.107" --gateway 10.69.12.6 homenet`

## Other commands

```
   14   9.377923 10.69.12.129 → 10.69.12.109 HTTP 138 GET /?req=setup_wireless_read HTTP/1.0
   24  10.383104 10.69.12.129 → 10.69.12.109 HTTP 130 GET /?req=get_rt_list HTTP/1.0
  309 128.832397 10.69.12.129 → 10.69.12.109 HTTP 218 GET /?req=setup_wireless_save&auth=wpa2&ssid=MyWLANSSID&key=MYWLANPSK&index=1 HTTP/1.0
  322 128.842891 10.69.12.129 → 10.69.12.109 HTTP 142 GET /?req=set_scan_timer&value=30 HTTP/1.0
  333 128.848148 10.69.12.129 → 10.69.12.109 HTTP 133 GET /?req=restart_system HTTP/1.0
  399 148.759775 10.69.12.129 → 10.69.12.109 HTTP 130 GET /?req=get_version HTTP/1.0
  410 148.770311 10.69.12.129 → 10.69.12.109 HTTP 142 GET /?req=set_timer_state&value=0 HTTP/1.0
  420 148.775242 10.69.12.129 → 10.69.12.109 HTTP 132 GET /?req=get_wifi_cert HTTP/1.0
 1064 266.390469 10.69.12.129 → 10.69.12.109 HTTP 138 GET /?req=setup_wireless_read HTTP/1.0
 1684 464.595285 10.69.12.129 → 10.69.12.109 HTTP 130 GET /?req=get_version HTTP/1.1
 1697 464.597699 10.69.12.129 → 10.69.12.109 HTTP 142 GET /?req=set_timer_state&value=0 HTTP/1.0
 1708 464.599283 10.69.12.129 → 10.69.12.109 HTTP 132 GET /?req=get_wifi_cert HTTP/1.0
```

### Other Findings for Mebo 1.0

- After reset, SSID for the robot wifi is `Mebo-XX-XX-XX`, where XX-XX-XX is replaced by the last three bytes of the mac address. For instance, my MAC address is `44:2c:05:1a:03:67` and my SSID is Mebo-1A-03-67.
- Mebo 1.0 also runs an HTTP server on port 8080 that serves some HTML
- Mebo 1.0 also runs some kind of server on port 6667, what is normally the IRC port.

## Mebo 2.0

After resetting, the wifi is of the form MEBO2_XXXXXX, where XXXXXX is the last part of the mac address

The Mebo2.0 has a webserver at the robot's IP address, with the following pages:

| Page | Contents|
|--------------- | --------------- |
| /status.html| system status, free memory, baud rate, etc  |
| /system.html| WiFi Setup, reboot video/controller board,factory reset |
| /upgrade.html| Firmware details for video and controller, and forms for updating each |
| /nvram.html| NVRAM parameters. Not sure yet how to use this |
| /factory.html| This one is hidden by default. But it's unlockable via `Ctrl+Alt+/`|


Instead of the HTTP API for controls in v1, there appears to be some kind of JSON API:

`http://192.168.99.1/ajax/command.json?command1=mebolink_message_send(!ARABCDEFGHI)`
`http://192.168.99.1/ajax/command.json?command1=mouth_led_state()`
Further investigation shows that it is ArduPilot software. 

- <https://discuss.ardupilot.org/t/how-to-use-json-command-to-read-attitude-quaternion-on-web-browser/84529https://discuss.ardupilot.org/t/how-to-use-json-command-to-read-attitude-quaternion-on-web-browser/84529>
- <https://docs.google.com/document/d/12IQFXDRIif06BiriHSCGdiJGZ6zsQ_phQsG_iI6_MAo/edit?pli=1#heading=h.gvvvomuy1uik>


It's possible you might be able to use DroneKit for Mebo 2: https://dronekit-python.readthedocs.io/en/latest/guide/quick_start.html
## Notes about My Mebo2.0
Current Sonix Firmware Version Details:

```
SDK: SN986_1.20_151a_20170512_1950_Mebo2_20170703(a-law patch)

BLD: FW_SX_MEBO2_PD_16127_09Oct2017_1218

Note the default Mebo Board Baudrate ins 115200


# TODO
- [ ] use http-enum
- [ ] use gobuster
- [ ] 


