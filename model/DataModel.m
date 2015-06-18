classdef DataModel < handle
    %DATAMODEL Holds all input data available for recommendation
    %   Mainly provides access to the User Rating Matrix (URM)
    %   read from the input files, stored as a sparse matrix
    
    properties (SetAccess = private)
        Items
        Users
        NumItems
        NumUsers
        NumPreferences
    end
    
    properties
        % Not meant to be used directly
        % Except for testing
        Urm
    end
    
    methods
        %Constructor
        function obj = DataModel(filename)
            if (nargin == 0)
                %Default constructor
                return
            end
            urm = parseData(filename, '\t');
            obj.Urm = urm;
        end
        
        %Updates dependent value on user rating matrix change
        %Main use case is testing
        function set.Urm(obj, value)
            % Save immutable data
            obj.Urm = value;
            % Not using dependent to avoid doing this operations each time
            users = findUnique(value, 1);
            obj.Users = users;
            obj.NumUsers = length(users);
            items = findUnique(value, 2);
            obj.Items = items;
            obj.NumItems = length(items);
            obj.NumPreferences = nnz(value);
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
        
        %Retrieves the known items without any preference from the user
        function items = itemsNotSeenByUser( obj, userId )
            seen = obj.itemsSeenByUser(userId);
            items = setdiff(obj.Items, seen);
        end
    end
    
end

