function torque = roughTorque( body, stance, body_mass, stance_mass,contactf )
    torque = zeros(3,1);
    anchor = mean( stance, 2 );
    force  = body_mass*gravity();
    diff   = cross( force, body-anchor);
    torque = torque + diff;
    for idx = 1:4
        if ~contactf(idx)
            force = stance_mass(idx)*gravity();
            diff  = cross( force, stance(:,idx )-anchor);
            torque = torque + diff;
        end
    end
end

