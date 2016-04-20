function out = H_disttoHarrisedges( fparam, img , imgR, imgG, imgB, typeidx )

if ( nargin == 1 )

  out.weight = fparam.harrisWeight;
  
  out.numtypes = 2;
  out.descriptions{1} = 'Distance to Harris edges';

else
    harris = detectHarrisFeatures(img);
    harris = harris.selectStrongest(100);
    harris = double(harris.Location);
    [X1,X2] = meshgrid(1:size(img, 1),1:size(img, 2));
    
    buf = mvnpdf([X1(:) X2(:)], harris(1,:), [10 2; 2 10]);
    F = reshape(buf,size(img, 1),size(img, 2));
    out.map = F;
    for a = 2:size(harris,1)
        buf = mvnpdf([X1(:) X2(:)], harris(a,:), [10 2; 2 10]);
        F = reshape(buf,size(img, 1),size(img, 2));
        out.map = out.map + F;
    end
end
