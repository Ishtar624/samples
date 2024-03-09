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

t1='14 ч 22 мин';
t2 = '15 ч 14 мин';
t3 = '16 ч 11 мин';
t4 = '16 ч 36 мин';
t5 = '14 ч 34 мин';
t6 = '13 ч 00 мин';
t7 = '12 ч 47 мин';
t8 = '11 ч 51 мин';
t9 = '11 ч 11 мин';
t10 = '9 ч 50 мин';

t.XTickLabel = {t1; t2; t3; t4; t5; t6; t7; t8; t9; t10};

figure,plot(1:1:10,Ca_Iris,'r.-',1:1:10,Cb_Iris,'b.-'),...
set(gca,'xticklabel',t.XTickLabel),...   
title({'\fontsize{13}Зависимость концентрации фотосинтетических пигментов';'\fontsize{13}ириса болотного от длины светового дня'}),...
legend('\fontsize{13}Концентрация хлорофилла a, мг/л','\fontsize{13}Концентрация хлорофилла b, мг/л'),grid on,...
xlabel('\fontsize{13}Длина светового дня'),ylabel('\fontsize{13}Концентрация');   
xticklabel_rotate;

saveas(gcf,'plot_Iris.png');


figure,plot(1:1:10,Ca_Pion,'r.-',1:1:10,Cb_Pion,'b.-'),...
set(gca,'xticklabel',t.XTickLabel),...   
title({'\fontsize{13}Зависимость концентрации фотосинтетических пигментов';'\fontsize{13}пиона махрового от длины светового дня'}),...
legend('\fontsize{11}Концентрация хлорофилла a, мг/л','\fontsize{11}Концентрация хлорофилла b, мг/л','location','southeast'),grid on,...
xlabel('\fontsize{13}Длина светового дня'),ylabel('\fontsize{13}Концентрация');   
xticklabel_rotate;

saveas(gcf,'plot_Pion.png');


ts.XTickLabel = {t3; t4; t5; t6; t7; t8; t9; t10};

figure,plot(1:1:8,Ca_Spir,'r.-',1:1:8,Cb_Spir,'b.-'),...
set(gca,'xticklabel',ts.XTickLabel),...   
title({'\fontsize{13}Зависимость концентрации фотосинтетических пигментов';'\fontsize{13}спиреи от длины светового дня'}),...
legend('\fontsize{11}Концентрация хлорофилла a, мг/л','\fontsize{11}Концентрация хлорофилла b, мг/л','location','southeast'),grid on,...
xlabel('\fontsize{13}Длина светового дня'),ylabel('\fontsize{13}Концентрация');   
xticklabel_rotate;

saveas(gcf,'plot_Spir.png');