classdef pointMass
    
    properties    
        mass = 1.0;
        pos  = zeros(3,1);
        vel  = zeros(3,1);
        acc  = zeros(3,1);
        frc  = zeros(3,1);
    end

    methods
    
        function pm = pointMass( varargin )
            while numel(varargin)
                if strcmpi(varargin{1},'MASS');
                    pm.mass = varargin{2};
                else
                    error(['Unrecognized token : ',varargin{2}]);
                end    
                varargin(1:2) = [];
            end
        end
        
        
        function pm = reset(pm)
            for idx = 1:numel(pm)
                pm(idx).frc = zeros(3,1);
            end
        end
        
        
        function pm = hardstop(pm)
            for idx = 1:numel(pm)
                pm(idx).acc = zeros(3,1);
                pm(idx).vel = zeros(3,1);
            end
        end
        
        
        function pm = integrate(pm,dt)
            for idx = 1:numel(pm)
                pm(idx).acc = pm(idx).frc/pm(idx).mass;
                pm(idx).vel = pm(idx).vel + pm(idx).acc*dt;
                pm(idx).pos = pm(idx).pos + pm(idx).acc*dt;
            end
        end
         
        
        function pm = applySMD( pm, other, K, d )
            for idx = 1:numel(pm)
                diff        = pm(idx).pos - other.pos;
                magn        = norm(diff);
                dird        = diff/magn;
                deld        = magn - d;
                pm(idx).frc = pm(idx).frc - K*deld*dird;
            end
        end
         
        
        function pm = applySMD_XY( pm, other, K, d )
            for idx = 1:numel(pm)
                diff        = pm(idx).pos - other.pos;
                magn        = norm(diff);
                dird        = diff/magn;
                deld        = magn - d;
                pm(idx).frc = pm(idx).frc - proj(K*deld*dird,zeros(3,1),[0;0;1]);
            end
        end        
        
        
        
        function pm = applyBoundaryForces( pm, other, K, rmin, rmax )
            for idx = 1:numel(pm)
                diff        = pm(idx).pos - other.pos;
                magn        = norm(diff);
                dird        = diff/magn;
                pm(idx).frc = pm(idx).frc - boundaryFunction(magn,K,rmin,rmax)*dird;
            end
        end
        
        
        
        function pm = applyBoundaryForces_XY( pm, other, K, rmin, rmax )
            for idx = 1:numel(pm)
                diff        = pm(idx).pos - other.pos;
                magn        = norm(diff);
                dird        = diff/magn;
                pm(idx).frc = pm(idx).frc - proj(boundaryFunction(magn,K,rmin,rmax)*dird,zeros(3,1),[0;0;1]);
            end
        end
        
        
        
        
        function pm = applyForce( pm, f )
            for idx = 1:numel(pm)
                pm(idx).frc = pm(idx).frc + f;
            end
        end       
        
        
        
        
        function pm = applyViscousFriction( pm, coeff )
            for idx = 1:numel(pm)
                pm(idx).frc = pm(idx).frc - coeff*pm(idx).vel;
            end
        end          
        

                
        
        function plot(pm,varargin)
            to_draw = zeros(3,numel(pm));
            if ~isempty(to_draw)
                
                for idx = 1:numel(pm)
                    to_draw(:,idx) = pm(idx).pos;
                end
                
                plot3( ...
                    to_draw(1,:),...
                    to_draw(2,:),...
                    to_draw(3,:),...
                    varargin{:}  ...
                );
            
            end 
        end
        
        
        function to_set = set_to(pm)
            to_set = zeros(3,numel(pm));
            for idx = 1:numel(pm)
                to_set(:,idx) = pm(idx).pos;
            end
        end
        
        
        function pm = set_from(pm,to_set)
            for idx = 1:numel(pm)
                pm(idx).pos = to_set(:,idx);
            end
        end
        
        
    end
    
end


function fout = boundaryFunction(x,K,rmin,rmax)
    fout = -exp(K*(rmin-x)) + exp(-K*(rmax-x) );
end