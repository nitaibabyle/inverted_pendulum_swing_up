clear all
clc
global l M m g
g = 9.8;
l=0.5;
m = 2;
M = 10;

% Initial conditions and other settings.
framespersec=1000;  %if view is not speeded or slowed in dbpend_animate
T=2;             %duration of animation  in seconds
% 
x_ed=1;        dx_ed=0;      ddx_ed=0;
theta_ed=pi;        dtheta_ed=0;      ddtheta_ed=0;

%theta_ed=0.0573;    dtheta_ed=0;

x_0=0;        dx_0=0;     ddx_0=0;
theta_0=0;        dtheta_0=0;     ddtheta_0=0;
%theta_0=0.0573;    dtheta_0=0;
u0=[0,0,0,0,0,0,0,0,0,0];
global z_0 z_ed
z_0=[ddx_0,dx_0,x_0,ddtheta_0,dtheta_0,theta_0];
z_ed=[ddx_ed,dx_ed,x_ed,ddtheta_ed,dtheta_ed,theta_ed];

MMM0=[z_0';...
    (8*z_0'+1*z_ed')/9;
    (7*z_0'+2*z_ed')/9;
    (6*z_0'+3*z_ed')/9;
    (5*z_0'+4*z_ed')/9;
    (4*z_0'+5*z_ed')/9;
    (3*z_0'+6*z_ed')/9;
    (2*z_0'+7*z_ed')/9; 
    (1*z_0'+8*z_ed')/9;
    z_ed';   u0'];
      %Kp_spring1;Kp_spring2;Kp_spring3;Kp_spring4;Kp_spring5;Kd_spring1;Kd_spring2;Kd_spring3;Kd_spring4;Kd_spring5;Time0];
% MMM0=ccc;
%options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
options = optimoptions('fmincon',...
    'Algorithm','sqp','Display','iter','ConstraintTolerance',1e-12);
%     options = optimoptions('fmincon','Display','iter');
[ccc,y]=fmincon('objective',MMM0,[],[],[],[],[],[],'nlconstraint',options);



