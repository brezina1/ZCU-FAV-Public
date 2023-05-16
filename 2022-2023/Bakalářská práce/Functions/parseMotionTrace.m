function data = parseMotionTrace(filename)
%PARSEMOTIONTRACE Summary of this function goes here
%   Detailed explanation goes here

% relTime [S], setA [au/s^2], setV [au/s], setP [au], actV [au/s], loadP-AV [au], setI [A], actI [A], cucI [A], MMS, MSS
table = readtable(filename, 'HeaderLines', 3);%

data = table{:, :};
end

