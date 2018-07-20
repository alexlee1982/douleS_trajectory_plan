%定义一些基本的计算量
rk = 0;
drk = 0;
ddrk = 0;
jmax = 5;
jmin = -5;
U = jmax;
vmin = -3;
vmax = 2;
amin = -2;
amax = 2;

qk = 0;
qk_1 = 0;
dqk = 0;
dqk_1 = 0;
ddqk = 0;
ddqk_1 = 0;
Ts = 0.1;
T = 0;
uk_1 = 0;

qc = [];
dqc = [];
ddqc = [];
jc = [];
while 1

    ek = (qk -rk)/U;
    dek = (dqk - drk)/U;
    ddek = (ddqk - ddrk)/U;

    demin = (vmin - drk)/U;
    demax = (vmax - drk)/U;
    ddemin = (amin - ddrk)/U;
    ddemax = (amax - ddrk)/U;

    delta = dek + abs(ddek)*ddek/2;
    sigma = ek + dek*ddek*sign(delta) - ddek^3*(1 - 3*abs(sign(delta)))/6 + sign(delta)/4*sqrt(2*(ddek^2 + 2* dek*sign(delta))^3);
    v_plus = ek - ddemax *(ddek - 2*dek)/4 - (ddek^2 - 2*dek)^2/8/ddemax - ddek*(3*ek - ddek^2)/3;
    v_minus = ek - ddemin*(ddek^2 + 2*ek)/4 - (ddek^2 + 2*dek)^2/8/ddemin + ddek*(3*dek + ddek^2)/3;
    
    if (ddek <= ddemax) && (dek <= ddek^2/2 - ddemax^2)
        SIGMA = v_plus;
    elseif (ddek >= ddemin) && (dek >= ddemin/2 - ddek^2/2)
        SIGMA = v_minus;
    else
        SIGMA = sigma;
    end
    uc = -U*sign(SIGMA + (1 - abs(sign(SIGMA)))*(delta + (1 - abs(sign(delta))*ddek )));
    
    
    ua_ddemin = -U*sign(ddek - ddemin);
    ua_ddemax = -U*sign(ddek - ddemax);
    
    deltav_demin = ddek*abs(ddek) + 2*(dek - demin);
    deltav_demax = ddek*abs(ddek) + 2*(dek - ddemax);
   
    ucv_demin = -U*sign(deltav_demin + (1 - abs(sign(deltav_demin)))*ddek);
    ucv_demax = -U*sign(deltav_demax + (1 - abs(sign(deltav_demax)))*ddek);
    
    uv_demin = max(ua_ddemin,min(ucv_demin,ua_ddemax));
    uv_demax = max(ua_ddemin,min(ucv_demax,ua_ddemax));
    
    uk = max(uv_demin,min(uc,uv_demax));
    ddqk = ddqk_1 + Ts*uk_1;
    dqk = dqk_1 + Ts/2*(ddqk+ddqk_1);
    qk = qk_1 + Ts/2*(dqk+ dqk_1);
    qc = [qc qk];
    dqc = [dqc dqk];        
    ddqc = [ddqc ddqk];
    jc = [jc uk];
    uk_1 = uk;
    ddqk_1 = ddqk;
    dqk_1 = dqk;
    qk_1 = qk;
    
    
    
    
    
    
    T = T + Ts;
%     if T>=7
%         rk = 6;
%     end
%     if T >= 13
%         rk = -12;
%     end
    if T >20
        break;
    end
end % end of while
figure
plot(qc)
figure
plot(dqc)
figure
plot(ddqc)
figure
plot(jc)








