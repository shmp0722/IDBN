function afq = runAFQonIDBN(newRun)
%
% run AFQ pipeline on AMD and AMD controls
%
% SO@ACH 

%% AFQ version set to master
Git
cd jyeatman/AFQ/

cmd = '!git checkout master';
eval(cmd)

%%
if notDefined('newRun'); newRun = 0; end

AFQdata = '/media/USB_HDD1/dMRI_data';
qData   = '/media/USB_HDD1/qMRI_data/Tamagawa';

LHON = {'LHON1-TK-20121130-DWI','LHON2-SO-20121130-DWI','LHON3-TO-20121130-DWI','LHON4-GK-20150628','LHON6-SS-20131206-DWI',...
    'LHON7-TT-2014-12-20','LHON8-AS-20151110'};

IDBN_pre  = {'LHON5-HS-IDBN-20160516','LHON9-NH-IDBN-20160516','LHON10-RK-IDBN-2016-5-22','LHON11-SK-IDBN-2016-5-22'};

IDBN_post = {'LHON5-HS-post_IDBN-20161123','LHON9-NH-post_IDBN-20161121','LHON10-RK-post_IDBN-20161123','LHON11-SK-post_IDBN-20161123'};
    
%subject = [64:67,75,76,82,83]

% Make directory structure for each subject
subs = [IDBN_pre,IDBN_post];

for ii = 1:length(subs)
    sub_dirs{ii} = fullfile(AFQdata, subs{ii},'dwi_1st');
end

% Subject grouping is a little bit funny because afq only takes two groups
% but we have 3. For now we will divide it up this way but we can do more
% later
Pa  = zeros(1,length(subs));
Ct = ones(1,length(IDBN_pre));

Pa(1,1:length(Ct)) =Ct; 

sub_group = Pa;

%% Now create and afq structure
if newRun == 1;
    afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 1,'normalization','ants');
    
    % afq.params.cutoff=[5 95];
    afq.params.outdir = ...
        fullfile('/home/ganka/git/IDBN');
    % afq.params.outname = 'AFQ_5JMD_5Ctl.mat';
    % afq.params.computeCSD = 1;
    % afq.params.track.faMaskThresh = 0.09;
    
    % Run AFQ on these subjects
    afq = AFQ_run(sub_dirs, sub_group, afq);
    % Add callosal fibers
    afq = AFQ_SegmentCallosum(afq);
else
    Git
    cd IDBN
    load afq_17-Jan-2017.mat
end
return


%% Prepare to add_newfibers
for ii = 1:length(sub_dirs)
    
    OTdir = fullfile(sub_dirs{ii},'fibers/OT_MD32');
    AFQdir = fullfile(sub_dirs{ii},'fibers');
    OTs   = dir(fullfile(OTdir,'*OT*'));
    
    copyfile(fullfile(OTdir,OTs(1).name), fullfile(AFQdir,sprintf('%s.mat',OTs(1).name(1:8))));
    copyfile(fullfile(OTdir,OTs(2).name), fullfile(AFQdir,sprintf('%s.mat',OTs(2).name(1:8))));
end

%% Add new fibers

fgName = 'LOT_MD32';
roi1Name = '85_Optic-Chiasm';
roi2Name = 'Lt-LGN4';
cleanFibers =0;
computeVals =1;
afq.params.clip2rois = 0;
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, cleanFibers);

fgName = 'ROT_MD32';
roi1Name = '85_Optic-Chiasm';
roi2Name = 'Rt-LGN4';
cleanFibers =0;
computeVals =1;
afq.params.clip2rois = 0;
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, cleanFibers);

%% Prepare to add_newfibers
for ii = 1:length(sub_dirs)
    
    ORdir = fullfile(sub_dirs{ii},'fibers/conTrack/OR_100K');
    AFQdir = fullfile(sub_dirs{ii},'fibers');
    [p,f] = fileparts(sub_dirs{ii});
    ROIdir = fullfile(p,'ROIs');
    copyfile(fullfile(p,'ROIs/*'),fullfile(sub_dirs{ii},'ROIs'))
    
    LOR   = dir(fullfile(ORdir,'*Rh_NOT_MD4.pdb*'));
    ROR   = dir(fullfile(ORdir,'*Lh_NOT_MD4.pdb*'));
    
    LOR   = fgRead(fullfile(ORdir, LOR.name));
    LOR.name = 'LOR_MD4';
    
    ROR   = fgRead(fullfile(ORdir,ROR.name));
    ROR.name = 'ROR_MD4';
    
    fgWrite(LOR,fullfile(AFQdir, [LOR.name,'.mat']),'mat')
    fgWrite(ROR,fullfile(AFQdir, [ROR.name,'.mat']),'mat')
    
%     copyfile(fullfile(ORdir,ROR(1).name), fullfile(AFQdir,sprintf('%s.mat',LOR(1).name(1:8))));
%     copyfile(fullfile(ORdir,LOR(1).name), fullfile(AFQdir,sprintf('%s.mat',ROR(1).name(1:8))));
end

%% Add optic radiation
fgName = 'LOR_MD4';
roi1Name = 'Lt-LGN4';
roi2Name = 'lh_V1_smooth3mm_Half';
cleanFibers =0;
computeVals =1;
afq.params.clip2rois = 0;
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, cleanFibers);

fgName = 'ROR_MD4';
roi1Name = 'Rt-LGN4';
roi2Name = 'rh_V1_smooth3mm_Half';
cleanFibers =0;
computeVals =1;
afq.params.clip2rois = 0;
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, cleanFibers);

return

%% Add NODDI maps
% create a cell array of paths to each subjects image.
imgDir ='/media/USB_HDD1/AMICO';

% subs
for ii = 1:length(subs)
    dwi = fullfile(imgDir, subs{ii}, 'NODDI_DWI.nii.gz');
    dwi_img = fullfile(imgDir, subs{ii}, 'NODDI_DWI.hdr');

    if exist(dwi_img,'file') && ~exist(dwi,'file');
      nii = nii_tool('load', fullfile(imgDir, subs{ii}, 'NODDI_DWI.hdr'));
      nii_tool('save',nii,fullfile(imgDir, subs{ii}, 'NODDI_DWI.nii.gz'));
    end
    
    NODDI_Path{ii} = fullfile(imgDir, subs{ii}, 'NODDI_DWI.nii.gz');
end
  
afq = AFQ_set(afq, 'images', NODDI_Path);

%%
afq = AFQ_set(afq,'overwritevals',1:8);
afq = AFQ_run(sub_dirs, sub_group,afq);

