% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images


function local_Sakk_distribution(bilder, durchlauf, ~ , kontroll_kennung, patient_kennung, data_path, image_path)
my_message('Create Fixation maps',0)

    [faces, faces_m, faces_t, kont] =  Separate_test_images(image_path);

    [control_listing, patient_listing] =  Separate_test_persons(kontroll_kennung, patient_kennung, data_path);
    
    % Baue eine Liste aller Bilder, die abgearbeitet werden sollen
    image_list{1,1} = 'List of all images to use.';
    if bilder >= 8; image_list = vertcat(image_list, faces{2:end}); bilder = bilder -8; end;
    if bilder >= 4; image_list = vertcat(image_list, faces_m{2:end}); bilder = bilder -4; end;
    if bilder >= 2; image_list = vertcat(image_list, faces_t{2:end}); bilder = bilder -2; end;
    if bilder >= 1; image_list = vertcat(image_list, kont{2:end}); bilder = bilder -1; end;
    
    if size(image_list,1) == 1
        my_message('No matching images found',0)
        my_message('Ended badly',0)
        return;
    end
    if size(control_listing,1) == 1
        my_message(cat(2,'No control with ID ', kontroll_kennung, ' found'),0)
        my_message('Ended badly',0)
        return;
    end
    if size(patient_listing,1) == 1
        my_message(cat(2,'No patient with ID ', patient_kennung, ' found'),0)
        my_message('Ended badly',0)
        return;
    end
    
    % Variablen
    image_x = 288;
    image_y = 456;
    
     
%% Fixation map parameters
    downsampling = 1;
    auswertung = 128;
    Fixation_map_control = zeros((image_y+auswertung)/downsampling, (image_x+auswertung)/downsampling);
    Fixation_map_patient = zeros((image_y+auswertung)/downsampling, (image_x+auswertung)/downsampling);
    sigma = [46 0; 0 46];
    x1 = 1:auswertung/downsampling+1;
    x1 = 1:auswertung/downsampling+1;
    [X1,X2] = meshgrid(x1,x1);
    F = mvnpdf([X1(:) X2(:)],[floor(mean(x1)) floor(mean(x1))] ,sigma);
    F  = reshape(F,length(x1),length(x1));
    

%% Alle Daten der Kontrollen heraussuchen
my_message('Extract control data',0)

    pos_control = [0 0];
%     anz_sakkpro_control = zeros(size(control_listing,1),1);
    
    for b = 2:size(control_listing,1)
my_message(cat(2,'Extract control data ', num2str(b), '/', num2str(size(control_listing,1))),2)
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
                image_size = m.image_size;
                pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', image_size(1,2), image_size(1,1));
                pos_control = [pos_control ; pos(:, 1:2)]; 
%                 anz_sakkpro_control(b) = anz_sakkpro_control(b) + size(pos, 1);
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
                image_size = m.image_size;
                pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', image_size(1,2), image_size(1,1));
                pos_control = [pos_control ; pos(:, 1:2)]; 
%                 anz_sakkpro_control(b) = anz_sakkpro_control(b) + size(pos, 1);
            end
        end
    end

%% Alle Daten der Patienten heraussuchen
my_message('Extract patient data',0)

    pos_patient = [0 0];
%     anz_sakkpro_patient = zeros(size(patient_listing,1),1);
    
    for b = 2:size(patient_listing,1)
my_message(cat(2,'Extract patient data ', num2str(b), '/', num2str(size(patient_listing,1))),2)
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
                image_size = m.image_size;
                pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', image_size(1,2), image_size(1,1));
                pos_patient = [pos_patient ; pos(:, 1:2)]; 
%                 anz_sakkpro_patient(b) = anz_sakkpro_patient(b) + size(pos, 1);
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
                image_size = m.image_size;
                pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', image_size(1,2), image_size(1,1));
                pos_patient = [pos_patient ; pos(:, 1:2)]; 
%                 anz_sakkpro_patient(b) = anz_sakkpro_patient(b) + size(pos, 1);
            end
        end
    end

%% Auswertung
my_message('Evaluate Data',0)

    pos_patient(1,:) = [];
    pos_control(1,:) = [];
    
    if isempty(pos_control) == 1 || isempty(pos_patient) == 1
my_message('No matching .mat found',0)
my_message('Ended',0)
        return;
    end

    pos_control_down = floor(pos_control/downsampling);
    pos_control_down(pos_control_down==0) = 1;
    pos_patient_down = floor(pos_patient/downsampling);
    pos_patient_down(pos_patient_down==0) = 1;
    
    for g = 1:size(pos_control_down)
        Fixation_map_control(pos_control_down(g,2):pos_control_down(g,2)+length(x1)-1,pos_control_down(g,1):pos_control_down(g,1)+length(x1)-1) =...
            Fixation_map_control(pos_control_down(g,2):pos_control_down(g,2)+length(x1)-1,pos_control_down(g,1):pos_control_down(g,1)+length(x1)-1) + F;
    end
    for g = 1:size(pos_patient_down)
        Fixation_map_patient(pos_patient_down(g,2):pos_patient_down(g,2)+length(x1)-1,pos_patient_down(g,1):pos_patient_down(g,1)+length(x1)-1) =...
            Fixation_map_patient(pos_patient_down(g,2):pos_patient_down(g,2)+length(x1)-1,pos_patient_down(g,1):pos_patient_down(g,1)+length(x1)-1) + F;
    end

    Fixation_map_control = Fixation_map_control((mean(x1)-1)/downsampling+1:end-(mean(x1)-1)/downsampling-1,(mean(x1)-1)/downsampling+1:end-(mean(x1)-1)/downsampling-1);
    Fixation_map_patient = Fixation_map_patient((mean(x1)-1)/downsampling+1:end-(mean(x1)-1)/downsampling-1,(mean(x1)-1)/downsampling+1:end-(mean(x1)-1)/downsampling-1);
    
    Fixation_map_control = Fixation_map_control./sum(trapz(Fixation_map_control));
    Fixation_map_patient = Fixation_map_patient./sum(trapz(Fixation_map_patient));
        
    figure(1)
    hold on; grid on; box on; axis equal, axis off;
    set(gca,'FontWeight','bold');
    if size(image_list,1) == 2
        surf(Fixation_map_control, 'LineStyle', 'none', 'FaceAlpha', 0.5);
    else
        surf(Fixation_map_control, 'LineStyle', 'none');
    end
    caxis([min(Fixation_map_control(:))-.5*range(Fixation_map_control(:)),max(Fixation_map_control(:))]);
    legend('Fixation map - Control')
    colorbar
    xlim([0 image_x/downsampling])
    ylim([0 image_y/downsampling])
    if size(image_list,1) == 2
        image = imread(cat(2, image_path, '/', cat(2,image_list{2}, '.jpg')));
        image = imresize(image, 1/downsampling);
        imshow(image);
    end

    figure(2)
    hold on; grid on; box on; axis equal, axis off;
    set(gca,'FontWeight','bold');
    if size(image_list,1) == 2
        surf(Fixation_map_patient, 'LineStyle', 'none', 'FaceAlpha', 0.5);
    else
        surf(Fixation_map_patient, 'LineStyle', 'none');
    end
    caxis([min(Fixation_map_patient(:))-.5*range(Fixation_map_patient(:)),max(Fixation_map_patient(:))]);
    legend('Fixation map - Patient')
    colorbar
    xlim([0 image_x/downsampling])
    ylim([0 image_y/downsampling])
    if size(image_list,1) == 2
        image = imread(cat(2, image_path, '/', cat(2,image_list{2}, '.jpg')));
        image = imresize(image, 1/downsampling);
        imshow(image);
    end
    
    figure(3);
    hold on; grid on; box on; axis equal, axis off;
    set(gca,'FontWeight','bold');
    difference = (Fixation_map_control - Fixation_map_patient);
    amplitude = max(difference(:)) - min(difference(:));
    difference(difference(:) < (max(difference(:)) - amplitude*0.25) & difference(:) > (min(difference(:)) + amplitude*0.25)) = 0;
    if size(image_list,1) == 2
        surf(difference, 'LineStyle', 'none', 'FaceAlpha', 0.5);
    else
        surf(difference, 'LineStyle', 'none');
    end
    caxis([min(difference(:))-.5*range(difference(:)),max(difference(:))]);
    legend('Fixation map difference (cont. - pat.)')
    colorbar
    xlim([0 image_x/downsampling])
    ylim([0 image_y/downsampling])
    if size(image_list,1) == 2
        image = imread(cat(2, image_path, '/', cat(2,image_list{2}, '.jpg')));
        image = imresize(image, 1/downsampling);
        imshow(image);
    end

end
