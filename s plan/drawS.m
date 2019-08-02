
vs = 0;
ve = 0;
F =100;
Dmax =100;
Amax = 100;
J = 1000;
S = 2;

t = calDoubleSTime(vs, ve ,F ,Dmax ,Amax ,J ,S);
% 根据时间t画出来各个阶段的曲线
T = t(1) + t(2) + t(3) + t(4) + t(5) + t(6) + t(7); 
T1 = t(1);
T2 = t(1) + t(2);
T3 = t(1) + t(2) + t(3);
T4 = t(1) + t(2) + t(3) + t(4);
T5 = t(1) + t(2) + t(3) + t(4) + t(5);
T6 = t(1) + t(2) + t(3) + t(4) + t(5) + t(6);
T7 = t(1) + t(2) + t(3) + t(4) + t(5) + t(6) + t(7);
Td = t(5) + t(6) + t(7);
t_7 = t(7);
p  = [];
vc = [];
ac = [];
jc = [];
v1 = vs + 0.5*J*t(1)^2;
v2 = v1 + J*t(1)*t(2);
v3 = vs + J*t(1)^2 + J*t(1)*t(2);
v4 = v3;
v5 = v4 - 0.5*J*t(5)^2;
v6 = v5 - J*t(5)*t(6);
T = T + 0.008;
a1 = J*t(1);
a2 = a1;
a3 = 0;
a4 = 0;
a5 = -J*t(5);
a6 = a5;
p1 = vs*t(1) + 1/6*J*t(1)^3;
p2 = p1 + v1*t(2) + 0.5*J*t(1)*t(2)^2 ;
p3 = p2 + v2*t(3) + 0.5*a1*t(3)^2 - 1/6*J*t(3)^3;
p4 = p3 + v3*t(4);
p5 = p4 + v4*t(5) - 1/6*J*t(5)^3;
p6 = p5 + v5*t(6) - 0.5*J*t(5)*t(6)^2;

for time = 0:0.008:T
    if time > T7
        time = T7;
    end
    if time >=0 && time <= T1
        q = vs*time + 1/6*J*time^3;
        v = vs + 0.5*J*time^2;
        a = J*time;
    elseif time >= T1 && time < T2
        q = p1 + v1*(time - T1) + 0.5*J*t(1)*(time - T1)^2 ;
        v = v1 + J*t(1)*(time - T1);
        a = a1;
    elseif time >= T2 && time < T3
        t_ = time - T2;
        q = p2 + v2*t_ + 0.5*a1*t_^2 - 1/6*J*t_^3;
        v = v2 + a1*t_ - 0.5*J*t_^2;
        a = a1 - J*t_;
    elseif time >= T3 && time < T4 
        q = p3 + v3*(time - T3);
        v = v3;
        a = 0;
    elseif time >= T4 && time < T5
        q = p4 + v4*(time - T4) - 1/6*J*(time - T4)^3;
        v = v4 - 0.5*J*(time - T4)^2;
        a = -J*(time -T4);
    elseif time >= T5 && time < T6
        q = p5 + v5*(time - T5) - 0.5*J*t(5)*(time - T5)^2;
        v = v5 - J*t(5)*(time - T5);
        a = a6;
    elseif time >= T6 && time <= T7
        q = p6 + v6*(time - T6) + 1/2*a6*(time - T6)^2 + 1/6*J*(time - T6)^3;
        v = v6 + a6*(time - T6) + 1/2*J*(time - T6)^2;
        a = a6 + J*(time - T6);
    end
     p = [p q];
     vc = [vc v];
     ac = [ac a];
%      jc = [jc j];
end
plot(p,'r')
% figure;
hold on;
plot(vc,'g')
% figure;
hold on;
plot(ac,'b')
% figure;
% hold on;
% plot(jc,'k')