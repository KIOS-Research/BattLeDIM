# BattLeDIM
The Battle of the Leakage Detection and Isolation Methods (BattLeDIM) 2020, organized initially as part of the 2nd International CCWI/WDSA Joint Conference in Beijing, China (http://www.ccwi-wdsa2020.com/), aims at objectively comparing the performance of methods for the detection and localization of leakage events, relying on SCADA measurements of flow and pressure sensors installed within water distribution networks. Participants may use different types of tools and methods, including (but not limited to) engineering judgement, machine learning, statistical methods, signal processing, and model-based fault diagnosis approaches.

# Website
http://battledim.ucy.ac.cy/

# Organizing committee/Contributors
Stelios G. Vrachimis, 	KIOS Center of Excellence, University of Cyprus, Cyprus<br>
Demetrios G. Eliades,		KIOS Center of Excellence, University of Cyprus, Cyprus<br>
Riccardo Taormina,		Technical University Delft, the Netherlands<br>
Avi Ostfeld,			Technion - Israel Institute of Technology, Israel<br>
Zoran Kapelan,			Technical University Delft, the Netherlands<br>
Shuming Liu,			Tsinghua University, China<br>
Marios Kyriakou,		KIOS Center of Excellence, University of Cyprus, Cyprus<br>
Pavlos Pavlou,			KIOS Center of Excellence, University of Cyprus, Cyprus<br>
Mengning Qiu,			Technion - Israel Institute of Technology, Israel<br>
Marios M. Polycarpou,		KIOS Center of Excellence, University of Cyprus, Cyprus

# Requirements
This work uses the EPANET-Matlab-Toolkit which is a Matlab class for EPANET libraries.
Please install the toolkit before use.
For more information see https://github.com/OpenWaterAnalytics/EPANET-Matlab-Toolkit#EPANET-MATLAB-Toolkit .

# Instructions for scoring result files
1. Download and install required software: MATLAB, EPANET-MATLAB toolkit
2. Download code
3. Insert your resutls file in the correct format (see Results Template) in Scoring_Algorithm/SUBMITTED_files
4. Run Scoring_Algorithm.m
5. Follow Command Window instructions to get your score

# Results template
Please submit your results in the following format (including spaces):

\# linkID, startTime\
p1, 2019-02-03 10:00<br>
p23, 2019-05-19 02:05<br>
p234, 2019-08-21 03:00<br>

# CodeOcean - Instructions

In case you don't have access to the required software, e.g. MATLAB, try evaluating your results through the CodeOcean computational research platform:

<b>Note:</b> Pending approval of code from CodeOcean. Please retry in a few days

1. https://codeocean.com/<br>
2. Create a codeocean account - Sign up<br>
3. Activate your codeocean account<br>
4. Go to https://codeocean.com/capsule/8332511<br>
5. Create your results file in the correct format (Results template)<br>
6. Select the folder `data` and then press the upload icon<br>
7. Upload your results in a file named `results.txt`<br>
8. You get the message: "The following files already exist and will be overwritten if you proceed". Press "Proceed".
(In case the file is not in the folder 'code', drag and drop the `results.txt` file in folder `data`)<br>
9. Press <b>Re-Run</b> in the upper right<br>
