function c = vizRegularPolygon(stance,contacts,varargin)
    to_draw = stance(:,boolean(contacts));
    c       = zeros(3,1);
    if ~isempty(to_draw)
        to_draw(:,end+1) = to_draw(:,1);
        plot3( ...
            to_draw(1,:),...
            to_draw(2,:),...
            to_draw(3,:),...
            varargin{:}  ...
        );
    
        if nargout == 1
            
        end
    end
end