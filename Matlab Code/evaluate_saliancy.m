function evaluate_saliancy(bilder, durchlauf, saliancy, kontroll_kennung, patient_kennung, data_path, image_path)

    if bilder > 15 && bilder < 1; disp('Enter valid number for "bilder"!'); return; end;

    [faces, faces_m, faces_t, kont] =  Separate_test_images(image_path);

    [control_listing, patient_listing] =  Separate_test_persons(kontroll_kennung, patient_kennung, data_path);
    
    % Baue eine Liste aller Bilder, die abgearbeitet werden sollen
    image_list{1,1} = 'List of all images to use.';
    if bilder >= 8; image_list = vertcat(image_list, faces{2:end}); bilder = bilder -8; end;
    if bilder >= 4; image_list = vertcat(image_list, faces_m{2:end}); bilder = bilder -4; end;
    if bilder >= 2; image_list = vertcat(image_list, faces_t{2:end}); bilder = bilder -2; end;
    if bilder >= 1; image_list = vertcat(image_list, kont{2:end}); bilder = bilder -1; end;
    
    disp('Extract Data');
%% Alle Daten der Kontrollen heraussuchen

    data_control = 0;
    distance_control = 0;

    for b = 2:size(control_listing,1)
        if durchlauf == 1 || durchlauf == 3
            for c = 2:size(image_list,1)
                % Open .mat file
                if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', image_list{c,1} , '_1','.mat' ), 'file') > 0
                    m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', image_list{c,1} , '_1','.mat' ));
                else
                    continue
                end
                % Extrahiere alle notwendigen Daten
                clearvars Sakk_parsed Sakk_pos buf
                Sakk_parsed = m.Sakk_parsed;
                image = imread(cat(2, image_path, '/', image_list{c,1}, '.jpg'));
                image = rgb2gray(image);
                if strcmp(saliancy, 'Gray scale at saccade end point') == 1
                    Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
                    data_control = [data_control; diag(image(floor(Sakk_pos(:,2)), floor(Sakk_pos(:,1))))];
                elseif  strcmp(saliancy, 'Squared Distance to nearest Harris features at sacc end point') == 1
                    Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
                    harris = detectHarrisFeatures(image);
                    harris = harris.selectStrongest(100);
                    harris = double(harris.Location);
                    for d = 1:size(harris,1)
                        buf(:,d) = ((Sakk_pos(:,1)-harris(d,1)).^2 + (Sakk_pos(:,2)-harris(d,2)).^2);
                    end
                    distance_control = [distance_control ; min(buf, [], 2)];
                end
            end
        end
        if durchlauf == 2 || durchlauf == 3
            for c = 2:size(image_list,1)
                % Open .mat file
                if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', image_list{c,1} , '_2','.mat' ), 'file') > 0
                    m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', image_list{c,1} , '_2','.mat' ));
                else
                    continue
                end
                % Extrahiere alle notwendigen Daten
                clearvars Sakk_parsed Sakk_pos buf
                Sakk_parsed = m.Sakk_parsed;
                image = imread(cat(2, image_path, '/', image_list{c,1}, '.jpg'));
                image = rgb2gray(image);
                if strcmp(saliancy, 'Gray scale at saccade end point') == 1
                    Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
                    data_control = [data_control; diag(image(floor(Sakk_pos(:,2)), floor(Sakk_pos(:,1))))];
                elseif  strcmp(saliancy, 'Squared Distance to nearest Harris features at sacc end point') == 1
                    Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
                    harris = detectHarrisFeatures(image);
                    harris = harris.selectStrongest(100);
                    harris = double(harris.Location);
                    for d = 1:size(harris,1)
                        buf(:,d) = ((Sakk_pos(:,1)-harris(d,1)).^2 + (Sakk_pos(:,2)-harris(d,2)).^2);
                    end
                    distance_control = [distance_control ; min(buf, [], 2)];
                end
            end
        end
    end

%% Alle Daten der Patienten heraussuchen

    data_patient = 0;
    distance_patient = 0;
    
    for b = 2:size(patient_listing,1)
        if durchlauf == 1 || durchlauf == 3
            for c = 2:size(image_list,1)
                % Open .mat file
                if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', image_list{c,1} , '_1','.mat' ), 'file') > 0
                    m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', image_list{c,1} , '_1','.mat' ));
                else
                    continue
                end
                % Extrahiere alle notwendigen Daten
                clearvars Sakk_parsed Sakk_pos buf
                Sakk_parsed = m.Sakk_parsed;
                image = imread(cat(2, image_path, '/', image_list{c,1}, '.jpg'));
                image = rgb2gray(image);
                if strcmp(saliancy, 'Gray scale at saccade end point') == 1
                    Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
                    data_patient = [data_patient; diag(image(floor(Sakk_pos(:,2)), floor(Sakk_pos(:,1))))];
                elseif  strcmp(saliancy, 'Squared Distance to nearest Harris features at sacc end point') == 1
                    Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
                    harris = detectHarrisFeatures(image);
                    harris = harris.selectStrongest(100);
                    harris = double(harris.Location);
                    for d = 1:size(harris,1)
                        buf(:,d) = ((Sakk_pos(:,1)-harris(d,1)).^2 + (Sakk_pos(:,2)-harris(d,2)).^2);
                    end
                    distance_patient = [distance_patient ; min(buf, [], 2)];
                end
            end
        end
        if durchlauf == 2 || durchlauf == 3
            for c = 2:size(image_list,1)
                % Open .mat file
                if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', image_list{c,1} , '_2','.mat' ), 'file') > 0
                    m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', image_list{c,1} , '_2','.mat' ));
                else
                    continue
                end
                % Extrahiere alle notwendigen Daten
                clearvars Sakk_parsed Sakk_pos buf
                Sakk_parsed = m.Sakk_parsed;
                image = imread(cat(2, image_path, '/', image_list{c,1}, '.jpg'));
                image = rgb2gray(image);
                if strcmp(saliancy, 'Gray scale at saccade end point') == 1
                    Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
                    data_patient = [data_patient; diag(image(floor(Sakk_pos(:,2)), floor(Sakk_pos(:,1))))];
                elseif  strcmp(saliancy, 'Squared Distance to nearest Harris features at sacc end point') == 1
                    Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
                    harris = detectHarrisFeatures(image);
                    harris = harris.selectStrongest(100);
                    harris = double(harris.Location);
                    for d = 1:size(harris,1)
                        buf(:,d) = ((Sakk_pos(:,1)-harris(d,1)).^2 + (Sakk_pos(:,2)-harris(d,2)).^2);
                    end
                    distance_patient = [distance_patient ; min(buf, [], 2)];
                end
            end
        end
    end

%% Auswertung

    disp('Evaluate Data');
    
    data_patient(1) = [];
    data_control(1) = [];
    distance_patient(1) = [];
    distance_control(1) = [];
    
    data_patient = double(data_patient');
    data_control = double(data_control');
    
    if strcmp(saliancy, 'Gray scale at saccade end point') == 1
        threshold = 1:1:255;
        figure(1)
        hold on; grid on;
        histogram(data_control,100);
        histogram(data_patient,100);
        legend('Control', 'Patient')
        xlabel('gray scale values')
        ylabel('# saccades');
        
        anz(1) = size(data_patient,2);
        anz(2) = size(data_control,2);
%         % classifier: everything smaller than a threshold is patient. 
%         for a = 1:255
%             TPR(a) = size(data_patient(data_patient < threshold(a)),2) / anz(1);
%             FPR(a) = size(data_control(data_control < threshold(a)),2) / anz(2);
%         end

        % classifier: everything higher than a threshold is patient. 
        for a = 1:size(threshold,2)
            TPR(a) = size(data_patient(data_patient > threshold(a)),2) / anz(1);
            FPR(a) = size(data_control(data_control > threshold(a)),2) / anz(2);
        end
        figure(2)
        hold on; grid on;
        plot(FPR,TPR);
        plot([0 1], [0 1],'k')
        legend('ROC-curve');
        xlabel('False Positive Rate (%)');
        ylabel('True Positive Rate (%)');
    elseif strcmp(saliancy, 'Squared Distance to nearest Harris features at sacc end point') == 1
        threshold = 1:5:max([distance_control;distance_patient]);
        figure(1)
        hold on; grid on;
        histogram(distance_control,100);
        histogram(distance_patient,100);
        legend('Control', 'Patient')
        xlabel('Squared Distance to nearest Harris features at sacc end point')
        ylabel('# saccades');
        anz(1) = size(distance_patient,1);
        anz(2) = size(distance_control,1);
        
%         % classifier: everything smaller than a threshold is patient. 
%         anz(1) = size(distance_patient,1);
%         anz(2) = size(distance_control,1);
%         for a = 1:size(threshold,2)
%             TPR(a) = size(distance_patient(distance_patient > threshold(a)),1) / anz(1);
%             FPR(a) = size(distance_control(distance_control > threshold(a)),1) / anz(2);
%         end

        % classifier: everything higher than a threshold is patient. 
        for a = 1:size(threshold,2)
            TPR(a) = size(distance_patient(distance_patient > threshold(a)),1) / anz(1);
            FPR(a) = size(distance_control(distance_control > threshold(a)),1) / anz(2);
        end
        figure(2)
        hold on; grid on;
        plot(FPR,TPR);
        plot([0 1], [0 1],'k')
        legend('ROC-curve');
        xlabel('False Positive Rate (%)');
        ylabel('True Positive Rate (%)');
    end
end