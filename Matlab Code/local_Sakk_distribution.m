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
    boot_nr = 1;
    image_x = 288;
    image_y = 456;
    
     
%% Fixation map parameters
    downsampling = 1;
    auswertung = 32;
    Fixation_map_control = zeros((image_y+auswertung)/downsampling, (image_x+auswertung)/downsampling);
    Fixation_map_patient = zeros((image_y+auswertung)/downsampling, (image_x+auswertung)/downsampling);
    sigma = [28 0; 0 28];
    x2 = 1:auswertung/downsampling+1;
    x1 = 1:auswertung/downsampling+1;
    [X1,X2] = meshgrid(x1,x2);
    

%% Alle Daten der Kontrollen heraussuchen
my_message('Extract control data',0)

    pos_control = [0 0];
    anz_sakkpro_control = zeros(size(control_listing,1),1);
    
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
                anz_sakkpro_control(b) = anz_sakkpro_control(b) + size(pos, 1);
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
                anz_sakkpro_control(b) = anz_sakkpro_control(b) + size(pos, 1);
            end
        end
    end

%% Alle Daten der Patienten heraussuchen
my_message('Extract patient data',0)

    pos_patient = [0 0];
    anz_sakkpro_patient = zeros(size(patient_listing,1),1);
    
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
                anz_sakkpro_patient(b) = anz_sakkpro_patient(b) + size(pos, 1);
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
                anz_sakkpro_patient(b) = anz_sakkpro_patient(b) + size(pos, 1);
            end
        end
    end

%% Auswertung
my_message('Evaluate Data',0)

    pos_patient(1,:) = [];
    pos_control(1,:) = [];
    
    [~, test] = bootstrp(boot_nr, 'mean' ,pos_control(:,1));
    [~, test2] = bootstrp(boot_nr,'mean',pos_patient(:,1));

    leave_one_out_map_control = cell(2,size(anz_sakkpro_control,1)-1);
    leave_one_out_map_patient = cell(2,size(anz_sakkpro_patient,1)-1);
    init = zeros((image_y+auswertung)/downsampling,(image_x+auswertung)/downsampling); init = mat2cell(init,(image_y+auswertung)/downsampling,(image_x+auswertung)/downsampling);
    leave_one_out_map_control(1,:) = init;
    leave_one_out_map_patient(1,:) = init;
    F = mvnpdf([X1(:) X2(:)],[floor(mean(x1)) floor(mean(x1))] ,sigma);
    F  = reshape(F,length(x1),length(x2));
    pos_control_down = floor(pos_control/downsampling);
    pos_control_down(pos_control_down==0) = 1;
    pos_patient_down = floor(pos_patient);
    pos_patient_down(pos_patient_down==0) = 1;
    for f = 1:boot_nr
my_message(cat(2,'Evaluate Data ', num2str(f), '/', num2str(boot_nr)),2)
        for g = 1:size(anz_sakkpro_control)-1
            for e = (sum(anz_sakkpro_control(1:g))+1):(sum(anz_sakkpro_control(1:g))+anz_sakkpro_control(g+1))
%                 g
%                 e
%                 if g == 18 && e == 19312
%                     pause(1);
%                 end;
                leave_one_out_map_control{1,g}(pos_control_down(e,2):pos_control_down(e,2)+length(x1)-1,pos_control_down(e,1):pos_control_down(e,1)+length(x1)-1) =...
                leave_one_out_map_control{1,g}(pos_control_down(e,2):pos_control_down(e,2)+length(x1)-1,pos_control_down(e,1):pos_control_down(e,1)+length(x1)-1) + F;
            end
        end
        
        for g = 1:size(anz_sakkpro_patient)-1
            for e = (sum(anz_sakkpro_patient(1:g))+1):(sum(anz_sakkpro_patient(1:g))+anz_sakkpro_patient(g+1))
                leave_one_out_map_patient{1,g}(pos_patient_down(e,2):pos_patient_down(e,2)+length(x1)-1,pos_patient_down(e,1):pos_patient_down(e,1)+length(x1)-1) =...
                leave_one_out_map_patient{1,g}(pos_patient_down(e,2):pos_patient_down(e,2)+length(x1)-1,pos_patient_down(e,1):pos_patient_down(e,1)+length(x1)-1) + F;
            end
        end
    end
    
    
    for a = 1:size(leave_one_out_map_control,2)
        Fixation_map_control = Fixation_map_control+ leave_one_out_map_control{1,a};
    end
    for a = 1:size(leave_one_out_map_patient,2)
        Fixation_map_patient = Fixation_map_patient+ leave_one_out_map_patient{1,a};
    end
    Fixation_map_control = Fixation_map_control((mean(x1)-1)/downsampling+1:end-(mean(x1)-1)/downsampling-1,(mean(x1)-1)/downsampling+1:end-(mean(x1)-1)/downsampling-1);
    Fixation_map_patient = Fixation_map_patient((mean(x1)-1)/downsampling+1:end-(mean(x1)-1)/downsampling-1,(mean(x1)-1)/downsampling+1:end-(mean(x1)-1)/downsampling-1);
    
    Fixation_map_control = Fixation_map_control./sum(trapz(Fixation_map_control));
    Fixation_map_patient = Fixation_map_patient./sum(trapz(Fixation_map_patient));
        
    figure(1)
    hold on; grid on; box on;
    set(gca,'FontWeight','bold');
    surf(Fixation_map_control, 'LineStyle', 'none', 'FaceAlpha', 0.3);
    caxis([min(Fixation_map_control(:))-.5*range(Fixation_map_control(:)),max(Fixation_map_control(:))]);
    legend('Fixation map - Control')
    colorbar
    xlim([0 image_x])
    ylim([0 image_y])
    if size(image_list,1) == 2
        image = imread(cat(2, image_path, '/', cat(2,image_list{2}, '.jpg')));
        imshow(image);
    end

    figure(2)
    hold on; grid on; box on;
    set(gca,'FontWeight','bold');
    surf(Fixation_map_patient, 'LineStyle', 'none', 'FaceAlpha', 0.3);
    caxis([min(Fixation_map_patient(:))-.5*range(Fixation_map_patient(:)),max(Fixation_map_patient(:))]);
    legend('Fixation map - Patient')
    colorbar
    xlim([0 image_x])
    ylim([0 image_y])
    if size(image_list,1) == 2
        image = imread(cat(2, image_path, '/', cat(2,image_list{2}, '.jpg')));
        imshow(image);
    end
    
    figure(3);
    hold on; grid on; box on;    
    set(gca,'FontWeight','bold');
    difference = (Fixation_map_control - Fixation_map_patient);
    amplitude = max(difference(:)) - min(difference(:));
    difference(difference(:) < (max(difference(:)) - amplitude*0.25) & difference(:) > (min(difference(:)) + amplitude*0.25)) = 0;
    surf(difference, 'LineStyle', 'none', 'FaceAlpha', 0.3);
    caxis([min(difference(:))-.5*range(difference(:)),max(difference(:))]);
    legend('Fixation map difference (cont. - pat.)')
    colorbar
    xlim([0 image_x])
    ylim([0 image_y])
    if size(image_list,1) == 2
        image = imread(cat(2, image_path, '/', cat(2,image_list{2}, '.jpg')));
        imshow(image);
    end
        
    if as_saliency == 1
%% leave one out saliency maps control
        % Saliency map von jedem Probanden einzeln
        % Gaußglocke um jeden Fixationspunkt eines Probanden
my_message('Compute saliency maps control', 0);
%      leave_one_out_map_control = cell(2,size(anz_sakkpro_control,1)-1);
%         for f = 1:size(anz_sakkpro_control)-1
%             leave_one_out_map_control{1,f} = zeros(length(x2),length(x1));
%             for e = (sum(anz_sakkpro_control(1:f))+1):(sum(anz_sakkpro_control(1:f))+anz_sakkpro_control(f+1))
%                 mu = [pos_control(e,1) pos_control(e,2)];
%                 buf = mvnpdf([X1(:) X2(:)],mu ,sigma);
%                 F  = reshape(buf,length(x2),length(x1));
%                 leave_one_out_map_control{1,f} = leave_one_out_map_control{1,f} + F;
%             end
%         end
%         % Einzelne Maps normieren
%         for h = 1:size(anz_sakkpro_control,1)-1
%             leave_one_out_map_control{1,h} = leave_one_out_map_control{1,h}./sum(trapz(leave_one_out_map_control{1,h}));
%         end
        anz_sakkpro_control(1) = [];
        
        if size(anz_sakkpro_control,1) >1;
            % Saliency map vorletzter herausgelassen + normieren
            leave_one_out_map_control{2,end} = leave_one_out_map_control{1,end};
            for g = 1:size(anz_sakkpro_control)-2
                leave_one_out_map_control{2,end} = leave_one_out_map_control{2,end} + leave_one_out_map_control{1,g};
            end
            leave_one_out_map_control{2,end} = leave_one_out_map_control{2,end}./sum(trapz(leave_one_out_map_control{2,end}));    
            
            if size(anz_sakkpro_control,1) >2;
                % Saliency map von allen anderen basierend auf dem vorher berechneten berechnen + normieren
                for f = size(anz_sakkpro_control)-1:-1:2
                    leave_one_out_map_control{2,f} = leave_one_out_map_control{1,f} + leave_one_out_map_control{2,f+1} - leave_one_out_map_control{1,f-1};
                    leave_one_out_map_control{2,f} = leave_one_out_map_control{2,f}./sum(trapz(leave_one_out_map_control{2,f}));
                end
            end
            % Letzte Saliency map extra berechnen + normieren
            leave_one_out_map_control{2,1} = leave_one_out_map_control{1,1} + leave_one_out_map_control{2,2} - leave_one_out_map_control{1,end};
            leave_one_out_map_control{2,1} = leave_one_out_map_control{2,1}./sum(trapz(leave_one_out_map_control{2,1}));
            % Normalisieren
            for h = 1:size(anz_sakkpro_control,1)
                leave_one_out_map_control{2,h} = (leave_one_out_map_control{2,h} - mean(leave_one_out_map_control{2,h}(:)))/std(leave_one_out_map_control{2,h}(:));
            end
        else
            leave_one_out_map_control{2,1} = leave_one_out_map_control{1,1};
        end
        
%% leave one out saliency maps patient
        % Saliency map von jedem Probanden einzeln
        % Gaußglocke um jeden Fixationspunkt eines Probanden
my_message('Compute saliency maps patient', 0);
%         leave_one_out_map_patient = cell(2,size(anz_sakkpro_patient,1)-1);
%         for f = 1:size(anz_sakkpro_patient)-1
%             leave_one_out_map_patient{1,f} = zeros(length(x2),length(x1));
%             for e = (sum(anz_sakkpro_patient(1:f))+1):(sum(anz_sakkpro_patient(1:f))+anz_sakkpro_patient(f+1))
%                 mu = [pos_patient(e,1) pos_patient(e,2)];
%                 buf = mvnpdf([X1(:) X2(:)],mu ,sigma);
%                 F  = reshape(buf,length(x2),length(x1));
%                 leave_one_out_map_patient{1,f} = leave_one_out_map_patient{1,f} + F;
%             end
%         end
%         % Einzelne Maps normieren
%         for h = 1:size(anz_sakkpro_patient,1)-1
%             leave_one_out_map_patient{1,h} = leave_one_out_map_patient{1,h}./sum(trapz(leave_one_out_map_patient{1,h}));
%         end
        anz_sakkpro_patient(1) = [];
        
        if size(anz_sakkpro_patient,1) >1;
            % Saliency map vorletzter herausgelassen + normieren
            leave_one_out_map_patient{2,end} = leave_one_out_map_patient{1,end};
            for g = 1:size(anz_sakkpro_patient)-2
                leave_one_out_map_patient{2,end} = leave_one_out_map_patient{2,end} + leave_one_out_map_patient{1,g};
            end
            leave_one_out_map_patient{2,end} = leave_one_out_map_patient{2,end}./sum(trapz(leave_one_out_map_patient{2,end}));    
            
            if size(anz_sakkpro_control,1) >2;
                % Saliency map von allen anderen basierend auf dem vorher berechneten berechnen + normieren
                for f = size(anz_sakkpro_patient)-1:-1:2
                    leave_one_out_map_patient{2,f} = leave_one_out_map_patient{1,f} + leave_one_out_map_patient{2,f+1} - leave_one_out_map_patient{1,f-1};
                    leave_one_out_map_patient{2,f} = leave_one_out_map_patient{2,f}./sum(trapz(leave_one_out_map_patient{2,f}));
                end
            end
            
            % Letzte Saliency map extra berechnen + normieren
            leave_one_out_map_patient{2,1} = leave_one_out_map_patient{1,1} + leave_one_out_map_patient{2,2} - leave_one_out_map_patient{1,end};
            leave_one_out_map_patient{2,1} = leave_one_out_map_patient{2,1}./sum(trapz(leave_one_out_map_patient{2,1}));

            % Normalisieren
            for h = 1:size(anz_sakkpro_patient,1)
                leave_one_out_map_patient{2,h} = (leave_one_out_map_patient{2,h} - mean(leave_one_out_map_patient{2,h}(:)))/std(leave_one_out_map_patient{2,h}(:));
            end
        else
            leave_one_out_map_patient{2,1} = leave_one_out_map_patient{1,1};
        end
        
%% NSS
my_message('Compute NSS', 0);
        anz_sakkpro_control = [0; anz_sakkpro_control];
        for a = 2:size(anz_sakkpro_control,1)
            anz_sakkpro_control(a) = anz_sakkpro_control(a-1) + anz_sakkpro_control(a);
        end
        anz_sakkpro_patient = [0; anz_sakkpro_patient];
        for a = 2:size(anz_sakkpro_patient,1)
            anz_sakkpro_patient(a) = anz_sakkpro_patient(a-1) + anz_sakkpro_patient(a);
        end

    % NSS für Kontrollen
        norm_scanpath_saliency_control = zeros(2,size(anz_sakkpro_control,1)-1);

        % NSS letzter herausgelassen
        pos_buf = [floor(pos_control(anz_sakkpro_control(end-1)+1:anz_sakkpro_control(end),1)/downsampling) floor(pos_control(anz_sakkpro_control(end-1)+1:anz_sakkpro_control(end),2)/downsampling)];
        pos_buf(pos_buf ==0) = 1;
        norm_scanpath_saliency_control(1,1) = mean(diag(leave_one_out_map_control{2,1}(pos_buf(:,2), pos_buf(:,1)))); % Unter n-1 Kontrollen und der herausgelassenen Kontrolle

        pos_buf = [floor(pos_patient(:,1)/downsampling) floor(pos_patient(:,2)/downsampling)];
        pos_buf(pos_buf ==0) = 1;
        norm_scanpath_saliency_control(2,1) = mean(diag(leave_one_out_map_control{2,1}(pos_buf(:,2), pos_buf(:,1)))); % Zwischen n-1 Kontrollen und allen Patienten
        
        if size(anz_sakkpro_control,1) > 2
            % NSS für den Rest
            for a = 3:size(anz_sakkpro_control,1)
                pos_buf = [floor(pos_control(anz_sakkpro_control(a-2)+1:anz_sakkpro_control(a-1),1)/downsampling) floor(pos_control(anz_sakkpro_control(a-2)+1:anz_sakkpro_control(a-1),2)/downsampling)];
                pos_buf(pos_buf ==0) = 1;
                norm_scanpath_saliency_control(1,a-1) = mean(diag(leave_one_out_map_control{2,a-1}(pos_buf(:,2),pos_buf(:,1)))); % Unter n-1 Kontrollen und der herausgelassenen Kontrolle

                pos_buf = [floor(pos_patient(:,1)/downsampling) floor(pos_patient(:,2)/downsampling)];
                pos_buf(pos_buf ==0) = 1;
                norm_scanpath_saliency_control(2,a-1) = mean(diag(leave_one_out_map_control{2,a-1}(pos_buf(:,2), pos_buf(:,1)))); % Zwischen n-1 Kontrollen und allen Patienten
            end
        end

    % NSS für Patienten
        norm_scanpath_saliency_patient = zeros(2,size(anz_sakkpro_patient,1)-1);

        % NSS letzter herausgelassen
        pos_buf = [floor(pos_patient(anz_sakkpro_patient(end-1)+1:anz_sakkpro_patient(end),1)/downsampling) floor(pos_patient(anz_sakkpro_patient(end-1)+1:anz_sakkpro_patient(end),2)/downsampling)];
        pos_buf(pos_buf ==0) = 1;
        norm_scanpath_saliency_patient(1,1) = mean(diag(leave_one_out_map_patient{2,1}(pos_buf(:,2), pos_buf(:,1)))); % Unter n-1 Kontrollen und der herausgelassenen Kontrolle

        pos_buf = [floor(pos_control(:,1)/downsampling) floor(pos_control(:,2)/downsampling)];
        pos_buf(pos_buf ==0) = 1;
        norm_scanpath_saliency_patient(2,1) = mean(diag(leave_one_out_map_patient{2,1}(pos_buf(:,2), pos_buf(:,1)))); % Zwischen n-1 Kontrollen und allen Patienten

        if size(anz_sakkpro_patient,1) > 2
            % NSS für den Rest
            for a = 3:size(anz_sakkpro_patient,1)
                pos_buf = [floor(pos_patient(anz_sakkpro_patient(a-2)+1:anz_sakkpro_patient(a-1),1)/downsampling) floor(pos_patient(anz_sakkpro_patient(a-2)+1:anz_sakkpro_patient(a-1),2)/downsampling)];
                pos_buf(pos_buf ==0) = 1;
                norm_scanpath_saliency_patient(1,a-1) = mean(diag(leave_one_out_map_patient{2,a-1}(pos_buf(:,2),pos_buf(:,1)))); % Unter n-1 Kontrollen und der herausgelassenen Kontrolle

                pos_buf = [floor(pos_control(:,1)/downsampling) floor(pos_control(:,2)/downsampling)];
                pos_buf(pos_buf ==0) = 1;
                norm_scanpath_saliency_patient(2,a-1) = mean(diag(leave_one_out_map_patient{2,a-1}(pos_buf(:,2), pos_buf(:,1)))); % Zwischen n-1 Kontrollen und allen Patienten
            end
        end
        
        figure(4)
        hold on; grid on; box on;
        set(gca,'FontWeight','bold');
        subplot(2,1,1)
        hold on; grid on; box on;
        set(gca,'FontWeight','bold');
        ylabel('NSS');
        boxplot(norm_scanpath_saliency_control', 'labels', {'n-1 controls vs. 1 control', 'n-1 controls vs. m patients'});
        subplot(2,1,2)
        hold on; grid on; box on;
        set(gca,'FontWeight','bold');
        boxplot(norm_scanpath_saliency_patient', 'labels', {'m-1 patients vs. 1 patients', 'm-1 patients vs. n controls'});
        ylabel('NSS');
    end
end
