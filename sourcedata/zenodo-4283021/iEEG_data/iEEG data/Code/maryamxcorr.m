%%prep data

%Neural_Ds = Channal x timesample 
Phasic_Ds = smoothEDA_205 (1:281);
Neural_Ds = (all_zAAbinned_theta_205)';

window = 50;%%   3 sec for theta box plots? . 50 sec for xcorr plots with 1 sec. shows the eda shape smooth very well. 

for i = 1:size(Neural_Ds,1)    % i = number of channelschannel

   [XCorr(i,:),Lag(i,:)]=xcorr(Phasic_Ds,Neural_Ds(i,:)',window,'coeff');%400*100);%,'normalized'); 

   [~,Ind_Max] = max(abs(XCorr(i,window:length(XCorr)))); 
%%   [~,Ind_Max] = min(XCorr(i,window:length(XCorr))); 


   Lag_Max(i) = Lag(i,Ind_Max+window);    Max_Xcorr(i)  = XCorr(i,Ind_Max+window);  

end   

 

% Permute for 1000 times 

for iter = 1:1000

    

    fprintf(' iter= %d \n',iter)

    for i = 1:size(Neural_Ds,1)    

       [XCorr_Perm,Lag_Perm]=xcorr(Phasic_Ds,Neural_Ds(i,randperm(size(Neural_Ds,2)))',window,'coeff');%400*100,'normalized'); 

     %  [~,Ind_Max_Perm] = min(XCorr_Perm); 

       [~,Ind_Max_Perm] = max(abs(XCorr_Perm)); 

       Lag_Max_Perm(i,iter) = Lag_Perm(:,Ind_Max_Perm);    Max_Xcorr_Perm(i,iter) =  XCorr_Perm(Ind_Max_Perm); 

    end   

    

    

end



% this is computing the confidence interval  

Index_Feature_Sig = []; 

for  i = 1:size(Neural_Ds,1)    

    CI(i,:) = Compute_ConfInt(Max_Xcorr_Perm(i,:)); 

        

    if Max_Xcorr(i)<CI(i,1)| Max_Xcorr(i)>CI(i,2) 

    Index_Feature_Sig = [Index_Feature_Sig i]; 

    end

end
figure; plot (Lag(1,:), XCorr, '-');
figure; plot (Lag(1,:), mean(XCorr,1));
sem = std (XCorr_total)./sqrt (size(XCorr_total,1));
figure; shadedErrorBar (Lag(1,:), mean(XCorr,1),sem)
figure; shadedErrorBar (Lag_total(1,:), mean(XCorr_total,1),sem)

set(gca, 'TickDir', 'out', 'XTicklabels',[],'YTicklabels',[],'LineWidth', 1.5, 'TickLength', [0.02 0.02]); 

%%
% this is plotting the permuted distribution and the real Xcorr 
% 70 = is the number of features I had which was 14 channel x 5 frequency band 
figure;
boxplot(Max_Xcorr_Perm'); hold on 

h = scatter([1:4],Max_Xcorr,'ko','filled'); set(h,'SizeData',10); 
set(gca,'XtickLabel',{'2','3','53','54','16','21' }); xtickangle(90); box off; ylabel('Max Cross Corrrelation High Gamma Insula');  ylim([-0.4 0.4])
 
%%

clear XCorr Lag
clear Ind_Max Lag_Max Max_Xcorr
clear Lag_Perm Lag_Max_Perm Max_Xcorr_Perm XCorr_Perm