function out = A_AOI( fparam, img , imgR, imgG, imgB, typeidx )

if ( nargin == 1 )

  out.weight = fparam.AOIWeight;
  
  out.numtypes = 2;
  out.descriptions{1} = 'AOI';

else
    
    
    image_AOI = imread(cat(2, fparam.imagePath, fparam.imageName, '_AOI.jpg'));
    image_size = fparam.imageSize;
    image_size = image_size(1:2);
    image_AOI = imresize(image_AOI, image_size);
    image_AOI = double(image_AOI);
    
    levels =  2 : fparam.maxcomputelevel ;

    
%     imgR_AOI{1} = mySubsample(image_AOI(:,:,1)); 
%     imgG_AOI{1} = mySubsample(image_AOI(:,:,2)); 
%     imgB_AOI{1} = mySubsample(image_AOI(:,:,3));
    [imgr,imgg,imgb,imgi] = mygetrgb( image_AOI );
    imgR_AOI{1} = mySubsample(imgr); imgG_AOI{1} = mySubsample(imgg); imgB_AOI{1} = mySubsample(imgb);
    if size(imgR_AOI{1}) == size(img)
        image(:, :,1) = imgR_AOI{1};
        image(:, :,2) = imgG_AOI{1};
        image(:, :,3) = imgB_AOI{1};
    else
        for i=levels
            imgR_AOI{i} = mySubsample( imgR_AOI{i-1} );
            imgG_AOI{i} = mySubsample( imgG_AOI{i-1} );
            imgB_AOI{i} = mySubsample( imgB_AOI{i-1} );
            if size(imgR_AOI{i}) == size(img)
                image(:, :,1) = imgR_AOI{i};
                image(:, :,2) = imgG_AOI{i};
                image(:, :,3) = imgB_AOI{i};
                break; 
            end; 
        end
    end
   
    out.map = zeros(size(img,1), size(img,2));
    out.map(image(:, :,2) < 20 & image(:, :,3) < 20) = 0.66; % rot = Auge links
    out.map(image(:, :,3) < 20 & image(:, :,1) > 235 & image(:, :,2) > 235) = 0.66; % gelb = Auge rechts
    out.map(image(:, :,1) < 20 & image(:, :,3) < 20) = 1; % grün = Mund
    out.map(image(:, :,1) < 20 & image(:, :,2) < 20) = 0.5; % blau = Nase
end