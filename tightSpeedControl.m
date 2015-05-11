%new setting of speed profiles, allowing for tighter control and slower
%accelerations
function [cur_speedR,cur_speedL,cur_inc,sentTimer,sentVR,sentVL,readTimer,tightSpeedR,tightSpeedL,tightTime] = tightSpeedControl(speedR,speedL,time)
%Gets speed-time points and calculates a speed profile on a tight control
%(controlling upto 100ms if necessary) & implements it on the treadmill.
%Interpolates between given points assuming straight lines

%Check speeds withing adequate range, & accelerations not exceeded, all
%vectors equal length
if (length(speedL)~=length(speedR))||(length(speedL)~=length(time)) %Length
    disp('Error: vectors are not of same size')
    return
end
if any(abs(speedL)>4000)||any(abs(speedR)>4000)
    disp('Error: speeds to high')
    return
end
if any(abs(diff(speedL)./diff(time))>2000)||any(abs(diff(speedR)./diff(time))>2000)
   disp('Error: requested accelerations too high')
   return
end


%Check changes not faster than 100ms
if any(diff(time)<0.14)
    disp('Warning: time changes too close together, unfeasible profile')
end


%Calculate speed profile in time
tightSpeedL=[0];
tightSpeedR=[0];
tightTime=[0];
for i=2:length(time)
    N=floor(7*(time(i)-time(i-1))); %Update every 140ms tops!
    tightSpeedL(end:end+N-1)=linspace(speedL(i-1),speedL(i),N); %Rewrite value for last speed command in previous point
    tightSpeedR(end:end+N-1)=linspace(speedR(i-1),speedR(i),N);
    tightTime(end:end+N-1)=linspace(time(i-1),time(i),N);
end
%Send profile
[cur_speedR,cur_speedL,cur_inc,sentTimer,readTimer,sentVR,sentVL] = setSpeedProfile(tightSpeedR,tightSpeedL,tightTime);

end