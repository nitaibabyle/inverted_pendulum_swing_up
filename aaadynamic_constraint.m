function [dynamic]=aaadynamic_constraint(X)
global l M m g
ddx=X(1);
dx=X(2);
x=X(3);
ddtheta=X(4);
dtheta=X(5);
theta=X(6);
u=X(7);

dynamic1=((l*m*sin(theta))*(dtheta^2)+u+(m*g*cos(theta))*sin(theta))/(M+m*(1-(cos(theta))^2))-ddx;
dynamic2=-((l*m*cos(theta))*(sin(theta))*(dtheta^2)+u*cos(theta)+(M+m)*g*sin(theta))/(l*M+l*m*(1-(cos(theta))^2))-ddtheta;

dynamic = [dynamic1;dynamic2];