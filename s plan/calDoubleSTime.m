function [ t ] = calDoubleSTime( v_s, v_e ,F ,D_max ,A_max ,J ,S )
%UNTITLED6 计算S曲线规划的各段的时间，
% 时间分为 T1,T2,T3,T4,T5,T6,T7
%   输入分别为：
%        v_s    起始速度
%        v_e    结束速度
%        F      最大进给速度
%        D_max   最大减速度
%        A_max   最大加速度
%        J      最大加加速度
%        S      运行距离

% 第一步计算T1 - T6 ，
if F >= v_s + A_max^2/J
    T1 = A_max/J;
    T2 = (F - v_s)/A_max - A_max/J;
else
    T1 = sqrt((F - v_s)/J);
    T2 = 0;
end

if F >= v_e + D_max^2/J
    T5 = D_max/J;
    T6 = (F - v_e)/D_max - D_max/J;
else
    T5 = sqrt((F - v_e)/J);
    T6 = 0;
end
T3 = T1;
T7 = T5;

v1 = v_s + 0.5*J*T1^2;
v2 = v1 + J*T1*T2;
v3 = v_s + J*T1^2 + J*T1*T2;
v4 = v3;
v5 = v4 - 0.5*J*T5^2;
v6 = v5 - J*T5*T6;

S1 = (F + v_s)/2*(2*T1 + T2) + (F + v_e)/2*(2*T5 + T6);

if S1 < S
    T4 = (S - S1)/F; 
elseif S1 == S
    T4 = 0;
else
%     S1 > S 说明没有匀速段，T4 = 0，并且系统没有带到给定的进给速度F
%     重新计算各个阶段的运行时间
    T4 = 0;
    if v_s < v_e
%         说明加速阶段大于减速阶段时间
%         按照可以到的最大速度F1，重新计算
        F1 = v_e + D_max^2/J;
        F = F1;
        S1 = (F + v_s)/2*(2*T1 + T2) + (F + v_e)/2*(2*T5 + T6);
        if S1 < S
%             说明系统有匀减速时间，实际S型为6段
              F = -A_max^2/2/J + sqrt(A_max^4 - 2*J*( A_max^2*(v_s + v_e) - J*(v_s^2 + v_e^2) - 2*A_max*J*S))/2/J;
              T1 = A_max/J;
              T3 = T1;
              T2 = (F - v_s )/A_max - A_max/J;
              T5 = D_max/J;
              T7 = T5;
              T6 = (F - v_e)/D_max - D_max/J;
        elseif S1 == S
%             说明不含匀减速段，F1 == F
              T1 = A_max/J;
              T3 = T1;
              T2 = (F - v_s )/A_max - A_max/J;
              T5 = D_max/J;
              T7 = T5;
              T6 = 0;
        else 
%           S1 > S 说明不含匀减速度，实际最大速度小于F1        
%             求解F2，确定是否存在匀加速度段
            F2 = v_s + A_max^2/J;
            if F2 <= v_e
%                 存在匀加速段，S曲线为5段
%                 根据公式11，迭代求取最大速度F
                F = calEquation11(v_s, v_e ,F ,D_max ,A_max ,J ,S);
                T1 = A_max/J;
                T3 = T1;
                T2 = (F - v_s )/A_max - A_max/J;
                T5 = sqrt(abs(F - v_e)/J);
                T7 = T5;
                T6 = 0;
            else
%                 F2 > ve 求 S2，确定是否存在匀加速段
                  F = F2;
                  T1 = A_max/J;
                  T5 = D_max/J;
                  S2 = (v_s + F)*T1 + (v_e + F)*T5;
                  if S2 >= S
%                       不存在匀加速度
%                         使用方程式14迭代求解F
                  F = calEquation14(v_s, v_e ,F ,D_max ,A_max ,J ,S);
                  T1 = sqrt((F - v_s)/J);
                  T3 = T1;
                  T2 = 0;
                  T6 = 0;
                  T5 = sqrt((F - v_e)/J);
                  T7 = T5;
                  else
%                       根据方程11 迭代计算 F，
                    F = calEquation11(v_s, v_e ,F ,D_max ,A_max ,J ,S);
                    T1 = A_max/J;
                    T3 = T1;
                    T2 = (F - v_s )/A_max - A_max/J;
                    T5 = sqrt(abs(F - v_e)/J);
                    T7 = T5;
                    T6 = 0;
                  end
            end
        end
    else
%     vs >= ve 
%       求F1,在用F1求解S1
      F1 = v_s + A_max^2/J;
      F = F1;
      S1 = (F + v_s)/2*(2*T1 + T2) + (F + v_e)/2*(2*T5 + T6);
      if S1 < S
%           含有匀加速段，由于加速时间小于减速时间，则必定含有匀减速段
          F = -A_max^2/2/J + sqrt(A_max^4 - 2*J*( A_max^2*(v_s + v_e) - J*(v_s^2 + v_e^2) - 2*A_max*J*S))/2/J;
          T1 = A_max/J;
          T3 = T1;
          T2 = (F - v_s )/A_max - A_max/J;
          T5 = D_max/J;
          T7 = T5;
          T6 = (F - v_e)/D_max - D_max/J;        
      elseif S1 == S
          T1 = A_max/J;
          T3 = T1;
          T2 = 0;
          T5 = D_max/J;
          T7 = T5;
          T6 = (F - ve)/D_max - D_max/J;          
      else
%        S1 > S 说明不含有匀加速段，接下来判断是否含有匀减速的
          F2 = v_e + D_max^2/J;
          F = F2;
          T1 = A_max/J;
          T5 = D_max/J;
          S2 = (v_s + F)*T1 + (v_e + F)*T5;
          if S2 >= S
%               不存在匀减速段，不存在匀加速段，
%               根据方程16求解最大速度F，方程16与方程14相同
                F = calEquation14(v_s, v_e ,F ,D_max ,A_max ,J ,S);
                T1 = sqrt((F - v_s)/J);
                T3 = T1;
                T2 = 0;
                T6 = 0;
                T5 = sqrt((F - v_e)/J);
                T7 = T5;
          else
%               系统存在匀减速段，但是不存在匀加速段
%               根据方程18求解最大速度F
                 F = calEquation18(v_s, v_e ,F ,D_max ,A_max ,J ,S);
                 T1 = sqrt((F - v_s)/J);
                 T3 = T1;
                 T2 = 0;
                 T5 = D_max/J;
                 T7 = T5;
                 T6 = (F - v_e)/D_max - D_max/J;
          end
      end
    end     
end

    t(1) = T1;
    t(2) = T2;
    t(3) = T3;
    t(4) = T4;
    t(5) = T5;
    t(6) = T6;
    t(7) = T7;


end

