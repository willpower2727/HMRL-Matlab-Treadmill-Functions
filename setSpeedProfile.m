function [cur_speedR,cur_speedL,cur_inc,sentTimer,readTimer,sentVR,sentVL] = setSpeedProfile(speedR,speedL,timing)
%setSpeedProfile send a speed profile to the treadmill

%INPUTS:
%speedL,speedR: vector of desired speeds
%timing: vector of times to apply the desired speeds (has to start in 0),
%expressed in sec.
%OUTPUT:
cur_speedR=[];
cur_speedL=[];
cur_inc=[];
sentTimer=[];
readTimer=[];

%% Set testing mode
testing=false;

%% Proceed

%Check all vectors are of same size
if (length(speedL)~=length(speedR))||(length(speedL)~=length(timing))
    disp('Error: vectors are not of same size')
    return
end

%Check timing(1)=0
if ~timing(1)==0
    disp('Error: initial time is not 0')
    return
end

%Check that time intervals are not too fast (less than 100 ms)
if any(diff(timing)<0.14)
    disp('Warning: trying to send commands too fast')
end
if any(diff(timing)<0)
    disp('Error: time is not monotonically increasing')
    return
end
if any(diff(timing)>0.3 & (diff(speedR)~=0 | diff(speedL)~=0)) 
    disp('Warning: time spacing too large, discontinuities in acceleration will probably be noticed')
end


%Generate acceleration vectors (this is minimum acceleration, to achieve
%the profile, in case we start falling behind, we will probably want to
%skip packets and for that we would need a higher acceleration. Also, 
%if the actual acceleration is somewhat less than the desired one, we need 
%higher acceleration just to keep up with the schedule)
accL=[100,ceil(abs(diff(speedL)./diff(timing)))];
accR=[100,ceil(abs(diff(speedR)./diff(timing)))];
if (any(accL>1500))||(any(accR>1500))
    disp('Error: trying to accelerate too fast')
    return
end
accL=round(2*accL); %100% margin
accR=round(2*accR); %100% margin

%Open communications
t=[];
if ~testing
    t = openTreadmillComm(); %%%%%%%%% Comment for testing
end

try %try-catch to avoid leaving communications halfway
    
%Getpayload
[payload] = getPayload(speedR(1),speedL(1),accR(1),accL(1),0);
sentVL(1)=bytes2Int(payload(2:3));
sentVR(1)=bytes2Int(payload(4:5));
%Send packet
%baseTime=int64(tic); %Time in microseconds
baseTime=clock;
%newTiming=int64(round(timing*10^6)) + baseTime; %Expressing in microsecs, adding offset
newTiming=timing;
sentTimer(1)=0;
if testing
    sendTreadmillPacket2(payload,t) %%%%%%%%%% use 2 for testing
else
    sendTreadmillPacket(payload,t);
    [cur_speedR(1),cur_speedL(1),cur_incl(1)] = readCurrentTreadmillData(t);
end
%Read reply
if ~testing
readTimer(1)=etime(clock,baseTime);
end

if testing
for i=2:length(timing)
    [payload] = getPayload(speedR(i),speedL(i),accR(i),accL(i),0); %Get new payload
    curTime=clock; %Get new time
    elapsedTime=etime(curTime,baseTime);
    while elapsedTime<newTiming(i)
        curTime=clock; %Keep getting time until we can send packet
        elapsedTime=etime(curTime,baseTime);
    end
    sendTreadmillPacket2(payload,t) %%%%%%%% Use 2 for testing
    sentTimer(i)=elapsedTime;
    sentVR(i)=bytes2Int(payload(2:3));
    sentVL(i)=bytes2Int(payload(4:5));
end
else
    for i=2:length(timing)
    [payload] = getPayload(speedR(i),speedL(i),accR(i),accL(i),0); %Get new payload
    curTime=clock; %Get new time
    elapsedTime=etime(curTime,baseTime);
    while elapsedTime<newTiming(i)
        curTime=clock; %Keep getting time until we can send packet
        elapsedTime=etime(curTime,baseTime);
    end
    sendTreadmillPacket(payload,t);
    [cur_speedR(i),cur_speedL(i),cur_incl(i)] = readCurrentTreadmillData(t);
    readTimer(i)=etime(clock,baseTime);
    sentTimer(i)=elapsedTime;
    sentVR(i)=bytes2Int(payload(2:3));
    sentVL(i)=bytes2Int(payload(4:5));
end
end

%Close comm
if ~testing
    closeTreadmillComm(t) %%%%%%%%% Comment for testing
end

catch %in case something fails
    if ~testing
    closeTreadmillComm(t) %%%%%%%%% Comment for testing
    end
end
end

