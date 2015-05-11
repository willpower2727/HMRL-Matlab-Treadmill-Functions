function [ints] = bytes2Int(bytes)
%Takes a Mx2 array of integers in the 0-255 interval, assumed to represent
%M int16 numbers (2 bytes = 1 number) and returns the values of the
%integers

for i=1:size(bytes,1)
    if bytes(i,1)>127 %(negative number)
        ints(i) = (double(bytes(i,1))*256 + double(bytes(i,2)))-2^16; 
    else
        ints(i) = double(bytes(i,1))*256 + double(bytes(i,2)); 
    end
end


end

