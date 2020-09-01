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
%%
try 
d.unload
catch ERR
end 
fclose all;clear class;clear all;clc;close all;
addpath(genpath(pwd));

%% Scoring Parameters:
SP.xmax=300; % max pipe distance for leakage detection (meters)
SP.costWater=0.80; % cost of water per m3 (Euro)
SP.costCrew=500; % maximum repair crew cost per assignment (Euro)

%% Score Individual result:
[teamName,TS,DL,DD,TP,FP,FN] = scoring_algorithm([],SP);
save(['results_mat/',teamName])

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Scoring Algorithm
function [teamName,TS,DL,DD,TP,FP,FN] = scoring_algorithm(res_num,SP)

%% Leakage info (construct and save):
if ~exist('leak_info.mat','file')
leak_saved_fname = 'competition_data/leak_info';
leak_fname = 'leakages_info.yalm';
disp('Constructing leakage information sruct...')
[leak] = readLeakageFile(leak_fname);
save(leak_saved_fname,'leak')
end
load leak_info

%% Detection info:
[detection_fname, teamName] = selectResultsFile([res_num]);
[detection] = readResultsFile(detection_fname);

%% Save in report file:
report_fname = ['results_reports/',teamName,'_report.txt'];
if exist(report_fname, 'file') ; delete(report_fname); end
diary(report_fname)
disp('-------------------------------------')
disp(['TEAM NAME: ',teamName])
disp('-------------------------------------')

%% Network parameters:
d=epanet('L-TOWN.inp'); % network model
dist = nodeTopologicalDistance('L-TOWN.inp'); % minimum NODE distances

%% Display scoring parameters:
disp('-------------------------------------')
disp('Scoring Parameters')
% disp(['Max detection delay: ',num2str(SP.tmax),' (5-min. time steps)'])
disp(['Max detection distance: ',num2str(SP.xmax),'  (meters)'])
disp(['Cost of water per m^3: ',num2str(SP.costWater),' (Euro)'])
disp(['Max repair crew cost per assignment: ',num2str(SP.costCrew),' (Euro)'])

%% Scoring:
disp('-------------------------------------')
disp('Calculating score...')

%%% Ignore 2018 detections:
dettimes = [detection.startTime];
detection(find(dettimes<0))=[];

%%% Sort detections in chronological order:
dettimes = [detection.startTime];
[~, sortind] = sort(dettimes,'ascend');
detection = detection(sortind);

%%% Initialize:
score=zeros(length(detection),length(leak));
suc_det=zeros(length(detection),length(leak));
leak_detected_list=[];
score_per_det = -SP.costCrew*ones(length(detection),1);
leak_per_det = zeros(length(detection),1);
lcnt = 1; DD=[]; DL=[];
FP=0; 

%%% Evaluate each detection:
for i = 1:length(detection) % for every detection
    x=inf(1,length(leak));
    for j = 1:length(leak) % for every leak
        [score(i,j), suc_det(i,j), x(j)] = scoring_function(d,dist,SP,leak(j),detection(i));
    end
    
    %%% Evaluate detection:
    if any(suc_det(i,:))
        det_ind = find(suc_det(i,:));
        non_rep_det_ind = setdiff(det_ind,leak_detected_list);
        if isempty(non_rep_det_ind) % Repeated detection
           score_per_det(i) = 0; % ignore detection if leak has been detected
           leak_per_det(i) = 0;
        else % True Detection
           leak_per_det(i) = find(x==min(x(non_rep_det_ind))); % choose leakage closest to succesful detection
           if ~ismember(leak_per_det(i),non_rep_det_ind); error('Check'); end
           score_per_det(i) = score(i,leak_per_det(i)); % score of detection
           leak_detected_list = ([leak_detected_list, leak_per_det(i)]); % add leak to detected leakages list
           DD(lcnt)=detection(i).startTime-leak(leak_per_det(i)).startTime; % Detection Delay
           DL{lcnt} = leak(leak_per_det(i)).linkID; % detected leak link ID
           lcnt = lcnt+1;
        end
    else % No detection
        FP = FP+1; % add false postive here to account for repeated detections
        score_per_det(i) = -SP.costCrew;
        leak_per_det(i) = 0;
    end
            
    %%% Display score for detection i:
    disp('-------------------------------------')
    disp(['Detection entry : ',detection(i).linkID,', ',steps2time(detection(i).startTime)])
    if leak_per_det(i)>0
        disp(['Detected leakage: ',leak(leak_per_det(i)).linkID,', ',steps2time(leak(leak_per_det(i)).startTime)])
    else
        disp( 'NO detection')
    end
    disp(['Score: ',num2str(score_per_det(i))])
end

%%% Confusion matrix metrics:
TP = length(leak_detected_list);
FN = length(leak)-TP; % false negatives

%%% Calculate total score:
TS = sum(score_per_det); % total score
TS = round(TS,2);
disp('-------------------------------------')
disp(['TEAM NAME: ',teamName])
disp(['Total score: ',num2str(char(8364)),' ',num2str(TS)])
disp(['True Positives: ',num2str(TP)])
disp(['False Positives: ',num2str(FP)])
disp(['False Negatives: ',num2str(FN)])
disp('-------------------------------------')

%%
d.unload
diary off
end
