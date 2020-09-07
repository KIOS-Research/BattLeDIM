function [ts] = time2steps(timeG)
%%% Converts a given time of the year 2019 to number of 5-minute time steps
%%% since 2019-01-01 00:00

%% 
timeFormat = 'yyyy-mm-dd HH:MM';
timeG = datenum(timeG,timeFormat);
initTime = datenum('2019-01-01 00:00',timeFormat);
fiveMinStep = datenum('2019-01-01 00:05',timeFormat)-initTime;
ts = round((timeG-initTime)/fiveMinStep);

end