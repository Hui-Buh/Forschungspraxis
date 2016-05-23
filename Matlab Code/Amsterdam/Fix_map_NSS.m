% This function calculates Fixation maps based on fixation text files

% data_path = absolute or relative path of the folder containing all data or a single file path

function Fix_map_NSS(data_path)

%% variables
%  Eyetracker resolution
    video_size = [1024 1280]; % in px [y-size x_size]
    
%% List of all data to use
%  Usable with a single file or a data path containing multiple data files
%  Filters for '.txt documents'
%  Data separation is done via the document name
    if isdir(data_path) == 1
        if data_path(end) ~= '\'; data_path = cat(2, data_path, '\'); end;
        data = dir(data_path);
        for a = 1: size(data,1)
            if isempty(strfind(data(a).name, '.txt')) == 0
                test_person_list{a,1} = data(a).name;
                if strfind(test_person_list{a,1}, 'pre')      % 'pre' in doument name indicates pre test
                    test_person_list{a,2} = 1;
                elseif strfind(test_person_list{a,1}, 'post') % 'post' in doument name indicates post test
                    test_person_list{a,2} = 2; 
                else                                          % anyting else is classified as 'expert' data set
                    test_person_list{a,2} = 3;
                end;
            end
        end
        test_person_list( cellfun(@isempty,test_person_list(:,1))>0,: ) = [];
        test_person_list = sortrows(test_person_list,2);
    else
        buf = strfind(data_path, '\');
        test_person_list = data_path(buf(end)+1:end);
        data_path = data_path(1:buf(end));
    end

%% Get data
    mask_NSS = cell(1,size(test_person_list,1));
    map_NSS = cell(1,size(test_person_list,1));
    for a = 1:size(test_person_list,1)
        
        file = fopen(cat(2, data_path, test_person_list{a,1}));
        data = textscan(file, '%d %d %d %d %d', 'HeaderLines', 20);
        data = cell2mat(data);
        fclose(file);
        
%         plot(data(:,4) , data(:,5))
%         data(:,5) = data(:,5)*(-1)+video_size(2)+1;
        mask_NSS{1,a} = makeFixationMask( data(:,4) , data(:,5) , video_size );
        map_NSS{1,a} =  makeSaliencyMap( data(:,4) , data(:,5), video_size );
    end

%% Calculate Fixation maps of pre, post and expert data
    Fixation_map_pre = zeros(size(mask_NSS{1,1}));
    Fixation_map_post = zeros(size(mask_NSS{1,1}));
    Fixation_map_expert = zeros(size(mask_NSS{1,1}));
    for b = 1:size(test_person_list,1)
        if test_person_list{b,2} == 1
            Fixation_map_pre = Fixation_map_pre + map_NSS{b};
        elseif test_person_list{b,2} == 2
            Fixation_map_post = Fixation_map_post + map_NSS{b};
        else
            Fixation_map_expert = Fixation_map_expert + map_NSS{b};
        end
    end
    Fixation_map_pre = Fixation_map_pre./sum(trapz(Fixation_map_pre));
    Fixation_map_post = Fixation_map_post./sum(trapz(Fixation_map_post));
    Fixation_map_expert = Fixation_map_expert./sum(trapz(Fixation_map_expert));

    figure(1)
    hold on; grid on; box on; axis off
    set(gca,'FontWeight','bold');
    surf(Fixation_map_pre', 'LineStyle', 'none');
    caxis([min(Fixation_map_pre(:))-.5*range(Fixation_map_pre(:)),max(Fixation_map_pre(:))]);
    legend('Fixation map - Pre')
    colorbar
    
    figure(2)
    hold on; grid on; box on; axis off
    set(gca,'FontWeight','bold');
    surf(Fixation_map_post', 'LineStyle', 'none');
    caxis([min(Fixation_map_post(:))-.5*range(Fixation_map_post(:)),max(Fixation_map_post(:))]);
    legend('Fixation map - Post')
    colorbar
    
    figure(3)
    hold on; grid on; box on; axis off
    set(gca,'FontWeight','bold');
    surf(Fixation_map_expert', 'LineStyle', 'none');
    caxis([min(Fixation_map_expert(:))-.5*range(Fixation_map_expert(:)),max(Fixation_map_expert(:))]);
    legend('Fixation map - Expert')
    colorbar
    
%% Calculate Normalized Scanpath Saliency
    separation = cell2mat(test_person_list(:,2));
    pre_post_exp = [size(separation(separation==1),1); size(separation(separation==2),1); size(separation(separation==3),1)];
    if size(test_person_list,1) > 1 
%% NNS for pre
        if pre_post_exp(1) > 1 
            % Leave one out saliency maps
            leave_one_out = map_NSS(1,1:pre_post_exp(1));
            leave_one_out = [leave_one_out leave_one_out(1,1) ];
            leave_one_out{2,end} = zeros(size(map_NSS{1,1}));
            for b = 1:size(leave_one_out,2)-2
                leave_one_out{2,end} = leave_one_out{2,end} + leave_one_out{1,b};
            end
            for c = size(leave_one_out,2)-1:-1:2
                leave_one_out{2,c} = leave_one_out{2,c+1} + leave_one_out{1,c} - leave_one_out{1,c-1};
            end
            % Normalize
            leave_one_out(:,1) = []; 
            for d = 1:size(leave_one_out,2)
                leave_one_out{2,d} = leave_one_out{2,d}./sum(trapz(leave_one_out{2,d}));
                leave_one_out{2,d} = (leave_one_out{2,d} - mean(leave_one_out{2,d}(:)))/std(leave_one_out{2,d}(:));
            end
            % NSS
            norm_scanpath_saliency = zeros(size(leave_one_out,2),1);
            for e = 1:size(leave_one_out,2)
                buf = leave_one_out{2,e}(:).*mask_NSS{e}(:);
                buf2 = find(mask_NSS{e}(:));
                buf = buf(buf2);
                norm_scanpath_saliency(e) = mean(buf);
            end

            figure(4)
            hold on; grid on; box on;
            set(gca,'FontWeight','bold');
            ylabel('NSS');
            boxplot(norm_scanpath_saliency', 'labels', 'inter pre NSS');
        end

%% NNS for post
        if pre_post_exp(2) > 1 
            % Leave one out saliency maps
            leave_one_out = map_NSS(1,pre_post_exp(1)+1:pre_post_exp(1)+pre_post_exp(2));
            leave_one_out = [leave_one_out leave_one_out(1,1) ];
            leave_one_out{2,end} = zeros(size(map_NSS{1,1}));
            for b = 1:size(leave_one_out,2)-2
                leave_one_out{2,end} = leave_one_out{2,end} + leave_one_out{1,b};
            end
            for c = size(leave_one_out,2)-1:-1:2
                leave_one_out{2,c} = leave_one_out{2,c+1} + leave_one_out{1,c} - leave_one_out{1,c-1};
            end
            % Normalize
            leave_one_out(:,1) = []; 
            for d = 1:size(leave_one_out,2)
                leave_one_out{2,d} = leave_one_out{2,d}./sum(trapz(leave_one_out{2,d}));
                leave_one_out{2,d} = (leave_one_out{2,d} - mean(leave_one_out{2,d}(:)))/std(leave_one_out{2,d}(:));
            end
            % NSS
            norm_scanpath_saliency = zeros(size(leave_one_out,2),1);
            for e = 1:size(leave_one_out,2)
                buf = leave_one_out{2,e}(:).*mask_NSS{e+pre_post_exp(1)}(:);
                buf2 = find(mask_NSS{e+pre_post_exp(1)}(:));
                buf = buf(buf2);
                norm_scanpath_saliency(e) = mean(buf);
            end

            figure(5)
            hold on; grid on; box on;
            set(gca,'FontWeight','bold');
            ylabel('NSS');
            boxplot(norm_scanpath_saliency', 'labels', 'inter post NSS');
        end

%% NNS for expert
        if pre_post_exp(3) > 1 
            % Leave one out saliency maps
            leave_one_out = map_NSS(1,pre_post_exp(1)+pre_post_exp(2)+1:end);
            leave_one_out = [leave_one_out leave_one_out(1,1) ];
            leave_one_out{2,end} = zeros(size(map_NSS{1,1}));
            for b = 1:size(leave_one_out,2)-2
                leave_one_out{2,end} = leave_one_out{2,end} + leave_one_out{1,b};
            end
            for c = size(leave_one_out,2)-1:-1:2
                leave_one_out{2,c} = leave_one_out{2,c+1} + leave_one_out{1,c} - leave_one_out{1,c-1};
            end
            % Normalize
            leave_one_out(:,1) = []; 
            for d = 1:size(leave_one_out,2)
                leave_one_out{2,d} = leave_one_out{2,d}./sum(trapz(leave_one_out{2,d}));
                leave_one_out{2,d} = (leave_one_out{2,d} - mean(leave_one_out{2,d}(:)))/std(leave_one_out{2,d}(:));
            end
            % NSS
            norm_scanpath_saliency = zeros(size(leave_one_out,2),1);
            for e = 1:size(leave_one_out,2)
                buf = leave_one_out{2,e}(:).*mask_NSS{e+pre_post_exp(1)+pre_post_exp(2)}(:);
                buf2 = find(mask_NSS{e+pre_post_exp(1)+pre_post_exp(2)}(:));
                buf = buf(buf2);
                norm_scanpath_saliency(e) = mean(buf);
            end

            figure(6)
            hold on; grid on; box on;
            set(gca,'FontWeight','bold');
            ylabel('NSS');
            boxplot(norm_scanpath_saliency', 'labels', 'inter expert NSS');
        end
    end
end

%% function to generate the Fixation map
% X = x coordinate oif Fixation oint
% Y = y coordinate oif Fixation oint
% mask_size = size of mask to be generated as array of dimension sizes
function mask = makeFixationMask( X , Y , mask_size )
    mask = zeros( mask_size);
    for i = 1 : length(X)
      mask( Y(i) , X(i) ) = mask( Y(i) , X(i) ) + 1;
    end
end

%% function to generate the Fixation map (Saliency map for NSS)
% X = x coordinate oif Fixation oint
% Y = y coordinate oif Fixation oint
% map_size = size of map to be generated as array of dimension sizes
function Fixation_map = makeSaliencyMap( X , Y, map_size )
% Fixation map parameters
    downsampling = 1; % works for values of 2^x
    gauss_size = 256; % in px
    sigma = [1024 0; 0 1024];
    Fixation_map = zeros((map_size(1)+gauss_size)/downsampling, (map_size(2)+gauss_size)/downsampling);
    x1 = 1:gauss_size/downsampling+1;
    [X1,X2] = meshgrid(x1,x1);
    G = mvnpdf([X1(:) X2(:)],[floor(mean(x1)) floor(mean(x1))] ,sigma);
    G  = reshape(G,length(x1),length(x1));
% Downsampling
    X = X/downsampling;
    Y = Y/downsampling;
    X = floor(X);
    Y = floor(Y);
    X(X==0) = 1;
    Y(Y==0) = 1;
% Saliency map creating
    for i = 1 : length(X)
      Fixation_map( Y(i):Y(i) + gauss_size , X(i):X(i) + gauss_size ) = Fixation_map( Y(i):Y(i) + gauss_size , X(i):X(i) + gauss_size ) + G;
    end
    
    Fixation_map = Fixation_map(gauss_size/2+1:end-gauss_size/2,gauss_size/2+1:end-gauss_size/2);
    Fixation_map = Fixation_map./sum(trapz(Fixation_map));
end
