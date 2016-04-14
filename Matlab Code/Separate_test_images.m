% image_path = absolute or relative path of the folder containing all images

function [faces, faces_m, faces_t, kont] =  Separate_test_images(image_path)

%% Aufteilen der Bilder in faces, faces_m, faces_t und sonstige

    image_listing = dir(image_path);
    image_listing = image_listing([image_listing.isdir] == 0,:);
    faces{1,1} = 'only normal faces';
    faces_m{1,1} = 'binary faces';
    faces_t{1,1} = 'binary upside down faces';
    kont{1,1} = 'anything else';
    buf2 = 0;
    for a = 1:size(image_listing,1)
        if isempty(regexp(image_listing(a,1).name, '[d u][0-9]+.jpg', 'once')) == 0 ... % normal faces
        || isempty(regexp(image_listing(a,1).name, 'Noh_Maske_test[0-9]+.jpg', 'once')) == 0 ...
        || isempty(regexp(image_listing(a,1).name, 'front.jpg', 'once')) == 0
        
            faces{size(faces,1)+1,1} = image_listing(a,1).name(1:end-4);
            buf2 = 1;
        end
        if isempty(regexp(image_listing(a,1).name, '[d u][0-9]+m.jpg', 'once')) == 0 ...  % binary faces
        || isempty(regexp(image_listing(a,1).name, 'Noh_Maske_test[0-9]+_m.jpg', 'once')) == 0 ...
        || isempty(regexp(image_listing(a,1).name, 'frontm.jpg', 'once')) == 0
        
            faces_m{size(faces_m,1)+1,1} = image_listing(a,1).name(1:end-4);
            buf2 = 1;
        end
        if isempty(regexp(image_listing(a,1).name, '[d u][0-9]+t.jpg', 'once')) == 0 ... % binary upside down faces
        || isempty(regexp(image_listing(a,1).name, 'Noh_Maske_test[0-9]+_t.jpg', 'once')) == 0 ...
        || isempty(regexp(image_listing(a,1).name, 'frontt.jpg', 'once')) == 0
    
            faces_t{size(faces_t,1)+1,1} = image_listing(a,1).name(1:end-4);
            buf2 = 1;
        end
        if buf2 == 0 % anything else
            kont{size(kont,1)+1,1} = image_listing(a,1).name(1:end-4); 
        end
        buf2 = 0;
    end

end