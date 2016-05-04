
function map = makeSaliencyMap_NSS( X , Y, map_size )

    sigma = [28 0; 0 28];
    x1 = 1:65;
    [X1,X2] = meshgrid(x1,x1);
    F = mvnpdf([X1(:) X2(:)],[floor(mean(x1)) floor(mean(x1))] ,sigma);
    F  = reshape(F,length(x1),length(x1));
    
    map = zeros( map_size(1)+64, map_size(2)+64);

    X = floor(X);
    Y = floor(Y);
    X(X==0) = 1;
    Y(Y==0) = 1;
    
    for i = 1 : length(X)
      map( Y(i):Y(i)+64 , X(i):X(i)+64 ) = map( Y(i):Y(i)+64 , X(i):X(i)+64 ) + F;
    end
    
    map = map(33:end-32,33:end-32);
    map = map./sum(trapz(map));
end