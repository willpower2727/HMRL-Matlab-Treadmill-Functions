function [cur_speedR,cur_speedL,cur_incl] = getCurrentData(t)
%% Deprecated method, will return incorrectly formatted data
%Use readTreadmillPacket()

while(get(t,'BytesAvailable')>1)
    readTreadmillPacket(t); %Old data
end
[cur_speedR,cur_speedL,cur_incl] = readTreadmillPacket(t); %Latest news

