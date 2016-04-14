% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% Sakkpx_Sakkgrad: 1 = Sakkadenamplituden in px, 2 = Sakkadenamplituden in°,
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images


function create_Sakk_profile( bilder, durchlauf, Sakkpx_Sakkgrad, kontroll_kennung, patient_kennung, data_path, image_path )

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

    figure(1)
    hold on; grid on;
    time_c = 0;
    for a = 1:size(sakkade_control,2) % alle Bilder aller Patienten durchlaufen     - Kontrollen
        for b = 1:size(sakkade_control,1) % Alle Sakkaden in einem Bild durchlaufen - Kontrollen
            clearvars sakk diff_ amplitude
            sakk = sakkade_control(b,a);
            sakk = cell2mat(sakk); % Daten einer Sakkade
            if isempty(sakk) == 0
                sakk(:,1) = sakk(:,1) - sakk(1,1) +1;
                diff_ = (sakk(1:end-1,[2 3]) - sakk(2:end,[2 3])); 
                if  sakk(end,1) > time_c 
                    time_c = sakk(1:end-1,1);
                    vel_c = sqrt(sum(diff_ .* diff_, 2))/2 ;
                    if Sakkpx_Sakkgrad == 2
                        vel_c = vel_c *450/9.8 /1000;
                    end
                    acc_c = diff(vel_c);
                end
            end
        end
    end
    time_p = 0;
    for a = 1:size(sakkade_patient,2) % alle Bilder aller Patienten durchlaufen     - Patienten
        for b = 1:size(sakkade_patient,1) % Alle Sakkaden in einem Bild durchlaufen - Patienten
            clearvars sakk diff_ amplitude
            sakk = sakkade_patient(b,a);
            sakk = cell2mat(sakk); % Daten einer Sakkade
            if isempty(sakk) == 0
                sakk(:,1) = sakk(:,1) - sakk(1,1) +1;
                diff_ = (sakk(1:end-1,[2 3]) - sakk(2:end,[2 3])) ; 
                if  sakk(end,1) > time_p
                    time_p = sakk(1:end-1,1);
                    vel_p = sqrt(sum(diff_ .* diff_, 2))/2 ;
                    if Sakkpx_Sakkgrad == 2
                        vel_p = vel_p *450/9.8 /1000;
                    end
                    acc_p = diff(vel_p);
                end
            end
        end
    end
    subplot(1,2,1)
    [x,y,z] = plotyy(time_c, vel_c, time_c(2:end) - 0.5, acc_c);
    xlabel('Time (ms)');
    ylabel(x(1), 'velocity (px/ms)');
    ylabel(x(2), 'acceleration (px/ms^2)');
    if Sakkpx_Sakkgrad == 2
        ylabel(x(1), 'velocity (°/s)');
        ylabel(x(2), 'acceleration (°/s^2)');
    end
    legend('Geschwindigkeit Kontrolle', 'Beschleunigung Kontrolle')
    subplot(1,2,2)
    [x,y,z] = plotyy(time_p, vel_p, time_p(2:end) - 0.5, acc_p);
    xlabel('Time (ms)');
    ylabel(x(1), 'velocity (px/ms)');
    ylabel(x(2), 'acceleration (px/ms^2)');
    if Sakkpx_Sakkgrad == 2
        ylabel(x(1), 'velocity (°/s)');
        ylabel(x(2), 'acceleration (°/s^2)');
    end
    legend('Geschwindigkeit Patient', 'Beschleunigung Patient')

end