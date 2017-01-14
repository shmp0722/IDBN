function BrainMaskfromFS

%% MergeROis_NOTROI.m
% merge ROIs to create Big NOT ROI.

%% Set directory
[homeDir ,subDir] = fileparts(pwd);

% if notDefined('subID'),
%     subID = 1:length(subDir);
% end


%% Merging waypoint ROIs
% for ii = subID
%% make NOT ROI

SubDir = fullfile(homeDir,subDir);
roiDir = fullfile(SubDir,'ROIs');
%     cd(roiDir)

% ROI file names you want to merge
for hemisphere = 1:2
    %         if ii<22
    switch(hemisphere)
        case  1 % Left-WhiteMatter
            roiname = {...
                '*Right-Cerebellum-White-Matter*'
                '*Right-Cerebellum-Cortex*'
                '*Left-Cerebellum-White-Matter*'
                '*Left-Cerebellum-Cortex*'
                '*Left-Hippocampus*'
                '*Right-Hippocampus*'
                '*Left-Lateral-Ventricle*'
                '*Right-Lateral-Ventricle*'
                '*Left-Cerebral-White-Matter*'};
        case 2 % Right-WhiteMatter
            roiname = {...
                '*Right-Cerebellum-White-Matter*'
                '*Right-Cerebellum-Cortex*'
                '*Left-Cerebellum-White-Matter*'
                '*Left-Cerebellum-Cortex*'
                '*Left-Hippocampus*'
                '*Right-Hippocampus*'
                '*Left-Lateral-Ventricle*'
                '*Right-Lateral-Ventricle*'
                '*Right-Cerebral-White-Matter*'};
    end
    
    % load all ROIs
    for j = 1:length(roiname)
        RoiFile = dir(fullfile(roiDir,roiname{j}));
        roi{j} = dtiReadRoi(fullfile(roiDir,RoiFile(1).name));
    end
    
    
    % Merge ROI one by one
    newROI = roi{1,1};
    for kk=2:length(roiname)
        if ~isempty(roi{kk}.coords)
            newROI = dtiMergeROIs(newROI,roi{1,kk});
        end;
    end
    
    % Save the new NOT ROI
    % define file name
    
    switch(hemisphere)
        case 1 % Left-WhiteMatter
            newROI.name = 'Lh_NOT';
        case 2 % Right-WhiteMatter
            newROI.name = 'Rh_NOT';
    end
    % Save Roi
    dtiWriteRoi(newROI,fullfile(roiDir,newROI.name),1)
    clear roi newROI
end
% end
