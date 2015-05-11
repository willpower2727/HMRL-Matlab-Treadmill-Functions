Treadmill Interface Toolbox README

This toolbox was programmed by Pablo Iturralde, to interface the Bertec Treadmill from Matlab.
Last updated: Jun 7th 2013

Requirements
--------------
To use this toolbox, it is necessary that the treadmill be ON, and that the Treadmill Control Panel is open. Within the Control Panel, it is necessary to allow for incoming TCP/IP commands on port 4000 (first select TCP/IP remote control in Settings, and then click on the button that appears on the main window).

Functions
--------------


%Auxiliar
int16toBytes: gets numbers in int16 and returns the MSB & lsb for each (2x 8 bits) to be used in TCP/IP transmission
bytes2int: gets M couples of 2 bytes, and returns M int16 numbers

%Low-level (communication on a TCP/IP packet level)
sendTreadmillPacket: writes a TCP/IP packet with the given payload
readTreadmillPacket: reads first packet in TCP/IP buffer with speeds and incline
readCurrentTreadmillDat: reads succesive packets until there is no more data available, returns latest

openTreadmillComm: open TCP/IP
closeTreadmillComm: close TCP/IP

getPayload: generates a payload from values for speed, acceleration and incline, that can be written through sendTreadmillPacket

%Mid-level (functions that can be called on their own, without worrying for communications and give orders/read from treadmill)
setTreadmill: does all that is necessary to set the treadmill to a new speed (open TCP/IP, send, close)
readTreadmill: does all that is necessary to read current treadmill state
setSpeedProfile: does all that is necessary to send succesive speed values to generate a desired speed profile in time

%High-level (functions that give higher order commands, useful for experiments without having to micro-manage)
tightSpeedControl: from basic speed points, interpolates linearly and calls setSpeedProfile to generate the resulting profile





