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
            % For the time just use a matlab matrix file
            obj.Icm = load(filename);
        end
    end
    
end

