function [filename, teamName] = selectResultsFile(num)
%% choose a network to load from networks folder
clc
dirName = [pwd,'\SUBMITTED_files\*.txt'];
Allinpnames = dir(dirName);

if isempty(num)
    disp(sprintf('\nChoose Results file:'))
    for i=1:length(Allinpnames)
        disp([num2str(i),'. ', Allinpnames(i).name])
    end
    x = input(sprintf('\nEnter File Number: '));
else
    x = num;
end
filename=[Allinpnames(x).name];
teamName = filename(1:strfind(filename,'.txt')-1);
end