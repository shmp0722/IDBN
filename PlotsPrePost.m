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
    load /Users/shumpei/Documents/Code/git/IDBN/afq_19-Jan-2017.mat
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
        legend('Pre-Treat','Post-Treat')
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
    for kk = 31:32
        y1(kk) = nanmean(afq.vals.fa{kk}(ii,:),2);
        z1(kk) = nanstd(afq.vals.fa{kk}(ii,:)');
        y2(kk) = nanmean(afq.vals.fa{kk}(ii+4,:),2);
        z2(kk) = nanstd(afq.vals.fa{kk}(ii+4,:));
    end
    
    figure; hold on;
%     plot(x1,y1,'ob')
%     plot(x2,y2,'or')

    errorbar(x1,y1,z1,'ob')
    errorbar(x2,y2,z2,'or')
    
    % add legend 
    legend('Pre-Treat','Post-Treat')
    
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

%% MD
% x axis
for ii = 1:4 %subject loop
    x = 1: length(afq.fgnames);
    x1 = x-0.1;
    x2 = x+0.1;
    
    % y values
    for kk = 1:32
        y1(kk) = nanmean(afq.vals.md{kk}(ii,:),2);
        z1(kk) = nanstd(afq.vals.md{kk}(ii,:)');
        y2(kk) = nanmean(afq.vals.md{kk}(ii+4,:),2);
        z2(kk) = nanstd(afq.vals.md{kk}(ii+4,:));
    end
    
    figure; hold on;
%     plot(x1,y1,'ob')
%     plot(x2,y2,'or')

    errorbar(x1,y1,z1,'ob')
    errorbar(x2,y2,z2,'or')
    
    % add legend 
    legend('Pre-Treat','Post-Treat')
    
    % ID is helpful
    [~,f]=fileparts(fileparts(afq.sub_dirs{ii}));
    k = strfind(f,'-');
    title(sprintf('%s', f(1:k(1)-1)))
    
    % set fg names
    set(gca,'XTickLabelRotation',90,'XTickLabelMode','manual','XTick',[1:32],...
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
        z1(kk) = nanstd(afq.vals.ad{kk}(ii,:)');
        y2(kk) = nanmean(afq.vals.ad{kk}(ii+4,:),2);
        z2(kk) = nanstd(afq.vals.ad{kk}(ii+4,:));
    end
    
    figure; hold on;
%     plot(x1,y1,'ob')
%     plot(x2,y2,'or')

    errorbar(x1,y1,z1,'ob')
    errorbar(x2,y2,z2,'or')
    
    % add legend 
    legend('Pre-Treat','Post-Treat')
    
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
    end
    
    figure; hold on;
%     plot(x1,y1,'ob')
%     plot(x2,y2,'or')

    errorbar(x1,y1,z1,'ob')
    errorbar(x2,y2,z2,'or')
    
    % add legend 
    legend('Pre-Treat','Post-Treat')
    
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

