function CtrGenOT_all

% Generate optic radiation and optic tract with conTrack
%
% SO@ACH 2015

%% Take subject names
[dMRI, List] = SubJect;

% pick up your interesting subject
File = true(1,length(List));

for ii = 1:length(List)
if ~exist(fullfile(dMRI,List{ii},'dwi_1st/fibers/conTrack','OT_5K'),'dir');
    File(ii) = false;end 
end

% Subs  = List([81,82,65,66]);  
Subs  = List(File==0);
% Subs = Subs(4:end-1);

%% Optic Tract
% Create params structure
ctrParams = ctrInitBatchParams;

% set params
ctrParams.projectName = 'OT_5K_thalamus';
ctrParams.logName = 'myConTrackLog';
ctrParams.baseDir = dMRI;
ctrParams.dtDir = 'dwi_1st';
ctrParams.roiDir = 'ROIs';
ctrParams.subs = Subs;

% set parameter
ctrParams.roi1 = {'85_Optic-Chiasm','85_Optic-Chiasm'};
ctrParams.roi2 = {'Rt-LGN4','Lt-LGN4'};

% ctrParams.roi1 = {'85_Optic-Chiasm'};
% ctrParams.roi2 = {'Rt-LGN4'};

ctrParams.nSamples = 5000;  % number of fibers 
ctrParams.maxNodes = 100;   % longest fiber length(mm) 
ctrParams.minNodes = 20;    % shortest fiber length(mm) 
ctrParams.stepSize = 1;
ctrParams.pddpdfFlag = 0;
ctrParams.wmFlag = 0;
ctrParams.oi1SeedFlag = 'true';
ctrParams.oi2SeedFlag = 'true';
ctrParams.multiThread = 0;
ctrParams.xecuteSh = 0;

%% generate optic tract
[cmd, ~] = ctrInitBatchTrack(ctrParams);
system(cmd);
clear ctrParams

end
