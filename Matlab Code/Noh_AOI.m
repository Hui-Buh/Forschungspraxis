% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images

function Noh_AOI( bilder, durchlauf, ~, kontroll_kennung, patient_kennung, data_path, image_path)

    if bilder > 15 && bilder < 1; disp('Enter valid number for "bilder"!'); return; end;

    [faces, faces_m, faces_t, kont] =  Separate_test_images(image_path);

    [control_listing, patient_listing] =  Separate_test_persons(kontroll_kennung, patient_kennung, data_path);
    


%% Alle Daten der Kontrollen heraussuchen

    Sakk_pos_control = zeros(1,2);
    
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_control = [Sakk_pos_control;  Sakk_pos(:,1:2)];
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_control = [Sakk_pos_control;  Sakk_pos(:,1:2)];
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_control = [Sakk_pos_control;  Sakk_pos(:,1:2)];
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_control = [Sakk_pos_control;  Sakk_pos(:,1:2)];
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_control = [Sakk_pos_control;  Sakk_pos(:,1:2)];
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_control = [Sakk_pos_control;  Sakk_pos(:,1:2)];
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_control = [Sakk_pos_control;  Sakk_pos(:,1:2)];
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_control = [Sakk_pos_control;  Sakk_pos(:,1:2)];
                end
            end
            bilder = bilder - 1;
        end
    end
    
    
%% Alle Daten der Patienten heraussuchen


    Sakk_pos_patient = zeros(1,2);
    
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient;  Sakk_pos(:,1:2)];
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient;  Sakk_pos(:,1:2)];
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient;  Sakk_pos(:,1:2)];
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient;  Sakk_pos(:,1:2)];
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient;  Sakk_pos(:,1:2)];
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient;  Sakk_pos(:,1:2)];
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient;  Sakk_pos(:,1:2)];
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
                    clearvars Sakk_parsed Sakk_pos
                    Sakk_parsed = m.Sakk_parsed;
                    Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient;  Sakk_pos(:,1:2)];
                end
            end
            bilder = bilder - 1;
        end
    end
    

%% Auswertung
    clearvars buf

    Sakk_pos_control(1,:) = [];
    Sakk_pos_patient(1,:) = [];

    % Linkes Auge
    buf = (Sakk_pos_control(:,1) - 90).^2/45^2 + (Sakk_pos_control(:,2) - (456-200)).^2/25^2;
    buf = find(buf < 1);
    Auge_links_control(:,1) = Sakk_pos_control(buf,1);
    Auge_links_control(:,2) = Sakk_pos_control(buf,2);
    buf = (Sakk_pos_patient(:,1) - 90).^2/45^2 + (Sakk_pos_patient(:,2) - (456-200)).^2/25^2;
    buf = find(buf < 1);
    Auge_links_patient(:,1) = Sakk_pos_patient(buf,1);
    Auge_links_patient(:,2) = Sakk_pos_patient(buf,2);
    
    % Rechtes Auge
    buf = (Sakk_pos_control(:,1) - 200).^2/45^2 + (Sakk_pos_control(:,2) - (456-200)).^2/25^2;
    buf = find(buf < 1);
    Auge_rechts_control(:,1) = Sakk_pos_control(buf,1);
    Auge_rechts_control(:,2) = Sakk_pos_control(buf,2);
    buf = (Sakk_pos_patient(:,1) - 200).^2/45^2 + (Sakk_pos_patient(:,2) - (456-200)).^2/25^2;
    buf = find(buf < 1);
    Auge_rechts_patient(:,1) = Sakk_pos_patient(buf,1);
    Auge_rechts_patient(:,2) = Sakk_pos_patient(buf,2);
    
    % Mund
    buf = (Sakk_pos_control(:,1) - 145).^2/55^2 + (Sakk_pos_control(:,2) - (456-300)).^2/30^2;
    buf = find(buf < 1);
    Mund_control(:,1) = Sakk_pos_control(buf,1);
    Mund_control(:,2) = Sakk_pos_control(buf,2);
    buf = (Sakk_pos_patient(:,1) - 145).^2/55^2 + (Sakk_pos_patient(:,2) - (456-300)).^2/30^2;
    buf = find(buf < 1);
    Mund_patient(:,1) = Sakk_pos_patient(buf,1);
    Mund_patient(:,2) = Sakk_pos_patient(buf,2);

    figure(1)
    hold on; grid on;
    plot(Sakk_pos_control(:,1), Sakk_pos_control(:,2), '.k');
    plot(Sakk_pos_patient(:,1), Sakk_pos_patient(:,2), '.y');
    
    scatter(Auge_links_control(:,1), Auge_links_control(:,2), 'b');
    scatter(Auge_links_patient(:,1), Auge_links_patient(:,2), 'r');
    scatter(Auge_rechts_control(:,1), Auge_rechts_control(:,2), 'b');
    scatter(Auge_rechts_patient(:,1), Auge_rechts_patient(:,2), 'r');
    scatter(Mund_control(:,1), Mund_control(:,2), 'b');
    scatter(Mund_patient(:,1), Mund_patient(:,2), 'r');
    
    legend('Kontrollen', 'Patienten', 'Kontrollen', 'Patienten');
    
     u = uitable('Data', [size(Mund_control,1) size(Mund_patient,1); size(Auge_links_control,1) size(Auge_links_patient,1); size(Auge_rechts_control,1) size(Auge_rechts_patient,1) ], ...
    'RowName', {'mouth', 'eye_left', 'eye_right'}, ...
    'ColumnName', {'control' ,'patient'}, 'FontName', 'Arial', 'FontSize', 8);

    u.Position(1) = 0;
    u.Position(2) = 0;
    u.Position(3) = 252;
    u.Position(4) = 73;
    

end