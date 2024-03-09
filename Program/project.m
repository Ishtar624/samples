clear all
close all
T=xlsread('input.xlsx');
[row,column]=size(T);

Ca(1:2,1)=13.7.*T(1:2,3)-5.76.*T(1:2,4);
Ca(3:row,1)=(13.7.*T(3:row,3)-5.76.*T(3:row,4)).*4;

Cb(1:2,1)=25.8.*T(1:2,4)-7.6.*T(1:2,3);
Cb(3:row,1)=(25.8.*T(3:row,4)-7.6.*T(3:row,3)).*4;

Ccar(1:2,1)=(1000.*T(1:2,5)-3.27.*Ca(1:2,1)-100.*Cb(1:2,1))./229;
Ccar(3:row,1)=((1000.*T(3:row,5)-3.27.*Ca(3:row,1)-100.*Cb(3:row,1))./229).*4;

T_new=[T Ca Cb Ccar];

Ca_Iris=[Ca(1,1); Ca(3,1); Ca(5:3:row,1)];
Cb_Iris=[Cb(1,1); Cb(3,1); Cb(5:3:row,1)];

Ca_Pion=[Ca(2,1); Ca(4,1); Ca(6:3:row,1)];
Cb_Pion=[Cb(2,1); Cb(4,1); Cb(6:3:row,1)];

Ca_Spir=[Ca(7:3:row,1)];
Cb_Spir=[Cb(7:3:row,1)];

xlswrite('output.xlsx',T_new)

t1='14 � 22 ���';
t2 = '15 � 14 ���';
t3 = '16 � 11 ���';
t4 = '16 � 36 ���';
t5 = '14 � 34 ���';
t6 = '13 � 00 ���';
t7 = '12 � 47 ���';
t8 = '11 � 51 ���';
t9 = '11 � 11 ���';
t10 = '9 � 50 ���';

t.XTickLabel = {t1; t2; t3; t4; t5; t6; t7; t8; t9; t10};

figure,plot(1:1:10,Ca_Iris,'r.-',1:1:10,Cb_Iris,'b.-'),...
set(gca,'xticklabel',t.XTickLabel),...   
title({'\fontsize{13}����������� ������������ ����������������� ���������';'\fontsize{13}����� ��������� �� ����� ��������� ���'}),...
legend('\fontsize{13}������������ ���������� a, ��/�','\fontsize{13}������������ ���������� b, ��/�'),grid on,...
xlabel('\fontsize{13}����� ��������� ���'),ylabel('\fontsize{13}������������');   
xticklabel_rotate;

saveas(gcf,'plot_Iris.png');


figure,plot(1:1:10,Ca_Pion,'r.-',1:1:10,Cb_Pion,'b.-'),...
set(gca,'xticklabel',t.XTickLabel),...   
title({'\fontsize{13}����������� ������������ ����������������� ���������';'\fontsize{13}����� ��������� �� ����� ��������� ���'}),...
legend('\fontsize{11}������������ ���������� a, ��/�','\fontsize{11}������������ ���������� b, ��/�','location','southeast'),grid on,...
xlabel('\fontsize{13}����� ��������� ���'),ylabel('\fontsize{13}������������');   
xticklabel_rotate;

saveas(gcf,'plot_Pion.png');


ts.XTickLabel = {t3; t4; t5; t6; t7; t8; t9; t10};

figure,plot(1:1:8,Ca_Spir,'r.-',1:1:8,Cb_Spir,'b.-'),...
set(gca,'xticklabel',ts.XTickLabel),...   
title({'\fontsize{13}����������� ������������ ����������������� ���������';'\fontsize{13}������ �� ����� ��������� ���'}),...
legend('\fontsize{11}������������ ���������� a, ��/�','\fontsize{11}������������ ���������� b, ��/�','location','southeast'),grid on,...
xlabel('\fontsize{13}����� ��������� ���'),ylabel('\fontsize{13}������������');   
xticklabel_rotate;

saveas(gcf,'plot_Spir.png');