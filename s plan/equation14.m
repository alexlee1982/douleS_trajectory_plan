function [ value ] = equation14(  v_s, v_e ,F ,D_max ,A_max ,J ,S )
%UNTITLED2 使用牛顿拉夫逊迭代法计算方程式14的解
% 该函数为方程的正解，即正向求等式的值
%   方程式为 ： 
%  ( F + v_s )*sqrt((F - v_s)/J) + (F + v_e)*sqrt((F - v_e)/J) - S
%   
% 其中F为待求解变量
% v_s  v_e J A_max S 为已知常量

value = ( F + v_s )*sqrt(abs(F - v_s)/J) + (F + v_e)*sqrt(abs(F - v_e)/J) - S;
end

