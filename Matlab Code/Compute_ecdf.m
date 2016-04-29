% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% Sakka_Sakkd_Fix: 0 = Sakkadenamplituden in px, 1 = Sakkadenamplituden in °, 2 = Sakkadendauer, 3 = Fixationsdauer (Intersakkadenintervall)
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images

function Compute_ecdf( bilder, durchlauf, Sakka_Sakkd_Fix, kontroll_kennung, patient_kennung, data_path, image_path)
my_message('Compute ECDF',0)

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
    
%% Alle Daten der Kontrollen heraussuchen
my_message('Extract control data',0)

    Data_control = 0;
    
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
                if Sakka_Sakkd_Fix == 0
                    Data_control = [Data_control; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px;
                elseif Sakka_Sakkd_Fix == 1
                    Data_control = [Data_control; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                elseif Sakka_Sakkd_Fix == 2
                    Data_control = [Data_control; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                elseif Sakka_Sakkd_Fix == 3
                    Data_control = [Data_control; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                end
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
                if Sakka_Sakkd_Fix == 0
                    Data_control = [Data_control; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px;
                elseif Sakka_Sakkd_Fix == 1
                    Data_control = [Data_control; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                elseif Sakka_Sakkd_Fix == 2
                    Data_control = [Data_control; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                elseif Sakka_Sakkd_Fix == 3
                    Data_control = [Data_control; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                end
            end
        end
    end

%% Alle Daten der Patienten heraussuchen
    my_message('Extract patient data',0)

    Data_patient = 0;
    
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
                if Sakka_Sakkd_Fix == 0
                    Data_patient = [Data_patient; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px;
                elseif Sakka_Sakkd_Fix == 1
                    Data_patient = [Data_patient; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                elseif Sakka_Sakkd_Fix == 2
                    Data_patient = [Data_patient; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                elseif Sakka_Sakkd_Fix == 3
                    Data_patient = [Data_patient; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                end
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
                if Sakka_Sakkd_Fix == 0
                    Data_patient = [Data_patient; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px;
                elseif Sakka_Sakkd_Fix == 1
                    Data_patient = [Data_patient; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                elseif Sakka_Sakkd_Fix == 2
                    Data_patient = [Data_patient; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                elseif Sakka_Sakkd_Fix == 3
                    Data_patient = [Data_patient; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                end
            end
        end
    end

%% Auswertung
    my_message('Evaluate Data',0)
    
    Data_control(1) = [];
    Data_patient(1) = [];
    
    h = figure (1);
    h.Position = [200 200 900 450];
    
    hold on; grid on; box on;
    subplot(1,2,1)
    hold on; grid on; box on;
    set(gca,'FontWeight','bold');
    title('ecdf', 'FontSize', 12);
    ecdf(Data_control); % Kontrollen
    ecdf(Data_patient); % Patienten
    subplot(1,2,2)
    hold on; grid on; box on;
    set(gca,'FontWeight','bold');
    title('ecdf extract', 'FontSize', 12);
    ecdf(Data_control); % Kontrollen
    ecdf(Data_patient); % Patienten 
    % kstest_reject: Die Sakkadenamplituden von Patienten und Kontrollen resultieren aus 1=unterschiedliche Verteilungen, 0=gleiche Verteilungen
    [kstest_reject, p, max_vert_abstand] = kstest2(Data_control, Data_patient);
    data_mean(1) = mean(Data_control);
    data_mean(2) = mean(Data_patient);
    data_median(1) = median(Data_control);
    data_median(2) = median(Data_patient);
    
    if Sakka_Sakkd_Fix == 0 
        subplot(1,2,1)
        legend('Sacc. amp. Controls (px)', 'Sacc. amp. Patients (px)', 'location', 'southeast');
        legend('Sacc. amp. Controls (px)', 'Sacc. amp. Patients (px)', 'location', 'southeast');
        subplot(1,2,2)
        legend('Sacc. amp. Controls (px)', 'Sacc. amp. Patients (px)', 'location', 'southeast');
        legend('Sacc. amp. Controls (px)', 'Sacc. amp. Patients (px)', 'location', 'southeast');
        xlim([0 200]);
    elseif Sakka_Sakkd_Fix == 1
        subplot(1,2,1)
        legend('Sacc. amp. Controls (°)', 'Sacc. amp. Patients (°)', 'location', 'southeast');
        legend('Sacc. amp. Controls (°)', 'Sacc. amp. Patients (°)', 'location', 'southeast');
        subplot(1,2,2)
        legend('Sacc. amp. Controls (°)', 'Sacc. amp. Patients (°)', 'location', 'southeast');
        legend('Sacc. amp. Controls (°)', 'Sacc. amp. Patients (°)', 'location', 'southeast');
        xlim([0 5]);
    elseif Sakka_Sakkd_Fix == 2
        subplot(1,2,1)
        legend('Sacc. duration Controls (ms)', 'Sacc. duration Patients (ms)', 'location', 'southeast');
        legend('Sacc. duration Controls (ms)', 'Sacc. duration Patients (ms)', 'location', 'southeast');
        subplot(1,2,2)
        legend('Sacc. duration Controls (ms)', 'Sacc. duration Patients (ms)', 'location', 'southeast');
        legend('Sacc. duration Controls (ms)', 'Sacc. duration Patients (ms)', 'location', 'southeast');
        xlim([0 100]);
    elseif Sakka_Sakkd_Fix == 3
        subplot(1,2,1)
        legend('Fix. duration Controls (ms)', 'Fix. duration Patients (ms)', 'location', 'southeast');
        legend('Fix. duration Controls (ms)', 'Fix. duration Patients (ms)', 'location', 'southeast');
        subplot(1,2,2)
        legend('Fix. duration Controls (ms)', 'Fix. duration Patients (ms)', 'location', 'southeast');
        legend('Fix. duration Controls (ms)', 'Fix. duration Patients (ms)', 'location', 'southeast');
        xlim([0 1000]);
    end
    
    u = uitable('Data', [kstest_reject; p; max_vert_abstand; data_mean(1); data_mean(2); data_median(1); data_median(2)], ...
    'RowName', {'reject h_0', 'p-value', 'max. vert. dist.', 'Mean Control', 'Mean Patient', 'Median Control', 'Median Patient'}, ...
    'ColumnName', 'Data', 'FontName', 'Arial', 'FontSize', 8);

    u.Position(1) = 180;
    u.Position(2) = 120;
    u.Position(3) = 254;
    u.Position(4) = 141;

end