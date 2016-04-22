function out = S_saturation( fparam , img , imgR, imgG, imgB, typeidx )

if ( nargin == 1)  
  out.weight = fparam.saturationWeight;
  out.numtypes = 1;
  out.descriptions{1} = 'saturation';    
else
  image_color(:,:,1) = imgR;
  image_color(:,:,2) = imgG;
  image_color(:,:,3) = imgB;
  hsv_image = rgb2hsv(image_color);
  out.map = hsv_image(:,:,2);
end
