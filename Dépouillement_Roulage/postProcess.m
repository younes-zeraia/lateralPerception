% this script is intended to post process Lateral perception test logs



% PROCESS
% 1. Common process : Name, SW versions, etc...
% 2. Performance Process : C0-C1-C2, etc...
% 3. RoadEdge   : Specific to RoadEdge tests at CTA
% 4. Clustering Process : Line Type, color, Highway Exit, etc...

% SYNTHESIS
%% Parameters to be changed
containsFrCamSignals = true;
containsFusionSignals= true;
adasFunction            = 3; % 1-LCA  /  2-LKA  / 3-Open Loop
resim                   = 0; % 0-Vehicle Analysis  /  1-Resim analysis
vehicleID               = 'Alot HHN 20';
FrCamSW                 = 'SW5.1';
FusionSW                = 'RM5.1';
adasSW                  = '';
track                   = 'HOD'; % Ring / CTA2 / HOD / HWE
testType                = 'Clustering'; % Performance / RoadEdge / Clustering / Robustness / HWE / LS-LM
%% Path parameters
scriptPath = pwd;
functionPath = fullfile(scriptPath,'..','..','functions');
addpath(functionPath);
run('initParams');
testPath = getTestPath(initPath);
switch testType
    case 'Performance'
        logsPath = fullfile(testPath,logsConvFolderName,groundTruthLogPath);
    case {'RoadEdge','Clustering'}
        logsPath = fullfile(testPath,logsConvFolderName,taggingLogPath);
    otherwise
        error('Unrecognised Test Type');
end
graphResultsPath = fullfile(testPath,graphPath);
currScriptPath = pwd;
%% search files
logFiles = filesearch(logsPath,'mat');

for f=1:length(logFiles)
    
    fileName = logFiles(f).name;
    log = load(fullfile(logsPath,fileName));
    
    run('commonProcess.m');
    run('buildCommonSynthesis.m');
    switch testType
        case 'Performance'
            addpath(fullfile(currScriptPath,'performance'));
            run('performanceProcess.m');
%             run('buildPerfoReport.m');
            run('buildPerfoSynthesis.m');
            add2Synthesis(synthesisPath,synthesisName,commonSynthesis,perfoSynthesis);
        case 'RoadEdge'
            addpath(fullfile(currScriptPath,'roadEdge'));
            run('roadEdgeProcess.m');
            run('buildRoadEdgeSynthesis.m');
            add2Synthesis(synthesisPath,synthesisName,commonSynthesis,roadEdgeSynthesis);
        case 'Clustering'
            addpath(fullfile(currScriptPath,'clustering'));
            run('clusteringProcess.m');
            rund('buildClusteringSynthesis.m');
            add2Synthesis(synthesisPath,synthesisName,commonSynthesis,clusteringSynthesis);
        otherwise
            error('Unrecognised Test Type');
    end
    
    
    switch testType
        case 'Performance'
        case 'RoadEdge'
    end
    
    
end