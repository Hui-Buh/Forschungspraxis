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
    
    % Baue eine Liste aller Bilder, die abgearbeitet werden sollen
    image_list{1,1} = 'List of all images to use.';
    if bilder >= 8; image_list = vertcat(image_list, faces{2:end}); bilder = bilder -8; end;
    if bilder >= 4; image_list = vertcat(image_list, faces_m{2:end}); bilder = bilder -4; end;
    if bilder >= 2; image_list = vertcat(image_list, faces_t{2:end}); bilder = bilder -2; end;
    if bilder >= 1; image_list = vertcat(image_list, kont{2:end}); bilder = bilder -1; end;
    
    
%% Alle Daten der Kontrollen heraussuchen

    Sakk_pos_control = zeros(1,4);
    
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
                Sakk_parsed = m.Sakk_parsed;
                if isempty(Sakk_parsed) == 1; continue; end;
                clearvars difference pos
                difference(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                difference(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), difference(:,1), difference(:,2), '-', '-', 300, 460);
                Sakk_pos_control = [Sakk_pos_control ; pos(:, [1 2 3 4])];
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
                Sakk_parsed = m.Sakk_parsed;
                if isempty(Sakk_parsed) == 1; continue; end;
                clearvars difference pos
                difference(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                difference(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), difference(:,1), difference(:,2), '-', '-', 300, 460);
                Sakk_pos_control = [Sakk_pos_control ; pos(:, [1 2 3 4])];
            end
        end
    end

%% Alle Daten der Patienten heraussuchen

    Sakk_pos_patient = zeros(1,4);
    
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
                Sakk_parsed = m.Sakk_parsed;
                if isempty(Sakk_parsed) == 1; continue; end;
                clearvars difference pos
                difference(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                difference(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), difference(:,1), difference(:,2), '-', '-', 300, 460);
                Sakk_pos_patient = [Sakk_pos_patient ; pos(:, [1 2 3 4])];
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
                Sakk_parsed = m.Sakk_parsed;
                if isempty(Sakk_parsed) == 1; continue; end;
                clearvars difference pos
                difference(:,1) = Sakk_parsed(:,5) - Sakk_parsed(:,2);
                difference(:,2) = Sakk_parsed(:,6) - Sakk_parsed(:,3);
                pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), difference(:,1), difference(:,2), '-', '-', 300, 460);
                Sakk_pos_patient = [Sakk_pos_patient ; pos(:, [1 2 3 4])];
            end
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
    phi = linspace(0, 2*pi, 53);
    x = sin(phi(1:end-1));
    y = cos(phi(1:end-1));
    kreis = [x' y'];
    einheitskreis = kreis;
    for f = 1:size(Sakk_pos_control,1)
        buf = (x + Sakk_pos_control(f,3)).^2  + (y + Sakk_pos_control(f,4)).^2;
        [~, buf1] = max(buf);
        kreis(buf1,:) = kreis(buf1,:) + einheitskreis(buf1,:);
    end

    kreis = kreis /(size(Sakk_pos_control,1)+1);
    kreis(end,:) = kreis(1,:);
    probability_control = sqrt(sum(kreis(:,:) .* kreis(:,:), 2));
    percent_control(1) = probability_control(52) + probability_control(1) + probability_control(2);
    percent_control(2) = probability_control(13) + probability_control(14) + probability_control(15);
    percent_control(3) = probability_control(26) + probability_control(27) + probability_control(28);
    percent_control(4) = probability_control(39) + probability_control(40) + probability_control(41);
    plot(kreis(:,1), kreis(:,2), 'b');
    
    kreis = [x' y'];
    einheitskreis = kreis;
    for f = 1:size(Sakk_pos_patient,1)
        buf = (x + Sakk_pos_patient(f,3)).^2  + (y + Sakk_pos_patient(f,4)).^2;
        [~, buf1] = max(buf);
        kreis(buf1,:) = kreis(buf1,:) + einheitskreis(buf1,:);
    end
    kreis = kreis /(size(Sakk_pos_patient,1)+1);
    kreis(end,:) = kreis(1,:);
    probability_patient = sqrt(sum(kreis(:,:) .* kreis(:,:), 2));
    percent_patient(1) = probability_patient(52) + probability_patient(1) + probability_patient(2);
    percent_patient(2) = probability_patient(13) + probability_patient(14) + probability_patient(15);
    percent_patient(3) = probability_patient(26) + probability_patient(27) + probability_patient(28);
    percent_patient(4) = probability_patient(39) + probability_patient(40) + probability_patient(41);
    plot(kreis(:,1), kreis(:,2), 'r');
    legend('Kontrollen', 'Patienten');
    
    ratio(1) = (percent_control(2)+percent_control(4))/(percent_control(1)+percent_control(3));
    ratio(2) = (percent_patient(2)+percent_patient(4))/(percent_patient(1)+percent_patient(3));
    u = uitable('Data', [[percent_control'*100; ratio(1)] [percent_patient'*100; ratio(2)] ], ...
    'RowName', {'up +-10%', 'right +-10%', 'down +-10%', 'left +-10%', 'ratio lr/ud'}, ...
    'ColumnName', {'control' ,'patient'}, 'FontName', 'Arial', 'FontSize', 8);

    u.Position(1) = 0;
    u.Position(2) = 0;
    u.Position(3) = 274;
    u.Position(4) = 107;
    
    
end