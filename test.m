clear; clc; cla

dir     = [1;0;0];
body_i  = [0;0;120];

body_mass   = 2000;
stance_mass = [400,400,400,400];

stance  = createRegularQuad(150);
junc    = createRegularQuad(65,body_i);
feet    = repmat( pointMass('MASS',2), 1, 4);
body    = pointMass('MASS',2); 
feet    = feet.set_from(stance);
body    = body.set_from(body_i);


contactf  = [1,1,1,1];
stability = 1;
stability_data = [];

dt = 0.01;
tt = 30;
tn = 0;

axis(200*[-1,1,-1,1,-1,1]);
axis square
shg

wtt     = 0.1;
gait_p  = 0.25;
gait_t  = 0;
gait_idx= 1;

body_trace = [];

while tn < tt
    pause(1e-3)
    cla
    tn = tn + dt;

    dir(1) = sin(2*pi*tn*wtt);
    dir(2) = cos(2*pi*tn*wtt);
   
    feet = feet.reset();
    body = body.reset();
    
    
    if gait_t < gait_p
        gait_t = gait_t + dt;
        feet(gait_idx)          = feet(gait_idx).applyForce(dir*200);
        feet(gait_idx).pos(3)   = sin(pi/gait_p*gait_t)*80;
    else
        gait_idx                = mod(gait_idx,4)+1;
        contactf                = ones(1,4);
        contactf(gait_idx)      = 0;
        gait_t = 0;
    end
    
    
    for idx = 1:4
        if  contactf(idx)
            dort = feet(idx).pos-body.pos;
            body = body.applySMD_XY(feet(idx),10*(1-stability/2)*vectorDeviation( (feet(idx).pos-body.pos),dir),165);
        end
        body = body.applyBoundaryForces_XY(feet(idx),0.1,50,200);
    end
    
    torque      = roughTorque(body.pos,stance,body_mass,stance_mass,contactf);
    stability   = exp(-1e-2*torque.'*eye(3)*torque);
    
    %stability_data(1,end+1) = tn;
    %stability_data(2,end)   = stability;
    
    body    = body.applyForce(30*dir);
    body    = body.applyForce(-torque/1e8);
    
    %body    = body.applyViscousFriction(1);
    %feet    = feet.applyViscousFriction(1);
    
    feet    = feet.integrate(dt);
    body    = body.integrate(dt);
    junc    = createRegularQuad(65,body.pos);
    
    body_trace(:,end+1) = body.pos;
%     for idx = 1:4
%         drawSphere( [junc(:,idx).'  ,200],'FaceColor','r','FaceAlpha',0.02) 
%         %drawSphere( [stance(:,idx).',100],'FaceColor','r','FaceAlpha',0.02) 
%     end

    stance  = feet.set_to();
    
    %subplot(2,1,1); cla
    plotcv3(50*dir+body.pos,body.pos,'s-b');
    plotcv3(stance,junc,'o-k');
    vizRegularPolygon(stance,contactf, 'r','LineWidth',2);
    vizRegularPolygon(junc  ,[1,1,1,1],'k');
    
    plot3(body_trace(1,:),body_trace(2,:),body_trace(3,:),'g')
    %subplot(2,1,2); cla
    %plot(stability_data(1,:), stability_data(2,:) );
end