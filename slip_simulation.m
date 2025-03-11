function slip
clc
clear all
close all
format long

ip.g = 10;
ip.l=0.5;
ip.m = 2;
ip.M = 10;

x0=0;
dx0=0;
theta0=0;
dtheta0=0;

z0=[x0 dx0 theta0 dtheta0];

t0=0;
dt=15;
t_ode=t0;
z_ode=z0;
fps = 10;

global u ref_traj_pos ref_traj_vel act_traj_pos act_traj_vel traj_time I_error
u=0;
ref_traj_pos=0;
ref_traj_vel=0;
I_error =0;
act_traj_pos=0;
act_traj_vel=0;

traj_time=0;

options2 = odeset('Abstol',1e-13,'Reltol',1e-13);
    tspan = linspace(t0,t0+dt,dt*1000);
    [t_temp2,z_temp2] = ode113(@invert_pendulum,tspan,z0,options2,ip);
    [t_temp2,z_temp2] = loco_interpolate(t_temp2,z_temp2,15);
    %ref_traj=loco_interpolate(ref_traj_pos,ref_traj_vel,15);
    %z_temp2(:,1)=z_temp2(:,1)+x_com+slip.l*sin(slip.theta);
    t_ode = [t_ode; t_temp2(2:end)];
    z_ode = [z_ode; z_temp2(2:end,:)];
    
    t=t_ode;
    z=z_ode;
    
%%pd跟踪误差  
figure(2)  
hold on
plot(traj_time,ref_traj_pos);
plot(traj_time,act_traj_pos);

figure(1)
for i=1:length(t)
    
    window_xmin = -0.5; window_xmax = 1.8;
    window_ymin = -0.6; window_ymax = 0.6;

    plot(z(i,1),0,'ks','MarkerEdgeColor','black', 'MarkerFaceColor',[0.5,0.5,0.5],'MarkerSize',10); %com
    line([z(i,1) z(i,1)+ip.l*sin(z(i,3))],[0 -ip.l*cos(z(i,3))],'Linewidth',4,'Color',[0.8 0 0]); %leg
    %hold on 
   
%hold off
    %plot(z(i,1)+ip.l*sin(z(i,3)),-ip.l*cos(z(i,3)),'ro','MarkerEdgeColor','black', 'MarkerFaceColor','black','MarkerSize',10); %com
    %hold off
   
    axis('equal')
    axis on
    axis([window_xmin window_xmax window_ymin window_ymax])
    %pause(0.05);
    F(i)=getframe;
end
v = VideoWriter('daolibai.avi');
open(v);
writeVideo(v,F);
close(v);


function zdot=invert_pendulum(t,z,ip) 
global u

l=ip.l;
M=ip.M;
m=ip.m;
g=ip.g;
x=z(1);dx=z(2);theta=z(3);dtheta=z(4);

u=controller(t,z,ip);

ddx = ((l*m*sin(theta))*(dtheta^2)+u+(m*g*cos(theta))*sin(theta))/(M+m*(1-(cos(theta))^2));
ddtheta = -((l*m*cos(theta))*(sin(theta))*(dtheta^2)+u*cos(theta)+(M+m)*g*sin(theta))/(l*M+l*m*(1-(cos(theta))^2));
zdot = [dx ddx dtheta ddtheta]';

function zdot=spring(t,z,slip) 

x=z(1);dx=z(2);y=z(3);dy=z(4);
F_spring = slip.kp*(slip.l0-sqrt(x^2+y^2));
Fy_gravity = slip.m*slip.g;
Fx = F_spring*(x/sqrt(x^2+y^2));
Fy = -Fy_gravity+F_spring*(y/sqrt(x^2+y^2));
ddx = (1/slip.m)*(Fx);
ddy = (1/slip.m)*(Fy);
zdot = [dx ddx dy ddy]';

function [gstop, isterminal,direction]=release(t,z,slip)
x=z(1);
y=z(3);
gstop = sqrt(x^2+y^2)-slip.l0+0.01;
direction = 1;
isterminal = 1;

function [t_interp,z_interp] = loco_interpolate(t_all,z_all,fps)
%===================================================================
[m,n] = size(z_all);
t_interp = linspace(t_all(1),t_all(end),fps*(t_all(end)-t_all(1)));

for i=1:n
    z_interp(:,i) = interp1(t_all,z_all(:,i),t_interp);
end
t_interp = t_interp';


function F_input=controller(t,z,ip)
global ref_traj_pos ref_traj_vel act_traj_pos act_traj_vel traj_time
l=ip.l;
M=ip.M;
m=ip.m;
g=ip.g;
x=z(1);dx=z(2);theta=z(3);dtheta=z(4);
global I_error
if (t<=2)

%%% nl_opt traj
u_opt_traj=[-1.50393571526796e-22;92.0423592733342;34.3553989117093;-37.9299135194090;-119.125578940257;-11.9612329198616;43.2278574047184;20.1826975650117;-19.6822982883327;-1.25103066454319e-21];
x_opt_traj=[-1.82989790350704e-22;0.108404755915235;0.459606081641226;0.916915844434232;1.14236746342481;1.04706590627817;0.911203999413714;0.914904109961713;0.974113072109600;1];
dx_opt_traj=[-4.65598826463764e-22;0.975642803237115;2.18516912829681;1.93061873684025;0.0984458340749961;-0.956159848394753;-0.266597313385399;0.299898308317389;0.232982351013598;-3.56387226535983e-23];
u_time=[0:(2/9):2];

%%% Interpolation of trajectories to generate reference trajectories
x_ref_traj=interp1(u_time,x_opt_traj,t,'cubic');
dx_ref_traj=interp1(u_time,dx_opt_traj,t,'cubic');
u_ref_traj=interp1(u_time,u_opt_traj,t,'cubic');

%%% pd controller
ref_now_pos=x;
ref_now_vel=dx;
kp=-251;
kd=-10;

F_pd=kp*(ref_now_pos-x_ref_traj)+kd*(ref_now_vel-dx_ref_traj);
F_input=u_ref_traj+F_pd;


ref_traj_pos=[ref_traj_pos,ref_now_pos];
ref_traj_vel=[ref_traj_vel,ref_now_vel];
act_now_pos=x;
act_now_vel=dx;
act_traj_pos=[act_traj_pos,act_now_pos];
act_traj_vel=[act_traj_vel,act_now_vel];


traj_time=[traj_time,t];


else

%     &&(theta-pi)^2<=0.0001&&dtheta^2<=0.0001)

error=theta;
I_error=I_error-error;
I_error=clamp(I_error,-50,300);
F_input=-9000*(theta-pi)-200*(dtheta)+0.2*I_error;

end

function b = clamp(a, lim1, lim2)
%CLAMP Clamp value between two bounds.

	% Find which limit is min and max
	a_min = min(lim1, lim2);
	a_max = max(lim1, lim2);

	% Clamp value between limits
	b = max(min(a, a_max), a_min);
