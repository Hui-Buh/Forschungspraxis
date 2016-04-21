% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% Sakkpx_Sakkgrad: 1 = Sakkadenamplituden in px, 2 = Sakkadenamplituden in°,
% vel_acc: What should be plotted? 1 = vel, 2 = acc, 3 = vel+acc
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images


function create_Sakk_profile( bilder, durchlauf, Sakkpx_Sakkgrad, vel_acc, kontroll_kennung, patient_kennung, data_path, image_path, sakkaden_laenge )
    my_message('Create saccade profile',0)
    
    sakkaden_laenge = str2num(sakkaden_laenge);

    [faces, faces_m, faces_t, kont] =  Separate_test_images(image_path);

    [control_listing, patient_listing] =  Separate_test_persons(kontroll_kennung, patient_kennung, data_path);
    
    % Baue eine Liste aller Bilder, die abgearbeitet werden sollen
    image_list{1,1} = 'List of all images to use.';
    if bilder >= 8; image_list = vertcat(image_list, faces{2:end}); bilder = bilder -8; end;
    if bilder >= 4; image_list = vertcat(image_list, faces_m{2:end}); bilder = bilder -4; end;
    if bilder >= 2; image_list = vertcat(image_list, faces_t{2:end}); bilder = bilder -2; end;
    if bilder >= 1; image_list = vertcat(image_list, kont{2:end}); bilder = bilder -1; end;
    
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
                Sakk_parsed = m.Sakk_parsed;
                monokular = m.monokular;
                try % Check for variable Data
                    Data = m.Data_;
                catch my_error
                    my_message('.mat file lacks the variable Data ',0)
                    my_message('Ended badly',0) 
                    return;
                end
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
                Sakk_parsed = m.Sakk_parsed;
                monokular = m.monokular;
                try % Check for variable Data
                    Data = m.Data_;
                catch my_error
                    msgbox('At least one file does not contain a needed variable. Please use other .mat files containing the variable "Data_"!', 'Needed variable not found!') 
                    return;
                end
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
                monokular = m.monokular;
                try % Check for variable Data
                    Data = m.Data_;
                catch my_error
                    msgbox('At least one file does not contain a needed variable. Please use other .mat files containing the variable "Data_"!', 'Needed variable not found!') 
                    return;
                end
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
                Sakk_parsed = m.Sakk_parsed;
                monokular = m.monokular;
                try % Check for variable Data
                    Data = m.Data_;
                catch my_error
                    msgbox('At least one file does not contain a needed variable. Please use other .mat files containing the variable "Data_"!', 'Needed variable not found!') 
                    return;
                end
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
    
    figure(1)
    hold on; grid on;
    
    time_c = (0:2:(sakkaden_laenge-4))';
    vel_c = zeros((sakkaden_laenge-2)/2,1);
    acc_c = zeros((sakkaden_laenge-2)/2,1);
    
    for a = 1:size(sakkade_control,2) % alle Bilder aller Patienten durchlaufen     - Kontrollen
        for b = 1:size(sakkade_control,1) % Alle Sakkaden in einem Bild durchlaufen - Kontrollen
            clearvars sakk diff_ vel
            sakk = sakkade_control(b,a);
            sakk = cell2mat(sakk); % Positionen einer einzelnen Sakkade
            
            if isempty(sakk) == 1
                continue;
            else
                sakk(:,1) = sakk(:,1) - sakk(1,1);
                diff_ = (sakk(1:end-1,[2 3]) - sakk(2:end,[2 3])); 
                
                if  (sakk(end,1) > sakkaden_laenge -1) && (sakk(end,1) < sakkaden_laenge +1)
                    vel = sqrt(sum(diff_ .* diff_, 2))/2;
                    if Sakkpx_Sakkgrad == 2
                        vel = vel *450/9.8 /1000;
                    end
                    vel_c = [vel_c vel(1:end-1)];
                    acc_c = [acc_c diff(vel)/2];
                end
            end
        end
    end
    
    time_p = (0:2:(sakkaden_laenge-4))';
    vel_p = zeros((sakkaden_laenge-2)/2,1);
    acc_p = zeros((sakkaden_laenge-2)/2,1);
    
    for a = 1:size(sakkade_patient,2) % alle Bilder aller Patienten durchlaufen     - Patienten
        for b = 1:size(sakkade_patient,1) % Alle Sakkaden in einem Bild durchlaufen - Patienten
            clearvars sakk diff_ vel
            sakk = sakkade_patient(b,a);
            sakk = cell2mat(sakk); % Positionen einer einzelnen Sakkade
            
            if isempty(sakk) == 1
                continue;
            else
                sakk(:,1) = sakk(:,1) - sakk(1,1);
                diff_ = (sakk(1:end-1,[2 3]) - sakk(2:end,[2 3])); 
                
                if  (sakk(end,1) > sakkaden_laenge -1) && (sakk(end,1) < sakkaden_laenge +1)
                    vel = sqrt(sum(diff_ .* diff_, 2))/2;
                    if Sakkpx_Sakkgrad == 2
                        vel = vel *450/9.8 /1000;
                    end
                    vel_p = [vel_p vel(1:end-1)];
                    acc_p = [acc_p diff(vel)/2];
                end
            end
        end
    end
    
    vel_c(:,1) = [];
    acc_c(:,1) = [];
    vel_p(:,1) = [];
    acc_p(:,1) = [];
    
    vel_c = mean(vel_c,2);
    acc_c = mean(acc_c,2);
    vel_p = mean(vel_p,2);
    acc_p = mean(acc_p,2);
    
    
    subplot(1,2,1)
    if vel_acc == 1 
        plot(time_c, vel_c);
        xlabel('Time (ms)');
        ylabel('velocity (px/ms)');
        if Sakkpx_Sakkgrad == 2; ylabel('velocity (°/s)'); end;
        legend('Geschwindigkeit Kontrolle')
    elseif vel_acc == 2
        plot(time_c, acc_c);
        xlabel('Time (ms)');
        ylabel('acceleration (px/ms^2)');
        if Sakkpx_Sakkgrad == 2; ylabel('acceleration (°/s^2)'); end;
        legend('Beschleunigung Kontrolle')
    elseif vel_acc == 3
        [x,y,z] = plotyy(time_c, vel_c, time_c, acc_c);
        xlabel('Time (ms)');
        ylabel(x(1), 'velocity (px/ms)');
        ylabel(x(2), 'acceleration (px/ms^2)');
        if Sakkpx_Sakkgrad == 2
            ylabel(x(1), 'velocity (°/s)');
            ylabel(x(2), 'acceleration (°/s^2)');
        end
        legend('Geschwindigkeit Kontrolle', 'Beschleunigung Kontrolle')
    end
    subplot(1,2,2)
    if vel_acc == 1 
        plot(time_p, vel_p);
        xlabel('Time (ms)');
        ylabel('velocity (px/ms)');
        if Sakkpx_Sakkgrad == 2; ylabel('velocity (°/s)'); end;
        legend('Geschwindigkeit Patient')
    elseif vel_acc == 2
        plot(time_p, acc_p);
        xlabel('Time (ms)');
        ylabel('acceleration (px/ms^2)');
        if Sakkpx_Sakkgrad == 2; ylabel(x(2), 'acceleration (°/s^2)'); end;
        legend('Beschleunigung Patient')
    elseif vel_acc == 3
        [x,y,z] = plotyy(time_p, vel_p, time_p, acc_p);
        xlabel('Time (ms)');
        ylabel(x(1), 'velocity (px/ms)');
        ylabel(x(2), 'acceleration (px/ms^2)');
        if Sakkpx_Sakkgrad == 2
            ylabel(x(1), 'velocity (°/s)');
            ylabel(x(2), 'acceleration (°/s^2)');
        end
        legend('Geschwindigkeit Patient', 'Beschleunigung Patient')
    end
end