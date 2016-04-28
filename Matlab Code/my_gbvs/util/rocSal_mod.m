
function [p, area] = rocSal_mod( salmap , mask )

%     ROC area agreement between saliency map (salmap) and fixations (mask) 
% == good measure of HOW WELL salmap 'predicts' fixations
%
% - mask is the same size as salmap and contains number of fixations at each map location ( 0,1,2,..etc. )
%   map and salmap can also be an array of cells containing same number of maps as salmap
%   map, salmap 2nd dimenson = 2, 1st = control, 2nd = patient
%
% - gives the ROC curve and score of the following binary classification problem 
%
%   separate patients from controls
%
% % % % % %   a true positive occurs (TP)
% % % % % %      when a (patient, fixation,location) pair is above threshold
% % % % % %   a true negative occurs (TN)
% % % % % %      when a (control fixation,location) pair is below threshold
% % % % % %   a false negative occurs (FN)
% % % % % %      when a (patient fixation,location) pair is below threshold
% % % % % %   a false positive occurs (FP)
% % % % % %      when a (control fixation,location) pair is above threshold
%
%   ROC curve plots TPR against FPR
%    where TPR = TP / (TP+FN) = TP / (number of ground-truth trues)
%          FPR = FP / (FP+TN) = FP / (number of ground-truth falses)
%


t = 1:255;
Nt = 255;
p = zeros(Nt,2);
Ntrues = 0;
Nfalses = 0;
TP = zeros(Nt,1);
FP = zeros(Nt,1);
for a = 1:size(salmap,1)
    % limit to 256 unique values
    saliency_map_cotrol = mat2gray(salmap{a,1});
    saliency_map_patient = mat2gray(salmap{a,2});
    if ( strcmp(class(saliency_map_cotrol),'double') )
        saliency_map_cotrol = uint8(saliency_map_cotrol * 255);
    end
    if ( strcmp(class(saliency_map_patient),'double') )
        saliency_map_patient = uint8(saliency_map_patient * 255);
    end

    Ntrues = Ntrues + sum(mask{a,2}(:)); 

    Nfalses = Nfalses + sum(mask{a,1}(:));    
    if ( Nfalses == 0 ) Nfalses = 1e-6; end
    
    for ti = 1 : Nt  
        T = t(ti); 
        tmp = saliency_map_patient >= T;    
        TPm = mask{a,2} .* tmp;
        TP(ti) = TP(ti) + sum( TPm(:) );
        tmp = saliency_map_cotrol >= T; 
        FPm = mask{a,1} .* tmp;
        FP(ti) = FP(ti) + sum( FPm(:) );
    end
end

tpr = TP / Ntrues;
fpr = FP / Nfalses;
p = [ tpr fpr ];
area = areaROC(p);