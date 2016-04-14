% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images


function local_Sakk_distribution(bilder, durchlauf, ~ , kontroll_kennung, patient_kennung, data_path, image_path)

    if bilder > 15 && bilder < 1; disp('Enter valid number for "bilder"!'); return; end;

    [faces, faces_m, faces_t, kont] =  Separate_test_images(image_path);

    [control_listing, patient_listing] =  Separate_test_persons(kontroll_kennung, patient_kennung, data_path);
    
    % Baue eine Liste aller Bilder, die abgearbeitet werden sollen
    image_list{1,1} = 'List of all images to use.';
    if bilder >= 8; image_list = vertcat(image_list, faces{2:end}); bilder = bilder -8; end;
    if bilder >= 4; image_list = vertcat(image_list, faces_m{2:end}); bilder = bilder -4; end;
    if bilder >= 2; image_list = vertcat(image_list, faces_t{2:end}); bilder = bilder -2; end;
    if bilder >= 1; image_list = vertcat(image_list, kont{2:end}); bilder = bilder -1; end;
     
%% Fixation map parameters
    Fixation_map_control = zeros(1024/8, 1280/8);
    Fixation_map_patient = zeros(1024/8, 1280/8);
    sigma = [100 60; 60 100];
    x2 = 1:8:1024;
    x1 = 1:8:1280;
    [X1,X2] = meshgrid(x1,x2);
    

%% Alle Daten der Kontrollen heraussuchen

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

    pos_patient(1,:) = [];
    pos_control(1,:) = [];

    for e = 1:size(pos_control,1)
        mu = [pos_control(e,1) pos_control(e,2)];
        buf = mvnpdf([X1(:) X2(:)],mu ,sigma);
        F = reshape(buf,length(x2),length(x1));
        Fixation_map_control = Fixation_map_control + F;
    end
    for e = 1:size(pos_patient,1)
        mu = [pos_patient(e,1) pos_patient(e,2)];
        buf = mvnpdf([X1(:) X2(:)],mu ,sigma);
        F = reshape(buf,length(x2),length(x1));
        Fixation_map_patient = Fixation_map_patient + F;
    end

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
end             