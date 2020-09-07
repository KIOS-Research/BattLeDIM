function [Q, H, CL] = EPAsimulation(inpname)
%load network
d=epanet(inpname);
allParameters=d.getComputedTimeSeries;
H = allParameters.Head;
d.unload
end