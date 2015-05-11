function [cur_speedR,cur_speedL,cur_incl] = readTreadmillPacket(t)
%readTreadmillPacket reads in a packet from the treadmill, 32 bytes long,
%and parses out the belt speeds and incline angle. Note, accelerations are
%not available
%   
% disp(get(t,'BytesAvailable'))

%read through the buffer to get fresh data (throw away chunks of 32 bytes)
while(get(t,'BytesAvailable')>1)
    fread(t,32);
end



%INCORRECT WAY OF DOING IT: because decimalToBinary doesn't consider signs. -Pablo, 4/30/2015
% %read 32 bytes (latest data)
% packet = fread(t,32);
% 
% %convert back to binary to re-assess what the real value is: (Pablo, 4/30/2015: why are we doing this? How is the int16 conversion wrong?)
% cur_speedR = [decimalToBinaryVector(packet(2),8) decimalToBinaryVector(packet(3),8)];
% cur_speedR = binaryVectorToDecimal(cur_speedR);
% 
% cur_speedL = [decimalToBinaryVector(packet(4),8) decimalToBinaryVector(packet(5),8)];
% cur_speedL = binaryVectorToDecimal(cur_speedL);
% 
% cur_incl = [decimalToBinaryVector(packet(10),8) decimalToBinaryVector(packet(11),8)];
% cur_incl = binaryVectorToDecimal(cur_incl); %


%CORRECT WAY: -Pablo 4/30/2015
%Will, you stated that this was incorrect. why? This was working before and seems to match Bertec's comm specifications) method of converting bytes
read_format=fread(t,1,'uint8');
speeds=fread(t,4,'int16');
cur_speedR=speeds(1);
cur_speedL=speeds(2);
cur_incl=fread(t,1,'int16');
padding=fread(t,21,'uint8');

end

