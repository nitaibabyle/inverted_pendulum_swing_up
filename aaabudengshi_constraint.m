function [budengshi]=aaabudengshi_constraint(X) 
ddx=X(1);
dx=X(2);
x=X(3);
ddtheta=X(4);
dtheta=X(5);
theta=X(6);
u=X(7);


joint_range_constraint=[...
    -x-5;...
    x-5;...
    -u-500;...
    u-500];


budengshi=[joint_range_constraint;-1];
