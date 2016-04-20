% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% saliancy: Auswahl im PopupMenü der Gui
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images


function evaluate_saliency(bilder, durchlauf, saliency_params, kontroll_kennung, patient_kennung, data_path, image_path)

    if bilder > 15 || bilder < 1; disp('Enter valid number for "bilder"!'); return; end;

    [faces, faces_m, faces_t, kont] =  Separate_test_images(image_path);

    [control_listing, patient_listing] =  Separate_test_persons(kontroll_kennung, patient_kennung, data_path);
    
    % Baue eine Liste aller Bilder, die abgearbeitet werden sollen
    image_list{1,1} = 'List of all images to use.';
    if bilder >= 8; image_list = vertcat(image_list, faces{2:end}); bilder = bilder -8; end;
    if bilder >= 4; image_list = vertcat(image_list, faces_m{2:end}); bilder = bilder -4; end;
    if bilder >= 2; image_list = vertcat(image_list, faces_t{2:end}); bilder = bilder -2; end;
    if bilder >= 1; image_list = vertcat(image_list, kont{2:end}); bilder = bilder -1; end;
    
    for z = 2:size(image_list,1)
        image = cat(2, image_path, '/', image_list{z,1}, '.jpg');
        saliency_map(z) = gbvs(image, saliency_params);
        image_size(z,:) = size(saliency_map(z).master_map_resized);
    end
    
    
    disp('Extract Data');
%% Alle Daten der Kontrollen heraussuchen

    counter = 1;
%     gray_scale_control = 0;
%     distance_control = 0;
%     Sakk_pos_control = cell(size(image_list,1),1);

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
                clearvars Sakk_parsed Sakk_pos
                Sakk_parsed = m.Sakk_parsed;
                Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', image_size(c,2), image_size(c,1));
                Sakk_pos_control{c,1} = Sakk_pos;
                map{counter,1} = saliency_map(c).master_map_resized;
                mask{counter,1} = makeFixationMask( Sakk_pos(:,1) , Sakk_pos(:,2) , size(map{counter}) , size(map{counter}) );
%                 rocSal(map{counter,1}, mask{counter,1})
                counter = counter +1;
                
%                 % 5. saliency
%                     Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
%                     Sakk_pos(Sakk_pos < 1) = 1;
%                     Sakk_pos = diag(image(floor(Sakk_pos(:,2)), floor(Sakk_pos(:,1))));
%                     gray_scale_control = [gray_scale_control; Sakk_pos];
%                 % 4. saliency
%                     Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
%                     harris = detectHarrisFeatures(image);
%                     harris = harris.selectStrongest(100);
%                     harris = double(harris.Location);
%                     for d = 1:size(harris,1)
%                         buf(:,d) = ((Sakk_pos(:,1)-harris(d,1)).^2 + (Sakk_pos(:,2)-harris(d,2)).^2);
%                     end
%                     distance_control = [distance_control ; min(buf, [], 2)];
%                 % third saliency
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
                clearvars Sakk_parsed Sakk_pos
                Sakk_parsed = m.Sakk_parsed;
                Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', image_size(c,2), image_size(c,1));
                Sakk_pos_control{c,1} = Sakk_pos;
                map{counter,1} = saliency_map(c).master_map_resized;
                mask{counter,1} = makeFixationMask( Sakk_pos(:,1) , Sakk_pos(:,2) , size(map{counter}) , size(map{counter}) );
%                 rocSal(map{counter,1}, mask{counter,1})
                counter = counter +1;
                
%                 % 5. saliency
%                     Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
%                     Sakk_pos(Sakk_pos < 1) = 1;
%                     Sakk_pos = diag(image(floor(Sakk_pos(:,2)), floor(Sakk_pos(:,1))));
%                     gray_scale_control = [gray_scale_control; Sakk_pos];
%                 % 4. saliency
%                     Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
%                     harris = detectHarrisFeatures(image);
%                     harris = harris.selectStrongest(100);
%                     harris = double(harris.Location);
%                     for d = 1:size(harris,1)
%                         buf(:,d) = ((Sakk_pos(:,1)-harris(d,1)).^2 + (Sakk_pos(:,2)-harris(d,2)).^2);
%                     end
%                     distance_control = [distance_control ; min(buf, [], 2)];
%                 % Third saliency
            end
        end
    end

%% Alle Daten der Patienten heraussuchen

    counter = 1;
%     gray_scale_patient = 0;
%     distance_patient = 0;
%     Sakk_pos_patient = cell(size(image_list,1),1);

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
                clearvars Sakk_parsed Sakk_pos
                Sakk_parsed = m.Sakk_parsed;
                Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', image_size(c,2), image_size(c,1));
                Sakk_pos_control{c,1} = Sakk_pos;
                map{counter,2} = saliency_map(c).master_map_resized;
                mask{counter,2} = makeFixationMask( Sakk_pos(:,1) , Sakk_pos(:,2) , size(map{counter}) , size(map{counter}) );
%                 rocSal(map{counter,2}, mask{counter,2})
                counter = counter +1;
                
%                 % 5. saliency
%                     Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
%                     Sakk_pos(Sakk_pos < 1) = 1;
%                     Sakk_pos = diag(image(floor(Sakk_pos(:,2)), floor(Sakk_pos(:,1))));
%                     gray_scale_patient = [gray_scale_patient; Sakk_pos];
%                 % 4. saliency
%                     Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
%                     harris = detectHarrisFeatures(image);
%                     harris = harris.selectStrongest(100);
%                     harris = double(harris.Location);
%                     for d = 1:size(harris,1)
%                         buf(:,d) = ((Sakk_pos(:,1)-harris(d,1)).^2 + (Sakk_pos(:,2)-harris(d,2)).^2);
%                     end
%                     distance_patient = [distance_patient ; min(buf, [], 2)];
%                 % Third saliency
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
                clearvars Sakk_parsed Sakk_pos
                Sakk_parsed = m.Sakk_parsed;
                Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', image_size(c,2), image_size(c,1));
                Sakk_pos_control{c,1} = Sakk_pos;
                map{counter,2} = saliency_map(c).master_map_resized;
                mask{counter,2} = makeFixationMask( Sakk_pos(:,1) , Sakk_pos(:,2) , size(map{counter}) , size(map{counter}) );
%                 rocSal(map{counter,2}, mask{counter,2})
                counter = counter +1;
                
%                 % 5. saliency
%                     Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
%                     Sakk_pos(Sakk_pos < 1) = 1;
%                     Sakk_pos = diag(image(floor(Sakk_pos(:,2)), floor(Sakk_pos(:,1))));
%                     gray_scale_patient = [gray_scale_patient; Sakk_pos];
%                 % 4. saliency
%                     Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', size(image, 2), size(image, 1));
%                     harris = detectHarrisFeatures(image);
%                     harris = harris.selectStrongest(100);
%                     harris = double(harris.Location);
%                     for d = 1:size(harris,1)
%                         buf(:,d) = ((Sakk_pos(:,1)-harris(d,1)).^2 + (Sakk_pos(:,2)-harris(d,2)).^2);
%                     end
%                     distance_patient = [distance_patient ; min(buf, [], 2)];
%                 % Third saliency
            end
        end
    end

%% Auswertung

    disp('Evaluate Data');
    
    [p, area] = rocSal_mod(map, mask);
    figure(1)
    hold on; grid on;
    plot(p(:,2), p(:,1));
    plot([0 1], [0 1],'k')
    text(0.6, 0.3, cat(2, 'Area under ROC: ', num2str(area) ));
    legend('ROC-curve');
    xlabel('False Positive Rate (%)');
    ylabel('True Positive Rate (%)');
    
    
    
    
    
    
%     gray_scale_patient(1) = [];
%     gray_scale_control(1) = [];
%     distance_patient(1) = [];
%     distance_control(1) = [];
%     
%     % Gray scale values [0,1]
%     gray_scale_patient = double(gray_scale_patient')/255;
%     gray_scale_control = double(gray_scale_control')/255;
%     
%     % Squared distance values [0,1]
%     distance_patient = 1./distance_patient;
%     distance_control = 1./distance_control;
%     distance_patient = distance_patient./max([distance_control;distance_patient]);
%     distance_control = distance_control./max([distance_control;distance_patient]);
%     
%     
%     if strcmp(saliency, 'Gray scale at saccade end point') == 1
%         threshold = 1:1:255;
%         figure(1)
%         hold on; grid on;
%         histogram(gray_scale_control,100);
%         histogram(gray_scale_patient,100);
%         legend('Control', 'Patient')
%         xlabel('gray scale values')
%         ylabel('# saccades');
%         
%         anz(1) = size(gray_scale_patient,2);
%         anz(2) = size(gray_scale_control,2);
% 
%         % classifier: everything higher than a threshold is patient. 
%         for a = 1:size(threshold,2)
%             TPR(a) = size(gray_scale_patient(gray_scale_patient > threshold(a)),2) / anz(1);
%             FPR(a) = size(gray_scale_control(gray_scale_control > threshold(a)),2) / anz(2);
%         end
%         figure(2)
%         hold on; grid on;
%         plot(FPR,TPR);
%         plot([0 1], [0 1],'k')
%         ROC_area = abs(trapz(FPR, TPR));
%         text(0.6, 0.3, cat(2, 'area under ROC: ', num2str(ROC_area) ));
%         legend('ROC-curve');
%         xlabel('False Positive Rate (%)');
%         ylabel('True Positive Rate (%)');
%     elseif strcmp(saliency, 'Squared Distance to nearest Harris features at sacc end point') == 1
%         threshold = 1:5:max([distance_control;distance_patient]);
%         figure(1)
%         hold on; grid on;
%         histogram(distance_control,100);
%         histogram(distance_patient,100);
%         legend('Control', 'Patient')
%         xlabel('Squared Distance to nearest Harris features at sacc end point')
%         ylabel('# saccades');
%         anz(1) = size(distance_patient,1);
%         anz(2) = size(distance_control,1);
%         
%         % classifier: everything higher than a threshold is patient. 
%         for a = 1:size(threshold,2)
%             TPR(a) = size(distance_patient(distance_patient > threshold(a)),1) / anz(1);
%             FPR(a) = size(distance_control(distance_control > threshold(a)),1) / anz(2);
%         end
%         figure(2)
%         hold on; grid on;
%         plot(FPR,TPR);
%         plot([0 1], [0 1],'k')
%         ROC_area = abs(trapz(FPR, TPR));
%         text(0.6, 0.3, cat(2, 'area under ROC: ', num2str(ROC_area) ));
%         legend('ROC-curve');
%         xlabel('False Positive Rate (%)');
%         ylabel('True Positive Rate (%)');
%     end
end