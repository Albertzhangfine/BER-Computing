clc
close all
clear
SNR=0:1:20;                 %信噪比变化范围
SNR1=0.5*(10.^(SNR/10));    %将信噪比转化成直角坐标
N=1000000;                  %仿真点数
M1=2;                       %BPSK
M2=4;                       %QPSK
x1=randi([0,1],1,N);         %产生随机信号
x2=randi([0,3],1,N);
R=raylrnd(0.5,1,N);         %产生瑞利信号
h1=pskmod(x1,M1);            %BPSK调制
h2=pskmod(x2,M2);            %QPSK调制
H1=h1.*R;                   %BPSK经瑞利信道
H2=h2.*R;                   %QPSK经瑞利信道
for i=1:length(SNR)
    yAn1=awgn(h1,SNR(i),'measured'); 
    yA1=pskdemod(yAn1,M1);     
    [bit_A1,~]=biterr(x1,yA1); 
    BPSK_AWGN(i)=bit_A1/N;
    
    yAn2=awgn(h2,SNR(i),'measured'); 
    yA2=pskdemod(yAn2,M2);     
    [bit_A2,~]=biterr(x2,yA2); 
    QPSK_AWGN(i)=bit_A2/N;
    
    yRn1=awgn(H1,SNR(i),'measured');
    yR1=pskdemod(yRn1,M1);     
    [bit_R1,~]=biterr(x1,yR1);
    BPSK_Ray(i)=bit_R1/N; 
    
    yRn2=awgn(H2,SNR(i),'measured');
    yR2=pskdemod(yRn2,M2);     
    [bit_R2,~]=biterr(x2,yR2);
    QPSK_Ray(i)=bit_R2/N; 
    
end
% QPSK_t_AWGN=1/2*erfc(sqrt(10.^(SNR/10)/2));   %AWGN信道下QPSK理论误码率
% QPSK_t_Ray= -(1/4)*(1-sqrt(SNR1./(SNR1+1))).^2+(1-sqrt(SNR1./(SNR1+1)));%Rayleigh信道下QPSK理论误码率

%绘制图形
figure
semilogy(SNR,BPSK_AWGN,'r*');hold on;
semilogy(SNR,QPSK_AWGN,'yo');
semilogy(SNR,BPSK_Ray,':b*');
semilogy(SNR,QPSK_Ray,':go'); grid on;
axis([-1 20 10^-4 1]);
legend('BPSK-AWGN仿真','QPSK-AWGN仿真','BPSK-Rayleigh仿真','QPSK-Rayleigh仿真');
title('PSK误码性能分析');
xlabel('信噪比（dB）');ylabel('BER');