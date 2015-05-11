function [cur_speedR,cur_speedL,cur_incl] = setTreadmill(speedR,speedL,accR,accL,incline)
%setTreadmill This function can be used as a stand-in proxy instead of a
%user having to manually change things in the Treadmill Control Panel
%(Bertec).

%As explained before, this function acts as a stand-in for a manual user in the control of Bertec's Tredmill.
%As such, it can only do things that a user can do from the control panel.
%INPUTS:
%speedR: sets the target speed for right belt, in mm/s. Can only be in the
%-6500 to 6500 mm/s range (it gets saturated outside this range).
%speedL: analogous for the left belt.
%accR: sets the desired acceleration for the right belt to go from current
%speed to target speed. In mm/s^2. Only takes strictly positive values (treats them
%as an absolute value of desired acceleration). Defaults to 1 m/s^2 when
%not provided or value is zero or negative.
%accL: analogous for left belt.
%incline: sets the desired inclination of the belts (both). Integer value
%set in hundredths of a degree (e.g. 200 = 2 deg). Only takes non-negative
%values. Defaults to 0.
%OUTPUTS:
%cur_speedR= current speed of R belt. In mm/s. Integer.
%cur_speedL= analogous for L belt.
%cur_incl= current treadmill inclination. In hundredths of degree 
%(e.g. 20 = 0.20 deg)
%AUTHOR:
%Pablo Iturralde - pai7@pitt.edu
%Last update: Feb 21st 2013 - 12:00

%% Relevant parameters
defAcc=1000;
defInc=0;
%% Default values when not provided:
if nargin<3 %Accelerations not provided
    accR=defAcc;
    accL=defAcc;
end
if nargin<5 %Incline not provided
    incline=defInc;
end

%% Get payload to send
[payload] = getPayload(speedR,speedL,accR,accL,incline);
%% Sending of packet
t = openTreadmillComm();

%Send packet
sendTreadmillPacket(payload,t)

%Read reply
[cur_speedR,cur_speedL,cur_inc] = readCurrentTreadmillData(t);

%Close comm
closeTreadmillComm(t)

end

