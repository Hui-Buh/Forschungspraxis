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
    
    
%% Fixation map parameters
    Fixation_map_control = zeros(1024/8, 1280/8);
    Fixation_map_patient = zeros(1024/8, 1280/8);
    sigma = [100 60; 60 100];
    x2 = 1:8:1024;
    x1 = 1:8:1280;
    [X1,X2] = meshgrid(x1,x2);
    

%% Alle Daten der Kontrollen heraussuchen

    pos_control = [0 0];
    
    bilder_save = bilder;
    
    for b = 2:size(control_listing,1)
        bilder = bilder_save;
        
% normal faces
        if bilder >= 8 
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(faces,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_control = [pos_control ; pos(:, 1:2)]; 
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(faces,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_control = [pos_control ; pos(:, 1:2)]; 
                end
            end
            bilder = bilder - 8;
        end
% binaray faces
        if bilder >= 4
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(faces_m,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_m{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_m{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_control = [pos_control ; pos(:, 1:2)]; 
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(faces_m,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_m{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_m{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_control = [pos_control ; pos(:, 1:2)]; 
                end
            end
            bilder = bilder - 4;
        end
% binaray upside down faces
        if bilder >= 2
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(faces_t,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_t{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_t{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_control = [pos_control ; pos(:, 1:2)]; 
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(faces_t,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_t{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_t{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_control = [pos_control ; pos(:, 1:2)]; 
                end
            end
            bilder = bilder - 2;
        end
% all but faces
        if bilder >= 1
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(kont,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', kont{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', kont{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_control = [pos_control ; pos(:, 1:2)]; 
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(kont,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', kont{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', kont{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_control = [pos_control ; pos(:, 1:2)]; 
                end
            end
            bilder = bilder - 1;
        end
    end
    
    
%% Alle Daten der Patienten heraussuchen

    pos_patient = [0 0];

    for b = 2:size(patient_listing,1)
        bilder = bilder_save;
        
% normal faces
        if bilder >= 8 
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(faces,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_patient = [pos_patient ; pos(:, 1:2)]; 
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(faces,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_patient = [pos_patient ; pos(:, 1:2)]; 
                end
            end
            bilder = bilder - 8;
        end
% binaray faces
        if bilder >= 4
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(faces_m,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_m{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_m{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_patient = [pos_patient ; pos(:, 1:2)]; 
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(faces_m,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_m{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_m{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_patient = [pos_patient ; pos(:, 1:2)]; 
                end
            end
            bilder = bilder - 4;
        end
% binaray upside down faces
        if bilder >= 2
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(faces_t,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_t{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_t{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_patient = [pos_patient ; pos(:, 1:2)]; 
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(faces_t,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_t{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_t{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_patient = [pos_patient ; pos(:, 1:2)]; 
                end
            end
            bilder = bilder - 2;
        end
% all but faces
        if bilder >= 1
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(kont,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', kont{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', kont{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_patient = [pos_patient ; pos(:, 1:2)]; 
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(kont,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', kont{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', kont{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    clearvars pos
                    Sakk_parsed = m.Sakk_parsed;
                    pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                    pos_patient = [pos_patient ; pos(:, 1:2)]; 
                end
            end
            bilder = bilder - 1;
        end
    end
    
%% Auswertung

    pos_patient(1,:) = [];
    pos_control(1,:) = [];
    
%     figure(1)
%     hold on; grid on;
%     hist3(pos_control, [100 100],'FaceAlpha',0.5, 'FaceColor','interp','CDataMode','auto');
%     hist3(pos_patient, [100 100],'FaceAlpha',0.5);
%     legend('Kontrollen', 'Patienten')
    
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


    figure(2)
    hold on; grid; 
    surf(x1,x2,Fixation_map_control);
    caxis([min(Fixation_map_control(:))-.5*range(Fixation_map_control(:)),max(Fixation_map_control(:))]);
    legend('Fixation map - Kontrollen')
    colorbar
    xlim([0 300])
    ylim([0 460])
    
    figure(3)
    hold on; grid; 
    surf(x1,x2,Fixation_map_patient);
    caxis([min(Fixation_map_patient(:))-.5*range(Fixation_map_patient(:)),max(Fixation_map_patient(:))]);
    legend('Fixation map - Patienten')
    colorbar
    xlim([0 300])
    ylim([0 460])
    
end
                    
                        
                   