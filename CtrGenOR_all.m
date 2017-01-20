function CtrGenOR_all

% Generate optic radiation and optic tract with conTrack
%
% SO@ACH 2015


%% Take subject names
[dMRI, List] = SubJect;

% pick up your interesting subject
File = true(1,length(List));

for ii = 1:length(List)
if ~exist(fullfile(dMRI,List{ii},'dwi_1st/fibers/conTrack','OR_100K/*.pdb'),'file');
    File(ii) = false;end 
end

Subs  = List(~File);
% Subs  = List([82,83]);  

%% Optic Radiation
% Set Params for contrack fiber generation

% Create params structure
ctrParams = ctrInitBatchParams;

% params
ctrParams.projectName = 'OR_100K';
ctrParams.logName = 'myConTrackLog';
ctrParams.baseDir = dMRI;
ctrParams.dtDir = 'dwi_1st';
ctrParams.roiDir = '/ROIs';

% pick up subjects
ctrParams.subs = Subs;

% set parameter
ctrParams.roi1 = {'Lt-LGN4','Rt-LGN4'};
ctrParams.roi2 = {'lh_V1_smooth3mm_Half','rh_V1_smooth3mm_Half'};

% ctrParams.roi1 = {'Rt-LGN4'};
% ctrParams.roi2 = {'rh_V1_smooth3mm_Half'};

ctrParams.nSamples = 100000;
ctrParams.maxNodes = 240;
ctrParams.minNodes = 100; % defalt: 10
ctrParams.stepSize = 1;
ctrParams.pddpdfFlag = 0;
ctrParams.wmFlag = 0;
ctrParams.oi1SeedFlag = 'true';
ctrParams.oi2SeedFlag = 'true';
ctrParams.multiThread = 0;
ctrParams.xecuteSh = 0;


%% Generate OR usinig Sherbondy's contrack
[cmd, ~] = ctrInitBatchTrack(ctrParams);


%%
system(cmd);
clear ctrParams

end
% return
% %% paralel
% 
% parfor jj = 1:length(ctrParams.subs)
%     cmd = fullfile(ctrParams.baseDir,ctrParams.subs{jj},ctrParams.dtDir,...
%         'fibers/conTrack',ctrParams.projectName)
% end
% end