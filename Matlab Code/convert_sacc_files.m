% data_path = absolute or relative path of the folder containing all patient specific data in TUM format


function convert_sacc_files( data_path )
    
Sakk_parsed_README = 'Start_time (ms) : x-coord. : y-coord. : End_time : x-coord. : y-coord. (mean of both eyes), indices of max_vel ind Data';
README = 'Sakk_dauer (ms); Fix_dauer (ms); Sakk_amplitude (px bez. auf image_size); Sakk_max_vel (px/ms), Sakk_mean_vel (px/ms)';

    liste = dir(data_path);
    liste  = liste ([liste .isdir] == 1,:);
    liste = liste(3:end,:);
    
    my_message('Parse .sacc to .mat files',0);
    for a = 1:size(liste,1)
        dir_entries = dir(cat(2,data_path, '/', liste(a,1).name ));
        for b = 1:size(dir_entries,1)
            tmp = isempty(strfind(dir_entries(b,1).name, '.scc'));
            if tmp == 0 
                if size(dir_entries(b,1).name,2) == strfind(dir_entries(b,1).name, '.scc')+3
                    if exist(cat(2, data_path, '/', liste(a,1).name, '/', dir_entries(b,1).name(1:end-4), '.mat'), 'file') == 1
                        continue;
                    end
                    file = fopen(cat(2,data_path, '/', liste(a,1).name, '/',dir_entries(b,1).name));
                    table = textscan(file, '%s');
                    table = table{1,1};
                    fclose(file);
                    index = find(strcmp(table, 'saccades'),1);
                    if isempty(index) == 1
                        my_message( dir_entries(b,1).name, 0); 
                        my_message( 'Keyword "saccades" not found in', 0); 
                        my_message( 'Ended badly', 0); 
                        return; 
                    end
                    table = table(index+1:end);
                    table = str2double(table);
                    image_size = [table(1) table(2)];
                    table = table(3:end);
                    Sakk_parsed = reshape(table, 6, size(table,1)/6)';
                    
                    % Positionen der maximalen Geschwindigkeit wieder löschen
                    Sakk_parsed = Sakk_parsed(:,1:6);

                    % Sakkadenamplituden berechnen
                    clearvars difference Sakk_amplitude
                    difference(:,1) = Sakk_parsed(:,2) - Sakk_parsed(:,5);
                    difference(:,2) = Sakk_parsed(:,3) - Sakk_parsed(:,6);
                    Sakk_amplitude = zeros(size(difference,1),1);
                    for i = 1:size(difference,1)
                        Sakk_amplitude(i) = norm(difference(i,:));
                    end

                    % Sakkadendauer
                    clearvars Sakk_dauer
                    Sakk_dauer = Sakk_parsed(:,4) - Sakk_parsed(:,1);

                    % Intersakkadische Intervalle
                    clearvars Fix_dauer 
                    Fix_dauer = Sakk_parsed(2:end,1) - Sakk_parsed(1:end-1,4);

                    % Mittlere Sakkadengeschwindigkeit

                    clearvars Sakk_mean_vel 
                    Sakk_mean_vel = Sakk_amplitude./Sakk_dauer;
                    
                    %% Write data
                    original_filename = liste(a,1).name;
                    mat_dir = data_path;
                    image_name = dir_entries(b,1).name(6:end);

                    % Speicherung der Daten
                    % ! Daten werden überschrieben !!!
                    % Unterscheidung zwischen erster und zweiter Frage
                    save(cat(2, data_path, '/', liste(a,1).name, '/', dir_entries(b,1).name(1:end-4), '.mat' ),...
                    'image_size', 'mat_dir', 'Sakk_parsed', 'image_name', 'original_filename', 'Sakk_amplitude', 'Fix_dauer', 'Sakk_dauer', 'Sakk_mean_vel', 'README', 'Sakk_parsed_README');

                end
            end
        end
    end
end