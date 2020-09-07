%{
 Copyright (c) 2020 KIOS Research and Innovation Centre of Excellence
 (KIOS CoE), University of Cyprus (www.kios.org.cy)
 
 Licensed under the EUPL, Version 1.1 or – as soon they will be approved
 by the European Commission - subsequent versions of the EUPL (the "Licence");
 You may not use this work except in compliance with theLicence.
 
 You may obtain a copy of the Licence at: https://joinup.ec.europa.eu/collection/eupl/eupl-text-11-12
 
 Unless required by applicable law or agreed to in writing, software distributed
 under the Licence is distributed on an "AS IS" basis,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the Licence for the specific language governing permissions and limitations under the Licence.
 
 Author(s)     : Stelios Vrachimis
 
 Work address  : KIOS Research Center, University of Cyprus
 email         : vrachimis.stelios@ucy.ac.cy (Stelios Vrachimis)
 Website       : http://www.kios.ucy.ac.cy
 
 Last revision : August 2020
%}
function [score,suc_det,x] = scoring_function(d,dist,SP,leak,detection)
%%% Calculates score given a specific leak and specific detection on L-TOWN
%%% network of the BattLeDIM 2020 competition
%%% score in [-1,1]

%% Scoring parameters:
xmax=SP.xmax; % max scoring distance for specific leak (meters)
costWater=SP.costWater; % Cost of water per m3 (Euro)
costCrew=SP.costCrew; % maximum repair crew cost per assignment (Euro)

%% Pipe length distance between the center of links:
leakLinkInd = double(d.getLinkIndex(leak.linkID)); % leak pipe ind
detLinkInd = double(d.getLinkIndex(detection.linkID)); % det pipe ind
if leakLinkInd==detLinkInd
    x = 0;
else
    LNI = d.getLinkNodesIndex; % nodes connected to links
    %%% minimum distance between link centers is the minimum distance between 
    %%% any combination of their adjucent nodes plus half of the pipe lengths:
    x = min([dist(LNI(leakLinkInd,1),LNI(detLinkInd,1)),...
    dist(LNI(leakLinkInd,1),LNI(detLinkInd,2)),...
    dist(LNI(leakLinkInd,2),LNI(detLinkInd,1)),...
    dist(LNI(leakLinkInd,2),LNI(detLinkInd,2))])...
    +double(d.getLinkLength(leakLinkInd))/2+double(d.getLinkLength(detLinkInd))/2;
end
%% Time parameters:
t0=leak.startTime; % leak start time (time step)
tend=leak.endTime; % leak end time (time step)
td = detection.startTime; % detection time (time step)

%% Scoring logic:
suc_det = 0; % succesful detection binary
score = 0;
if td<0 % detection in 2018
    score = 0;
elseif td>=t0 && td<=tend && abs(x)<=xmax % inside leak time-space
    if td==0; td=1; end
    water_saved = sum(leak.timeSeries(td:end))/12; % every 5 minutes!
    euro_saved = water_saved*costWater;
    labour_cost = -(x/xmax)*costCrew;
    score = euro_saved + labour_cost; % euros
    suc_det = 1;
elseif td<t0 || td>tend || abs(x)>xmax % outside leak time-space
    score = -costCrew;
else
    error('undefined')
end

end
    