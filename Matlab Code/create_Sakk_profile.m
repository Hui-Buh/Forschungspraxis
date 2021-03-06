% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% Sakkpx_Sakkgrad: 1 = Sakkadenamplituden in px, 2 = Sakkadenamplituden in°,
% vel_acc: What should be plotted? 1 = vel, 2 = acc, 3 = vel+acc
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images


function create_Sakk_profile( bilder, durchlauf, Sakkpx_Sakkgrad, vel_acc, kontroll_kennung, patient_kennung, data_path, image_path, sakkaden_amplitude )
my_message('Create saccade profile',0)
    
    sakkaden_amplitude = str2num(sakkaden_amplitude);
    if isempty(sakkaden_amplitude) == 1
        my_message('Please enter valid saccade amplitude',0);
        my_message('Ended badly',0);
        return;
    end
    if sakkaden_amplitude < 0
        my_message('Only positive saccade amplitudes are valid',0);
        my_message('Ended badly',0);
        return;
    end

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
    boot_nr = 100;
    
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
                    continue
                end
                % Extrahiere alle notwendigen Daten
                try % Check for variable Data
                    Data = m.Data_;
                catch my_error
                    my_message('.mat file lacks the Data ',0)
                    my_message('Ended badly',0) 
                    return;
                end
                Sakk_parsed = m.Sakk_parsed;
                monokular = m.monokular;
                for d = 1:size(Sakk_parsed, 1)
                    clearvars buf
                    buf = Data(Data(:,1) >= Sakk_parsed(d,1) & Data(:,1) <= Sakk_parsed(d,4),:);
                    if monokular == 2
                        buf(:,2) = buf(:,4);
                        buf(:,3) = buf(:,5);
                    elseif monokular == 3
                        buf(:,2) = mean([buf(:,2) buf(:,4)],2);
                        buf(:,3) = mean([buf(:,3) buf(:,5)],2);
                    end
                    sakkade_control{d,counter} = buf(:,1:3);
                end
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
                try % Check for variable Data
                    Data = m.Data_;
                catch my_error
                    my_message('.mat file lacks the Data ',0)
                    my_message('Ended badly',0) 
                    return;
                end
                Sakk_parsed = m.Sakk_parsed;
                monokular = m.monokular;
                for d = 1:size(Sakk_parsed, 1)
                    clearvars buf
                    buf = Data(Data(:,1) >= Sakk_parsed(d,1) & Data(:,1) <= Sakk_parsed(d,4),:);
                    if monokular == 2
                        buf(:,2) = buf(:,4);
                        buf(:,3) = buf(:,5);
                    elseif monokular == 3
                        buf(:,2) = mean([buf(:,2) buf(:,4)],2);
                        buf(:,3) = mean([buf(:,3) buf(:,5)],2);
                    end
                    sakkade_control{d,counter} = buf(:,1:3);
                end
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
                    continue
                end
                % Extrahiere alle notwendigen Daten
                try % Check for variable Data
                    Data = m.Data_;
                catch my_error
                    my_message('.mat file lacks the Data ',0)
                    my_message('Ended badly',0) 
                    return;
                end
                Sakk_parsed = m.Sakk_parsed;
                monokular = m.monokular;
                for d = 1:size(Sakk_parsed, 1)
                    clearvars buf
                    buf = Data(Data(:,1) >= Sakk_parsed(d,1) & Data(:,1) <= Sakk_parsed(d,4),:);
                    if monokular == 2
                        buf(:,2) = buf(:,4);
                        buf(:,3) = buf(:,5);
                    elseif monokular == 3
                        buf(:,2) = mean([buf(:,2) buf(:,4)],2);
                        buf(:,3) = mean([buf(:,3) buf(:,5)],2);
                    end
                    sakkade_patient{d,counter} = buf(:,1:3);
                end
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
                try % Check for variable Data
                    Data = m.Data_;
                catch my_error
                    my_message('.mat file lacks the Data ',0)
                    my_message('Ended badly',0) 
                    return;
                end
                Sakk_parsed = m.Sakk_parsed;
                monokular = m.monokular;
                for d = 1:size(Sakk_parsed, 1)
                    clearvars buf
                    buf = Data(Data(:,1) >= Sakk_parsed(d,1) & Data(:,1) <= Sakk_parsed(d,4),:);
                    if monokular == 2
                        buf(:,2) = buf(:,4);
                        buf(:,3) = buf(:,5);
                    elseif monokular == 3
                        buf(:,2) = mean([buf(:,2) buf(:,4)],2);
                        buf(:,3) = mean([buf(:,3) buf(:,5)],2);
                    end
                    sakkade_patient{d,counter} = buf(:,1:3);
                end
                counter = counter +1;
            end
        end
    end  

%% Auswertung
    my_message('Evaluate Data',0)
    
    time_c = 1;
    counter = 1;

    for a = 1:size(sakkade_control,2) % alle Bilder aller Patienten durchlaufen     - Kontrollen
my_message(cat(2,'Evaluate Data ', num2str(a), '/', num2str(size(sakkade_control,2)+size(sakkade_patient,2))),2)
        for b = 1:size(sakkade_control,1) % Alle Sakkaden in einem Bild durchlaufen - Kontrollen
            clearvars sakk diff_ vel
            sakk = sakkade_control(b,a);
            sakk = cell2mat(sakk); % Positionen einer einzelnen Sakkade
            if isempty(sakk) == 1
                continue;
            else
                sakk(:,1) = sakk(:,1) - sakk(1,1);
                diff_ = (sakk(1:end-1,[2 3]) - sakk(2:end,[2 3])); 
                tmp = norm(sakk(end,2:3)-sakk(1,2:3))*9.8/450;
                
                if  (tmp > sakkaden_amplitude -0.1) && (tmp < sakkaden_amplitude +0.1) && sakk(end,1) < 80 && sakk(end,1) > 20
                    amp = sqrt(sum(diff_ .* diff_, 2));
                    vel = amp/2;
                    if Sakkpx_Sakkgrad == 2
                        vel = vel *9.8/450 *1000;
                        amp = amp*9.8/450;
                    end
                    for c = 2:size(amp)
                        amp(c) = amp(c)+amp(c-1);
                    end
                    
                    if time_c < sakk(end,1)
                        time_c = sakk(2:end-1,1);
                    end
                    
                    vel_c(1:size(vel(1:end-1,1)),counter) = vel(1:end-1);
                    vel_c(1:size(vel(1:end-1,1)),counter) = medfilt1(vel_c(1:size(vel(1:end-1,1)),counter),5);
%                     acc_c(1:size(diff(vel)/2,1),counter) = diff(vel)/2;
%                     acc_c(1:size(diff(vel)/2,1),counter) = medfilt1(acc_c(1:size(diff(vel)/2,1),counter),5);
%                     amp_c(1:size(amp(1:end-1),1),counter) = amp(1:end-1);
                    
                    counter = counter +1;
                end
            end
        end
    end
    

    time_p = 1;
    counter = 1;
    count = a;
    
    for a = 1:size(sakkade_patient,2) % alle Bilder aller Patienten durchlaufen     - Patienten
my_message(cat(2,'Evaluate Data ', num2str(count+a), '/', num2str(size(sakkade_control,2)+size(sakkade_patient,2))),2)
        for b = 1:size(sakkade_patient,1) % Alle Sakkaden in einem Bild durchlaufen - Patienten
            clearvars sakk diff_ vel
            sakk = sakkade_patient(b,a);
            sakk = cell2mat(sakk); % Positionen einer einzelnen Sakkade
            
            if isempty(sakk) == 1
                continue;
            else
                sakk(:,1) = sakk(:,1) - sakk(1,1);
                diff_ = (sakk(1:end-1,[2 3]) - sakk(2:end,[2 3])); 
                tmp = norm(sakk(end,2:3)-sakk(1,2:3))*9.8/450;
                
                if  (tmp > sakkaden_amplitude -0.1) && (tmp < sakkaden_amplitude +0.1) && sakk(end,1) < 80 && sakk(end,1) > 20
                    amp = sqrt(sum(diff_ .* diff_, 2));
                    vel = amp/2;
                    if Sakkpx_Sakkgrad == 2
                        vel = vel *9.8/450 *1000;
                        amp = amp*9.8/450;
                    end
                    for c = 2:size(amp)
                        amp(c) = amp(c)+amp(c-1);
                    end
                    
                    if time_p < sakk(end,1)
                        time_p = sakk(2:end-1,1);
                    end
                    
                    vel_p(1:size(vel(1:end-1,1)),counter) = vel(1:end-1);
                    vel_p(1:size(vel(1:end-1,1)),counter) = medfilt1(vel_p(1:size(vel(1:end-1,1)),counter),5);
%                     acc_p(1:size(diff(vel)/2,1),counter) = diff(vel)/2;
%                     acc_p(1:size(diff(vel)/2,1),counter) = medfilt1(acc_p(1:size(diff(vel)/2,1),counter),5);
%                     amp_p(1:size(amp(1:end-1),1),counter) = amp(1:end-1);
                    
                    counter = counter +1;
                end
            end
        end
    end
    
    if size(vel_c,2) == 1 || size(vel_p,2) == 1 
my_message('No saccades with specified amplitude found',0)
my_message('Ended badly',0)
        return;
    end
    
    [~, test] = bootstrp(boot_nr, 'mean' ,vel_c');
    [~, test2] = bootstrp(boot_nr,'mean',vel_p');
    anz(1) = size(vel_c,2);
    anz(2) = size(vel_p,2);
    vel_c_mean = zeros(size(vel_c,1),boot_nr);
    vel_p_mean = zeros(size(vel_p,1),boot_nr);
    for a = 1:boot_nr
        vel_c_mean(:,a)=mean(vel_c(:,test(:,a)),2);
        vel_p_mean(:,a)=mean(vel_p(:,test2(:,a)),2);
    end
    percentile_c(:,1:2) = prctile(vel_c_mean,[5 95],2);
    percentile_p(:,1:2) = prctile(vel_p_mean,[5 95],2);
    vel_p_mean=mean(vel_p_mean,2);
    vel_c_mean=mean(vel_c_mean,2);
    percentile_c(:,1:2) = percentile_c(:,1:2) - [vel_c_mean vel_c_mean];
    percentile_p(:,1:2) = percentile_p(:,1:2) - [vel_p_mean vel_p_mean];
    
    h=figure(1);
    hold on; grid on; box on;
    set(gca,'FontWeight','bold');
    h.Position = [200 200 900 450];
    errorbar(time_c, vel_c_mean, percentile_c(:,1), percentile_c(:,2),'-xb', 'LineWidth', 1);
    errorbar(time_p, vel_p_mean, percentile_p(:,1), percentile_p(:,2), ':or', 'LineWidth', 1);
    xlabel('Time (ms)');
    ylabel('Velocity (px/ms)');
    if Sakkpx_Sakkgrad == 2; ylabel('velocity (�/s)'); end;
    legend(cat(2,'Velocity Control (', num2str(anz(1)),' saccades)'), cat(2,'Velocity Patient (', num2str(anz(2)),' saccades)'));
       
end