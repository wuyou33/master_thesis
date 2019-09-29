t = [0 2 4 6]'; % Waypoints times
tt = (t(1):.01:t(end))'; % Sample times

% Waypoints positions
pos = [0 0 0;
    1 2 1;
    1 -1 3;
    0 0  2];

vel = zeros(size(pos));
accel = vel;
jerk = vel;
snap = vel;

yaw = [0; pi/2; pi; 0];
yaw = [yaw zeros(length(yaw), 3)];

x_d = [pos vel accel jerk snap];
sample_fun = plan_polynomial_trajectory2(t, x_d, 3, 6);
sample_fun_yaw = plan_polynomial_trajectory2(t, yaw, 1, 2);

qqd = sample_fun(tt);
yaw_tt = sample_fun_yaw(tt);



physics_p = quadrotor3d_slung_physics();

[flat_outputs control_input] = differentially_flat_trajectory(qqd, yaw_tt, physics_p);
% plot(tt, qqd(:,1:3), tt, flat_outputs(:,1:3));
% plot(tt, flat_outputs(:,end-1:end));

plot_quadrotor3d_slung_flat_animation(tt, flat_outputs, flat_outputs, physics_p);

x = flat_outputs(:, 1);
y = flat_outputs(:, 2);
z = flat_outputs(:, 3);

phiL = flat_outputs(:, 7);
thetaL = flat_outputs(:, 8);

xL = x - physics_p.l * sin(thetaL);
yL = y + physics_p.l * sin(phiL) .* cos(thetaL);
zL = z - physics_p.l * cos(phiL) .* cos(thetaL);

% plot(tt,control_input);
% plot3(qqd(:, 1), qqd(:, 2), qqd(:, 3)); hold on;
plot3(x,y,z); hold on;
plot3(xL,yL,zL);

testCase = matlab.unittest.TestCase.forInteractiveUse;
assertEqual(testCase,qqd(:,1:3),[xL,yL,zL],'AbsTol',1e-8);
assertEqual(testCase,yaw_tt(:,1),flat_outputs(:,6),'AbsTol',1e-12);
assertEqual(testCase,yaw_tt(:,2),flat_outputs(:,14),'AbsTol',1e-12);
% assertEqual(testCase,yaw_tt(:,3),flat_outputs(:,22),'AbsTol',1e-12);