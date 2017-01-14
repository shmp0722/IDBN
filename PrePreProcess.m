
function PrePreProcess
%
% After running dicm2nii to create bvecs bvals and dwi files, We need to
% make dt6 file for using vistasoft.
%
%
% @ACH S.O. 20161124 

%%
LHON = {'LHON1-TK-20121130-DWI','LHON2-SO-20121130-DWI','LHON3-TO-20121130-DWI','LHON4-GK-20150628','LHON6-SS-20131206-DWI',...
    'LHON7-TT-2014-12-20','LHON8-AS-20151110'};

IDBN_pre  = {'LHON5-HS-IDBN-20160516','LHON9-NH-IDBN-20160516','LHON10-RK-IDBN-2016-5-22','LHON11-SK-IDBN-2016-5-22'};

IDBN_post = {'LHON5-HS-post_IDBN-20161123','LHON9-NH-post_IDBN-20161121','LHON10-RK-post_IDBN-20161123','LHON11-SK-post_IDBN-20161123'};
  

%%
cmd{1} = '!mv ep2d_diff_12dir_A_P_1_8iso.bval ../raw/dwi1st.bval';
cmd{2} = '!mv ep2d_diff_12dir_A_P_1_8iso.bvec ../raw/dwi1st.bvec';
cmd{3} = '!mv ep2d_diff_12dir_A_P_1_8iso.nii.gz ../raw/dwi1st.nii.gz';

for ii = 1:3
    eval(cmd{ii})
end

%%
cmd{1} = '!mv ep2d_diff_12dir_A_P_1_8iso.bval ../raw/dwi2nd.bval';
cmd{2} = '!mv ep2d_diff_12dir_A_P_1_8iso.bvec ../raw/dwi2nd.bvec';
cmd{3} = '!mv ep2d_diff_12dir_A_P_1_8iso.nii.gz ../raw/dwi2nd.nii.gz';

for ii = 1:3
    eval(cmd{ii})
end

%%
cd('/media/HDPC-UT/dMRI_data');
list = dir('LHON*post_IDBN*');

for jj = 1:length(list)
    cd(fullfile('/media/HDPC-UT/dMRI_data',list(jj).name))
    ACH_Preprocess([],1);ACH_Preprocess([],2);
end