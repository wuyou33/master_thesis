startup;

[physics_p, control_p_smc, traj_p_smc, sim_p] = smc3d_slung_config();
[~, control_p_flat, traj_p_flat] = flat_smc3d_slung_config();
[~, control_p_shaped_smc, traj_p_shaped_smc] = shaped_smc3d_slung_config();
[~, control_p_shaped_flat, traj_p_shaped_flat] = shaped_flat_smc3d_slung_config();


% Plot desired path
fig = figure('units','normalized','outerposition',[0.25,0.2,0.46,0.56]);
set(fig,'Renderer','painters');
grid on;
view(3);

offset_xy = .9*physics_p.l;
offset_z = 2*physics_p.r;
xlim_values = [min(traj_p_flat.rd(:,1))-offset_xy, max(traj_p_flat.rd(:,1))+offset_xy];
ylim_values = [min(traj_p_flat.rd(:,2))-offset_xy, max(traj_p_flat.rd(:,2))+offset_xy];
zlim_values = [min(traj_p_flat.rLd(:,3))-offset_z,  max(traj_p_flat.rd(:,3))+offset_z];

axis equal;
xlim(xlim_values);
ylim(ylim_values);
zlim(zlim_values);

line(traj_p_flat.rd(:,1),traj_p_flat.rd(:,2),traj_p_flat.rd(:,3),'Color','g');
line(traj_p_flat.rLd(:,1),traj_p_flat.rLd(:,2),traj_p_flat.rLd(:,3),'Color','r');

xlabel('$x$ [m]','FontSize',14);
ylabel('$y$ [m]','FontSize',14);
zlabel('$z$ [m]','FontSize',14);

leg = legend("Trajeto da aeronave (I e II)", "Trajeto da carga (III)","Interpreter","tex","FontSize",11);
% set(leg,'FontSize',14);



disp('smc');
tic;
[t,x_smc,qd_smc,u_smc,metrics_smc] = run_simulation(physics_p, control_p_smc, traj_p_smc, sim_p);
toc;
% disp('flat');
% tic;
% [~,x_flat,qd_flat,u_flat,metrics_flat] = run_simulation(physics_p, control_p_flat, traj_p_flat, sim_p);
% toc;

disp('shaped smc');
tic;
[~,x_shaped_smc,qd_shaped_smc,u_shaped_smc,metrics_shaped_smc] = run_simulation(physics_p, control_p_shaped_smc, traj_p_shaped_smc, sim_p);
toc;

disp('shaped flat');
tic;
[~,x_shaped_flat,qd_shaped_flat,u_shaped_flat,metrics_shaped_flat] = run_simulation(physics_p, control_p_shaped_flat, traj_p_shaped_flat, sim_p);
toc;

metrics = [metrics_smc; metrics_flat; metrics_shaped_smc; metrics_shaped_flat];

figure;
bar([metrics_shaped_smc', metrics_shaped_flat']);
legend("Configuração III", "Configuração IV");
set(gca,'xticklabel',{'$r_{RMS}$','$\beta_{RMS}$','$\alpha_{RMS}$','$\bar{f}_\omega$'});

figure;
bar([metrics_smc', metrics_shaped_smc', metrics_shaped_flat']);
legend("(I)", "(II)", "(III)");
set(gca,'xticklabel',{'$r_{RMS}$','$\beta_{RMS}$','$\alpha_{RMS}$','$\bar{f}_\omega$'});




% 
% fig = figure('units','normalized','outerposition',[0 0 1 1]);
% set(fig,'Renderer','painters');
% subplot(1,3,1);
plot_drone_load_path(x_smc,traj_p.rd,physics_p, '(I)');
plot_drone_load_path(x_flat,traj_p.rd,physics_p, '(II)');
% plot_drone_load_path(x_flat,traj_p.rd,physics_p);
% subplot(1,3,2);
plot_drone_load_path(x_shaped_smc,traj_p.rd,physics_p, '(III)');
% legend("Trajeto de referência da aeronave", "Trajeto de referência da carga", "Trajeto da aeronave", "Trajeto da carga","Interpreter","tex","FontSize",12);
% subplot(1,3,3);
plot_drone_load_path(x_shaped_flat,traj_p.rd,physics_p, '(IV)');

