%通过直接确定轨迹参数的方法，计算并且画出双S曲线。
%定义变量 , 现在的初始值都按找书中的例子给定
q0 = 0  
q1 = 10 
vmax = 10
max = 10
v0 = 1
v1 = 0
amax = 10
jmax = 30

%根据轨迹规划的流程，首先根据初始调节与限制条件判断是否存在云加速段
%首先按照能够达到最大速度vmax，来计算Ta,Tb,Tj1 Tj2, Tv
if (vmax -v0)*jmax < amax^2
    Tj1 = ((vmax - v0)/jmax)^0.5
    Ta = 2*Tj1
    alima = Tj1 * jmax;
else
    Tj1 = amax/jmax
    Ta = Tj1 + (vmax-v0)/amax
    alima = amax
end

if (vmax -v1)*jmax < amax^2
    Tj2 = ((vmax - v1)/jmax)^0.5
    Td = 2*Tj1
    alimd = Tj2* jmax;
else
    Tj2 = amax/jmax
    Td = Tj2 + (vmax-v1)/amax
    alimd = amax
end
    
Tv = (q1 - q0)/vmax - Ta/2*(1+v0/vmax) - Td/2*(1+v1/vmax)
T = Tv + Ta + Td
%Tv>0 说明可以达到最大速度，进入计算轨迹，并画图
p  = [];
vc = [];
ac = [];
jc = [];
if Tv > 0
    vlim = vmax;
    T = Tv + Ta + Td
else
    Tv = 0;
    %说明没有办法达到最大速度，判断是否能够达到最大加速度
    %首先重新计算Ta,Tb
    amax_org = amax;
    delta = (amax^4)/(jmax^2) + 2*(v0^2+v1^2) + amax*(4*(q1 - q0) - 2*amax/jmax*(v0+v1));
    Tj1 = amax/jmax;
    Ta = (amax^2/jmax - 2*v0 + delta^0.5)/2/amax;
    Tj2 = amax/jmax;
    Td = (amax^2/jmax - 2*v1 + delta^0.5)/2/amax;
    while Ta < 2*Tj1
        amax = amax - amax_org*0.1;
        alima = amax;
        Tj1 = amax/jmax;
        Ta = (amax^2/jmax - 2*v0 + delta^0.5)/2/amax;     
    end
    
    if Ta <0
        Ta =0;
    end
    amax = amax_org;
    while Td < 2*Tj2
        amax = amax - amax_org*0.1;
        alimb = amax;
        Tj2 = amax/jmax;
        Td = (amax^2/jmax - 2*v1 + delta^0.5)/2/amax;     
    end
    if Td <0
        Td =0;
    end
    Tj1
    Tj2
    Ta
    Td
    alima
    alimd
    T = Tv + Ta + Td
%     vlim = v0 + alima * Tj1^2 + (Ta - 2*Tj1)*alima
    vlim = v0 + (Ta - Tj1)*alima 
end
for t = 0:0.001:T
%         加速段轨迹
        if t>=0&&t<Tj1
            q = q0 + v0*t + jmax*t^3/6;
            p = [p q];
            v = v0 + jmax*t^2/2;
            vc = [vc v];
            a = jmax*t;
            ac = [ac a];
            jc = [jc jmax];
        elseif t>= Tj1&&t<(Ta - Tj1)
            q = q0 + v0*t + alima/6*(3*t^2 - 3*Tj1*t + Tj1^2);
            p = [p q];
            v = v0 + alima*(t - Tj1/2);
            vc = [vc v];
            a = alima;
            ac = [ac a];
            jc = [jc 0];
        elseif t>=(Ta - Tj1)&&t < Ta
            q = q0 + (vlim + v0)*Ta/2 - vlim*(Ta - t) + jmax*(Ta - t)^3/6;
            p = [p q];
            v = vlim - jmax*(Ta - t)^2/2;
            vc = [vc v];
            a = jmax*(Ta - t);
            ac = [ac a];
            jc = [jc -jmax];
         %匀速段   
        elseif t>=Ta&&t<(Ta + Tv)
            q = q0 + (vlim + v0)*Ta/2 + vlim*(t - Ta);
            p = [p q];
            v = vlim;
            vc = [vc v];
            a = 0;
            ac = [ac 0];
            jc = [jc 0];           
        %减速段    
        elseif t>=(T - Td)&&t <(T - Td + Tj2)
            q = q1 - (vlim + v1)*Td/2 + vlim*(t - T + Td) - jmax*(t - T + Td)^3/6;
            p = [p q];
            v = vlim - jmax*(t - T + Td)^2/2;
            vc = [vc v];
            a = -jmax*(t - T + Td);
            ac = [ac a];
            jc = [jc -jmax];
        elseif t>=(T - Td + Tj2)&&t<(T - Tj2)
            q = q1 - (vlim + v1)*Td/2 + vlim*(t - T + Td) - alimd/6*(3*(t - T + Td)^2 -3*Tj2*(t - T + Td) + Tj2^2);
            p = [p q];
            v = vlim - alimd*(t - T + Td - Tj2/2);
            vc = [vc v];
            a = -alimd;
            ac = [ac a];
            jc = [jc 0];
        elseif t>=(T - Tj2)&& t<T
            q = q1 - v1*(T - t) -jmax*(T - t)^3/6;
            p = [p q];
            v = v1 + jmax*(T - t)^2/2;
            vc = [vc v];
            a = -jmax*(T - t);
            ac = [ac a];
            jc = [jc jmax];           
         end
end
t =  0:0.001:T;
plot(t,p)
figure
plot(t,vc)
figure
plot(t,ac)
figure
plot(t,jc)

