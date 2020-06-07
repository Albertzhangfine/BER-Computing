clc
close all
clear
SNR=0:1:20;                 %信噪比变化范围
SNR1=0.5*(10.^(SNR/10));    %将信噪比转化成直角坐标
N=1000000;                  %仿真点数
M1=4;                       %QPSK
M2=16;                      %16QAM
K=0.5;
x1=randi([0,M1-1],1,N);         %产生随机信号
x2=randi([0,M2-1],1,N);
R=raylrnd(0.5,1,N);         %瑞利信道
R_rice=sqrt(K/(K+1))+sqrt(1/(K+1))*R;%莱斯信道
h1=pskmod(x1,M1);            %QPSK调制
H1=h1.*R_rice;              %%QPSK经瑞利信道
h2=qammod(x2,M2);            %16QAM调制
H2=h2.*R_rice;              %16QAM经瑞利信道
for i=1:length(SNR)
    
    yRn1=awgn(H1,SNR(i),'measured');
    yR1=pskdemod(yRn1,M1);     
    [bit_R1,~]=biterr(x1,yR1);
    QPSK_Rice(i)=bit_R1/N; 
    
    yRn2=awgn(H2,SNR(i),'measured');
    yR2=qamdemod(yRn2,M2);     
    [bit_R2,~]=biterr(x2,yR2);
    QAM_Rice(i)=bit_R2/N;
end
% QPSK_t_AWGN=1/2*erfc(sqrt(10.^(SNR/10)/2));   %AWGN信道下QPSK理论误码率
% QPSK_t_Ray= -(1/4)*(1-sqrt(SNR1./(SNR1+1))).^2+(1-sqrt(SNR1./(SNR1+1)));%Rayleigh信道下QPSK理论误码率

%绘制图形
figure

figure
semilogy(SNR,QPSK_Rice,':b*');hold on;
semilogy(SNR,QAM_Rice,'yo');
grid on;
% axis([-1 20 10^-4 1]);
legend('QPSK','16QAM');
title('QPSK误码性能分析');
xlabel('信噪比（dB）');ylabel('BER');

