function out = B_fast( fparam, img , imgR, imgG, imgB, typeidx )

if ( nargin == 1 )

  out.weight = fparam.fastWeight;
  
  out.numtypes = 2;
  out.descriptions{1} = 'Distance to FAST edges';

else
    fast = detectFASTFeatures(img);
    fast = fast.selectStrongest(100);
    fast = double(fast.Location);
    [X1,X2] = meshgrid(1:size(img, 1),1:size(img, 2));
    if isempty(fast) == 1
        out.map = zeros(size(img, 1),size(img, 2));
        return;
    else
        buf = mvnpdf([X1(:) X2(:)], fast(1,:), [10 0; 0 10]);
        F = reshape(buf,size(img, 1),size(img, 2));
        out.map = F;
    end
    for a = 2:size(fast,1)
        buf = mvnpdf([X1(:) X2(:)], fast(a,:), [10 0; 0 10]);
        F = reshape(buf,size(img, 1),size(img, 2));
        out.map = out.map + F;
    end
end
