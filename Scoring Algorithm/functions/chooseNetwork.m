function [inpname,dispname] = chooseNetwork(net_num)
%% choose a network to load from networks folder
clc
dirName = [pwd,'\networks\*.inp'];
Allinpnames = dir(dirName);

if isempty(net_num)
    disp(sprintf('\nChoose Water Network:'))
    for i=1:length(Allinpnames)
        disp([num2str(i),'. ', Allinpnames(i).name])
    end
    x = input(sprintf('\nEnter Network Number: '));
else
    x = net_num;
end
inpname=['\networks\',Allinpnames(x).name];    
dispname=Allinpnames(x).name(1:find(Allinpnames(x).name=='.')-1);
end

