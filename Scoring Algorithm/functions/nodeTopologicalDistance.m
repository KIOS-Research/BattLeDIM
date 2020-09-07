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
function D = nodeTopologicalDistance(inpname)
%%% Calculates D matrix, the distance of each node from other nodes

%% Find minimum topological distance between all nodes:
dispname = inpname(1:min(strfind(inpname,'.inp'))-1);
D_filename = [pwd,'\competition_data\D_Mat_',dispname,'.mat'];
if isfile(D_filename)
    % File exists:
    load(D_filename)
else
    % File does not exist:
    %%% Load Network
    d=epanet(inpname);
    %%%
    disp('Calculating min topological distances...')
    %%% D: nxn matrix with node distance
    %%% dmax: max distance in the network
    A = d.getConnectivityMatrix; % Adjacency matrix
    connNodes = d.NodesConnectingLinksIndex;
    pipeLengths = d.getLinkLength;
    for i = 1:length(connNodes)
        A(connNodes(i,1),connNodes(i,2)) = pipeLengths(i);
        A(connNodes(i,2),connNodes(i,1)) = pipeLengths(i);
    end    
    A = graph(A);
    D = distances(A);
    save(['competition_data\D_Mat_',dispname],'D')
    disp('Topological distance matrix created!')
    %%% Unload
    d.unload
end

end