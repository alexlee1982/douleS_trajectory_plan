function [ value ] = dotEquation11(  v_s, v_e ,F ,D_max ,A_max ,J ,S)
%UNTITLED2 使用牛顿拉夫逊迭代法计算方程式11的解
% 该函数为方程的正解，即正向求等式的值
%   方程式为 ： 
%  ( F + v_s )/2 * ( A_max/J + ( F - v_s )/A_max ) + ( F + v_e
%   )*sqrt(( F - v_e )/J) = S
%  方程的导数为：
%  A_max/(2*J) + (F - v_s)/(2*A_max) + (F/2 + v_s/2)/A_max + ((F - v_e)/J)^(1/2) + (F + v_e)/(2*J*((F - v_e)/J)^(1/2))
% 其中F为待求解变量
% v_s  v_e J A_max S 为已知常量

value = A_max/(2*J) + (F - v_s)/(2*A_max) + (F/2 + v_s/2)/A_max + (abs(F - v_e)/J)^(1/2) + (F + v_e)/(2*J*(abs(F - v_e)/J)^(1/2));
end

