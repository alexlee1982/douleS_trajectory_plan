function [ value ] = dotEquation14(  v_s, v_e ,F ,D_max ,A_max ,J ,S)
%UNTITLED2 使用牛顿拉夫逊迭代法计算方程式11的解
% 该函数为方程的正解，即正向求等式的值
%   方程式为 ： 
%  ( F + v_s )*sqrt((F - v_s)/J) + (F + v_e)*sqrt((F - v_e)/J) - S
%  方程的导数为：
%  ((F - v_e)/J)^(1/2) + ((F - v_s)/J)^(1/2) + (F + v_e)/(2*J*((F - v_e)/J)^(1/2)) + (F + v_s)/(2*J*((F - v_s)/J)^(1/2))
% 其中F为待求解变量
% v_s  v_e J A_max S 为已知常量

value = (abs(F - v_e)/J)^(1/2) + (abs(F - v_s)/J)^(1/2) + (F + v_e)/(2*J*(abs(F - v_e)/J)^(1/2)) + (F + v_s)/(2*J*(abs(F - v_s)/J)^(1/2));
end

