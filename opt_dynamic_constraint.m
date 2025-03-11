function [dynamic]=opt_dynamic_constraint(MMM)

Qdd_Qd_q_t1=MMM(1:6);
Qdd_Qd_q_t2=MMM(7:12);
Qdd_Qd_q_t3=MMM(13:18);
Qdd_Qd_q_t4=MMM(19:24);
Qdd_Qd_q_t5=MMM(25:30);
Qdd_Qd_q_t6=MMM(31:36);
Qdd_Qd_q_t7=MMM(37:42);
Qdd_Qd_q_t8=MMM(43:48);
Qdd_Qd_q_t9=MMM(49:54);
Qdd_Qd_q_t10=MMM(55:60);
ut=MMM(61:70);

X1=[Qdd_Qd_q_t1;ut(1)];
X2=[Qdd_Qd_q_t2;ut(2)];
X3=[Qdd_Qd_q_t3;ut(3)];
X4=[Qdd_Qd_q_t4;ut(4)];
X5=[Qdd_Qd_q_t5;ut(5)];
X6=[Qdd_Qd_q_t6;ut(6)];
X7=[Qdd_Qd_q_t7;ut(7)];
X8=[Qdd_Qd_q_t8;ut(8)];
X9=[Qdd_Qd_q_t9;ut(9)];
X10=[Qdd_Qd_q_t10;ut(10)];


[dynamic1]=aaadynamic_constraint(X1);
[dynamic2]=aaadynamic_constraint(X2);
[dynamic3]=aaadynamic_constraint(X3);
[dynamic4]=aaadynamic_constraint(X4);
[dynamic5]=aaadynamic_constraint(X5);
[dynamic6]=aaadynamic_constraint(X6);
[dynamic7]=aaadynamic_constraint(X7);
[dynamic8]=aaadynamic_constraint(X8);
[dynamic9]=aaadynamic_constraint(X9);
[dynamic10]=aaadynamic_constraint(X10);

dynamic=[dynamic1;dynamic2;dynamic3;dynamic4;dynamic5;dynamic6;dynamic7;dynamic8;dynamic9;dynamic10];



