function [data_rect,perc_rect] = dlc_preprocess(data,llh)
%DLC_PREPROCESS     filter data based on given likelihood threshold
%   [data_rect, perc_rect] = dlc_preprocess(data,num,llh) outputs the rectified data and percent rectified for each label
%   DATA    A matrix generated by DeepLabCut (rows of observations & columns of x, y, and likelihoods).
%   LLH    Likelihood threshold cut-off. User should base this on how the labeled videos from DeepLabCut looks. Default is 0.5.
%
%   Examples:
%   load Ms2OpenField.mat
%   rawdata = data_struct.data;
%   [data,perc_rect] = dlc_preprocess(rawdata,0.5);
%
%   Created by Alexander Hsu, Date: 051519
%   Contact ahsu2@andrew.cmu.edu
    if isstruct(data) || iscell(data)
        error('Input data has to be a matrix');
    end
    if nargin < 2
        llh = 0.5;
    end
    fprintf('Filtering low likelihood data points and replacing with the most recent position... \n');
    % Get rid of hind paws to speed up all following analyses
    datax = data(:,[2:3:17]);
    datay = data(:,[3:3:18]);
    data_lh = data(:,[4:3:19]);
    % filter out likelihood below llh
    for x = 1:length(data_lh(1,:))
        perc_rect(x) = length(find(data_lh(:,x) < llh))/length(data_lh);
        data_rect(1,(2*x-1):2*x) = [datax(1,x),datay(1,x)];
        for i = 2:length(data_lh)
            if  data_lh(i,x) < llh
                data_rect(i,(2*x-1):2*x) = [datax(i-1,x),datay(i-1,x)];
            else
                data_rect(i,(2*x-1):2*x) = [datax(i,x),datay(i,x)];
            end
        end
    end
return
