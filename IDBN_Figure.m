function IDBN_Figure
% Plot patient data against controls
%
%
% Example:
%
% load /biac4/wandell/data/WH/analysis/AFQ_WestonHavens_Full.mat
% afq_controls = afq;
% load /biac4/wandell/data/WH/kalanit/PS/AFQ_PS.mat
% afq_patient = afq;
% AFQ_PlotPatientMeans(afq_patient,afq_controls,'T1_map_lsq_2DTI',[],'age', [53 73])
% AFQ_PlotPatientMeans(afq_patient,afq_controls,'fa',[],'age', [53 73])
% AFQ_PlotPatientMeans(afq_patient,afq_controls,'md',[],'age', [53 73])


%% load afq
Git
cd('IDBN')
load('afq_20-Jan-2017.mat')
%% Which nodes to analyze
if notDefined('nodes')
    nodes = 21:80;
end

% Define output directory
%     outdir = '/media/USB_HDD1/dMRI_data/Results/AO';

% If no value was defined than find all the values that match for controls
% and the patient
if notDefined('valname')
    valname = fieldnames(afq.vals);
elseif ischar(valname)
    tmp = valname;clear valname
    valname{1} = tmp;
end
% Get rid of underscores in the valname for the sake of axis labels
for v = 1:length(valname)
    valtitle{v} = valname{v};
    sp = strfind(valname{v},'_');
    if ~isempty(sp)
        valtitle{v}(sp) = ' ';
    end
end
% Get number of fiber groups and their names
nfg = AFQ_get(afq,'nfg');
% nfg = 28;

fgNames = AFQ_get(afq,'fgnames');

% Set the views for each fiber group
fgviews = {'leftsag', 'rightsag', 'leftsag', 'rightsag', ...
    'leftsag', 'rightsag', 'leftsag', 'rightsag', 'axial', 'axial',...
    'leftsag', 'rightsag', 'leftsag', 'rightsag',  'leftsag', 'rightsag'...
    'leftsag', 'rightsag', 'leftsag', 'rightsag'};
% Slices to add to the rendering
slices = [-5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0;...
    0 0 -5; 0 0 -5; -5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0];

% Set the colormap and color range for the renderings
cmap = AFQ_colormap('bgr');
% cmap = lines(256);

% cmap =colormap;
crange = [-4 4];

% Make an output directory for this subject if there isn't one
% if ~exist(outdir{s},'dir')
%     mkdir(outdir{s});
% end
% fprintf('\nImages will be saved to %s\n',outdir);

%% Loop over the different values
% mrvNewGraphWin;
pVals = AFQ_get(afq,'patient data');
cVals = AFQ_get(afq,'control data');

for v = 1:length(valname)
    % Open a new figure window for the mean plot
    mrvNewGraphWin;

%     subplot(3,3,v);
    hold('on');    
    
    % Loop over each fiber group
    for ii = 1:nfg
        % Get the values for the patient and compute the mean
        vals_p = pVals(ii).(upper(valname{v}));
        %         vals_p = afq.vals.(valname{v}){ii}(1,:);
        %         pVals(ii).(upper(valname{v}));
        
        % Remove nodes that are not going to be analyzed and only
        % compute for subject #s
        vals_p = vals_p(:,nodes);
        vals_pm = nanmean(vals_p(:));
        
        % Get the value for each control and compute the mean
        vals_c = cVals(ii).(upper(valname{v}));
        vals_c = vals_c(:,nodes);
        vals_cm = nanmean(vals_c,2);
        
        % Compute control group mean and sd
        m = nanmean(vals_cm);
        sd = nanstd(vals_cm);
        
        % Plot control group means and sd
        x = [ii-.2 ii+.2 ii+.2 ii-.2 ii-.2];
        y1 = [m-sd m-sd m+sd m+sd m-sd];
        y2 = [m-2*sd m-2*sd m+2*sd m+2*sd m-2*sd];
        fill(x,y2, [.6 .6 .6],'edgecolor',[0 0 0]);
        fill(x,y1,[.4 .4 .4] ,'edgecolor',[0 0 0]);
        
        % plot individual means
        %         c = lines(8);
        
%         for jj = 1:sum(afq.sub_group)
%             vals_cur = vals_p(jj,:);
            m_curr   = vals_pm;
%             nanmean(vals_cur);
            % Define the color of the point for the fiber group based on its zscore
            tractcol = vals2colormap((m_curr - m)./sd,cmap,crange);
            
            % Plot patient
            plot(ii, m_curr,'ko', 'markerfacecolor',tractcol,'MarkerSize',6);
%         end
    end
    
    % make fgnames shorter
    newfgNames = {'l-TR','r-TR','l-C','r-C','l-CC','r-CC','l-CH','r-CH','CFMa',...
        'CFMi','l-IFOF','r-IFOF','l-ILF','r-ILF','l-SLF','r-SLF','l-U','r-U',...
        'l-A','r-A'};
    
    %     set(gca,'xtick',1:nfg,'xticklabel',newfgNames,'xlim',[0 nfg+1],'fontname','times','fontsize',11);
    set(gca,'xtick',1:nfg,'xticklabel',fgNames,'xlim',[0 nfg+1],'fontname','times','fontsize',11);
    set(gca, 'XTickLabelRotation',90,'TickDir','out')
    ylabel(upper(valtitle{v}));
    
    h = colorbar('AxisLocation','out');
    h.Label.String = 'z score';
    
    saveas(gcf, sprintf(valname{v}),'pdf')

end

return


%% if all subjects are too much, average them
% mrvNewGraphWin;
pVals = AFQ_get(afq,'patient data');
cVals = AFQ_get(afq,'control data');

for v = 1:length(valname)
    % Open a new figure window for the mean plot
    mrvNewGraphWin;

%     subplot(3,3,v);
    hold('on');    
    
    % Loop over each fiber group
    for ii = 1:nfg
        % Get the values for the patient and compute the mean
        vals_p = pVals(ii).(upper(valname{v}));
        %         vals_p = afq.vals.(valname{v}){ii}(1,:);
        %         pVals(ii).(upper(valname{v}));
        
        % Remove nodes that are not going to be analyzed and only
        % compute for subject #s
        vals_p = vals_p(:,nodes);
        vals_pm = nanmean(vals_p(:));
        
        % Get the value for each control and compute the mean
        vals_c = cVals(ii).(upper(valname{v}));
        vals_c = vals_c(:,nodes);
        vals_cm = nanmean(vals_c,2);
        
        % Compute control group mean and sd
        m = nanmean(vals_cm);
        sd = nanstd(vals_cm);
        
        % Plot control group means and sd
        x = [ii-.2 ii+.2 ii+.2 ii-.2 ii-.2];
        y1 = [m-sd m-sd m+sd m+sd m-sd];
        y2 = [m-2*sd m-2*sd m+2*sd m+2*sd m-2*sd];
        fill(x,y2, [.6 .6 .6],'edgecolor',[0 0 0]);
        fill(x,y1,[.4 .4 .4] ,'edgecolor',[0 0 0]);
        
        % plot individual means
        %         c = lines(8);
        
        for jj = 1:sum(afq.sub_group)
            vals_cur = vals_p(jj,:);
            m_curr   = nanmean(vals_cur);
            % Define the color of the point for the fiber group based on its zscore
            tractcol = vals2colormap((m_curr - m)./sd,cmap,crange);
            
            % Plot patient
            plot(ii, m_curr,'ko', 'markerfacecolor',tractcol,'MarkerSize',6);
        end
    end
    
    % make fgnames shorter
    newfgNames = {'l-TR','r-TR','l-C','r-C','l-CC','r-CC','l-CH','r-CH','CFMa',...
        'CFMi','l-IFOF','r-IFOF','l-ILF','r-ILF','l-SLF','r-SLF','l-U','r-U',...
        'l-A','r-A'};
    
    %     set(gca,'xtick',1:nfg,'xticklabel',newfgNames,'xlim',[0 nfg+1],'fontname','times','fontsize',11);
%     set(gca,'xtick',1:nfg,'xticklabel',fgNames,'xlim',[0 nfg+1],'fontname','times','fontsize',11);
    set(gca, 'XTickLabelRotation',90,'TickDir','out')
    ylabel(upper(valtitle{v}));
    
    h = colorbar('AxisLocation','out');
    h.Label.String = 'z score';
    
   % saveas(gcf, sprintf(valname{v}),'pdf')

end

return


%%
pVals = AFQ_get(afq,'patient data');
cVals = AFQ_get(afq,'control data');

c= lines(4);

figure;hold on;

for ii= 1:4
    plot(pVals(29).FA(ii,21:80),'color',c(ii,:))
    plot(cVals(29).FA(ii,21:80),'--','color',c(ii,:))

end