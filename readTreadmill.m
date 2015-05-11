function [cur_speedR,cur_speedL,cur_incl] = readTreadmill()
%readTreadmill returns current status of treadmill, as reported by the
%treadmill itself.
%OUTPUT:
%cur_speedR= current speed of R belt. In mm/s. Integer.
%cur_speedL= analogous for L belt.
%cur_incl= current treadmill inclination. In hundredths of degree 
%(e.g. 20 = 0.20 deg)
%AUTHOR:
%Pablo Iturralde - pai7@pitt.edu
%Last update: Feb 21st 2013 - 12:00

t=tcpip('localhost',4000);
set(t,'InputBufferSize',32,'OutputBufferSize',64);
fopen(t);
%Read reply
read_format=fread(t,1,'uint8');
speeds=fread(t,4,'int16');
cur_speedR=speeds(1);
cur_speedL=speeds(2);
cur_incl=fread(t,1,'int16');
padding=fread(t,21,'uint8');

fclose(t);
delete(t);


end

