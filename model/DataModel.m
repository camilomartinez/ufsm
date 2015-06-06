classdef DataModel
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
            row = obj.Urm(userId,:);
            [~, items, ~] = find(row);
        end
    end
    
end

