function CtrGenOT_IDBN

% Generate optic radiation and optic tract with conTrack
%
% SO@ACH 2015

%% Take subject names
[dMRI, List] = SubJect;
[IDBN_pre, IDBN_post, LHON] = IDBN_List;
s
% pick up your interesting subject
% File = true(1,length([IDBN_pre,IDBN_post]));
% 
% for ii = 1:length(List)
% if ~exist(fullfile(dMRI,List{ii},'dwi_1st/fibers/conTrack','OT_5K'),'dir');
%     File(ii) = false;end 
% end
% 
% % Subs  = List([81,82,65,66]);  
% Subs  = List([67,68]);
% % Subs = Subs(4:end-1);

%% Optic Tract
% Create params structure
ctrParams = ctrInitBatchParams;

% set params
ctrParams.projectName = 'OT_5K';
ctrParams.logName = 'myConTrackLog';
ctrParams.baseDir = dMRI;
ctrParams.dtDir = 'dwi_1st';
ctrParams.roiDir = 'ROIs';
ctrParams.subs = [IDBN_pre,IDBN_post];

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
