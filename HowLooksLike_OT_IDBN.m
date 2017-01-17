function HowLooksLike_OT_IDBN
% Create figures illustrating the OR, optic tract, FA on the these tracts,
% and possibly the LGN position
%
% Repository dependencies
%    VISTASOFT
%    AFQ
%    LHON2
%
% SO Vista lab, 2014

%% Identify the directories and subject types in the study
% The full call can be
[homeDir,subDir] = SubJect;
 
 subID = [64:67,75,76,82,83];

% %%
% if notDefined('subID')
%     subID = [AMD,AMD_Ctl];
% end
%% load fiber groups (fg) and ROI files% select the subject{i}

% This selects a specific
for ii = subID; % 7 , 17
    % These directories are where we keep the data at Stanford.
    % The pointers must be directed to any site.
    SubDir=fullfile(homeDir,subDir{ii});
    OTdir = fullfile(SubDir,'/dwi_1st/fibers/OT_MD32');
%     ORdir= fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_divided');
    
    % dirROI = fullfile(SubDir,'/dwi_2nd/ROIs');
    dt6 =fullfile(SubDir,'/dwi_1st/dt6.mat');
    
    % OT check
    % Optic tract
    ROT_Name = fullfile(OTdir,'*R*.mat');
    ROT = dir(ROT_Name);
    
    LOT_Name = fullfile(OTdir,'*L*.mat');
    LOT = dir(LOT_Name);
    
    if length(LOT)==1
        L_OT = fgRead(fullfile(OTdir,LOT.name));
    elseif length(LOT)>=2
        L_OT = fgRead(fullfile(OTdir,LOT(1).name));
    end
    
    if length(ROT)==1
        R_OT = fgRead(fullfile(OTdir,ROT.name));
    elseif length(ROT)>=2
        R_OT = fgRead(fullfile(OTdir,ROT(1).name));
    end
    
%     %% OR check
%     %     ROR = dir(fullfile(ORdir, '*Rt*MD4.pdb'));
%     %     LOR = dir(fullfile(ORdir, '*Lt*MD4.pdb'));
%     
%     % removing redandant file 
%     if exist(fullfile(ORdir,'*NOT*NOT*','file'));
%         delete(fullfile(ORdir,'*NOT*NOT*','file'));
%     end
%     
%     % select tract files up
%     ROR_C = dir(fullfile(ORdir, '*Rt*Ecc0to3*MD3.pdb'));
%     LOR_C = dir(fullfile(ORdir, '*Lt*Ecc0to3*MD3.pdb'));
%     
%     ROR_P = dir(fullfile(ORdir, '*Rt*Ecc30to90*MD3.pdb'));
%     LOR_P = dir(fullfile(ORdir, '*Lt*Ecc30to90*MD3.pdb'));
%     
%     %     if ~isempty(ROR_C)
%     for ll = 1:length(ROR_C)
%         RORC{ll} = fgRead(fullfile(ORdir,ROR_C(ll).name));
%         LORC{ll} = fgRead(fullfile(ORdir,LOR_C(ll).name));
%     end
%     
%     for ll = 1:length(ROR_P)
%         RORP{ll} = fgRead(fullfile(ORdir,ROR_P(ll).name));
%         LORP{ll} = fgRead(fullfile(ORdir,LOR_P(ll).name));
%     end
%     clear ROR_C LOR_C ROR_P LOR_P
    %% Render figure
    figure;hold on;
    Dt6 = dtiLoadDt6(dt6);
    C = jet(10);
    %         C = jet(2+length(ROR)+length(LOR));
    
    AFQ_RenderFibers(R_OT,'numfibers',100,'color',C(1,:),'newfig',0)
    AFQ_RenderFibers(L_OT,'numfibers',100,'color',C(1,:),'newfig',0)
    
%     for ll = 1:length(RORC)
%         AFQ_RenderFibers(RORC{ll},'numfibers',100,'color',C(10,:),'newfig',0)
%         AFQ_RenderFibers(LORC{ll},'numfibers',100,'color',C(10,:),'newfig',0)
%     end
%     
%     for ll = 1:length(RORP)
%         AFQ_RenderFibers(RORP{ll},'numfibers',100,'color',C(5,:),'newfig',0)
%         AFQ_RenderFibers(LORP{ll},'numfibers',100,'color',C(5,:),'newfig',0)
%     end
%     
    %
    t1 = niftiRead(Dt6.files.t1);
    AFQ_AddImageTo3dPlot(t1,[0 0 -15]);
    axis image
    axis off
    light
    
    title(sprintf('%s MD3', subDir{ii}));
    %     view(-184,40)
%     clear R_OT L_OT RORP LORP
end
% end
% return