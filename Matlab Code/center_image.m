% x_pos = x-Komponente von Sakkaden
% y_pos = y-Komponente von Sakkaden
% param1 - 4 = Komponenten, die mit der Position verarbeitet werden müssen ==> kann durch '-' ersetzt werden, wenn keine Information vorhanden. 


function Sakk_pos = center_image(x_pos, y_pos, param1, param2, param3, param4, x_image, y_image)

    % Center gaze data
    Sakk_pos = [(x_pos - 640) (y_pos - 512) ];
    
    % Add optional parameters 
    if strcmp(param1, '-') == 0; Sakk_pos = [Sakk_pos param1]; end; 
    if strcmp(param2, '-') == 0; Sakk_pos = [Sakk_pos param2]; end; 
    if strcmp(param3, '-') == 0; Sakk_pos = [Sakk_pos param3]; end; 
    if strcmp(param4, '-') == 0; Sakk_pos = [Sakk_pos param4]; end;
    
    % Remove saccades outside the image boundaries
    Sakk_pos = Sakk_pos(Sakk_pos(:,1) > -x_image/2,:);
    Sakk_pos = Sakk_pos(Sakk_pos(:,1) < x_image/2,:);

    Sakk_pos = Sakk_pos(Sakk_pos(:,2) > -y_image/2,:);
    Sakk_pos = Sakk_pos(Sakk_pos(:,2) < y_image/2,:);
    
    % Shift image to supposed position
    Sakk_pos(:,1) = Sakk_pos(:,1) + x_image/2;
    Sakk_pos(:,2) = Sakk_pos(:,2) + y_image/2;
    
    % Round to get pixel
    Sakk_pos(:,1:2) = floor(Sakk_pos(:,1:2));
    Sakk_pos(Sakk_pos==0) = 1;
end