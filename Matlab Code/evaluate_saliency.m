% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% saliancy: Auswahl im PopupMenü der Gui
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images


function evaluate_saliency(bilder, durchlauf, saliency_params, kontroll_kennung, patient_kennung, data_path, image_path)
    my_message('Evaluate saliencies',0)

    [faces, faces_m, faces_t, kont] =  Separate_test_images(image_path);

    [control_listing, patient_listing] =  Separate_test_persons(kontroll_kennung, patient_kennung, data_path);
    
    % Baue eine Liste aller Bilder, die abgearbeitet werden sollen
    image_list{1,1} = 'List of all images to use.';
    if bilder >= 8; image_list = vertcat(image_list, faces{2:end}); bilder = bilder -8; end;
    if bilder >= 4; image_list = vertcat(image_list, faces_m{2:end}); bilder = bilder -4; end;
    if bilder >= 2; image_list = vertcat(image_list, faces_t{2:end}); bilder = bilder -2; end;
    if bilder >= 1; image_list = vertcat(image_list, kont{2:end}); bilder = bilder -1; end;
    
    % Erstelle Saliancy maps für alle Bilder
    for z = 2:size(image_list,1)
        image = cat(2, image_path, '/', image_list{z,1}, '.jpg');
        saliency_params.imageName = image_list{z,1};
        saliency_params.imagePath = cat(2, image_path, '/AOI/');
        saliency_params.imageSize = size(imread(cat(2, image_path, '/', image_list{z,1}, '.jpg')));
        saliency_map(z) = gbvs(image, saliency_params);
        image_size(z,:) = size(saliency_map(z).master_map_resized);
    end
    
    
%% Alle Daten der Kontrollen heraussuchen
    my_message('Extract control data',0)

    counter = 1;

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
                Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', image_size(c,2), image_size(c,1));
                Sakk_pos_control{c,1} = Sakk_pos;
                map{counter,1} = saliency_map(c).master_map_resized;
                mask{counter,1} = makeFixationMask( Sakk_pos(:,1) , Sakk_pos(:,2) , size(map{counter}) , size(map{counter}) );
%                 rocSal(map{counter,1}, mask{counter,1})
                counter = counter +1;
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
                Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', image_size(c,2), image_size(c,1));
                Sakk_pos_control{c,1} = Sakk_pos;
                map{counter,1} = saliency_map(c).master_map_resized;
                mask{counter,1} = makeFixationMask( Sakk_pos(:,1) , Sakk_pos(:,2) , size(map{counter}) , size(map{counter}) );
%                 rocSal(map{counter,1}, mask{counter,1})
                counter = counter +1;
            end
        end
    end

%% Alle Daten der Patienten heraussuchen
    my_message('Extract patient data',0)

    counter = 1;

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
                Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', image_size(c,2), image_size(c,1));
                Sakk_pos_control{c,1} = Sakk_pos;
                map{counter,2} = saliency_map(c).master_map_resized;
                mask{counter,2} = makeFixationMask( Sakk_pos(:,1) , Sakk_pos(:,2) , size(map{counter}) , size(map{counter}) );
%                 rocSal(map{counter,2}, mask{counter,2})
                counter = counter +1;
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
                Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', image_size(c,2), image_size(c,1));
                Sakk_pos_control{c,1} = Sakk_pos;
                map{counter,2} = saliency_map(c).master_map_resized;
                mask{counter,2} = makeFixationMask( Sakk_pos(:,1) , Sakk_pos(:,2) , size(map{counter}) , size(map{counter}) );
%                 rocSal(map{counter,2}, mask{counter,2})
                counter = counter +1;
            end
        end
    end

%% Auswertung
    my_message('Evaluate Data',0)
    
%     Sanity check
%     for a =  1:size(mask, 1)
%         mask{a,1} = mask{a,1}+100*rand;
%     end
    
    figure(1)
    hold on; grid on;
    [p, area] = rocSal_mod(map, mask);
    plot(p(:,2), p(:,1));
    plot([0 1], [0 1],'k')
    text(0.6, 0.3, cat(2, 'Area under ROC: ', num2str(area) ));
    legend('ROC-curve');
    title('Classification of patients and control');
    xlabel('False Positive Rate (%)');
    ylabel('True Positive Rate (%)');
    
    h = figure(2);
    hold on; grid on;
    plot([0 1], [0 1],'k')
    subplot(1,2,1)
    plot([0 1], [0 1],'k')
    hold on; grid on;
    title('Classification of fixations and non fixations of 1^s^t control');
    xlabel('False Positive Rate (%)');
    ylabel('True Positive Rate (%)');
    for a = 2:5
        [p, area(a,1)] = rocSal_mod2(map{a,1}, mask{a,1});
        plot(p(:,2), p(:,1));
    end
    legend('ROC-curve for image 1', 'ROC-curve for image 2', 'ROC-curve for image 3', 'ROC-curve for image 4');
    subplot(1,2,2)
    hold on; grid on;
    plot([0 1], [0 1],'k')
    title('Classification of fixations and non fixations of 1^s^t patient');
    xlabel('False Positive Rate (%)');
    ylabel('True Positive Rate (%)');
    RowName = cell(4,1);
    for a = 2:5
        [p, area(a,2)] = rocSal_mod2(map{a,2}, mask{a,2});
        plot(p(:,2), p(:,1));
        RowName{a-1,1} = cat(2, 'image ', num2str(a-1));
    end
    legend('ROC-curve for image 1', 'ROC-curve for image 2', 'ROC-curve for image 3', 'ROC-curve for image 4');
    
    u = uitable(h, 'Data', [area(2:5,1) area(2:5,2)], ...
    'RowName', RowName, ...
    'ColumnName', {'control', 'patient'}, 'FontName', 'Arial', 'FontSize', 8);

    u.Position(1) = 100;
    u.Position(2) = 100;
    u.Position(3) = 230;
    u.Position(4) = 90;
    
    figure(3)
    hold on; grid on;
    for a = 6:size(mask,1)
        [~, area(a,1)] = rocSal_mod2(map{a,1}, mask{a,1});
        [~, area(a,2)] = rocSal_mod2(map{a,2}, mask{a,2});
    end
    area(2:end,:) = sort(area(2:end,:));
    plot(1:size(mask, 1)-1, area(2:end,1));
    plot(1:size(mask, 1)-1, area(2:end,2));
%     histogram(area(2:end,1),100);
%     histogram(area(2:end,2),100);
    title('Plot - Area under ROC')
    ylabel('area under ROC [0,1]');
    xlabel('#')
    legend('control', 'patient');
 
end