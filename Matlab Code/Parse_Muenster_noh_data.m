% !Achtung! Bestehende Daten werden überschrieben. !Achtung!
my_message('',1)
my_message('Parse Münster Noh data',0)
clearvars -except image_path mat_path goal_path

%% Input 

image_path = '/mnt/syno8/data/Muenster_noh/Testbilder/';
mat_path = '/mnt/syno8/data/Muenster_noh/AugenbewegungsdateienBearbeitet/mat/';
% goal_path = '/home/ga25xed/Desktop/Forschungspraxis/Test/';
% goal_path = '/home/ga25xed/Desktop/Forschungspraxis/Patienten Daten/';
goal_path = '/home/ga25xed/Desktop/Forschungspraxis/Patienten Daten compressed/';

%% Process data
% Finde alle Files in dem .mat Ordner
listing = dir(mat_path);
listing = listing(3:end);
question = [1 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2]';

Data_README = 'Timestamp (ms) : x-coord. left : y-coord. left : x-coord. right : y-coord. right (all eye data)';
Sakk_bild_README = '{1,2} = {left,right} : start_sample : end_sample : max_vel_sample : max_acc_sample (all saccs, in samples)';
Sakk_parsed_README = 'Start_time (ms) : x-coord. : y-coord. : End_time : x-coord. : y-coord. (mean of both eyes), indices of max_vel ind Data';
Auge_README = 'x-coord. left : y-coord. left : x-coord. right : y-coord. right (in °, in samples)';
README = 'Sakk_dauer (ms); Fix_dauer (ms); Sakk_amplitude (px bez. auf image_size); Sakk_max_vel (px/ms), Sakk_mean_vel (px/ms)';

my_message('Parse and write data',0)
for c = 1:size(listing,1)
%% Load data
% Lade nur '.mat' files
    if listing(c,1).isdir == 0
        if listing(c,1).name(end-3:end) == '.mat'
            load(cat(2, mat_path, listing(c,1).name));
            original_filename = listing(c,1).name;
        else
            continue
        end
    else
        continue;
    end

%% Delete blinks or garbage data in Sakk

    Sakk_ = Sakk(Sakk(:,5) > 0,:);
    
%% Parse data
    bild_nummer = 0;
    for a = 1:size(Events,1)
        if strcmp(Events{a,2}, 'Bild') == 1
            bild_nummer = bild_nummer +1;
            
            % Bild zur Bearbeitung einlesen
            image = imread(cat(2,image_path,Events{a,3}));
            image_size = [size(image,1) size(image,2)];
            
            clearvars Sakk_bild Sakk_parsed
            
            % Start und Endzeitpunkte der Bildpärsentation
            time_start = double(Events{a+1,1});
            time_ende = double(Events{a+2,1});
            
            % Alle Zeitstempel der Sakk, die zu diesem einem Bild gehören
            Sakk_bild = Sakk_( (Data(Sakk_(:,2),1) > time_start) & (Data(Sakk_(:,3),1) <= time_ende) ,:);
            if isempty(Sakk_bild) == 1; continue; end;
            
            % monokular: 1= nur links, 2= nur rechts, 3 = beide Augen
            if min(Sakk_bild(:,1)) == max(Sakk_bild(:,1))
                if min(Sakk_bild(:,1)) == 1; 
                    monokular = 1; 
                else
                    monokular = 2; 
                end
            else
                monokular = 3;
            end
            
            % Start-Time : x-coord. left start : y-coord. right start : End-Time : x-coord. left end : y-coord. right end
            Sakk_parsed(:,1) = Data(Sakk_bild(:,2),1);
            Sakk_parsed(:,4) = Data(Sakk_bild(:,3),1);
            
            % Entscheidung, welche Augendaten verwendet werden sollen
            
            if monokular == 1
                Sakk_parsed(:,2) = Data(Sakk_bild(:,2),2);
                Sakk_parsed(:,3) = Data(Sakk_bild(:,2),3);
                Sakk_parsed(:,5) = Data(Sakk_bild(:,3),2);
                Sakk_parsed(:,6) = Data(Sakk_bild(:,3),3);
            elseif monokular == 2
                Sakk_parsed(:,2) = Data(Sakk_bild(:,2),4);
                Sakk_parsed(:,3) = Data(Sakk_bild(:,2),5);
                Sakk_parsed(:,5) = Data(Sakk_bild(:,3),4);
                Sakk_parsed(:,6) = Data(Sakk_bild(:,3),5);
            elseif monokular == 3
                Sakk_parsed(:,2) = mean([Data(Sakk_bild(:,2),2) Data(Sakk_bild(:,2),4)],2);
                Sakk_parsed(:,3) = mean([Data(Sakk_bild(:,2),3) Data(Sakk_bild(:,2),5)],2);
                Sakk_parsed(:,5) = mean([Data(Sakk_bild(:,3),2) Data(Sakk_bild(:,3),4)],2);
                Sakk_parsed(:,6) = mean([Data(Sakk_bild(:,3),3) Data(Sakk_bild(:,3),5)],2); 
            end
            % Positionen der maximalen Geschwindigkeit temporär merken
            Sakk_parsed(:,7) = Sakk_bild(:,4);
            
            % Remove outliers 
            
            Sakk_parsed = Sakk_parsed(min(Sakk_parsed(:,[2 3 5 6]), [], 2) > 0,:);
            Sakk_parsed = Sakk_parsed(max(Sakk_parsed(:,[2 3]), [], 2) < 1280,:);
            Sakk_parsed = Sakk_parsed(max(Sakk_parsed(:,[5 6]), [], 2) < 1024,:);
            
            % Maximale Sakkadengeschwindigkeit
            clearvars Sakk_max_vel strecke
            
            if monokular == 1
                strecke(:,1) = Data(Sakk_parsed(:,7)-1,2) - Data(Sakk_parsed(:,7)+1,2);
                strecke(:,2) = Data(Sakk_parsed(:,7)-1,3) - Data(Sakk_parsed(:,7)+1,3);
            elseif monokular == 2
                strecke(:,1) = Data(Sakk_parsed(:,7)-1,4) - Data(Sakk_parsed(:,7)+1,4);
                strecke(:,2) = Data(Sakk_parsed(:,7)-1,5) - Data(Sakk_parsed(:,7)+1,5);
            elseif monokular == 3
                strecke(:,1) = mean([Data(Sakk_parsed(:,7)-1,2) Data(Sakk_parsed(:,7)-1,4)],2) - mean([Data(Sakk_parsed(:,4)+1,2) Data(Sakk_parsed(:,7)+1,4)],2);
                strecke(:,2) = mean([Data(Sakk_parsed(:,7)-1,3) Data(Sakk_parsed(:,7)-1,5)],2) - mean([Data(Sakk_parsed(:,4)+1,3) Data(Sakk_parsed(:,7)+1,5)],2);
            end
            
            for i = 1:size(strecke,1)
                strecke(i,3) = norm(strecke(i,:));
            end
            if isempty(strecke) == 0
                Sakk_max_vel = strecke(:,3)/4;
            else
                Sakk_max_vel = [];
            end
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
%             image_name = char(Events{a,3});
%             patient_id = original_filename(1:5);
%             
%             % Ein Ordner für jeden Probanten
%             if exist(cat(2, goal_path,original_filename(1:5) ), 'dir') == 0
%                 mkdir(goal_path,original_filename(1:5));
%             end
            
%             % Default Speicherung mit allen Daten 
%             % ! Daten werden überschrieben !!!
%             % Unterscheidung zwischen erster und zweiter Frage
% 
%             Data_ = Data(Data(:,1) >= time_start & Data(:,1) <= time_ende,:);
%             Auge_ = Auge(Data(:,1) >= time_start & Data(:,1) <= time_ende,:);
%             
%             if question(bild_nummer) == 1 % Erste Frage
%                 save(cat(2, goal_path,original_filename(1:5), '/', original_filename(1:5), '_', image_name(1:end-4), '_1', '.mat' ),...
%                     'Auge_', 'Data_', 'goal_path', 'image_path', 'image_size', 'mat_path', 'Sakk_parsed', 'SamplingRate', 'image_name', 'patient_id', 'Sakk_amplitude', 'original_filename', 'Sakk_bild', 'Fix_dauer', 'Sakk_dauer', 'Sakk_mean_vel', 'Sakk_max_vel', 'monokular', 'Data_README', 'Sakk_parsed_README', 'Auge_README', 'Sakk_bild_README', 'README');
%                 file = fopen(cat(2, goal_path,original_filename(1:5), '/', original_filename(1:5), '_', image_name(1:end-4), '_1', '.scc' ),'w');
%             elseif question(bild_nummer) == 2 % Zweite Frage
%                 save(cat(2, goal_path,original_filename(1:5), '/', original_filename(1:5), '_', image_name(1:end-4), '_2', '.mat' ),...
%                     'Auge_', 'Data_', 'goal_path', 'image_path', 'image_size', 'mat_path', 'Sakk_parsed', 'SamplingRate', 'image_name', 'patient_id', 'Sakk_amplitude', 'original_filename', 'Sakk_bild', 'Fix_dauer', 'Sakk_dauer', 'Sakk_mean_vel', 'Sakk_max_vel', 'monokular', 'Data_README', 'Sakk_parsed_README', 'Auge_README', 'Sakk_bild_README', 'README');
%                 file = fopen(cat(2, goal_path,original_filename(1:5), '/', original_filename(1:5), '_', image_name(1:end-4), '_2', '.scc' ),'w');
%             end
            
            
%             % Speicherung mit weniger Daten zur Beschleunigung des Skriptes!
%             % ! Daten werden überschrieben !!!
%             % Unterscheidung zwischen erster und zweiter Frage
%             if question(bild_nummer) == 1 % Erste Frage
%                 save(cat(2, goal_path,original_filename(1:5), '/', original_filename(1:5), '_', image_name(1:end-4), '_1', '.mat' ),...
%                     'goal_path', 'image_path', 'image_size', 'mat_path', 'Sakk_parsed', 'SamplingRate', 'image_name', 'patient_id', 'Sakk_amplitude', 'original_filename', 'Fix_dauer', 'Sakk_dauer', 'Sakk_mean_vel', 'Sakk_max_vel', 'monokular', 'README', 'Sakk_parsed_README');
%                 file = fopen(cat(2, goal_path,original_filename(1:5), '/', original_filename(1:5), '_', image_name(1:end-4), '_1', '.scc' ),'w');
%             elseif question(bild_nummer) == 2 % Zweite Frage
%                 save(cat(2, goal_path,original_filename(1:5), '/', original_filename(1:5), '_', image_name(1:end-4), '_2', '.mat' ),...
%                     'goal_path', 'image_path', 'image_size', 'mat_path', 'Sakk_parsed', 'SamplingRate', 'image_name', 'patient_id', 'Sakk_amplitude', 'original_filename', 'Fix_dauer', 'Sakk_dauer', 'Sakk_mean_vel', 'Sakk_max_vel', 'monokular', 'README', 'Sakk_parsed_README');
%                 file = fopen(cat(2, goal_path,original_filename(1:5), '/', original_filename(1:5), '_', image_name(1:end-4), '_2', '.scc' ),'w');
%             end
         
%             % Schreibe Daten
%             fprintf(file, 'Sakk_start_time : x-coord. : y-coord. : Sakk_end_time : x-coord. : y-coord. (mean of both eyes)\n');
%             fprintf(file, cat(2,'saccades ', num2str(image_size(1)), ' ', num2str(image_size(2)), '\n'));
%             
%             for b = 1:size(Sakk_parsed,1)
%                 fprintf(file , '%d %f %f %d %f %f', Sakk_parsed(b,:));
%                 fprintf(file , '\n');
%             end
%             
%             fclose(file);
        end
    end
end
my_message('Finished converting data',0)