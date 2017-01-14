function runAFQonIDBN_mrt
%
% run AFQ pipeline on AMD and AMD controls
%
% SO@ACH 


%% set AFQ ver. to mrtrix3
Git
cd jyeatman/AFQ/

cmd = '!git checkout mrtrix3';
eval(cmd)

%% all subjects
AFQdata = '/media/USB_HDD1/dMRI_data';
qData   = '/media/USB_HDD1/qMRI_data/Tamagawa';

LHON = {'LHON1-TK-20121130-DWI','LHON2-SO-20121130-DWI','LHON3-TO-20121130-DWI','LHON4-GK-20150628','LHON6-SS-20131206-DWI',...
    'LHON7-TT-2014-12-20','LHON8-AS-20151110'};

IDBN_pre  = {'LHON5-HS-IDBN-20160516','LHON9-NH-IDBN-20160516','LHON10-RK-IDBN-2016-5-22','LHON11-SK-IDBN-2016-5-22'};

IDBN_post = {'LHON5-HS-post_IDBN-20161123','LHON9-NH-post_IDBN-20161121','LHON10-RK-post_IDBN-20161123','LHON11-SK-post_IDBN-20161123'};

% %% test
% AFQdata = '/media/USB_HDD1/dMRI_data';
% qData   = '/media/USB_HDD1/qMRI_data/Tamagawa';
% 
% LHON = {'LHON1-TK-20121130-DWI','LHON2-SO-20121130-DWI','LHON3-TO-20121130-DWI','LHON4-GK-20150628','LHON6-SS-20131206-DWI',...
%     'LHON7-TT-2014-12-20','LHON8-AS-20151110'};
% 
% IDBN_pre  = {'LHON9-NH-IDBN-20160516','LHON10-RK-IDBN-2016-5-22','LHON11-SK-IDBN-2016-5-22'};
% 
% IDBN_post = {'LHON9-NH-post_IDBN-20161121','LHON10-RK-post_IDBN-20161123','LHON11-SK-post_IDBN-20161123'};
    


%% Make directory structure for each subject
subs = [IDBN_pre,IDBN_post];

for ii = 1:length(subs)
    sub_dirs{ii} = fullfile(AFQdata, subs{ii},'dwi_2nd');
end

% Subject grouping is a little bit funny because afq only takes two groups
% but we have 3. For now we will divide it up this way but we can do more
% later
Pa  = zeros(1,length(subs));
Ct = ones(1,length(IDBN_pre));

Pa(1,1:length(Ct)) =Ct; 

sub_group = Pa;

%% Now create and afq structure
...'computeCSD',1);

afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 1,'computeCSD',1,'normalization','ants');

% afq.params.cutoff=[5 95];
afq.params.outdir = ...
fullfile('/home/ganka/git/IDBN');
afq.params.outname = 'afq_mrt_13-Jan-2017.mat';
% afq.params.computeCSD = 1;
% afq.params.track.faMaskThresh = 0.09;
%% Run AFQ on these subjects
afq = AFQ_set(afq,'overwritefibers');
afq = AFQ_run(sub_dirs, sub_group, afq);

%% Add callosal fibers
afq = AFQ_SegmentCallosum(afq);

%% Add qMRI maps to AFQ structure
% create a cell array of paths to each subjects image.
imgDir = dir(fullfile(qData,'LHON*'));
imgDir2 = {imgDir(2).name,imgDir(3).name,imgDir(4).name,imgDir(5).name,...
    imgDir(2).name,imgDir(3).name,imgDir(4).name,imgDir(5).name};

% t1w_acpc.nii.gz: generated t1w map
% T1_map_lin.nii.gz: quantitative T1 map
% TV_map.nii.gz: MTV map
% PD.nii.gz: quantitative PD map
% VIP_map.nii.gz: VIP map
% SIR_map.nii.gz: Surface Interction Rate map

for ii = 1:length(sub_dirs)
      t1Path{ii} = fullfile(qData, imgDir2{ii}, 'T1_alligned_map_lin.nii.gz');
      tvPath{ii} = fullfile(qData, imgDir2{ii}, 'TV_alligned_map.nii.gz');
      pdPath{ii} = fullfile(qData, imgDir2{ii}, 'PD_alligned.nii.gz');
      vipPath{ii} = fullfile(qData, imgDir2{ii}, 'VIP_alligned.nii.gz');
      sirPath{ii} = fullfile(qData, imgDir2{ii}, 'SIR_alligned.nii.gz');
end
  
afq = AFQ_set(afq, 'images', t1Path);
afq = AFQ_set(afq, 'images', tvPath);
afq = AFQ_set(afq, 'images', pdPath);
afq = AFQ_set(afq, 'images', vipPath);
afq = AFQ_set(afq, 'images', sirPath);

% the maps will be computed and added to the AFQ structure:
  afq = AFQ_run(sub_dirs, sub_group, afq);
% The values of the tract profiles will be saved based on the name of the image (eg. t1_map). They can be accessed in the afq structure using the AFQ_get command:
  vals = AFQ_get(afq, 'Left Arcuate' , 't1_map');


