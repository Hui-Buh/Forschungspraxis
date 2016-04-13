% kontroll_kennung = z.B. 032 ==> required
% patient_kennung = z.B. 031 ==> if = 0 all non kontroll_kennung data is used
% data_path = absolute or relative path of the folder containing all patient specific data in TUM format

function [control_listing, patient_listing] =  Separate_test_persons(kontroll_kennung, patient_kennung, data_path)

%% Patienten und Kontrollen trennen

    data_listing = dir(data_path);
    data_listing = data_listing(3:end);
    
    control_listing{1,1} = 'Kontollpersonen';
    patient_listing{1,1} = 'Patienten';
    
    for a = 1:size(data_listing, 1)
        if strcmp(patient_kennung, '0') == 1
            if strfind(data_listing(a,1).name, kontroll_kennung) == 1
                control_listing{size(control_listing,1)+1,1} = data_listing(a,1).name;
            else
                patient_listing{size(patient_listing,1)+1,1} = data_listing(a,1).name;
            end
        else
            if strfind(data_listing(a,1).name, kontroll_kennung) == 1
                control_listing{size(control_listing,1)+1,1} = data_listing(a,1).name;
            elseif strfind(data_listing(a,1).name, patient_kennung) == 1
                patient_listing{size(patient_listing,1)+1,1} = data_listing(a,1).name;
            end
        end
    end
end