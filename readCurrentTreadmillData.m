function [cur_speedR,cur_speedL,cur_incl] = readCurrentTreadmillData(t);
while(get(t,'BytesAvailable')>1) %Shouldn't this be >32?
    readTreadmillPacket(t); %Old data
end
[cur_speedR,cur_speedL,cur_incl] = readTreadmillPacket(t); %Latest news

