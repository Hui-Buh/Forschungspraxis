% Bilder: 8 = normal faces, 4 = binaray faces, 2 = binaray upside down faces, 1 = all but faces ==> cummulative
% durchlauf: 1=nur 1. Frage, 2=nur 2. Frage, 3=alle 2 Fragen
% Sakk_p_Sakk_grad_mean_max: 1 = Sakkadenamplituden in px, 2 = Sakkadenamplituden in°, 4 = Sakk_max_vel, 8 = Sakk_mean_vel
% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format
% image_path = absolute or relative path of the folder containing all images


function compare_Sakk(bilder, durchlauf, Sakk_p_Sakk_grad_max_mean , kontroll_kennung, patient_kennung, data_path, image_path)
    my_message('Compare saccades',0)

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
    
    Sakk_amplitude_control = 0;
    Sakk_vel_control = 0;
    
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
                clearvars Sakk_parsed pos
                Sakk_parsed = m.Sakk_parsed;
                if isempty(Sakk_parsed) == 1; continue; end;
                try
                    Sakk_max_vel = m.Sakk_max_vel;
                catch
                    my_message('Max velocity not available in .mat file',0);
                    my_message('Ended badly', 0);
                    return;
                end
                pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), m.Sakk_amplitude, Sakk_max_vel, m.Sakk_mean_vel, '-', 300, 460);
                if mod(Sakk_p_Sakk_grad_max_mean, 2) == 1
                    Sakk_amplitude_control = [Sakk_amplitude_control ; pos(:,3) ];
                    if Sakk_p_Sakk_grad_max_mean < 8
                        Sakk_vel_control = [Sakk_vel_control ; pos(:,4)];
                    else
                        Sakk_vel_control = [Sakk_vel_control ; pos(:,5)];
                    end
                else
                    Sakk_amplitude_control = [Sakk_amplitude_control ; pos(:,3) *9.8/450 ];
                    if Sakk_p_Sakk_grad_max_mean < 8
                        Sakk_vel_control = [Sakk_vel_control ; pos(:,4) *9.8/450 *1000];
                    else
                        Sakk_vel_control = [Sakk_vel_control ; pos(:,5) *9.8/450 *1000];
                    end
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
                clearvars Sakk_parsed pos
                Sakk_parsed = m.Sakk_parsed;
                if isempty(Sakk_parsed) == 1; continue; end;
                try
                    Sakk_max_vel = m.Sakk_max_vel;
                catch
                    my_message('Max velocity not available in .mat file',0);
                    my_message('Ended badly', 0);
                    return;
                end
                pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), m.Sakk_amplitude, Sakk_max_vel, m.Sakk_mean_vel, '-', 300, 460);
                if mod(Sakk_p_Sakk_grad_max_mean, 2) == 1
                    Sakk_amplitude_control = [Sakk_amplitude_control ; pos(:,3) ];
                    if Sakk_p_Sakk_grad_max_mean < 8
                        Sakk_vel_control = [Sakk_vel_control ; pos(:,4)];
                    else
                        Sakk_vel_control = [Sakk_vel_control ; pos(:,5)];
                    end
                else
                    Sakk_amplitude_control = [Sakk_amplitude_control ; pos(:,3) *9.8/450 ];
                    if Sakk_p_Sakk_grad_max_mean < 8
                        Sakk_vel_control = [Sakk_vel_control ; pos(:,4) *9.8/450 *1000];
                    else
                        Sakk_vel_control = [Sakk_vel_control ; pos(:,5) *9.8/450 *1000];
                    end
                end
            end
        end
    end

%% Alle Daten der Patienten heraussuchen
    my_message('Extract patient data',0)
    
    Sakk_amplitude_patient = 0;
    Sakk_vel_patient = 0;
    
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
                clearvars Sakk_parsed pos
                Sakk_parsed = m.Sakk_parsed;         
                if isempty(Sakk_parsed) == 1; continue; end;
                try
                    Sakk_max_vel = m.Sakk_max_vel;
                catch
                    my_message('Max velocity not available in .mat file',0);
                    my_message('Ended badly', 0);
                    return;
                end
                pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), m.Sakk_amplitude, Sakk_max_vel, m.Sakk_mean_vel, '-', 300, 460);
                if mod(Sakk_p_Sakk_grad_max_mean, 2) == 1
                    Sakk_amplitude_patient = [Sakk_amplitude_patient ; pos(:,3) ];
                    if Sakk_p_Sakk_grad_max_mean < 8
                        Sakk_vel_patient = [Sakk_vel_patient ; pos(:,4)];
                    else
                        Sakk_vel_patient = [Sakk_vel_patient ; pos(:,5)];
                    end
                else
                    Sakk_amplitude_patient = [Sakk_amplitude_patient ; pos(:,3) *9.8/450 ];
                    if Sakk_p_Sakk_grad_max_mean < 8
                        Sakk_vel_patient = [Sakk_vel_patient ; pos(:,4) *9.8/450 *1000];
                    else
                        Sakk_vel_patient = [Sakk_vel_patient ; pos(:,5) *9.8/450 *1000];
                    end
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
                clearvars Sakk_parsed pos
                Sakk_parsed = m.Sakk_parsed;
                if isempty(Sakk_parsed) == 1; continue; end;
                try
                    Sakk_max_vel = m.Sakk_max_vel;
                catch
                    my_message('Max velocity not available in .mat file',0);
                    my_message('Ended badly', 0);
                    return;
                end
                pos = center_image(Sakk_parsed(:,2), Sakk_parsed(:,3), m.Sakk_amplitude, Sakk_max_vel, m.Sakk_mean_vel, '-', 300, 460);
                if mod(Sakk_p_Sakk_grad_max_mean, 2) == 1
                    Sakk_amplitude_patient = [Sakk_amplitude_patient ; pos(:,3) ];
                    if Sakk_p_Sakk_grad_max_mean < 8
                        Sakk_vel_patient = [Sakk_vel_patient ; pos(:,4)];
                    else
                        Sakk_vel_patient = [Sakk_vel_patient ; pos(:,5)];
                    end
                else
                    Sakk_amplitude_patient = [Sakk_amplitude_patient ; pos(:,3) *9.8/450 ];
                    if Sakk_p_Sakk_grad_max_mean < 8
                        Sakk_vel_patient = [Sakk_vel_patient ; pos(:,4) *9.8/450 *1000];
                    else
                        Sakk_vel_patient = [Sakk_vel_patient ; pos(:,5) *9.8/450 *1000];
                    end
                end
            end
        end
    end

%% Auswertung
    my_message('Evaluate Data',0)
    
    Sakk_amplitude_patient(1) = [];
    Sakk_vel_patient(1) = [];
    Sakk_amplitude_control(1) = [];
    Sakk_vel_control(1) = [];

    x1 = Sakk_amplitude_control;
    x2 = Sakk_amplitude_patient;
    
    y1 = Sakk_vel_control;
    y2 = Sakk_vel_patient;

    % Declare fit type
    ft = fittype( 'a*x^b+c', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.MaxIter = 1000;
    opts.MaxFunEvals = 1000;
    opts.Lower = [-Inf 0 -Inf];
    opts.StartPoint = [0 0.5 0];
    opts.Upper = [Inf 1 Inf];

    figure(1)
    hold on; grid on; box on;
    set(gca,'FontWeight','bold');
    
    z1 = sortrows([x1 y1]);
    z1(:,2) = medfilt1(z1(:,2), 3);
    [~, ia, ~] = unique(z1(:,1));
    z1 = z1(ia,:);
    
    z2 = sortrows([x2 y2]);
    z2(:,2) = medfilt1(z2(:,2), 3);
    [~, ia, ~] = unique(z2(:,1));
    z2 = z2(ia,:);   

    plot(z1(:,1),z1(:,2), '.b');
    plot(z2(:,1),z2(:,2), '.r');
    
    try
    [f, gof, ~] = fit(z1(:,1), z1(:,2), ft, opts);
    plot(f, 'k');
    [f, gof2, ~] = fit(z2(:,1), z2(:,2), ft, opts);
    plot(f, 'g');
    catch
        my_message('Fitting chrashed');
    end
    
    legend({'Control Data', 'Patient Data', 'Control Fit', 'Patient Fit'}); 
    
    if mod(Sakk_p_Sakk_grad_max_mean, 2) == 1
        xlabel('Saccade amplitude (px)');    
        if Sakk_p_Sakk_grad_max_mean < 8
            ylabel('Max. velocity (px/ms)');
        else
            ylabel('Mean velocity (px/ms)');
        end
    else
        xlabel('Saccade amplitude (°)');    
        if Sakk_p_Sakk_grad_max_mean < 8
            ylabel('Max. velocity (°/s)');
        else
            ylabel('Mean velocity (°/s)');
        end
    end
    
    u = uitable('Data', {'a*x^b+c'; gof.rmse; gof2.rmse}, ...
    'RowName', {'Fittype', 'RMSE Cont.', 'RMSE Pat.'}, ...
    'ColumnName', 'Data', 'FontName', 'Arial', 'FontSize', 8);

    u.Position(1) = 250;
    u.Position(2) = 100;
    u.Position(3) = 188;
    u.Position(4) = 73;
    
%     figure(2);
%     hold on; grid on; box on;
%     set(gca,'FontWeight','bold');
%     scatterhist(x1,y1);
%     if mod(Sakk_p_Sakk_grad_max_mean, 2) == 1
%         xlabel('Sakkaden Amplitude (px)');    
%         if Sakk_p_Sakk_grad_max_mean < 8
%             ylabel('max. Geschwindigkeit (px/ms)');
%         else
%             ylabel('durchschnittl. Geschwindigkeit (px/ms)');
%         end
%     else
%         xlabel('Sakkaden Amplitude (°)');    
%         if Sakk_p_Sakk_grad_max_mean < 8
%             ylabel('max. Geschwindigkeit (°/s)');
%         else
%             ylabel('durchschnittl. Geschwindigkeit (°/s)');
%         end
%     end
%     legend('Kontrollen');
% 
%     figure(3)
%     hold on; grid on; box on;
%     set(gca,'FontWeight','bold');
%     scatterhist(x2,y2);
%     if mod(Sakk_p_Sakk_grad_max_mean, 2) == 1
%         xlabel('Sakkaden Amplitude (px)');    
%         if Sakk_p_Sakk_grad_max_mean < 8
%             ylabel('max. Geschwindigkeit (px/ms)');
%         else
%             ylabel('durchschnittl. Geschwindigkeit (px/ms)');
%         end
%     else
%         xlabel('Sakkaden Amplitude (°)');    
%         if Sakk_p_Sakk_grad_max_mean < 8
%             ylabel('max. Geschwindigkeit (°/s)');
%         else
%             ylabel('durchschnittl. Geschwindigkeit (°/s)');
%         end
%     end
% 
%     legend('Patienten');
    
end