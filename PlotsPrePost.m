function PlotsPrePost

%
% Showing Pre and Post IDBN dMRI results
%
%
%
% SO@ACH 2017.07.03

%% load AFQ

IDBN_dir ='/Users/shumpei/Documents/Code/git/IDBN';
if exist(IDBN_dir,'dir')
    load(fullfile(IDBN_dir,'afq_19-Jan-2017.mat'));
end

IDBN_dir ='/home/ganka/git/IDBN';
if exist(IDBN_dir,'dir')
    load(fullfile(IDBN_dir,'afq_19-Jan-2017.mat'));
end

%% each tract
% c = lines(4);

for jj = 29:32% length(afq.fgnames)
    
    for ii = 1:4
        figure; hold on;
        
        plot(afq.vals.fa{jj}(ii,:),'--b')%,'Color',c(ii,:))
        plot(afq.vals.fa{jj}(ii+4,:),'-r')%,'Color',c(ii,:))
        
        [~,f]=fileparts(fileparts(afq.sub_dirs{ii}));
        k = strfind(f,'-');
        
        title(sprintf('%s; %s', f(1:k(1)-1), afq.fgnames{jj}))
        legend('Pre-Treat','Post-Treat','Location','northwest')
        ylabel FA
    end
    
end

%% FA
% x axis
for ii = 1:4 %subject loop
    x = 1: length(afq.fgnames);
    x1 = x-0.1;
    x2 = x+0.1;
    
    % y values
    for kk = x
        y1(kk) = nanmean(afq.vals.fa{kk}(ii,:),2);
        z1(kk) = nanstd(afq.vals.fa{kk}(ii,:)');
        y2(kk) = nanmean(afq.vals.fa{kk}(ii+4,:),2);
        z2(kk) = nanstd(afq.vals.fa{kk}(ii+4,:));
        h(kk)  = ttest(afq.vals.fa{kk}(ii,:), afq.vals.fa{kk}(ii+4,:));
    end
    
    figure; hold on;
    %     plot(x1,y1,'ob')
    %     plot(x2,y2,'or')
    
    errorbar(x1,y1,z1,'ob')
    errorbar(x2,y2,z2,'or')
    
    
    for kk = x;
        if h(kk)==1;
            plot(kk, 0.21 ,'*k')
        end
    end
    
    % add legend
    legend('Pre-Treat','Post-Treat','Location','northwest')
    
    % ID is helpful
    [~,f]=fileparts(fileparts(afq.sub_dirs{ii}));
    k = strfind(f,'-');
    title(sprintf('%s', f(1:k(1)-1)))
    
    % set fg names
    set(gca,'XTickLabelRotation',90,'XTickLabelMode','manual','XTick',[1:32],...
        'XTickLabel',afq.fgnames)
    
    xlabel tracts
    ylabel FA
end

%% FA merge L and R
% x axis
for ii = 1:4 %subject loop
    x = 1:2;
    x1 = x-0.1;
    x2 = x+0.1;
    
    % y values
    for kk = [29, 31]
        y1(kk) = nanmean((afq.vals.fa{kk}(ii,:)+afq.vals.fa{kk+1}(ii,:))/2,2);
        z1(kk) = nanstd((afq.vals.fa{kk}(ii,:)+afq.vals.fa{kk+1}(ii,:))/2);
        y2(kk) = nanmean((afq.vals.fa{kk}(ii+4,:)+afq.vals.fa{kk+1}(ii+4,:))/2,2);
        z2(kk) = nanstd((afq.vals.fa{kk}(ii+4,:)+afq.vals.fa{kk+1}(ii+4,:))/2);
        h(kk)  = ttest((afq.vals.fa{kk}(ii,:)+afq.vals.fa{kk+1}(ii,:))/2, (afq.vals.fa{kk}(ii+4,:)+afq.vals.fa{kk+1}(ii+4,:))/2);
    end
    
    figure; hold on;
    %     plot(x1,y1,'ob')
    %     plot(x2,y2,'or')
    
    errorbar(x1,[y1(29),y1(31)],[z1(29),z1(31)],'ob')
    errorbar(x2,[y2(29),y2(31)],[z2(29),z2(31)],'or')
    
    
    if h(29)==1;
        plot(1, 0.21 ,'*k')
    end
    if h(31)==1;
        plot(2,0.21,'*k')
    end
    
    
    % add legend
    legend('Pre-Treat','Post-Treat','Location','northwest')
    
    % ID is helpful
    [~,f]=fileparts(fileparts(afq.sub_dirs{ii}));
    k = strfind(f,'-');
    title(sprintf('%s', f(1:k(1)-1)))
    
    % set fg names
    set(gca,'XTickLabelRotation',90,'XTickLabelMode','manual','XTick',[1:2],...
        'XTickLabel',{'OT','OR'})
    
    xlabel tracts
    ylabel FA
end

%% MD
% x axis
for ii = 1:4 %subject loop
    x = 1: length(afq.fgnames);
    x1 = x-0.1;
    x2 = x+0.1;
    
    % y values
    for kk = 1:32
        y1(kk) = nanmean(afq.vals.md{kk}(ii,:),2);
        z1(kk) = nanstd(afq.vals.md{kk}(ii,:));
        y2(kk) = nanmean(afq.vals.md{kk}(ii+4,:),2);
        z2(kk) = nanstd(afq.vals.md{kk}(ii+4,:));
        h(kk)  = ttest(afq.vals.md{kk}(ii,:), afq.vals.md{kk}(ii+4,:));
    end
    
    figure; hold on;
    %     plot(x1,y1,'ob')
    %     plot(x2,y2,'or')
    
    errorbar(x1,y1,z1,'ob')
    errorbar(x2,y2,z2,'or')
    
    % stats '*'
    for kk = x;
        if h(kk)==1;
            plot(kk, 0.31 ,'*k')
        end
    end
    
    % add legend
    legend('Pre-Treat','Post-Treat','Location','northwest')
    
    % ID is helpful
    [~,f]=fileparts(fileparts(afq.sub_dirs{ii}));
    k = strfind(f,'-');
    title(sprintf('%s', f(1:k(1)-1)))
    
    % set fg names
    set(gca,'XTickLabelRotation',90,'XTickLabelMode','manual','XTick',1:32,...
        'XTickLabel',afq.fgnames)
    
    xlabel tracts
    ylabel MD
end

%% AD
% x axis
for ii = 1:4 %subject loop
    x = 1: length(afq.fgnames);
    x1 = x-0.1;
    x2 = x+0.1;
    
    % y values
    for kk = 1:32
        y1(kk) = nanmean(afq.vals.ad{kk}(ii,:),2);
        z1(kk) = std(afq.vals.ad{kk}(ii,:),'omitnan');
        y2(kk) = nanmean(afq.vals.ad{kk}(ii+4,:),2);
        z2(kk) = nanstd(afq.vals.ad{kk}(ii+4,:));
        h(kk)  = ttest(afq.vals.ad{kk}(ii,:), afq.vals.ad{kk}(ii+4,:));
    end
    
    figure; hold on;
    %     plot(x1,y1,'ob')
    %     plot(x2,y2,'or')
    
    errorbar(x1,y1,z1,'ob')
    errorbar(x2,y2,z2,'or')
    
    % stats '*'
    for kk = x;
        if h(kk)==1;
            plot(kk, 0.71 ,'*k')
        end
    end
    
    % add legend
    legend('Pre-Treat','Post-Treat','Location','northwest')
    
    % ID is helpful
    [~,f]=fileparts(fileparts(afq.sub_dirs{ii}));
    k = strfind(f,'-');
    title(sprintf('%s', f(1:k(1)-1)))
    
    % set fg names
    set(gca,'XTickLabelRotation',90,'XTickLabelMode','manual','XTick',[1:32],...
        'XTickLabel',afq.fgnames)
    
    xlabel tracts
    ylabel AD
end


%% RD
% x axis
for ii = 1:4 %subject loop
    x = 1: length(afq.fgnames);
    x1 = x-0.1;
    x2 = x+0.1;
    
    % y values
    for kk = 1:32
        y1(kk) = nanmean(afq.vals.rd{kk}(ii,:),2);
        z1(kk) = nanstd(afq.vals.rd{kk}(ii,:)');
        y2(kk) = nanmean(afq.vals.rd{kk}(ii+4,:),2);
        z2(kk) = nanstd(afq.vals.rd{kk}(ii+4,:));
        h(kk)  = ttest(afq.vals.rd{kk}(ii,:), afq.vals.rd{kk}(ii+4,:));
    end
    
    figure; hold on;
    %     plot(x1,y1,'ob')
    %     plot(x2,y2,'or')
    
    errorbar(x1,y1,z1,'ob')
    errorbar(x2,y2,z2,'or')
    
    % stats '*'
    for kk = x;
        if h(kk)==1;
            plot(kk, 0.21 ,'*k')
        end
    end
    
    % add legend
    legend('Pre-Treat','Post-Treat','Location','northwest')
    
    % ID is helpful
    [~,f]=fileparts(fileparts(afq.sub_dirs{ii}));
    k = strfind(f,'-');
    title(sprintf('%s', f(1:k(1)-1)))
    
    % set fg names
    set(gca,'XTickLabelRotation',90,'XTickLabelMode','manual','XTick',[1:32],...
        'XTickLabel',afq.fgnames)
    
    xlabel tracts
    ylabel RD
end

%% identification rate
for ii= 1:32 % fg names loop
    fg(ii) = sum(isnan( afq.vals.fa{ii}(:,50)));
end

NanFg = afq.fgnames(fg>0); %7,8,27

perIdentidied = sum(fg)/(8*32)*100;

%% Stats
for id = 1:4;
    for ii = [1:6,9:26,28:32] % fg names loop
        pre  = afq.vals.fa{ii}(id,:);
        post = afq.vals.fa{ii}(id+4,:);
        
        [h(id,ii),p(id,ii)] = ttest(pre(:),post(:));
    end
end

% number of fibers have different values in pre with post
sum(h,2)

%%
for ii = 1:4
    Pre_dt = dtiLoadDt6( afq.files.dt6{ii});
    Pre_dt.files.alignedDwRaw
    
    Post_dt = dtiLoadDt6( afq.files.dt6{ii+4});
    
    %subject name
    [~,f]=fileparts(fileparts(afq.sub_dirs{ii}));
    k = strfind(f,'-');
    subname =  f(1:k(1)-1);
    
    % cmd = '!osmosis-dti-rrmse.py dwi1st_aligned_trilin.nii.gz dwi1st_aligned_trilin.bvecs dwi1st_aligned_trilin.bvals dwi2nd_aligned_trilin.nii.gz dwi2nd_aligned_trilin.bvecs dwi2nd_aligned_trilin.bvals dti_rrmse_wmMask.nii.gz --mask_file wmMask.nii.gz';
    cmd = sprintf('!osmosis-dti-rrmse.py %s %s %s %s %s %s %s_dti_rrmse_wmMask.nii.gz --mask_file %s'...
        ,Pre_dt.files.alignedDwRaw, Pre_dt.files.alignedDwBvecs, Pre_dt.files.alignedDwBvals,...
        Post_dt.files.alignedDwRaw,Post_dt.files.alignedDwBvecs, Post_dt.files.alignedDwBvals,...
        subname,Post_dt.files.brainMask);
    
    eval(cmd)
    %%
