% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images


function Sakk_directions(bilder, durchlauf, ~ , kontroll_kennung, patient_kennung, data_path, image_path)

    if bilder > 15 && bilder < 1; disp('Enter valid number for "bilder"!'); return; end;
    
    [faces, faces_m, faces_t, kont] =  Separate_test_images(image_path);

    [control_listing, patient_listing] =  Separate_test_persons(kontroll_kennung, patient_kennung, data_path);
    

%% Alle Daten der Kontrollen heraussuchen

    Sakk_pos_control = zeros(1,4);
    
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_control = [Sakk_pos_control ; pos(:, [1 2 3 4])];
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_control = [Sakk_pos_control ; pos(:, [1 2 3 4])];
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_control = [Sakk_pos_control ; pos(:, [1 2 3 4])];
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_control = [Sakk_pos_control ; pos(:, [1 2 3 4])];
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_control = [Sakk_pos_control ; pos(:, [1 2 3 4])];
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_control = [Sakk_pos_control ; pos(:, [1 2 3 4])];
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_control = [Sakk_pos_control ; pos(:, [1 2 3 4])];
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_control = [Sakk_pos_control ; pos(:, [1 2 3 4])];
                end
            end
            bilder = bilder - 1;
        end
    end
    
    
%% Alle Daten der Patienten heraussuchen

    Sakk_pos_patient = zeros(1,4);
    
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient ; pos(:, [1 2 3 4])];
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient ; pos(:, [1 2 3 4])];
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient ; pos(:, [1 2 3 4])];
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient ; pos(:, [1 2 3 4])];
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient ; pos(:, [1 2 3 4])];
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient ; pos(:, [1 2 3 4])];
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient ; pos(:, [1 2 3 4])];
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
                    Sakk_parsed = m.Sakk_parsed;
                    if isempty(Sakk_parsed) == 1; continue; end;
                    clearvars buf pos
                    buf(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                    buf(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                    pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), buf(:,1), buf(:,2), '-', '-', 300, 460);
                    Sakk_pos_patient = [Sakk_pos_patient ; pos(:, [1 2 3 4])];
                end
            end
            bilder = bilder - 1;
        end
    end
    
%% Auswertung
    Sakk_pos_control(1,:) = [];
    Sakk_pos_patient(1,:) = [];

    h = figure(1);
    h.Position = [100 100 300*1.5 460*1.5];
    hold on; grid on;

    coeff_control = pca([Sakk_pos_control(:,3) Sakk_pos_control(:,4)]);
    coeff_patient = pca([Sakk_pos_patient(:,3) Sakk_pos_patient(:,4)]);
    
    quiver(Sakk_pos_control(:,1), Sakk_pos_control(:,2), Sakk_pos_control(:,3)*2, Sakk_pos_control(:,4)*2 );
    quiver(Sakk_pos_patient(:,1), Sakk_pos_patient(:,2), Sakk_pos_patient(:,3)*2, Sakk_pos_patient(:,4)*2 );
    quiver([300/2; 300/2], [460/2; 460/2], coeff_control(:,1)*100, coeff_control(:,2)*100, 'k');
    quiver([300/2; 300/2], [460/2; 460/2], coeff_patient(:,1)*100, coeff_patient(:,2)*100, 'g');
    legend('Sakkaden Richtungen Kontrollen', 'Sakkaden Richtungen Patienten', 'Hauptkomponenten Kontrollen', 'Hauptkomponenten Patienten');
    
    
    figure(2)
    hold on; grid on;
    phi = linspace(0, 2*pi, 50);
    x = sin(phi(1:end-1));
    y = cos(phi(1:end-1));
    kreis = [x' y'];
    einheitskreis = kreis;
    for f = 1:size(Sakk_pos_control,1)
        buf = (x + Sakk_pos_control(f,3)).^2  + (y + Sakk_pos_control(f,4)).^2;
        [~, buf1] = max(buf);
        kreis(buf1,:) = kreis(buf1,:) + einheitskreis(buf1,:);
    end
    kreis = kreis /size(Sakk_pos_control,1);
    kreis(end,:) = kreis(1,:);
    plot(kreis(:,1), kreis(:,2), 'b');
    kreis = [x' y'];
    einheitskreis = kreis;
    for f = 1:size(Sakk_pos_patient,1)
        buf = (x + Sakk_pos_patient(f,3)).^2  + (y + Sakk_pos_patient(f,4)).^2;
        [~, buf1] = max(buf);
        kreis(buf1,:) = kreis(buf1,:) + einheitskreis(buf1,:);
    end
    kreis = kreis /size(Sakk_pos_patient,1);
    kreis(end,:) = kreis(1,:);
    plot(kreis(:,1), kreis(:,2), 'r');
    legend('Kontrollen', 'Patienten');
    
end