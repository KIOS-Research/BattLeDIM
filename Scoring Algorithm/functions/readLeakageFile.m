function [leak] = readLeakageFile(fname)

%% Leakages
%  # linkID, startTime, endTime, leakDiameter (m), leakType, peakTime
%  p257, 2018-01-08 13:30, 2019-12-31 23:55, 0.011843, incipient, 2018-01-25 08:30
%  p427, 2018-02-13 08:25, 2019-12-31 23:55, 0.0090731, incipient, 2018-05-14 19:25
%  p810, 2018-07-28 03:05, 2019-12-31 23:55, 0.010028, incipient, 2018-11-02 22:25
%  p654, 2018-07-05 03:40, 2019-12-31 23:55, 0.0087735, incipient, 2018-09-16 21:05
%  p523, 2019-01-15 23:00, 2019-02-01 09:50, 0.020246, abrupt, 2019-01-15 23:00
%  p827, 2019-01-24 18:30, 2019-02-07 09:05, 0.02025, abrupt, 2019-01-24 18:30
%  p280, 2019-02-10 13:05, 2019-12-31 23:55, 0.0095008, abrupt, 2019-02-10 13:05
%  p653, 2019-03-03 13:10, 2019-05-05 12:10, 0.016035, incipient, 2019-04-21 19:00
%  p710, 2019-03-24 14:15, 2019-12-31 23:55, 0.0092936, abrupt, 2019-03-24 14:15
%  p514, 2019-04-02 20:40, 2019-05-23 14:55, 0.014979, abrupt, 2019-04-02 20:40
%  p331, 2019-04-20 10:10, 2019-12-31 23:55, 0.014053, abrupt, 2019-04-20 10:10
%  p193, 2019-05-19 10:40, 2019-12-31 23:55, 0.01239, incipient, 2019-07-25 03:20
%  p277, 2019-05-30 21:55, 2019-12-31 23:55, 0.012089, incipient, 2019-08-11 15:05
%  p142, 2019-06-12 19:55, 2019-07-17 09:25, 0.019857, abrupt, 2019-06-12 19:55
%  p680, 2019-07-10 08:45, 2019-12-31 23:55, 0.0097197, abrupt, 2019-07-10 08:45
%  p586, 2019-07-26 14:40, 2019-09-16 03:20, 0.017184, incipient, 2019-08-28 07:55
%  p721, 2019-08-02 03:00, 2019-12-31 23:55, 0.01408, incipient, 2019-09-23 05:40
%  p800, 2019-08-16 14:00, 2019-10-01 16:35, 0.018847, incipient, 2019-09-07 21:05
%  p123, 2019-09-13 20:05, 2019-12-31 23:55, 0.011906, incipient, 2019-11-29 22:10
%  p455, 2019-10-03 14:00, 2019-12-31 23:55, 0.012722, incipient, 2019-12-16 05:25
%  p762, 2019-10-09 10:15, 2019-12-31 23:55, 0.01519, incipient, 2019-12-03 01:15
%  p426, 2019-10-25 13:25, 2019-12-31 23:55, 0.015008, abrupt, 2019-10-25 13:25
%  p879, 2019-11-20 11:55, 2019-12-31 23:55, 0.013195, incipient, 2019-12-31 23:55

%% Read file and sort info:
fname = 'leakages_info.yalm';
fid=fopen(fname);
tline = fgetl(fid);
leak_lines = cell(0,1);
i=1;
while ischar(tline)
    if strcmp(tline(1),'#')
        tline = fgetl(fid);
        continue
    end
    leak_lines{end+1,1} = tline;
    com = strfind(leak_lines{end,1},',');
    leak(i).linkID = leak_lines{end}(1:com(1)-1);
    leak(i).startTime = time2steps(leak_lines{end}(com(1)+2:com(2)-1));
    leak(i).endTime = time2steps(leak_lines{end}(com(2)+2:com(3)-1));
    leak(i).diameter = str2num(leak_lines{end}(com(3)+2:com(4)-1));
    leak(i).type = leak_lines{end}(com(4)+2:com(5)-1);
    leak(i).peakTime = time2steps(leak_lines{end}(com(5)+2:end));
    leak(i).timeSeries = xlsread(['Leak_',leak(i).linkID,'.xlsx'],2,'B2:B105121');
    leak(i).volume = sum(leak(i).timeSeries)/12;
    tline = fgetl(fid);
    i=i+1;
end
fclose(fid);

%%
% timeFormat = 'yyyy-mm-dd MM:HH';
% leak(i).startTime = datenum('2019-06-12 19:55',timeFormat);
% leak(i).peakTime = datenum('2019-06-12 19:55',timeFormat);
% leak(i).endTime = datenum('2019-07-17 09:25',timeFormat);
% detection(i).startTime= datenum('2019-06-13 19:55',timeFormat);

% i=1;
% leak(i).linkID = 'p142';
% leak(i).startTime = time2steps('2019-06-12 19:55');
% leak(i).peakTime = time2steps('2019-06-12 19:55');
% leak(i).endTime = time2steps('2019-07-17 09:25');
% leak(i).diameter = 0.019857;
% leak(i).type = 'abrupt';

end