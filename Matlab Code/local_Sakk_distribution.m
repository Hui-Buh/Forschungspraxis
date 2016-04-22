% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images


function local_Sakk_distribution(bilder, durchlauf, as_saliency , kontroll_kennung, patient_kennung, data_path, image_path)
    my_message('Create Fixation maps',0)

    [faces, faces_m, faces_t, kont] =  Separate_test_images(image_path);

    [control_listing, patient_listing] =  Separate_test_persons(kontroll_kennung, patient_kennung, data_path);
    
    % Baue eine Liste aller Bilder, die abgearbeitet werden sollen
    image_list{1,1} = 'List of all images to use.';
    if bilder >= 8; image_list = vertcat(image_list, faces{2:end}); bilder = bilder -8; end;
    if bilder >= 4; image_list = vertcat(image_list, faces_m{2:end}); bilder = bilder -4; end;
    if bilder >= 2; image_list = vertcat(image_list, faces_t{2:end}); bilder = bilder -2; end;
    if bilder >= 1; image_list = vertcat(image_list, kont{2:end}); bilder = bilder -1; end;
     
%% Fixation map parameters
    downsampling = 8;
    Fixation_map_control = zeros(1024/downsampling, 1280/downsampling);
    Fixation_map_patient = zeros(1024/downsampling, 1280/downsampling);
    sigma = [28 28; 28 28];
    x2 = 1:downsampling:1024;
    x1 = 1:downsampling:1280;
    [X1,X2] = meshgrid(x1,x2);
    

%% Alle Daten der Kontrollen heraussuchen
    my_message('Extract control data',0)

    pos_control = [0 0];
    
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
                clearvars pos
                Sakk_parsed = m.Sakk_parsed;
                pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                pos_control = [pos_control ; pos(:, 1:2)]; 
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
                clearvars pos
                Sakk_parsed = m.Sakk_parsed;
                pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                pos_control = [pos_control ; pos(:, 1:2)]; 
            end
        end
    end

%% Alle Daten der Patienten heraussuchen
    my_message('Extract patient data',0)

    pos_patient = [0 0];
    
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
                clearvars pos
                Sakk_parsed = m.Sakk_parsed;
                pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                pos_patient = [pos_patient ; pos(:, 1:2)]; 
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
                clearvars pos
                Sakk_parsed = m.Sakk_parsed;
                pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                pos_patient = [pos_patient ; pos(:, 1:2)]; 
            end
        end
    end

%% Auswertung
    my_message('Evaluate Data',0)

    pos_patient(1,:) = [];
    pos_control(1,:) = [];
    
    for e = 1:size(pos_control,1)
        mu = [pos_control(e,1) pos_control(e,2)];
        buf = mvnpdf([X1(:) X2(:)],mu ,sigma);
        F = reshape(buf,length(x2),length(x1));
        Fixation_map_control = Fixation_map_control + F;
    end
    Fixation_map_control = Fixation_map_control./sum(trapz(Fixation_map_control));
    for e = 1:size(pos_patient,1)
        mu = [pos_patient(e,1) pos_patient(e,2)];
        buf = mvnpdf([X1(:) X2(:)],mu ,sigma);
        F = reshape(buf,length(x2),length(x1));
        Fixation_map_patient = Fixation_map_patient + F;
    end
    Fixation_map_patient = Fixation_map_patient./sum(trapz(Fixation_map_patient));

    figure(1)
    hold on; grid; 
    surf(x1,x2,Fixation_map_control);
    caxis([min(Fixation_map_control(:))-.5*range(Fixation_map_control(:)),max(Fixation_map_control(:))]);
    legend('Fixation map - Kontrollen')
    colorbar
    xlim([0 300])
    ylim([0 460])

    figure(2)
    hold on; grid; 
    surf(x1,x2,Fixation_map_patient);
    caxis([min(Fixation_map_patient(:))-.5*range(Fixation_map_patient(:)),max(Fixation_map_patient(:))]);
    legend('Fixation map - Patienten')
    colorbar
    xlim([0 300])
    ylim([0 460])
    
    h=figure(3);
    hold on; grid; 
    difference = (Fixation_map_control - Fixation_map_patient);
    surf(x1,x2,difference);
    caxis([min(difference(:))-.5*range(difference(:)),max(difference(:))]);
    legend('Fixation map difference')
    colorbar
    xlim([0 300])
    ylim([0 460])
        
    if as_saliency == 1
        my_message('Compute NNS', 0);
        
        % Leave one out noch fertig machen!!!!!!!!!!!!!!!
        
        
        Fixation_map_control = (Fixation_map_control - mean(Fixation_map_control(:)))/std(Fixation_map_control(:));
        Fixation_map_patient = (Fixation_map_patient - mean(Fixation_map_patient(:)))/std(Fixation_map_patient(:));
        
        norm_scanpath_saliency_control = mean(diag(Fixation_map_patient(round(pos_control(:,1)/downsampling),round(pos_control(:,2)/downsampling))));
        norm_scanpath_saliency_patient = mean(diag(Fixation_map_control(round(pos_patient(:,1)/downsampling),round(pos_patient(:,2)/downsampling))));
        
        u = uitable(h, 'Data', [norm_scanpath_saliency_control norm_scanpath_saliency_patient], ...
        'RowName', {'NSS'}, ...
        'ColumnName', {'control', 'patient'}, 'FontName', 'Arial', 'FontSize', 8);

        u.Position(1) = 100;
        u.Position(2) = 100;
        u.Position(3) = 197;
        u.Position(4) = 39;
        
    end
end
