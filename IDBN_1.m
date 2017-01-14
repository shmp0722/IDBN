function IDBN_1

%
%


%% 
AFQdata = '/media/USB_HDD1/dMRI_data';
qData   = '/media/USB_HDD1/qMRI_data/Tamagawa';

LHON = {'LHON1-TK-20121130-DWI','LHON2-SO-20121130-DWI','LHON3-TO-20121130-DWI','LHON4-GK-20150628','LHON6-SS-20131206-DWI',...
    'LHON7-TT-2014-12-20','LHON8-AS-20151110'};

IDBN_pre  = {'LHON5-HS-IDBN-20160516','LHON9-NH-IDBN-20160516','LHON10-RK-IDBN-2016-5-22','LHON11-SK-IDBN-2016-5-22'};

IDBN_post = {'LHON5-HS-post_IDBN-20161123','LHON9-NH-post_IDBN-20161121','LHON10-RK-post_IDBN-20161123','LHON11-SK-post_IDBN-20161123'};
    

%%
for ii = 1:length(IDBN_pre)
    
    % loading dt6 files
    ni_pre  = dtiLoadDt6(fullfile(AFQdata,IDBN_pre{ii},'/dwi_1st/dt6.mat'));
    ni_post = dtiLoadDt6(fullfile(AFQdata,IDBN_post{ii},'/dwi_1st/dt6.mat'));
   
    % loading FA post and pre 
    FA_pre = niftiRead( ni_pre.files.faStd);
    FA_post = niftiRead( ni_post.files.faStd);
    
    % make FA substruction map
    FA_sub =  FA_post;
    FA_sub.data = FA_post.data - FA_pre.data;
    [p,f,e]  = fileparts(FA_sub.fname);
    
    FA_sub.fname = fullfile(p,['subs_',f,e]);
    niftiWrite(FA_sub);
    
    % loading MD map
    MD_pre  = niftiRead(ni_pre.files.mdStd);
    MD_post = niftiRead( ni_post.files.mdStd);
    
    % make MD substruction map
    MD_sub =  MD_post;
    MD_sub.data = MD_post.data - MD_pre.data;
    [p,f,e]  = fileparts(MD_sub.fname);
    
    MD_sub.fname = fullfile(p,['subs_',f,e]);
    niftiWrite(MD_sub);
    
%     if 
%     showMontage(FA_sub.data,[],'jet')
    
end
return

%%
% Make directory structure for each subject
for ii = 1:length(subs)
    subDir = fullfile(homeDir, subs{ii},'dwi_2nd');

    cd(subDir)

% Load up optic radiations
fg = dtiLoadFiberGroup(fullfile('fibers','LOR_MD3.pdb'));

% Load up the dt6
dt = dtiLoadDt6('dt6.mat');

% Now let's get all of the coordinates that the fibers go through
coords = horzcat(fg.fibers{:});

% get the unique coordinates
coords_unique = unique(floor(coords'),'rows');

% These coordsinates are in ac-pc (millimeter) space. We want to transform
% them to image indices.
img_coords = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_unique)), 'rows');

% Now we can calculate FA
fa = dtiComputeFA(dt.dt6);

% Now lets take these coordinates and turn them into an image. First we
% will create an image of zeros
OR_img = zeros(size(fa));
% Convert these coordinates to image indices
ind = sub2ind(size(fa), img_coords(:,1), img_coords(:,2),img_coords(:,3));
% Now replace every coordinate that has the optic radiations with a 1
OR_img(ind) = 1;

% Now you have an image. Just for your own interest if you want to make a
% 3d rendering
isosurface(OR_img,.5);

% For each voxel that does not contain the optic radiations we will zero
% out its value
fa(~OR_img) = 0;

% Now we want to save this as a nifti image; The easiest way to do this is
% just to steal all the information from another image. For example the b0
% image
dtiWriteNiftiWrapper(fa, dt.xformToAcpc, 'L-OR-MD3-FA.nii.gz');
end
disp('I did it')

