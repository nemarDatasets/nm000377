%MAKE MESH
%by Liberty Hamilton, altered by Morgan Lee Feb 2017

%can make a mesh of any freesurfer surface 

%must have rh or lh EC##_##_pial.mat loaded as cortex
%change label_list to make what you want
%must have gyri folder in label dir from mri_annotation2label


function make_mesh(subj, hem, cortex)
%make_mesh('EC##','rh',cortex);

subjdir = sprintf('/Users/alia/Documents/dura/data_store2/imaging/subjects/%', subj);
recondir = sprintf('%s/Meshes', subjdir); 
labeldir = sprintf('%/scvs_avg35_inMNI152/label/gyri', subjdir);

area = 'frontal';

% pick any combo of labels from gyri folder to make a mesh from
    %label_list = {'superiortemporal'};
    %label_list = {'lateralorbitofrontal','medialorbitofrontal','parsorbitalis'};
    %label_list = {'rostralanteriorcingulate','caudalanteriorcingulate', 'posteriorcingulate'};
    %label_list = {'fusiform', 'entorhinal', 'parahippocampal'};
    %label_list = {'insula'};
    %label_list = {'parstriangularis','parsopercularis', 'parsorbitalis', 'lateralorbitofrontal', 'rostralmiddlefrontal', 'caudalmiddlefrontal', 'precentral', 'superiorfrontal'}
    %label_list = {'transversetemporal','superiortemporal','bankssts','middletemporal','inferiortemporal','inferiorparietal','lateraloccipital','fusiform','cuneus', 'pericalcarine','lingual','parahippocampal','entorhinal','temporalpole'};
    %label_list = {'transversetemporal','superiortemporal','bankssts',...
    %'middletemporal','inferiortemporal',...
    %'temporalpole','fusiform'};
    
% change the name depending on the mesh you are making
outfile = sprintf('%s/%s_%s_%s_pial.mat', recondir, subj, hem, area);

if 1%~exist(outfile, 'file')
    if isempty(cortex)
        cortex = get_fsbrain_image(subj, hem);
    end
    pial_surf = struct();
    pial_surf.cortex = cortex;
    %pial_surf = load(sprintf('%s/%s_%s_pial.mat', recondir, subj, hem));
    ofc = struct();
    ofc.tri = [];
    ofc.vert = [];
    vertnums = [];
    for lab = 1:length(label_list)
        this_label = sprintf('%s/%s.%s.label', labeldir, hem, label_list{lab})
        fid=fopen(this_label);
        C = textscan(fid, '%f %f %f %f %f','Headerlines',2);
        verts = C{1}+1;
        
        % Find the vertices and add them to the ofc lobe vertices
        vertnums = [verts; vertnums];
        fclose(fid);
    end
    
    % Sort the vertices so they're drawn in the correct order
    vertnums = sort(vertnums);
    ofc.vert = pial_surf.cortex.vert(vertnums,:);
    
    vnum_new = 1:length(vertnums); % Index of the vertex (new, relative to ofc lobe)
    tri_list = [];
    % Find the triangles for these vertex numbers
    tri_row_inds = find(sum(ismember(pial_surf.cortex.tri, vertnums),2)==3);
    tri_list = pial_surf.cortex.tri(tri_row_inds,:);
    
    [i,j]=ismember(tri_list,vertnums);
    
    ofc.tri=j;
    
    fprintf(1,'Saving mesh %s\n', outfile);
    
    frontal = ofc;
    
    save(outfile, sprintf('%s',area));
else
    load(outfile)
end


