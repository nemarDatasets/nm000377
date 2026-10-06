function AACorrGSR_stanford(rawData,Datafs,chosenElecs,badIntervals,Refs,anxietyOnset,GSRdata,GSRsynctime,saveFN) 
    %Analysis Bins
    GSRtimeBin=0.1;
    timeBin=0.1;     %duration of sliding window
    tshift=0.1;   
    window = 0.1; %in seconds correlation window for xcorr function
    
    %amount of shift of sliding window (smoothing)
        
    cRange=[-2 2];
    spectRange=[0 150];
    
    params.Fs=400;
    params.fpass=[1 150];

    
    delta=[1 4];
    theta=[4 8];
    alpha=[8 15];
    beta=[15 40];
    lgamma=[40 70];
    hgamma=[70 150];
    gamma=[40 150];

    %HR analysis Parameters:
    fc1 = 2.5; % Low pass cut off frequency
    fc2 = .5; % High pass cut off frequency
%     thresh=0;
    
%==========================Handles Skin Conductance data========================
% 
%     load(GSRfn);
%     zEDAdata_raw=zscore(1./GSRdata);
    %zEDAdata = z_ds_raw;
   GSRdata = downsample (GSRdata, 10); 
    tsamp=0.005;                     %sampling interval
        
    zEDAdata_raw=zscore(GSRdata);
    EDAtime = [1:length(zEDAdata_raw)]*tsamp-GSRsynctime;
    [b,dev,stats] = glmfit(EDAtime,zEDAdata_raw);
    
    yPredict = glmval(b,EDAtime,'identity');
   % zEDAdata=zEDAdata_raw-yPredict;
   zEDAdata = zEDAdata_raw;
   
   % remove bad times from EDA (for baseline 200 262-266, 360-385), [79
   % 80;173 174;186 188]for EC 192 AMYGDALA ELECTRODE 97
   if ~isempty(badIntervals) 
   badedaTimes=[];
    for i=1:size(badIntervals,1)
        badedaTimes=[badedaTimes round((1/tsamp)*((badIntervals(i,1)-anxietyOnset-GSRsynctime)):(1/tsamp)*((badIntervals(i,2)-anxietyOnset-GSRsynctime)))];
    end

    zEDAdata(badedaTimes)=[];
    EDAtime (badedaTimes)=[];
   end
   
   
   
%     tsamp=mean(diff(EDAtime));  %approx 50Hz or 20ms

    %Processing GSR
    [r, p, t, l, d, e, obj] = cvxEDA(zEDAdata, tsamp);
    
    
    %Plotting GSR and components
    figure;
 %   plot(EDAtime,zEDAdata_raw,'g-'); hold on;
    plot(EDAtime,zEDAdata,'k-'); hold on;
    plot(EDAtime,r,'r-'); hold on;
    plot(EDAtime,t,'b-'); hold on;
    xlabel('Time (sec)');
    ylabel('EDA (zscore)');
    
    %Find recording 

    
	smoothEDA=[];
    GSRtime=0;
    smoothSCR = [];
    for t=GSRsynctime/tsamp:tshift/tsamp:size(zEDAdata,1)-GSRtimeBin/tsamp
        slideTime=round(t:t+GSRtimeBin/tsamp);
        %slideTime=t:t+GSRtimeBin/tsamp; this gave errors once in a while. 

     smoothEDA=[smoothEDA; mean(r(slideTime),1)];
     %smoothSCR=[smoothEDA; mean(r(slideTime),1)];
     %smoothSCR=[smoothSCR; mean(r(slideTime),1)];
 % smoothEDA=[smoothEDA; mean(zEDAdata(slideTime),1)];

     %smoothSCR=[smoothEDA; mean(zEDAdata(slideTime),1)];
        GSRtime=[GSRtime; GSRtime(end)+tshift];
    end
    figure; plot (smoothSCR);
    GSRtime=GSRtime(1:end-1)+GSRtimeBin/2;

    figure;
%    plot(GSRtime,smoothEDA);
    xlabel('Time (sec)');
    ylabel('EDA (zscore)');    
    
%==========================Handles the ECoG data========================
    
    %Loads Data
    allEcogDS=downsample(rawData',round(Datafs/400))';
      maxEcog=max(max(allEcogDS));

    i = 2;
    figure;
    plot([1:size(allEcogDS(i,:),2)]/params.Fs,allEcogDS(i,:)+maxEcog*i, 'k-'); hold on;
    title (' Raw Data');
    box off; 

        
    %Notch Filter
    [b60,a60]=fir2(400,[0 55 56 57 58 59 59.5 60.5 61 62 63 64 65 200]/200,[1 1 1 1 0 0 0 0 0 0 1 1 1 1 ]);
    [b120,a120]=fir2(400,[0 119 119.5 120.5 121 200]/200,[1 1 0 0 1 1 ]);
    [b180,a180]=fir2(400,[0 179 179.5 180.5 181 200]/200,[1 1 0 0 1 1 ]);

    allEcogDS=filtfilt(b60,a60,allEcogDS')';
    display('Notch 60Hz...');
    allEcogDS=filtfilt(b120,a120,allEcogDS')';
    display('Notch 120Hz...');
    allEcogDS=filtfilt(b180,a180,allEcogDS')';
    display('Notch 180Hz...');

    %Notched+DS Data
%     figure;
%     subplot(2,1,1);
%     maxEcog=max(max(allEcogDS));
%     for i=1:size(allEcogDS,1)
%         plot([1:size(allEcogDS(i,:),2)]/params.Fs,allEcogDS(i,:)+maxEcog*i); hold on;
%     end
%     title('Notched Raw Data');
    
   figure;
    maxEcog=max(max(allEcogDS));
    for i=2 %1:size(allEcogDS,1)
        plot([1:size(allEcogDS(i,:),2)]/params.Fs,allEcogDS(i,:)+maxEcog*i); hold on;
    end
    title('Notched Raw Data');
    
    %Remove Bad Times
    if ~isempty(badIntervals) 
    badTimes=[];
    for i=1:size(badIntervals,1)
        badTimes=[badTimes round(params.Fs*badIntervals(i,1):params.Fs*badIntervals(i,2))];
    end

    allEcogDS(:,badTimes)=[];
    end
    figure; 
    %Cleaned Data
    subplot(2,1,2);
    maxEcog=max(max(allEcogDS));
    for i=1:size(allEcogDS,1)
        plot([1:size(allEcogDS(i,:),2)]/params.Fs,allEcogDS(i,:)+maxEcog*i); hold on;
    end
    title('Cleaned Data');
    
    %Only Analyze Data from chosen elecs
    chosenEcogDS=allEcogDS(chosenElecs,:);
    RefEcogDS=allEcogDS(Refs,:);
    
    %CAR
    if ~isempty(Refs)
        CARref=mean(RefEcogDS,1);
        chosenEcogDS=chosenEcogDS-repmat(CARref,size(chosenEcogDS,1),1);
    end
   
    figure;
    i = 1;
    maxEcog=max(max(chosenEcogDS));
    plot([1:size(chosenEcogDS(i,:),2)]/params.Fs,chosenEcogDS(i,:)+maxEcog*i); hold on;
    title ('CARRED RAW')
   
    %Variable Initiation
    all_zAAbinned_theta=[];
    all_zAAbinned_alpha=[];
    all_zAAbinned_beta=[];
    all_zAAbinned_lgamma=[];
    all_zAAbinned_hgamma=[]; 
    all_zAAbinned_gamma=[]; 
    
    Rtotal_theta=[];
    Rtotal_alpha=[];
    Rtotal_beta=[];
    Rtotal_lgamma=[];
    Rtotal_hgamma=[];
    Rtotal_gamma=[];
    
    Ptotal_theta=[];
    Ptotal_alpha=[];
    Ptotal_beta=[];
    Ptotal_lgamma=[];
    Ptotal_hgamma=[];
    Ptotal_gamma=[];
    
    %Generates Figures
    TimeSeries=figure;
    PowerCorr=figure;
    LagCorr=figure;
    spectFig=figure;
    periodogram = figure; 
    
    for i=1:size(chosenEcogDS,1)
%         set(gcf,'Position',[10 50 600 150]);

        [cfs,sigma_fs,hilbdata]=processingHilbertTransform_filterbankGUI_onechan(chosenEcogDS(i,:),params.Fs,params.fpass);
        
        delta_freqs=find(cfs>=delta(1) & cfs<=delta(2));
        theta_freqs=find(cfs>=theta(1) & cfs<=theta(2));
        alpha_freqs=find(cfs>=alpha(1) & cfs<=alpha(2));
        beta_freqs=find(cfs>=beta(1) & cfs<=beta(2));
        lgamma_freqs=find(cfs>=lgamma(1) & cfs<=lgamma(2));
        hgamma_freqs=find(cfs>=hgamma(1) & cfs<=hgamma(2));
        gamma_freqs=find(cfs>=gamma(1) & cfs<=gamma(2));
        
        %Plots z-scored AA
        AA=squeeze(abs(hilbdata));
        
        %Sliding Window
        smoothAA=[];
        for t=round(anxietyOnset*params.Fs):params.Fs*tshift:size(AA,1)-params.Fs*timeBin
            slideTime=t:t+params.Fs*timeBin;
            smoothAA=[smoothAA; mean(AA(slideTime,:),1)];
        end
        zsmoothAA=zscore(smoothAA,1);
        smoothTime=[0:size(zsmoothAA,1)-1]*tshift+timeBin/2;
                
        zTheta=mean(zsmoothAA(:,theta_freqs),2);
        zAlpha=mean(zsmoothAA(:,alpha_freqs),2);
        zBeta=mean(zsmoothAA(:,beta_freqs),2);
        zLGamma=mean(zsmoothAA(:,lgamma_freqs),2);
        zHGamma=mean(zsmoothAA(:,hgamma_freqs),2);
        zGamma=mean(zsmoothAA(:,gamma_freqs),2);

        figure(spectFig);
        subplot(length(chosenElecs),1,i);
        smooth=pcolor(smoothTime,cfs,zsmoothAA'); hold on;
        set(smooth,'LineStyle','none'); hold on;
        plot([0 900],[4 4],'r-'); hold on;
        plot([0 900],[8 8],'r-'); hold on;
        plot([0 900],[15 15],'r-'); hold on;
        plot([0 900],[40 40],'r-'); hold on;
        
        colorbar;
        caxis([-2 2]);
        xlabel('Time (sec)');
        ylabel('Frequency (Hz)');
        ylim([2 150]);
        title(['Spectrogram ' num2str(chosenElecs(i))]); 
        yticks([5 10 20 40 70 100 150]);
        set(gca, 'YScale', 'log');
        set(gca, 'YTickLabel', get(gca,'YTick')); hold on;
   
        % Plot the Periodogram of AA's
         figure(periodogram);
         subplot(length(chosenElecs),1,i)
    %     plot(cfs,mean(AA(anxietyTimes,:),1),'r'); hold on;
    %     plot(cfs,mean(AA(safeTimes,:),1),'b');
         plot(cfs,mean(AA,1),'b-o');hold on;
         box off
         ylabel ('mean power');
         xlabel ('Frequency');
         title (['channel ', num2str(chosenElecs(i))]);
        
        
         
        figure(TimeSeries);
        subplot(length(chosenElecs),6,6*(i-1)+1);
        plot(smoothTime,zTheta); hold on;
        plot(GSRtime,smoothEDA,'r-');
        ylabel('Theta');
        xlim([min(GSRtime) max(GSRtime)]);
        
        subplot(length(chosenElecs),6,6*(i-1)+2);
        plot(smoothTime,zAlpha); hold on;
        plot(GSRtime,smoothEDA,'r-');
        ylabel('Alpha');
        xlim([min(GSRtime) max(GSRtime)]);
        
        subplot(length(chosenElecs),6,6*(i-1)+3);
        plot(smoothTime,zBeta); hold on;
        plot(GSRtime,smoothEDA,'r-');
        ylabel('Beta');
        xlim([min(GSRtime) max(GSRtime)]);
        
    	subplot(length(chosenElecs),6,6*(i-1)+4);
        plot(smoothTime,zGamma); hold on;
        plot(GSRtime,smoothEDA,'r-'); hold on;
        ylabel('Gamma');
        xlim([min(GSRtime) max(GSRtime)]);
        
        subplot(length(chosenElecs),6,6*(i-1)+5);
        plot(smoothTime,zHGamma); hold on;
        plot(GSRtime,smoothEDA,'r-'); hold on;
        ylabel('HGamma');
        xlim([min(GSRtime) max(GSRtime)]);
        
        subplot(length(chosenElecs),6,6*(i-1)+6);
        plot(smoothTime,zLGamma); hold on;
        plot(GSRtime,smoothEDA,'r-'); hold on;
        ylabel('LGamma');
        xlim([min(GSRtime) max(GSRtime)]);
        
        figure; 
        plot(smoothTime,zGamma); hold on;
        plot(GSRtime,smoothEDA,'r-'); hold on;
        ylabel(['Gamma',num2str(i)]);
        xlim([min(GSRtime) max(GSRtime)]);
        
   
        
        figure;
        plot(smoothTime,zTheta); hold on;
        plot(GSRtime,smoothEDA,'r-');
        ylabel(['Theta',num2str(i)]);
        xlim([min(GSRtime) max(GSRtime)]);
        
         figure; 
        plot(smoothTime,zGamma); hold on;
        plot(GSRtime,smoothEDA,'r-'); hold on;
        ylabel(['Gamma/scr',num2str(i)]);
        xlim([min(GSRtime) max(GSRtime)]);
        box off;
        
        figure;
        plot(smoothTime,zTheta); hold on;
        plot(GSRtime,smoothEDA,'r-');
        ylabel(['Theta/scr',num2str(i)]);
        xlim([min(GSRtime) max(GSRtime)]);
        box off;
%         subplot(length(chosenElecs),5,5*(i-1)+4);
%         plot(smoothTime-Offset,zLGamma); hold on;
%         plot(GSRtime,smoothEDA,'r-');
%         ylabel('LGamma');
%         
%         subplot(length(chosenElecs),5,5*(i-1)+5);
%         plot(smoothTime-Offset,zHGamma); hold on;
%         plot(GSRtime,smoothEDA,'r-');
%         ylabel('HGamma');

        %Concatentes Powers across electrodes
        all_zAAbinned_theta=[all_zAAbinned_theta zTheta];
        all_zAAbinned_alpha=[all_zAAbinned_alpha zAlpha];
        all_zAAbinned_beta=[all_zAAbinned_beta zBeta];
        all_zAAbinned_lgamma=[all_zAAbinned_lgamma zLGamma];
        all_zAAbinned_hgamma=[all_zAAbinned_hgamma zHGamma];
        all_zAAbinned_gamma=[all_zAAbinned_gamma zGamma];
        
        %Theta
        figure(PowerCorr);
        subplot(length(chosenElecs),6,6*(i-1)+1);
        if length(smoothEDA)>length(zTheta)
        plot(zTheta,smoothEDA(1:length(zTheta)),'ko');
        else
        plot(zTheta(1:length(smoothEDA)),smoothEDA,'ko');
        end
        
        % plot(zTheta(1:length(smoothEDA)),smoothEDA,'ko');
        xlabel('Theta (z score)');
        ylabel('EDA (zscore)');
        

        if length(smoothEDA)>length(zTheta)
        [r_theta,p_theta]=corr(zTheta,smoothEDA(1:length(zTheta)),'Type','Spearman'); 
        else
        [r_theta,p_theta]=corr(zTheta(1:length(smoothEDA)),smoothEDA,'Type','Spearman');
        end        %[r_theta,p_theta]=corr(zTheta(1:length(smoothEDA)),smoothEDA,'Type','Spearman'); 

        title(['R: ' num2str(r_theta) ' p: ' num2str(p_theta)]);       

        if length(smoothEDA)>length(zTheta)
        [corr_theta,lags_theta]=xcorr(zTheta,smoothEDA(1:length(zTheta)), window,'coeff');
        else
        [corr_theta,lags_theta]=xcorr(zTheta(1:length(smoothEDA)),smoothEDA,window, 'coeff');
        end        %[corr_theta,lags_theta]=xcorr(zTheta(1:length(smoothEDA)),smoothEDA);

        figure(LagCorr);  
        subplot(length(chosenElecs),6,6*(i-1)+1);
        plot(lags_theta,corr_theta,'k-');
        xlabel('Lags');
        ylabel('Corr');
        
        %Alpha
        figure(PowerCorr);
        subplot(length(chosenElecs),6,6*(i-1)+2);
 if length(smoothEDA)>length(zAlpha)
        plot(zAlpha,smoothEDA(1:length(zTheta)),'ko');
        else
        plot(zAlpha(1:length(smoothEDA)),smoothEDA,'ko');
        end
        
       xlabel('Alpha (z score)');
        ylabel('EDA (zscore)');
        
        if length(smoothEDA)>length(zAlpha)
        [r_alpha,p_alpha]=corr(zAlpha,smoothEDA(1:length(zAlpha)),'Type','Spearman');
        else
       [r_alpha,p_alpha]=corr(zAlpha(1:length(smoothEDA)),smoothEDA,'Type','Spearman');
        end
        title(['R: ' num2str(r_alpha) ' p: ' num2str(p_alpha)]);    
        if length(smoothEDA)>length(zAlpha)
        [corr_alpha,lags_alpha]=xcorr(zAlpha,smoothEDA(1:length(zAlpha)), window, 'coeff');
        else[corr_alpha,lags_alpha]=xcorr(zAlpha(1:length(smoothEDA)),smoothEDA, window, 'coeff');
        end
        
       figure(LagCorr);  
        subplot(length(chosenElecs),6,6*(i-1)+2);
        plot(lags_alpha,corr_alpha,'k-');
        xlabel('Lags (s)');
        ylabel('Corr (Alpha)');
        
        %Beta
        figure(PowerCorr);
        subplot(length(chosenElecs),6,6*(i-1)+3);
        if length(smoothEDA)>length(zBeta)
        plot(zBeta,smoothEDA((1:length(zTheta))),'ko');
        else
        plot(zBeta(1:length(smoothEDA)),smoothEDA,'ko');
        end
        xlabel('Beta (z score)');
        ylabel('EDA (zscore)');

        if length(smoothEDA)>length(zBeta)
        [r_beta,p_beta]=corr(zBeta,smoothEDA(1:length(zTheta)),'Type','Spearman');
        else
        [r_beta,p_beta]=corr(zBeta(1:length(smoothEDA)),smoothEDA,'Type','Spearman');
        end
        title(['R: ' num2str(r_beta) 'p: ' num2str(p_beta)]);    
        
        if length(smoothEDA)>length(zBeta)
        [corr_beta,lags_beta]=xcorr(zBeta,smoothEDA(1:length(zBeta)),window, 'coeff');
        else
        [corr_beta,lags_beta]=xcorr(zBeta(1:length(smoothEDA)),smoothEDA, window,'coeff');
        end
        
        figure(LagCorr);  
        subplot(length(chosenElecs),6,6*(i-1)+3);
        plot(lags_beta,corr_beta,'k-');
        xlabel('Lags (s)');
        ylabel('Corr (Beta)');
        
        %Gamma
        
        figure(PowerCorr);
        subplot(length(chosenElecs),6,6*(i-1)+4);
        if length(smoothEDA)>length(zAlpha)
        plot(zGamma,smoothEDA(1:length(zTheta)),'ko');
        else
        plot(zGamma(1:length(smoothEDA)),smoothEDA,'ko');
        end
        
        xlabel('Gamma (z score)');
        ylabel('EDA (zscore)');
        
        if length(smoothEDA)>length(zAlpha)
        [r_gamma,p_gamma]=corr(zGamma,smoothEDA(1:length(zGamma)),'Type','Spearman');
        else
        [r_gamma,p_gamma]=corr(zGamma(1:length(smoothEDA)),smoothEDA,'Type','Spearman');
        end
        
        title(['R: ' num2str(r_gamma) ' p: ' num2str(p_gamma)]);  
        
        %HGamma
        
        figure(PowerCorr);
        subplot(length(chosenElecs),6,6*(i-1)+5);
        if length(smoothEDA)>length(zAlpha)
        plot(zHGamma,smoothEDA(1:length(zTheta)),'ko');
        else
        plot(zHGamma(1:length(smoothEDA)),smoothEDA,'ko');
        end
        
        xlabel('HGamma (z score)');
        ylabel('EDA (zscore)');
        
        if length(smoothEDA)>length(zAlpha)
        [r_hgamma,p_hgamma]=corr(zHGamma,smoothEDA(1:length(zHGamma)),'Type','Spearman');
        else
        [r_hgamma,p_hgamma]=corr(zHGamma(1:length(smoothEDA)),smoothEDA,'Type','Spearman');
        end
        
        title(['R: ' num2str(r_hgamma) ' p: ' num2str(p_hgamma)]);    
        
        %LGamma
        
        figure(PowerCorr);
        subplot(length(chosenElecs),6,6*(i-1)+6);
        if length(smoothEDA)>length(zAlpha)
        plot(zLGamma,smoothEDA(1:length(zTheta)),'ko');
        else
        plot(zLGamma(1:length(smoothEDA)),smoothEDA,'ko');
        end
        
        xlabel('LGamma (z score)');
        ylabel('EDA (zscore)');
        
        if length(smoothEDA)>length(zAlpha)
        [r_lgamma,p_lgamma]=corr(zLGamma,smoothEDA(1:length(zLGamma)),'Type','Spearman');
        else
        [r_lgamma,p_lgamma]=corr(zLGamma(1:length(smoothEDA)),smoothEDA,'Type','Spearman');
        end
        
        title(['R: ' num2str(r_lgamma) ' p: ' num2str(p_lgamma)]); 

        %Lagged Correlation
        
        if length(smoothEDA)>length(zGamma)
        [corr_gamma,lags_gamma]=xcorr(zGamma,smoothEDA(1:length(zGamma)),window,'coeff');
        else
       [corr_gamma,lags_gamma]=xcorr(zGamma(1:length(smoothEDA)),smoothEDA,window,'coeff');
        end
        
        figure(LagCorr);  
        subplot(length(chosenElecs),4,4*(i-1)+4);
        plot(lags_gamma,corr_gamma,'k-');
        xlabel('Lags');
        ylabel('Corr (Gamma)');
        
        %      %  plot(zAlpha(1:length(smoothEDA)),smoothEDA,'ko');
%         xlabel('Alpha (z score)');
%         ylabel('EDA (zscore)');
% 
%         [r_alpha,p_alpha]=corr(zAlpha,smoothEDA(1:length(zTheta)),'Type','Spearman');
%         %[r_alpha,p_alpha]=corr(zAlpha(1:length(smoothEDA)),smoothEDA,'Type','Spearman');
% 
%         title(['R: ' num2str(r_alpha) ' p: ' num2str(p_alpha)]);    
% 
%         [corr_alpha,lags_alpha]=xcorr(zAlpha,smoothEDA(1:length(zAlpha)));
%         %[corr_alpha,lags_alpha]=xcorr(zAlpha(1:length(smoothEDA)),smoothEDA);
% 
%         figure(LagCorr);  
%         subplot(length(chosenElecs),4,4*(i-1)+2);
%         plot(lags_alpha,corr_alpha,'k-');
%         xlabel('Lags');
%         ylabel('Corr');
%         
%         %Beta
%         figure(PowerCorr);
%         subplot(length(chosenElecs),4,4*(i-1)+3);
%         plot(zBeta,smoothEDA((1:length(zTheta))),'ko');
%        %plot(zBeta(1:length(smoothEDA)),smoothEDA,'ko');
%  
%        xlabel('Beta (z score)');
%         ylabel('EDA (zscore)');
% 
%         [r_beta,p_beta]=corr(zBeta,smoothEDA(1:length(zTheta)),'Type','Spearman');
%        %[r_beta,p_beta]=corr(zBeta(1:length(smoothEDA)),smoothEDA,'Type','Spearman');
%  
%        title(['R: ' num2str(r_beta) 'p: ' num2str(p_beta)]);    
% 
%         [corr_beta,lags_beta]=xcorr(zBeta,smoothEDA(1:length(zBeta)));
%         
%         %[corr_beta,lags_beta]=xcorr(zBeta(1:length(smoothEDA)),smoothEDA);
%         figure(LagCorr);  
%         subplot(length(chosenElecs),4,4*(i-1)+3);
%         plot(lags_beta,corr_beta,'k-');
%         xlabel('Lags');
%         ylabel('Corr');
%         
%         %Gamma
%         figure(PowerCorr);
%         subplot(length(chosenElecs),4,4*(i-1)+4);
%         plot(zGamma,smoothEDA(1:length(zTheta)),'ko');
%         %plot(zGamma(1:length(smoothEDA)),smoothEDA,'ko');
% 
%         xlabel('Gamma (z score)');
%         ylabel('EDA (zscore)');
%         
%         [r_gamma,p_gamma]=corr(zGamma,smoothEDA(1:length(zGamma)),'Type','Spearman');
%         %[r_gamma,p_gamma]=corr(zGamma(1:length(smoothEDA)),smoothEDA,'Type','Spearman');
% 
%         title(['R: ' num2str(r_gamma) ' p: ' num2str(p_gamma)]);    
% 
%         [corr_gamma,lags_gamma]=xcorr(zGamma,smoothEDA(1:length(zGamma)));
%         
%         %[corr_gamma,lags_gamma]=xcorr(zGamma(1:length(smoothEDA)),smoothEDA);
% 
%         figure(LagCorr);  
%         subplot(length(chosenElecs),4,4*(i-1)+4);
%         plot(lags_gamma,corr_gamma,'k-');
%         xlabel('Lags');
%         ylabel('Corr');
%         
%         %Low Gamma
%         subplot(length(chosenElecs),5,5*(i-1)+4);
%         plot(zLGamma(ecogIdx),smoothEDA(shimmerIdx(1:length(ecogIdx))),'ko');
%         xlabel('L Gamma (z score)');
%         ylabel('EDA (zscore)');
        
      %  [r_lgamma,p_lgamma]=corr(zLGamma(1:length(smoothEDA)),smoothEDA,'Type','Spearman');
                
%         %High Gamma
%         subplot(length(chosenElecs),5,5*(i-1)+5);
%         plot(zHGamma(ecogIdx),smoothEDA(shimmerIdx(1:length(ecogIdx))),'ko');
%         xlabel('H Gamma (z score)');
%         ylabel('EDA (zscore)');
        
       % [r_hgamma,p_hgamma]=corr(zHGamma(1:length(smoothEDA)),smoothEDA,'Type','Spearman');
        
        %Concatenate Correlation Results:
        Rtotal_theta=[Rtotal_theta r_theta];
        Rtotal_alpha=[Rtotal_alpha r_alpha];
        Rtotal_beta=[Rtotal_beta r_beta];
        Rtotal_lgamma=[Rtotal_lgamma r_lgamma];
        Rtotal_hgamma=[Rtotal_hgamma r_hgamma];
        Rtotal_gamma=[Rtotal_gamma r_gamma];
        
        Ptotal_theta=[Ptotal_theta p_theta];
        Ptotal_alpha=[Ptotal_alpha p_alpha];
        Ptotal_beta=[Ptotal_beta p_beta];
        Ptotal_lgamma=[Ptotal_lgamma p_lgamma];
        Ptotal_hgamma=[Ptotal_hgamma p_hgamma];
        Ptotal_gamma=[Ptotal_gamma p_gamma];
    end
    
    save(saveFN,'Rtotal_theta','Rtotal_alpha','Rtotal_beta','Rtotal_lgamma','Rtotal_hgamma','Rtotal_gamma',...
                'Ptotal_theta','Ptotal_alpha','Ptotal_beta','Ptotal_lgamma','Ptotal_hgamma','Ptotal_gamma',...
                'smoothTime','all_zAAbinned_theta','all_zAAbinned_alpha','all_zAAbinned_beta','all_zAAbinned_lgamma','all_zAAbinned_hgamma','all_zAAbinned_gamma',...
                'GSRtime','smoothEDA', 'corr_theta', 'lags_theta', 'corr_alpha', 'lags_alpha', 'corr_beta', 'lags_beta', 'corr_gamma', 'lags_gamma');
end    
