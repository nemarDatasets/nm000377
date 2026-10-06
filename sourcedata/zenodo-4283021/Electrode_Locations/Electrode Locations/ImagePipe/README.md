# Matlab-Plotting-

### This repositiory contains all Matlab plotting scripts

Here are the instructions on how to plot the brain:
 
In this repository I have provided you with the following matlab scripts:
### make_roi_mesh.m:
a script that makes anatomical meshes
### ctmr_gauss_plot.m:
plots the brain
### plot_brain.m :
a script that plots the brain and different anatomical meshes in different colors
### el_add.m:
simply used to add electrode matrix to the brain

Packages:
### ctmr_gauss_plot
For plotting purposes

### cbrewer
This function loads colormaps based on the color brewer schemes
 
 
### Instructions on how to plot/make meshes:
All meshes you need should already be made, but just in case:
1. Change the fsdir in the make_roi_mesh.m file to wherever you have your imaging data for the MNI brain
2. Then you would do something like this: >> make_roi_mesh('cvs_avg35_inMNI152', 'lh', {'superiortemporal'}, 'STG')
      - Make sure the name matches the name in the labels/meshes folder 
3. The output file would be ‘cvs_avg35_inMNI152_lh_STG_pial.mat’
4. When you are finished making the meshes and loading them into your workspace, you can use plot_brain_MBL to plot the brain    with different colors
5. To add the electrodes, you simply use el_add(elecmatrix), you can change the color of the electrodes, the thickness of the outline and the size/shape of each plotted point by using something like this:
      - el_add(elecmatrix([277:282],:),'color','y','msize',6, 'edgecol', ‘k’, 'numbers', [],'LineWidth', 0.02)
