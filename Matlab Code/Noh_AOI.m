% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images

function Noh_AOI( bilder, durchlauf, ~, kontroll_kennung, patient_kennung, data_path, image_path)
    my_message('Evaluate AOI images',0)
    
    if bilder == 1
        my_message('No AOI imagages available',0);
        my_message('Ended badly',0);
        return;
    end
    
    [faces, faces_m, faces_t, ~] =  Separate_test_images(image_path);

    [control_listing, patient_listing] =  Separate_test_persons(kontroll_kennung, patient_kennung, data_path);
    
    % Baue eine Liste aller Bilder, die abgearbeitet werden sollen
    image_list{1,1} = 'List of all images to use.';
    bilder_bak = bilder;
    if bilder >= 8; image_list = vertcat(image_list, faces{2:end}); bilder = bilder -8; end;
    if bilder >= 4; image_list = vertcat(image_list, faces_m{2:end}); bilder = bilder -4; end;
    if bilder >= 2; image_list = vertcat(image_list, faces_t{2:end}); bilder = bilder -2; end;
    
    % Variablen
    color_grenzwert = 20;

%% Alle Daten der Kontrollen heraussuchen
    my_message('Extract control data',0)

    Sakk_pos_control = cell(size(image_list,1)-1,1);
    
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
                Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                Sakk_pos_control{c-1} = vertcat(Sakk_pos_control{c-1}, Sakk_pos(:,1:2));
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
                Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                Sakk_pos_control{c-1} = vertcat(Sakk_pos_control{c-1}, Sakk_pos(:,1:2));
            end
        end
    end

%% Alle Daten der Patienten heraussuchen
    my_message('Extract patient data',0)

    Sakk_pos_patient = cell(size(image_list,1)-1,1);
    
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
                Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                Sakk_pos_patient{c-1} = vertcat(Sakk_pos_patient{c-1}, Sakk_pos(:,1:2));
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
                Sakk_pos = center_image(mean([Sakk_parsed(2:end,2) Sakk_parsed(1:end-1,5)],2), mean([Sakk_parsed(2:end,3) Sakk_parsed(1:end-1,6)],2), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), zeros(size(Sakk_parsed,1)-1,1), 300, 460);
                Sakk_pos_patient{c-1} = vertcat(Sakk_pos_patient{c-1}, Sakk_pos(:,1:2));
            end
        end
    end

%% Auswertung
    my_message('Evaluate Data',0)

    clearvars buf

    image_path = cat(2,image_path, '/AOI');
    [faces, faces_m, faces_t, ~] = Separate_test_images(image_path);
    bilder = bilder_bak;
    image_list_AOI{1,1} = 'List of all AOI images to use.';
    if bilder >= 8; image_list_AOI = vertcat(image_list_AOI, faces{2:end}); bilder = bilder -8; end;
    if bilder >= 4; image_list_AOI = vertcat(image_list_AOI, faces_m{2:end}); bilder = bilder -4; end;
    if bilder >= 2; image_list_AOI = vertcat(image_list_AOI, faces_t{2:end}); bilder = bilder -2; end;
    
    figure (1)
    grid on; box on;
    set(gca,'FontWeight','bold');
    
    number = [0 0];
    anzahl_control = zeros(4,size(image_list ,1)-1);
    for a = 1:size(image_list ,1)-1
        if find( strcmp( image_list_AOI, cat(2,image_list{a+1}, '_AOI')) == 1) == 0; continue; end;
        buf = cell2mat(Sakk_pos_control(a,1));
        buf = round(buf);
        if size(buf,1) == 0; continue; end;
        number(1) = number(1) + size(buf,1);
        buf(:,2) = -1 * buf(:,2) + 460;
        subplot(1,2,1)
        image = imread(cat(2, image_path, '/', cat(2,image_list{a+1}, '_AOI.jpg') ));
        imshow(image);
        image = double(image);
        hold on;
        points_control = buf(diag(image(buf(:,2), buf(:,1),2)) < 0 + color_grenzwert & diag(image(buf(:,2), buf(:,1),3)) < 0 + color_grenzwert,:);
        plot(points_control(:,1) , points_control(:,2),'.b' );
        anzahl_control(1,a) = size(points_control,1); % Auge links
        points_control = buf(diag(image(buf(:,2), buf(:,1),3)) < 0 + color_grenzwert & diag(image(buf(:,2), buf(:,1),1)) > 255 - color_grenzwert & diag(image(buf(:,2), buf(:,1),2)) > 255 - color_grenzwert,:);
        plot(points_control(:,1) , points_control(:,2),'.k' );
        anzahl_control(2,a) = size(points_control,1); % Auge rechts
        points_control = buf(diag(image(buf(:,2), buf(:,1),1)) < 0 + color_grenzwert & diag(image(buf(:,2), buf(:,1),3)) < 0 + color_grenzwert,:);
        plot(points_control(:,1) , points_control(:,2),'.r' );
        anzahl_control(3,a) = size(points_control,1); % Mund
        points_control = buf(diag(image(buf(:,2), buf(:,1),1)) < 0 + color_grenzwert & diag(image(buf(:,2), buf(:,1),2)) < 0 + color_grenzwert,:);
        plot(points_control(:,1) , points_control(:,2),'.y' );
        anzahl_control(4,a) = size(points_control,1); % Nase
%         hold off;
    end
    anzahl_control = sum(anzahl_control,2);
    
    anzahl_patient = zeros(4,size(image_list ,1)-1);
    for a = 1:size(image_list ,1)-1
        if find( strcmp( image_list_AOI, cat(2,image_list{a+1}, '_AOI')) == 1) == 0; continue; end;
        buf = cell2mat(Sakk_pos_patient(a,1));
        buf = round(buf);
        if size(buf,1) == 0; continue; end;
        number(2) = number(2) + size(buf,1);
        buf(:,2) = -1 * buf(:,2) + 460;
        subplot(1,2,2)
        image = imread(cat(2, image_path, '/', cat(2,image_list{a+1}, '_AOI.jpg') ));
        imshow(image);
        image = double(image);
        hold on;
        points_patient = buf(diag(image(buf(:,2), buf(:,1),2)) < 0 + color_grenzwert & diag(image(buf(:,2), buf(:,1),3)) < 0 + color_grenzwert,:);
        plot(points_patient(:,1) , points_patient(:,2),'.b' );
        anzahl_patient(1,a) = size(points_patient,1); % Auge links
        points_patient = buf(diag(image(buf(:,2), buf(:,1),3)) < 0 + color_grenzwert & diag(image(buf(:,2), buf(:,1),1)) > 255 - color_grenzwert & diag(image(buf(:,2), buf(:,1),2)) > 255 - color_grenzwert,:);
        plot(points_patient(:,1) , points_patient(:,2),'.k' );
        anzahl_patient(2,a) = size(points_patient,1); % Auge rechts
        points_patient = buf(diag(image(buf(:,2), buf(:,1),1)) < 0 + color_grenzwert & diag(image(buf(:,2), buf(:,1),3)) < 0 + color_grenzwert,:);
        plot(points_patient(:,1) , points_patient(:,2),'.r' );
        anzahl_patient(3,a) = size(points_patient,1); % Mund
        points_patient = buf(diag(image(buf(:,2), buf(:,1),1)) < 0 + color_grenzwert & diag(image(buf(:,2), buf(:,1),2)) < 0 + color_grenzwert,:);
        plot(points_patient(:,1) , points_patient(:,2),'.y' );
        anzahl_patient(4,a) = size(points_patient,1); % Nase
%         hold off;
    end
    anzahl_patient = sum(anzahl_patient,2);

    figure(1)
    hold on; grid on; box on;
    set(gca,'FontWeight','bold');
    subplot(1,2,1)
    hold on; grid on; box on;
    set(gca,'FontWeight','bold');
    legend('Controls');
    subplot(1,2,2)
    hold on; grid on; box on;
    set(gca,'FontWeight','bold');
    legend('Patients');
    anzahl_control = anzahl_control./number(1)*1000;
    anzahl_patient = anzahl_patient./number(2)*1000;
    u = uitable('Data', [anzahl_control anzahl_patient anzahl_control./anzahl_patient], ...
    'RowName', {'eye_left', 'eye_right', 'mouth', 'nose'}, ...
    'ColumnName', {'control |[#/1000sacc]' ,'patient |[#/1000sacc]', 'con./pat.'}, 'FontName', 'Arial', 'FontSize', 8);

    u.Position(1) = 10;
    u.Position(2) = 10;
    u.Position(3) = 355;
    u.Position(4) = 107;

end