% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% Sakka_Sakkd_Fix: 0 = Sakkadenamplituden in px, 1 = Sakkadenamplituden in °, 2 = Sakkadendauer, 3 = Fixationsdauer (Intersakkadenintervall)
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images

function Compute_ecdf( bilder, durchlauf, Sakka_Sakkd_Fix, kontroll_kennung, patient_kennung, data_path, image_path)

    if bilder > 15 && bilder < 1; disp('Enter valid number for "bilder"!'); return; end;

    [faces, faces_m, faces_t, kont] =  Separate_test_images(image_path);

    [control_listing, patient_listing] =  Separate_test_persons(kontroll_kennung, patient_kennung, data_path);
    
%% Alle Daten der Kontrollen heraussuchen

    Sakk_amplitude_control = 0;
    Sakk_amplitude_control_grad = 0;
    Sakk_dauer_control = 0;
    Fix_dauer_control = 0;
    
    bilder_save = bilder;
    
    for b = 2:size(control_listing,1)
        bilder = bilder_save;
        
% normal faces
        if bilder >= 8 
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(faces,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_control = [Sakk_amplitude_control; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_control_grad = [Sakk_amplitude_control_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_control = [Sakk_dauer_control; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_control = [Fix_dauer_control; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(faces,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_control = [Sakk_amplitude_control; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_control_grad = [Sakk_amplitude_control_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_control = [Sakk_dauer_control; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_control = [Fix_dauer_control; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            bilder = bilder - 8;
        end
% binaray faces
        if bilder >= 4
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(faces_m,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_m{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_m{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_control = [Sakk_amplitude_control; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_control_grad = [Sakk_amplitude_control_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_control = [Sakk_dauer_control; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_control = [Fix_dauer_control; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(faces_m,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_m{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_m{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_control = [Sakk_amplitude_control; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_control_grad = [Sakk_amplitude_control_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_control = [Sakk_dauer_control; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_control = [Fix_dauer_control; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            bilder = bilder - 4;
        end
% binaray upside down faces
        if bilder >= 2
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(faces_t,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_t{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_t{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_control = [Sakk_amplitude_control; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_control_grad = [Sakk_amplitude_control_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_control = [Sakk_dauer_control; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_control = [Fix_dauer_control; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(faces_t,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_t{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', faces_t{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_control = [Sakk_amplitude_control; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_control_grad = [Sakk_amplitude_control_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_control = [Sakk_dauer_control; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_control = [Fix_dauer_control; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            bilder = bilder - 2;
        end
% all but faces
        if bilder >= 1
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(kont,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', kont{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', kont{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_control = [Sakk_amplitude_control; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_control_grad = [Sakk_amplitude_control_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_control = [Sakk_dauer_control; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_control = [Fix_dauer_control; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(kont,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', kont{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', control_listing{b,1}, '/', control_listing{b,1}, '_', kont{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_control = [Sakk_amplitude_control; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_control_grad = [Sakk_amplitude_control_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_control = [Sakk_dauer_control; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_control = [Fix_dauer_control; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            bilder = bilder - 1;
        end
    end
    
    
%% Alle Daten der Patienten heraussuchen

    Sakk_amplitude_patient = 0;
    Sakk_amplitude_patient_grad = 0;
    Sakk_dauer_patient = 0;
    Fix_dauer_patient = 0;
    
    for b = 2:size(patient_listing,1)
        bilder = bilder_save;
        
% normal faces
        if bilder >= 8 
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(faces,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_patient = [Sakk_amplitude_patient; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_patient_grad = [Sakk_amplitude_patient_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_patient = [Sakk_dauer_patient; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_patient = [Fix_dauer_patient; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(faces,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_patient = [Sakk_amplitude_patient; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_patient_grad = [Sakk_amplitude_patient_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_patient = [Sakk_dauer_patient; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_patient = [Fix_dauer_patient; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            bilder = bilder - 8;
        end
% binaray faces
        if bilder >= 4
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(faces_m,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_m{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_m{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_patient = [Sakk_amplitude_patient; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_patient_grad = [Sakk_amplitude_patient_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_patient = [Sakk_dauer_patient; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_patient = [Fix_dauer_patient; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(faces_m,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_m{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_m{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_patient = [Sakk_amplitude_patient; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_patient_grad = [Sakk_amplitude_patient_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_patient = [Sakk_dauer_patient; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_patient = [Fix_dauer_patient; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            bilder = bilder - 4;
        end
% binaray upside down faces
        if bilder >= 2
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(faces_t,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_t{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_t{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_patient = [Sakk_amplitude_patient; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_patient_grad = [Sakk_amplitude_patient_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_patient = [Sakk_dauer_patient; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_patient = [Fix_dauer_patient; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(faces_t,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_t{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', faces_t{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_patient = [Sakk_amplitude_patient; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_patient_grad = [Sakk_amplitude_patient_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_patient = [Sakk_dauer_patient; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_patient = [Fix_dauer_patient; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            bilder = bilder - 2;
        end
% all but faces
        if bilder >= 1
            if durchlauf == 1 || durchlauf == 3
                for c = 2:size(kont,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', kont{c,1} , '_1','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', kont{c,1} , '_1','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_patient = [Sakk_amplitude_patient; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_patient_grad = [Sakk_amplitude_patient_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_patient = [Sakk_dauer_patient; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_patient = [Fix_dauer_patient; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            if durchlauf == 2 || durchlauf == 3
                for c = 2:size(kont,1)
                    % Open .mat file
                    if exist(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', kont{c,1} , '_2','.mat' ), 'file') > 0
                        m = matfile(cat(2, data_path, '/', patient_listing{b,1}, '/', patient_listing{b,1}, '_', kont{c,1} , '_2','.mat' ));
                    else
                        continue
                    end
                    if Sakka_Sakkd_Fix == 0
                        Sakk_amplitude_patient = [Sakk_amplitude_patient; m.Sakk_amplitude]; % Fasse alle Sakkadenamplituden zusammen in px
                    elseif Sakka_Sakkd_Fix == 1
                        Sakk_amplitude_patient_grad = [Sakk_amplitude_patient_grad; m.Sakk_amplitude*9.8/450]; % Fasse alle Sakkadenamplituden zusammen in °
                    elseif Sakka_Sakkd_Fix == 2
                        Sakk_dauer_patient = [Sakk_dauer_patient; m.Sakk_dauer]; % Fasse alle Sakkadendauern zusammen
                    elseif Sakka_Sakkd_Fix == 3
                        Fix_dauer_patient = [Fix_dauer_patient; m.Fix_dauer]; % Fasse alle Fixationsdauern zusammen
                    end
                end
            end
            bilder = bilder - 1;
        end
    end
    

%% Auswertung
    
    Sakk_amplitude_control(1) = [];
    Sakk_amplitude_patient(1) = [];
    Sakk_amplitude_control_grad(1) = [];
    Sakk_amplitude_patient_grad(1) = [];
    Sakk_dauer_control(1) = [];
    Sakk_dauer_patient(1) = [];
    Fix_dauer_control(1) = [];
    Fix_dauer_patient(1) = [];
    
    h = figure (1);
    h.Position = [200 200 900 450];
    hold on; grid on;
    
    subplot(1,2,1)
    title('ecdf', 'FontSize', 12);
    subplot(1,2,2)
    title('ecdf Ausschnitt', 'FontSize', 12);
    
    if Sakka_Sakkd_Fix == 0 
        subplot(1,2,1)
        hold on; grid on;
        ecdf(Sakk_amplitude_control); % Kontrollen
        ecdf(Sakk_amplitude_patient); % Patienten
        legend('Sakk. Amp. Kontrollen (px)', 'Sakk. Amp. Patienten (px)', 'location', 'southeast');
        subplot(1,2,2)
        hold on; grid on;
        ecdf(Sakk_amplitude_control); % Kontrollen
        ecdf(Sakk_amplitude_patient); % Patienten  
        legend('Sakk. Amp. Kontrollen (px)', 'Sakk. Amp. Patienten (px)', 'location', 'southeast');
        xlim([0 200]);
        % kstest_reject: Die Sakkadenamplituden von Patienten und Kontrollen resultieren aus 1=unterschiedliche Verteilungen, 0=gleiche Verteilungen
        [kstest_reject, p, max_vert_abstand] = kstest2(Sakk_amplitude_control, Sakk_amplitude_patient);
        data_mean(1) = mean(Sakk_amplitude_control);
        data_mean(2) = mean(Sakk_amplitude_patient);
        data_median(1) = median(Sakk_amplitude_control);
        data_median(2) = median(Sakk_amplitude_patient);
    elseif Sakka_Sakkd_Fix == 1
        subplot(1,2,1)
        hold on; grid on;
        ecdf(Sakk_amplitude_control_grad); % Kontrollen
        ecdf(Sakk_amplitude_patient_grad); % Patienten  
        legend('Sakk. Amp. Kontrollen (°)', 'Sakk. Amp. Patienten (°)', 'location', 'southeast');
        subplot(1,2,2)
        hold on; grid on;
        ecdf(Sakk_amplitude_control_grad); % Kontrollen
        ecdf(Sakk_amplitude_patient_grad); % Patienten  
        legend('Sakk. Amp. Kontrollen (°)', 'Sakk. Amp. Patienten (°)', 'location', 'southeast');
        xlim([0 5]);
        % kstest_reject: Die Sakkadenamplituden von Patienten und Kontrollen resultieren aus 1=unterschiedliche Verteilungen, 0=gleiche Verteilungen
        [kstest_reject, p, max_vert_abstand] = kstest2(Sakk_amplitude_control_grad, Sakk_amplitude_patient_grad);
        data_mean(1) = mean(Sakk_amplitude_control_grad);
        data_mean(2) = mean(Sakk_amplitude_patient_grad);
        data_median(1) = median(Sakk_amplitude_control_grad);
        data_median(2) = median(Sakk_amplitude_patient_grad);
    elseif Sakka_Sakkd_Fix == 2
        subplot(1,2,1)
        hold on; grid on;
        ecdf(Sakk_dauer_control); % Kontrollen
        ecdf(Sakk_dauer_patient); % Patienten  
        legend('Sakk. Dauer Kontrollen (ms)', 'Sakk. Dauer Patienten (ms)', 'location', 'southeast');
        subplot(1,2,2)
        hold on; grid on;
        ecdf(Sakk_dauer_control); % Kontrollen
        ecdf(Sakk_dauer_patient); % Patienten  
        legend('Sakk. Dauer Kontrollen (ms)', 'Sakk. Dauer Patienten (ms)', 'location', 'southeast');
        xlim([0 100]);
        % kstest_reject: Die Sakkadenamplituden von Patienten und Kontrollen resultieren aus 1=unterschiedliche Verteilungen, 0=gleiche Verteilungen
        [kstest_reject, p, max_vert_abstand] = kstest2(Sakk_dauer_control, Sakk_dauer_patient);
        data_mean(1) = mean(Sakk_dauer_control);
        data_mean(2) = mean(Sakk_dauer_patient);
        data_median(1) = median(Sakk_dauer_control);
        data_median(2) = median(Sakk_dauer_patient);
    elseif Sakka_Sakkd_Fix == 3
        subplot(1,2,1)
        hold on; grid on;
        ecdf(Fix_dauer_control); % Kontrollen
        ecdf(Fix_dauer_patient); % Patienten
        legend('Fix. Dauer Kontrollen (ms)', 'Fix. Dauer Patienten (ms)', 'location', 'southeast');
        subplot(1,2,2)
        hold on; grid on;
        ecdf(Fix_dauer_control); % Kontrollen
        ecdf(Fix_dauer_patient); % Patienten
        legend('Fix. Dauer Kontrollen (ms)', 'Fix. Dauer Patienten (ms)', 'location', 'southeast');
        xlim([0 1000]);
        % kstest_reject: Die Fixationsdauern von Patienten und Kontrollen resultieren aus 1=unterschiedliche Verteilungen, 0=gleiche Verteilungen
        [kstest_reject, p, max_vert_abstand] = kstest2(Fix_dauer_control, Fix_dauer_patient);
        data_mean(1) = mean(Fix_dauer_control);
        data_mean(2) = mean(Fix_dauer_patient);
        data_median(1) = median(Fix_dauer_control);
        data_median(2) = median(Fix_dauer_patient);
    end
    
    u = uitable('Data', [kstest_reject; p; max_vert_abstand; data_mean(1); data_mean(2); data_median(1); data_median(2)], ...
    'RowName', {'reject h_0', 'p-Wert', 'max. vert. Abst.', 'Mean Kontrollen', 'Mean Patienten', 'Median Kontrollen', 'Median Patienten'}, ...
    'ColumnName', 'Daten', 'FontName', 'Arial', 'FontSize', 8);

    u.Position(1) = 180;
    u.Position(2) = 120;
    u.Position(3) = 265;
    u.Position(4) = 141;

end
