% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% saliancy: Auswahl im PopupMenü der Gui
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images


function evaluate_saliency(bilder, durchlauf, saliency_params, kontroll_kennung, patient_kennung, data_path, image_path, NSS)
my_message('Evaluate saliencies',0)

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
    
    % Erstelle Saliancy maps für alle Bilder
    for z = 2:size(image_list,1)
        image = cat(2, image_path, '/', image_list{z,1}, '.jpg');
        saliency_params.imageName = image_list{z,1};
        saliency_params.imagePath = cat(2, image_path, '/AOI/');
        saliency_params.imageSize = size(imread(cat(2, image_path, '/', image_list{z,1}, '.jpg')));
        if NSS == 0
            saliency_map(z) = gbvs(image, saliency_params);
%             image_size(z,:) = size(saliency_map(z).master_map_resized);
        end
    end 

    
%% Alle Daten der Kontrollen heraussuchen
my_message('Extract control data',0)

    counter = 1;

    for b = 2:size(control_listing,1)
my_message(cat(2,'Extract control data ', num2str(b), '/', num2str(size(control_listing,1))),2)
        if durchlauf == 1 || durchlauf == 3
            for c = 2:size(image_list,1)
                % Open .mat file
                if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', image_list{c,1} , '_1','.mat' ), 'file') > 0
                    m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', image_list{c,1} , '_1','.mat' ));
                else
                    counter = counter +1;
                    continue
                end
                % Extrahiere alle notwendigen Daten
                clearvars Sakk_parsed Sakk_pos
                Sakk_parsed = m.Sakk_parsed;
                image_size = m.image_size;
                Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', image_size(2), image_size(1));
                Sakk_pos_control{c,1} = Sakk_pos;
                if NSS == 0
                    map{counter,1} = saliency_map(c).master_map_resized;
                else
                    map{counter,1} = makeSaliencyMap_NSS( Sakk_pos(:,1) , Sakk_pos(:,2), image_size );
                end
                mask{counter,1} = makeFixationMask( Sakk_pos(:,1) , Sakk_pos(:,2) , size(map{counter,1}) , size(map{counter,1}) );
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
                    counter = counter +1;
                    continue
                end
                % Extrahiere alle notwendigen Daten
                clearvars Sakk_parsed Sakk_pos
                Sakk_parsed = m.Sakk_parsed;
                image_size = m.image_size;
                Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', image_size(2), image_size(1));
                Sakk_pos_control{c,1} = Sakk_pos;
                if NSS == 0
                    map{counter,1} = saliency_map(c).master_map_resized;
                else
                    map{counter,1} = makeSaliencyMap_NSS( Sakk_pos(:,1) , Sakk_pos(:,2), image_size );
                end
                mask{counter,1} = makeFixationMask( Sakk_pos(:,1) , Sakk_pos(:,2) , size(map{counter,1}) , size(map{counter,1}) );
%                 rocSal(map{counter,1}, mask{counter,1})
                counter = counter +1;
            end
        end
    end

%% Alle Daten der Patienten heraussuchen
my_message('Extract patient data',0)

    counter = 1;

    for b = 2:size(patient_listing,1)
my_message(cat(2,'Extract patient data ', num2str(b), '/', num2str(size(patient_listing,1))),2)
        if durchlauf == 1 || durchlauf == 3
            for c = 2:size(image_list,1)
                % Open .mat file
                if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', image_list{c,1} , '_1','.mat' ), 'file') > 0
                    m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', image_list{c,1} , '_1','.mat' ));
                else
                    counter = counter +1;
                    continue
                end
                % Extrahiere alle notwendigen Daten
                clearvars Sakk_parsed Sakk_pos
                Sakk_parsed = m.Sakk_parsed;
                image_size = m.image_size;
                Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', image_size(2), image_size(1));
                Sakk_pos_control{c,1} = Sakk_pos;
                if NSS == 0
                    map{counter,2} = saliency_map(c).master_map_resized;
                else
                    map{counter,2} = makeSaliencyMap_NSS( Sakk_pos(:,1) , Sakk_pos(:,2), image_size );
                end
                mask{counter,2} = makeFixationMask( Sakk_pos(:,1) , Sakk_pos(:,2) , size(map{counter,2}) , size(map{counter,2}) );
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
                    counter = counter +1;
                    continue
                end
                % Extrahiere alle notwendigen Daten
                clearvars Sakk_parsed Sakk_pos
                Sakk_parsed = m.Sakk_parsed;
                image_size = m.image_size;
                Sakk_pos = center_image(Sakk_parsed(:,5), Sakk_parsed(:,6), '-', '-', '-', '-', image_size(2), image_size(1));
                Sakk_pos_control{c,1} = Sakk_pos;
                if NSS == 0
                    map{counter,2} = saliency_map(c).master_map_resized;
                else
                    map{counter,2} = makeSaliencyMap_NSS( Sakk_pos(:,1) , Sakk_pos(:,2), image_size );
                end
                mask{counter,2} = makeFixationMask( Sakk_pos(:,1) , Sakk_pos(:,2) , size(map{counter,2}) , size(map{counter,2}) );
%                 rocSal(map{counter,2}, mask{counter,2})
                counter = counter +1;
            end
        end
    end

%% Auswertung
    my_message('Evaluate Data 1:',0)
    
%     Sanity check
%     for a =  1:size(mask, 1)
%         mask{a,1} = mask{a,1}+100*rand;
%     end

    if NSS ==1
        mask_NSS = reshape(mask, size(image_list,1)-1, (size(control_listing,1)-1)+(size(patient_listing,1)-1));
        map_NSS = reshape(map, size(image_list,1)-1, (size(control_listing,1)-1)+(size(patient_listing,1)-1));
        mask_NSS( sum(cellfun(@isempty,map_NSS),2)>0, : ) = [];
        map_NSS( sum(cellfun(@isempty,map_NSS),2)>0, : ) = [];
    end
    mask( all(cellfun(@isempty,map(:,1)),2), : ) = [];
    map( all(cellfun(@isempty,map(:,1)),2), : ) = [];
    mask( all(cellfun(@isempty,map(:,2)),2), : ) = [];
    map( all(cellfun(@isempty,map(:,2)),2), : ) = [];
    
    
%     [p, area] = rocSal_mod(map, mask);
%     figure(1)
%     hold on; grid on; box on;
%     set(gca,'FontWeight','bold');
%     plot(p(:,2), p(:,1));
%     plot([0 1], [0 1],'k')
%     text(0.6, 0.3, cat(2, 'Area under ROC: ', num2str(area) ));
%     legend('ROC-curve');
%     title('Classification of patients and controls');
%     xlabel('False Positive Rate (%)');
%     ylabel('True Positive Rate (%)');
    
    
    h = figure(2);
    hold on; grid on; box on;
    set(gca,'FontWeight','bold');
my_message('Evaluate Data 2:',0)
    plot([0 1], [0 1],'k')
    subplot(1,2,1)
    plot([0 1], [0 1],'k')
    hold on; grid on; box on;
    set(gca,'FontWeight','bold');
    title('Classification of fix. and non fix. of some controls');
    xlabel('False Positive Rate (%)');
    ylabel('True Positive Rate (%)');
    for a = 2:5
my_message(cat(2,'Evaluate data 2: ', num2str(a), '/', num2str(size(mask,1)+10)),2)
        [p, area(a,1)] = rocSal_mod2(map{a,1}, mask{a,1});
        plot(p(:,2), p(:,1));
    end
    legend('ROC-curve for image 1', 'ROC-curve for image 2', 'ROC-curve for image 3', 'ROC-curve for image 4');
    subplot(1,2,2)
    hold on; grid on; box on;
    set(gca,'FontWeight','bold');
    plot([0 1], [0 1],'k')
    title('Classification of fix. and non fix. of some patients');
    xlabel('False Positive Rate (%)');
    ylabel('True Positive Rate (%)');
    RowName = cell(4,1);
    for c = 2:5
my_message(cat(2,'Evaluate data 2: ', num2str(a+c), '/', num2str(size(mask,1)+10)),2)
        [p, area(c,2)] = rocSal_mod2(map{c,2}, mask{c,2});
        plot(p(:,2), p(:,1));
        RowName{c-1,1} = cat(2, 'image ', num2str(c-1));
    end
    legend('ROC-curve for image 1', 'ROC-curve for image 2', 'ROC-curve for image 3', 'ROC-curve for image 4');
    area(area==-1) = [];
    u = uitable(h, 'Data', [area(2:5,1) area(2:5,2)], ...
    'RowName', RowName, ...
    'ColumnName', {'control', 'patient'}, 'FontName', 'Arial', 'FontSize', 8);

    u.Position(1) = 100;
    u.Position(2) = 100;
    u.Position(3) = 230;
    u.Position(4) = 90;
    
    
%     for b = 6:size(mask,1)
% my_message(cat(2,'Evaluate data 2: ', num2str(a+b+c), '/', num2str(size(mask,1)+10)),2)
%         [~, area(b,1)] = rocSal_mod2(map{b,1}, mask{b,1});
%         [~, area(b,2)] = rocSal_mod2(map{b,2}, mask{b,2});
%     end
%     figure(3)
%     hold on; grid on; box on;
%     set(gca,'FontWeight','bold');
%     area(2:end,:) = sort(area(2:end,:));
%     plot(1:size(mask, 1)-1, area(2:end,1));
%     plot(1:size(mask, 1)-1, area(2:end,2));
%     difference = (trapz(area(2:end,1)) / trapz(area(2:end,2)) -1)*100;
%     text(10, 0.8, cat(2, 'Control fixations are ', num2str(difference), '% better predictable.'));
%     title('Area under ROC')
%     ylabel('area under ROC [0,1]');
%     xlabel('#')
%     legend('control', 'patient');
 
    
    figure(4)
    hold on; grid on; box on;    
    set(gca,'FontWeight','bold');
    saliency_value_c =0;
    saliency_value_p=0;
    for a = 1:size(map,1)
        tmp = map{a,1}.*mask{a,1};
        tmp = tmp(tmp~=0);
        saliency_value_c = [ saliency_value_c; tmp];
        tmp = map{a,2}.*mask{a,2};
        tmp = tmp(tmp~=0);
        saliency_value_p = [ saliency_value_p; tmp];;
    end
    saliency_value_c(1) =[];
    saliency_value_p(1) =[];
    ecdf(saliency_value_c);
    ecdf(saliency_value_p);
    title('ecdf', 'FontSize', 12);
    legend('Saliency values at saccade end points Control', 'Saliency values at saccade end points Patient', 'location', 'southeast');
    [kstest_reject, p, max_vert_abstand] = kstest2(saliency_value_c, saliency_value_p);
    data_mean(1) = mean(saliency_value_c);
    data_mean(2) = mean(saliency_value_p);
    data_median(1) = median(saliency_value_c);
    data_median(2) = median(saliency_value_p);
    
    u = uitable('Data', [kstest_reject; p; max_vert_abstand; data_mean(1); data_mean(2); data_median(1); data_median(2)], ...
    'RowName', {'reject h_0', 'p-value', 'max. vert. dist.', 'Mean Control', 'Mean Patient', 'Median Control', 'Median Patient'}, ...
    'ColumnName', 'Data', 'FontName', 'Arial', 'FontSize', 8);

    u.Position(1) = 180;
    u.Position(2) = 120;
    u.Position(3) = 254;
    u.Position(4) = 141;
    
    
    if NSS ==1
        
        for a = 1:size(map_NSS,1)
            % Leave one out für a-tes Bild controls
            leave_one_out = map_NSS(a,1:size(control_listing,1)-1);
            leave_one_out = [leave_one_out leave_one_out(1,1) ];
            leave_one_out{2,end} = zeros(size(map_NSS{a,1}));
            for b = 1:size(control_listing,1)-2
                leave_one_out{2,end} = leave_one_out{2,end} + leave_one_out{1,b};
            end
            for c = size(leave_one_out,2)-1:-1:2
                leave_one_out{2,c} = leave_one_out{2,c+1} + leave_one_out{1,c} - leave_one_out{1,c-1};
            end
            leave_one_out(:,1) = []; 
            for d = 1:size(leave_one_out,2)
                leave_one_out{2,d} = leave_one_out{2,d}./sum(trapz(leave_one_out{2,d}));
                leave_one_out{2,d} = (leave_one_out{2,d} - mean(leave_one_out{2,d}(:)))/std(leave_one_out{2,d}(:));
            end
            % NSS für a-tes Bild controls
            for e = 1:size(leave_one_out,2)
                buf = leave_one_out{2,e}(:).*mask_NSS{a,e}(:);
                buf2 = find(mask_NSS{a,e}(:));
                buf = buf(buf2);
                norm_scanpath_saliency_control(a,e) = mean(buf);
            end
            
            
            % Leave one out für a-tes Bild patients
            leave_one_out = map_NSS(a,size(control_listing,1):end);
            leave_one_out = [leave_one_out leave_one_out(1,1) ];
            leave_one_out{2,end} = zeros(size(map_NSS{a,size(control_listing,1)}));
            for b = 1:size(patient_listing,1)-2
                leave_one_out{2,end} = leave_one_out{2,end} + leave_one_out{1,b};
            end
            for c = size(leave_one_out,2)-1:-1:2
                leave_one_out{2,c} = leave_one_out{2,c+1} + leave_one_out{1,c} - leave_one_out{1,c-1};
            end
            leave_one_out(:,1) = []; 
            for d = 1:size(leave_one_out,2)
                leave_one_out{2,d} = leave_one_out{2,d}./sum(trapz(leave_one_out{2,d}));
                leave_one_out{2,d} = (leave_one_out{2,d} - mean(leave_one_out{2,d}(:)))/std(leave_one_out{2,d}(:));
            end
            % NSS für a-tes Bild patients
            for e = 1:size(leave_one_out,2)
                buf = leave_one_out{2,e}(:).*mask_NSS{a,e+size(control_listing,1)-1}(:);
                buf2 = find(mask_NSS{a,e}(:));
                buf = buf(buf2);
                norm_scanpath_saliency_patient(a,e) = mean(buf);
            end
            
        end

        figure(5)
        hold on; grid on; box on;
        set(gca,'FontWeight','bold');
        subplot(2,1,1)
        hold on; grid on; box on;
        set(gca,'FontWeight','bold');
        ylabel('NSS');
        boxplot(norm_scanpath_saliency_control');%, 'labels', {'n-1 controls vs. 1 control', 'n-1 controls vs. m patients'});
        subplot(2,1,2)
        hold on; grid on; box on;
        set(gca,'FontWeight','bold');
        boxplot(norm_scanpath_saliency_patient');%, 'labels', {'m-1 patients vs. 1 patients', 'm-1 patients vs. n controls'});
        ylabel('NSS');
    end
end