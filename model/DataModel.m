classdef DataModel
    %DATAMODEL Holds all input data available for recommendation
    %   Mainly provides access to the User Rating Matrix (URM)
    %   read from the input files, stored as a sparse matrix
    
    properties (Dependent)
        NumPreferences
    end
    
    properties (GetAccess=private, SetAccess = private)        
        % Not meant to be used directly
        Urm
    end
    
    properties
    end
    
    methods
        %Constructor
        function obj = DataModel( filename )
            obj.Urm = parseData(filename, '\t');
        end
        
        function NumPreferences = get.NumPreferences(obj)
            NumPreferences = nnz(obj.Urm);
        end
    end
    
end

