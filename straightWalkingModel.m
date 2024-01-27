        function obj = straightWalkingModel(speed,varargin)
            % If angle is specified, use it, if not assign a random one
            if length(varargin)<1
                direction = floor(random('unif',0,359));
            else
                direction = varargin{1};
            end
            obj.direction = direction;
            obj.speed = speed;
        end