classdef ContentModel < handle
    %CONTENTMODEL Available side information for items and users
    
    properties
        % Item content matrix
        % Not meant to be used directly
        % Except for testing
        % Each column correspond to the
        % feature vector of a given item
        Icm
    end
    
    methods
        %Constructor
        function obj = ContentModel(filename)
            if (nargin == 0)
                %Default constructor
                return
            end
            [~,~,ext] = fileparts(filename);
            if (strcmp(ext, '.mat'))
                % Just load a matlab matrix file
                load(filename);
                % Transpose to match item row vector convention
                obj.Icm = icm_idf';
            else
                %Skip first row
                obj.Icm = parseData(filename, '\t', true);
            end
            
        end
    end
    
end

