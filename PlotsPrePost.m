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
figure; hold on;

c = jets(4);

for jj = 1: length(afq.fgnames)

    for ii = 1:4
        plot(afq.control_data(jj).FA(ii,:),'-','Color',c(ii,:))
        afq.patient_data(1).FA(ii,:)
    end
    

