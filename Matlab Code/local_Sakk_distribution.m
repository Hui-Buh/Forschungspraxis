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
    downsampling = 1;
    Fixation_map_control = zeros(456/downsampling, 288/downsampling);
    Fixation_map_patient = zeros(456/downsampling, 288/downsampling);
    sigma = [28 0; 0 28];
    x2 = 1:downsampling:456;
    x1 = 1:downsampling:288;
    [X1,X2] = meshgrid(x1,x2);
    

%% Alle Daten der Kontrollen heraussuchen
    my_message('Extract control data',0)

    pos_control = [0 0];
    anz_sakkpro_control = zeros(size(control_listing,1),1);
    
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
                pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
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
                pos = center_image(Sakk_parsed(:, 5), Sakk_parsed(:, 6), '-', '-', '-', '-', 300, 460);
                pos_patient = [pos_patient ; pos(:, 1:2)]; 
                anz_sakkpro_patient(b) = anz_sakkpro_patient(b) + size(pos, 1);
            end
        end
    end

%% Auswertung
    my_message('Evaluate Data',0)

    pos_patient(1,:) = [];
    pos_control(1,:) = [];
    
    boot_nr = 10;
    [~, test] = bootstrp(boot_nr, 'mean' ,pos_control(:,1));
    [~, test2] = bootstrp(boot_nr,'mean',pos_patient(:,1));

    for f = 1:boot_nr
        for e = 1:size(pos_control,1)
            mu = [pos_control(test(e,f),1) pos_control(test(e,f),2)];
            buf = mvnpdf([X1(:) X2(:)],mu ,sigma);
            F = reshape(buf,length(x2),length(x1));
            Fixation_map_control = Fixation_map_control + F;
        end
        for e = 1:size(pos_patient,1)
            mu = [pos_patient(test2(e,f),1) pos_patient(test2(e,f),2)];
            buf = mvnpdf([X1(:) X2(:)],mu ,sigma);
            F = reshape(buf,length(x2),length(x1));
            Fixation_map_patient = Fixation_map_patient + F;
        end
    end
    Fixation_map_control = Fixation_map_control./sum(trapz(Fixation_map_control));
    Fixation_map_patient = Fixation_map_patient./sum(trapz(Fixation_map_patient));
        
    figure(1)
    hold on; grid off; 
    surf(x1,x2,Fixation_map_control, 'LineStyle', 'none');
    caxis([min(Fixation_map_control(:))-.5*range(Fixation_map_control(:)),max(Fixation_map_control(:))]);
    legend('Fixation map - Kontrollen')
    colorbar
    xlim([0 300])
    ylim([0 460])

    figure(2)
    hold on; grid off; 
    surf(x1,x2,Fixation_map_patient, 'LineStyle', 'none');
    caxis([min(Fixation_map_patient(:))-.5*range(Fixation_map_patient(:)),max(Fixation_map_patient(:))]);
    legend('Fixation map - Patienten')
    colorbar
    xlim([0 300])
    ylim([0 460])
    
    figure(3);
    hold on; grid off; 
    difference = (Fixation_map_control - Fixation_map_patient);
    amplitude = max(difference(:)) - min(difference(:));
    difference(difference < max(difference(:)) - amplitude*0.25 & difference > min(difference(:)) - amplitude*0.25) = 0;
    surf(x1,x2,difference, 'LineStyle', 'none');
    caxis([min(difference(:))-.5*range(difference(:)),max(difference(:))]);
    legend('Fixation map difference')
    colorbar
    xlim([0 300])
    ylim([0 460])
        
    if as_saliency == 1
        my_message('Compute NNS', 0);
        
%% leave one out saliency maps control
        % Saliency map von jedem Probanden einzeln
        % Gaußglocke um jeden Fixationspunkt eines Probanden
     leave_one_out_map_control = cell(2,size(anz_sakkpro_control,1)-1);
        for f = 1:size(anz_sakkpro_control)-1
            leave_one_out_map_control{1,f} = zeros(length(x2),length(x1));
            for e = (sum(anz_sakkpro_control(1:f))+1):(sum(anz_sakkpro_control(1:f))+anz_sakkpro_control(f+1))
                mu = [pos_control(e,1) pos_control(e,2)];
                buf = mvnpdf([X1(:) X2(:)],mu ,sigma);
                F  = reshape(buf,length(x2),length(x1));
                leave_one_out_map_control{1,f} = leave_one_out_map_control{1,f} + F;
            end
        end
        % Einzelne Maps normieren
        for h = 1:size(anz_sakkpro_control,1)-1
            leave_one_out_map_control{1,h} = leave_one_out_map_control{1,h}./sum(trapz(leave_one_out_map_control{1,h}));
        end
        anz_sakkpro_control(1) = [];
        % Saliency map vorletzter herausgelassen + normieren
        leave_one_out_map_control{2,end} = leave_one_out_map_control{1,end};
        for g = 1:size(anz_sakkpro_control)-2
            leave_one_out_map_control{2,end} = leave_one_out_map_control{2,end} + leave_one_out_map_control{1,g};
        end
        leave_one_out_map_control{2,end} = leave_one_out_map_control{2,end}./sum(trapz(leave_one_out_map_control{2,end}));    
        % Saliency map von allen anderen basierend auf dem vorher berechneten berechnen + normieren
        for f = size(anz_sakkpro_control)-1:-1:2
            leave_one_out_map_control{2,f} = leave_one_out_map_control{1,f} + leave_one_out_map_control{2,f+1} - leave_one_out_map_control{1,f-1};
            leave_one_out_map_control{2,f} = leave_one_out_map_control{2,f}./sum(trapz(leave_one_out_map_control{2,f}));
         end
        % Letzte Saliency map extra berechnen + normieren
        leave_one_out_map_control{2,1} = leave_one_out_map_control{1,1} + leave_one_out_map_control{2,2} - leave_one_out_map_control{1,7};
        leave_one_out_map_control{2,1} = leave_one_out_map_control{2,1}./sum(trapz(leave_one_out_map_control{2,1}));
        
        % Normieren
        for h = 1:size(anz_sakkpro_control,1)
            leave_one_out_map_control{2,h} = (leave_one_out_map_control{2,h} - mean(leave_one_out_map_control{2,h}(:)))/std(leave_one_out_map_control{2,h}(:));
        end
        
%% leave one out saliency maps patient
        % Saliency map von jedem Probanden einzeln
        % Gaußglocke um jeden Fixationspunkt eines Probanden
        leave_one_out_map_patient = cell(2,size(anz_sakkpro_patient,1)-1);
        for f = 1:size(anz_sakkpro_patient)-1
            leave_one_out_map_patient{1,f} = zeros(length(x2),length(x1));
            for e = (sum(anz_sakkpro_patient(1:f))+1):(sum(anz_sakkpro_patient(1:f))+anz_sakkpro_patient(f+1))
                mu = [pos_patient(e,1) pos_patient(e,2)];
                buf = mvnpdf([X1(:) X2(:)],mu ,sigma);
                F  = reshape(buf,length(x2),length(x1));
                leave_one_out_map_patient{1,f} = leave_one_out_map_patient{1,f} + F;
            end
        end
        % Einzelne Maps normieren
        for h = 1:size(anz_sakkpro_patient,1)-1
            leave_one_out_map_patient{1,h} = leave_one_out_map_patient{1,h}./sum(trapz(leave_one_out_map_patient{1,h}));
        end
        anz_sakkpro_patient(1) = [];
        % Saliency map vorletzter herausgelassen + normieren
        leave_one_out_map_patient{2,end} = leave_one_out_map_patient{1,end};
        for g = 1:size(anz_sakkpro_patient)-2
            leave_one_out_map_patient{2,end} = leave_one_out_map_patient{2,end} + leave_one_out_map_patient{1,g};
        end
        leave_one_out_map_patient{2,end} = leave_one_out_map_patient{2,end}./sum(trapz(leave_one_out_map_patient{2,end}));    
        % Saliency map von allen anderen basierend auf dem vorher berechneten berechnen + normieren
        for f = size(anz_sakkpro_patient)-1:-1:2
            leave_one_out_map_patient{2,f} = leave_one_out_map_patient{1,f} + leave_one_out_map_patient{2,f+1} - leave_one_out_map_patient{1,f-1};
            leave_one_out_map_patient{2,f} = leave_one_out_map_patient{2,f}./sum(trapz(leave_one_out_map_patient{2,f}));
         end
        % Letzte Saliency map extra berechnen + normieren
        leave_one_out_map_patient{2,1} = leave_one_out_map_patient{1,1} + leave_one_out_map_patient{2,2} - leave_one_out_map_patient{1,7};
        leave_one_out_map_patient{2,1} = leave_one_out_map_patient{2,1}./sum(trapz(leave_one_out_map_patient{2,1}));
        
        % Normieren
        for h = 1:size(anz_sakkpro_patient,1)
            leave_one_out_map_patient{2,h} = (leave_one_out_map_patient{2,h} - mean(leave_one_out_map_patient{2,h}(:)))/std(leave_one_out_map_patient{2,h}(:));
        end
        
%% NSS
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

        pos_buf = [floor(pos_control(anz_sakkpro_control(end-1)+1:anz_sakkpro_control(end),1)/downsampling) floor(pos_control(anz_sakkpro_control(end-1)+1:anz_sakkpro_control(end),2)/downsampling)];
        pos_buf(pos_buf ==0) = 1;
        norm_scanpath_saliency_control(1,1) = mean(diag(leave_one_out_map_control{2,1}(pos_buf(:,2), pos_buf(:,1)))); % Unter n-1 Kontrollen und der herausgelassenen Kontrolle

        pos_buf = [floor(pos_patient(:,1)/downsampling) floor(pos_patient(:,2)/downsampling)];
        pos_buf(pos_buf ==0) = 1;
        norm_scanpath_saliency_control(2,1) = mean(diag(leave_one_out_map_control{2,1}(pos_buf(:,2), pos_buf(:,1)))); % Zwischen n-1 Kontrollen und allen Patienten

        for a = 3:size(anz_sakkpro_control,1)
            pos_buf = [floor(pos_control(anz_sakkpro_control(a-2)+1:anz_sakkpro_control(a-1),1)/downsampling) floor(pos_control(anz_sakkpro_control(a-2)+1:anz_sakkpro_control(a-1),2)/downsampling)];
            pos_buf(pos_buf ==0) = 1;
            norm_scanpath_saliency_control(1,a-1) = mean(diag(leave_one_out_map_control{2,a-1}(pos_buf(:,2),pos_buf(:,1)))); % Unter n-1 Kontrollen und der herausgelassenen Kontrolle

            pos_buf = [floor(pos_patient(:,1)/downsampling) floor(pos_patient(:,2)/downsampling)];
            pos_buf(pos_buf ==0) = 1;
            norm_scanpath_saliency_control(2,a-1) = mean(diag(leave_one_out_map_control{2,a-1}(pos_buf(:,2), pos_buf(:,1)))); % Zwischen n-1 Kontrollen und allen Patienten
        end

    % NSS für Patienten
        norm_scanpath_saliency_patient = zeros(2,size(anz_sakkpro_patient,1)-1);

        pos_buf = [floor(pos_patient(anz_sakkpro_patient(end-1)+1:anz_sakkpro_patient(end),1)/downsampling) floor(pos_patient(anz_sakkpro_patient(end-1)+1:anz_sakkpro_patient(end),2)/downsampling)];
        pos_buf(pos_buf ==0) = 1;
        norm_scanpath_saliency_patient(1,1) = mean(diag(leave_one_out_map_patient{2,1}(pos_buf(:,2), pos_buf(:,1)))); % Unter n-1 Kontrollen und der herausgelassenen Kontrolle

        pos_buf = [floor(pos_control(:,1)/downsampling) floor(pos_control(:,2)/downsampling)];
        pos_buf(pos_buf ==0) = 1;
        norm_scanpath_saliency_patient(2,1) = mean(diag(leave_one_out_map_patient{2,1}(pos_buf(:,2), pos_buf(:,1)))); % Zwischen n-1 Kontrollen und allen Patienten

        for a = 3:size(anz_sakkpro_patient,1)
            pos_buf = [floor(pos_patient(anz_sakkpro_patient(a-2)+1:anz_sakkpro_patient(a-1),1)/downsampling) floor(pos_patient(anz_sakkpro_patient(a-2)+1:anz_sakkpro_patient(a-1),2)/downsampling)];
            pos_buf(pos_buf ==0) = 1;
            norm_scanpath_saliency_patient(1,a-1) = mean(diag(leave_one_out_map_patient{2,a-1}(pos_buf(:,2),pos_buf(:,1)))); % Unter n-1 Kontrollen und der herausgelassenen Kontrolle

            pos_buf = [floor(pos_control(:,1)/downsampling) floor(pos_control(:,2)/downsampling)];
            pos_buf(pos_buf ==0) = 1;
            norm_scanpath_saliency_patient(2,a-1) = mean(diag(leave_one_out_map_patient{2,a-1}(pos_buf(:,2), pos_buf(:,1)))); % Zwischen n-1 Kontrollen und allen Patienten
        end
        
    figure(4)
    hold on; grid on;

    boxplot([norm_scanpath_saliency_control' norm_scanpath_saliency_patient'], 'labels', {'n-1 controls vs. 1 control', 'n-1 controls vs. m patients', 'm-1 patients vs. 1 patients', 'm-1 patients vs. n controls'});

    ylabel('NSS');
    end
end
