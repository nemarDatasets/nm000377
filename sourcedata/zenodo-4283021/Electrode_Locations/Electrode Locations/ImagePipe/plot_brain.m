%PLOT BRAIN
%Morgan Lee Feb 2017
%plot all of the meshes you want, make them different colors


hold on
%lighting will be set from L or R depending on hem
hem = 'rh';

%this plots the right hemisphere
c_h = ctmr_gauss_plot(lh, [0 0 0], 0, 'lh', 1); 
c_h1 = ctmr_gauss_plot(rh, [0 0 0], 0, 'rh', 1); 
%this plots the lh and rh, load this in from 
%data_store2/imaging/subjects/meshes and rename to 'rh' and 'lh'

% % this plots the specified brain regions (probably default loads as cortex so rename it to
% % that region (do this for all the things you want to plot and leave the
% % whole brain as cortex)

%Plot insula 
ins_handle = ctmr_gauss_plot(insula, [0 0 0], 0, hem, 0); 

%plot hippo
lhipp_handle = ctmr_gauss_plot(lHD, [0 0 0], 0, hem, 0);
rhipp_handle = ctmr_gauss_plot(rHD, [0 0 0], 0, hem, 0);

%plot cingulate
cing_handle = ctmr_gauss_plot(lcing, [0 0 0], 0, hem, 0); 
rcing_handle = ctmr_gauss_plot(rcing, [0 0 0], 0, hem, 0); 

%plot Amygdala
lamyg_handle = ctmr_gauss_plot(lAmyg, [0 0 0], 0, hem, 0);
ramyg_handle = ctmr_gauss_plot(rAmyg, [0 0 0], 0, hem, 0);

%plot insula
ins_handle = ctmr_gauss_plot(lin, [0 0 0], 0, hem, 0); 
rins_handle = ctmr_gauss_plot(rin, [0 0 0], 0, hem, 0); 

%plot subtemporal
subtemp_handle = ctmr_gauss_plot(subtemporal, [0 0 0], 0, hem, 0); 

%plot ofc
ofc_handle = ctmr_gauss_plot(lOFC, [0 0 0], 0, hem, 0); 
rofc_handle = ctmr_gauss_plot(rOFC, [0 0 0], 0, hem, 0); 

hg_handle = ctmr_gauss_plot(HG, [0 0 0], 0, hem, 0); 


% set the appearance of all the meshes
% need edgecolor to make a colored triangle mesh, get rid of it if you don't
% want triangles

edge alpha for all
ea = .3;
face alpha for all
fa = .2;

set (c_h, 'EdgeAlpha', .5, 'FaceAlpha', .2); 
set (c_h, 'EdgeAlpha', .5, 'FaceAlpha', .2);

set (lhipp_handle, 'FaceColor', 'y','EdgeColor','y', 'FaceAlpha', fa,'EdgeAlpha', ea);
set (rhipp_handle, 'FaceColor', 'y','EdgeColor','y', 'FaceAlpha', fa,'EdgeAlpha', ea);

set (ins_handle, 'FaceColor', 'b', 'EdgeColor','b','FaceAlpha', fa,'EdgeAlpha', ea);
set (rins_handle, 'FaceColor', 'b', 'EdgeColor','b','FaceAlpha', fa,'EdgeAlpha', ea);

set (lamyg_handle, 'FaceColor', 'c', 'EdgeColor','c','FaceAlpha', fa,'EdgeAlpha', ea);
set (ramyg_handle, 'FaceColor', 'c', 'EdgeColor','c','FaceAlpha', fa,'EdgeAlpha', ea);


set (cing_handle,  'EdgeColor','m','FaceAlpha', fa,'EdgeAlpha', ea);
set (rcing_handle,  'EdgeColor','m','FaceAlpha', fa,'EdgeAlpha', ea);

set (subtemp_handle, 'FaceColor', 'y', 'EdgeColor','y','FaceAlpha', fa,'EdgeAlpha', ea);

set (ofc_handle, 'FaceColor', 'g', 'EdgeColor','g','FaceAlpha', fa,'EdgeAlpha', ea);
set (rofc_handle, 'FaceColor', 'g', 'EdgeColor','g','FaceAlpha', fa,'EdgeAlpha', ea);

set (hg_handle, 'FaceColor', 'g', 'EdgeColor','g','FaceAlpha', fa,'EdgeAlpha', ea);

%view(115, -5);

%background white
set(gcf,'color','w');



