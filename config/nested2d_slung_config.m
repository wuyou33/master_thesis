function [physics_p control_p traj_p plot_p] = nested2d_slung_config()

% Physical parameters
physics_p = quadrotor2d_slung_physics();
physics_p.dyn_fun = @quadrotor2d_slung;

% Control parameters
% 73.5951   87.9026   99.7530   84.6533   99.5703   13.5317


control_p.kp_x = 73.5951;
control_p.kd_x = 87.9026;

control_p.kp_z = 99.7530;
control_p.kd_z = 84.6533;

control_p.kp_theta = 99.5703;
control_p.kd_theta = 13.5317;

control_p.n_input = 6;

control_p.control_fun = @nested2d_controller;

% Trajectory parameters
xd = 5;
zd = 2;
T = 3;
steady_time = 10;
dt = .05;
traj_p = simple2d_shaped_trajectory(xd,zd,T,steady_time,dt,physics_p);
traj_p.x0 = zeros(8,1);

% Plot parameters
plot_p.plot_state = @plot_quadrotor2d_slung_state;
plot_p.plot_animation = @plot_quadrotor2d_slung_animation;

end