classdef DataModel < handle
    %DATAMODEL Holds all input data available for recommendation
    %   Mainly provides access to the User Rating Matrix (URM)
    %   read from the input files, stored as a sparse matrix
    
    properties (GetAccess=private, SetAccess = private)        
        % Not meant to be used directly
        Urm
    end
    
    properties (SetAccess = private)
        Items
        NumPreferences
    end
    
    properties
    end
    
    methods
        %Constructor
        function obj = DataModel( filename )
            urm = parseData(filename, '\t');
            % Save immutable data
            obj.Urm = urm;
            obj.Items = findUnique(urm, 2);
            obj.NumPreferences = nnz(obj.Urm);
        end
        
        %Retrieves the items with at least one preference
        %for the given user
        function items = itemsSeenByUser( obj, userId )
            nRows = size(obj.Urm, 1);
            if (userId < 1 || userId > nRows)
                error('DataModel:itemsSeenByUser:InputOutOfRange',...
                    'The user id %i is not between 1 and %i',...
                    userId, nRows);
            end
            row = obj.Urm(userId,:);
            [~, items, ~] = find(row);
        end
    end
    
end

