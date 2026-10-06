
load ForMelis.mat

figure;
hem = 'rh' ; % 'rh' depending on the view you want to have. e.g 'rh' will show you left hemisphere from the inside (right).

c_h = ctmr_gauss_plot(lh, [0 0 0], 0, hem, 1); 
%c_h1 = ctmr_gauss_plot(rh, [0 0 0], 0, hem, 1);

%% Meshes for all mesolimbic structures


%Lins_handle = ctmr_gauss_plot(lIns, [0 0 0], 0, hem, 0); 
%Rins_handle = ctmr_gauss_plot(rIns, [0 0 0], 0, hem, 0); 

% 
%plot hippo
%lhipp_handle = ctmr_gauss_plot(lHipp, [0 0 0], 0, hem, 0);
%rhipp_handle = ctmr_gauss_plot(rHipp, [0 0 0], 0, hem, 0);
% 
%plot cingulate
%lcing_handle = ctmr_gauss_plot(lCing, [0 0 0], 0, hem, 0); 
%rcing_handle = ctmr_gauss_plot(rCing, [0 0 0], 0, hem, 0); 
% 
%plot Amygdala
%lamyg_handle = ctmr_gauss_plot(lAmyg, [0 0 0], 0, hem, 0);
%ramyg_handle = ctmr_gauss_plot(rAmyg, [0 0 0], 0, hem, 0);
% 
%plot insula
%lins_handle = ctmr_gauss_plot(lIns, [0 0 0], 0, hem, 0); 
rins_handle = ctmr_gauss_plot(rIns, [0 0 0], 0, hem, 0); 

%plot OFC
%lOFC_handle = ctmr_gauss_plot(lOFC, [0 0 0], 0, hem, 0); 
rOFC_handle = ctmr_gauss_plot(rOFC, [0 0 0], 0, hem, 0); 


ea = .05;
%face alpha for all
fa = .03;
%---- colors for each mesh 
p1 = [224/255 174/255 114/255]; %hipp
p2 = [70/255 130/255 180/255]; % ofc
p3 = [0/255 0/255 102/255]; %cing
p5 = [248/255 213/255 104/255]; %ins
p6 = [0/255 153/255 153/255]; %amyg

set (c_h, 'EdgeAlpha', .3, 'FaceAlpha', .1); 
%set (c_h1, 'EdgeAlpha', .3, 'FaceAlpha', .1);
% 

% hippocampus
   %set (lhipp_handle, 'FaceColor', p1,'EdgeColor',p1, 'FaceAlpha', fa,'EdgeAlpha', ea);
  % set (rhipp_handle, 'FaceColor', p1,'EdgeColor',p1, 'FaceAlpha', fa,'EdgeAlpha', ea);

% 
%cingulate
   % set (lcing_handle,  'EdgeColor',p3,'FaceAlpha', fa,'EdgeAlpha', ea);
   % set (rcing_handle,  'EdgeColor',p3,'FaceAlpha', fa,'EdgeAlpha', ea);


%  Amygdala

   % set (lamyg_handle, 'FaceColor', p6, 'EdgeColor',p6,'FaceAlpha', fa,'EdgeAlpha', ea);
    %set (ramyg_handle, 'FaceColor', p6, 'EdgeColor',p6,'FaceAlpha', fa,'EdgeAlpha', ea);


% insula
  % set (lins_handle, 'FaceColor', p5, 'EdgeColor',p5,'FaceAlpha', fa,'EdgeAlpha', 0.5);
    set (rins_handle, 'FaceColor', p5, 'EdgeColor',p5,'FaceAlpha', fa,'EdgeAlpha', 0.5);


% OFC
    %set (lOFC_handle, 'FaceColor', p2, 'EdgeColor',p2,'FaceAlpha', fa,'EdgeAlpha', 0.5);
   set (rOFC_handle, 'FaceColor', p2, 'EdgeColor',p2,'FaceAlpha', fa,'EdgeAlpha', 0.7);

    
    
    %% load TDT_Elecs_All_Warped for EC205
    load('EC 205_TDT_elecs_all_warped.mat')
%     add CIN1 Index = 33
    %Ind = 33    
    %el_add(elecmatrix(Ind,:),'color',[1 1 1], 'msize',8, 'color',[0 0 0], 'edgecol',[1 1 1], 'numbers', [],'LineWidth', 0.1); % Make the last one white so we can over write the color 

%     add OFC1 1:10 
  Ind = [12 14] %205
   el_add(elecmatrix(Ind,:),'color',[1 1 1], 'msize',8, 'color',[0 0 0], 'edgecol',[1 1 1], 'numbers', [12 14],'LineWidth', 0.1); % Make the last one white so we can over write the color 
%     % add insula 205
  %Ind = [21] %205
   %el_add(elecmatrix(Ind,:),'color',[1 1 1], 'msize',8, 'color',[0 0 0], 'edgecol',[1 1 1], 'numbers', [],'LineWidth', 0.1); % Make the last one white so we can over write the color 
%    
%Ind = [98:99] %200 OFC
%el_add(elecmatrix(Ind,:),'color',[1 1 1], 'msize',8, 'color',[0 0 0], 'edgecol',[1 1 1], 'numbers', [98 99],'LineWidth', 0.1); % Make the last one white so we can over write the color 
   
   % add insula 192 they are Left
 %Ind = [2 3] ; %add 53 and 54 
 %el_add(elecmatrix(Ind,:),'color',[1 1 1], 'msize',8, 'color',[0 0 0], 'edgecol',[1 1 1], 'numbers', [],'LineWidth', 0.1); % Make the last one white so we can over write the color 
