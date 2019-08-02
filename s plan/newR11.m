syms v_s v_e J A_max D_max S F
value = ( F + v_e )/2 * ( D_max/J + ( F - v_e )/D_max ) + ( F + v_s )*sqrt(( F - v_s )/J) - S;
dot = diff(value,F)


% v_s = 0;
% v_e = 3;
% F =10;
% D_max =100;
% A_max = 100;
% J = 1000;
% S = 10;
% F0 = 10;
% for i = 1:1:10
%     v0 =  equation11(v_s, v_e ,F0 ,D_max ,A_max ,J ,S);
%     dot0 = dotEquation11(v_s, v_e ,F0 ,D_max ,A_max ,J ,S);
%     F1 = F0 - v0/dot0;
%     v1 = equation11(v_s, v_e ,F1 ,D_max ,A_max ,J ,S);
%     
%     if abs(F1 - F0) < 0.001|| abs(F1) < 0.001
%         disp('½áÊøµü´ú')
%         F1
%         break;
%     end
%     F0 = F1;
% end
% 
