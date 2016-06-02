function out = B_brisk( fparam, img , imgR, imgG, imgB, typeidx )

if ( nargin == 1 )

  out.weight = fparam.briskWeight;
  
  out.numtypes = 2;
  out.descriptions{1} = 'Distance to BRSIK edges';

else
    brisk = detectBRISKFeatures(img);
    brisk = brisk.selectStrongest(100);
    brisk = double(brisk.Location);
    [X1,X2] = meshgrid(1:size(img, 2),1:size(img, 1));
    if isempty(brisk) == 1
        out.map = zeros(size(img, 1),size(img, 2));
        return;
    else
        buf = mvnpdf([X1(:) X2(:)], brisk(1,:), [10 0; 0 10]);
        F = reshape(buf,size(img, 1),size(img, 2));
        out.map = F;
    end
    for a = 2:size(brisk,1)
        buf = mvnpdf([X1(:) X2(:)], brisk(a,:), [10 0; 0 10]);
        F = reshape(buf,size(img, 1),size(img, 2));
        out.map = out.map + F;
    end
end
