clc
close all
clear
SNR=0:1:20;                 %信噪比变化范围
SNR1=0.5*(10.^(SNR/10));    %将信噪比转化成直角坐标
N=1000000;                  %仿真点数
M1=4;                       %4QAM
M2=8;                       %8QAM
M3=16;                      %16QAM
K=0.5;
x1=randi([0,M1-1],1,N);         %产生随机信号
x2=randi([0,M2-1],1,N);
x3=randi([0,M3-1],1,N);
R=raylrnd(0.5,1,N);         %产生瑞利信号
h1=qammod(x1,M1);            %4QAM调制
h2=qammod(x2,M2);            %8QAM调制
h3=qammod(x3,M3);            %16QAM调制
H1=h1.*R;                   %4QAM经瑞利信道
H2=h2.*R;                   %8QAM经瑞利信道
H3=h3.*R;                   %16QAM经瑞利信道
for i=1:length(SNR)
    yAn1=awgn(h1,SNR(i),'measured'); 
    yA1=qamdemod(yAn1,M1);     
    [bit_A1,~]=biterr(x1,yA1); 
    QAM4_AWGN(i)=bit_A1/N;
    
    yAn2=awgn(h2,SNR(i),'measured'); 
    yA2=qamdemod(yAn2,M2);     
    [bit_A2,~]=biterr(x2,yA2); 
    QAM8_AWGN(i)=bit_A2/N;
    
    yAn3=awgn(h3,SNR(i),'measured'); 
    yA3=qamdemod(yAn3,M3);     
    [bit_A3,~]=biterr(x3,yA3); 
    QAM16_AWGN(i)=bit_A3/N;
    
    yRn1=awgn(H1,SNR(i),'measured');
    yR1=qamdemod(yRn1,M1);     
    [bit_R1,~]=biterr(x1,yR1);
    QAM4_Ray(i)=bit_R1/N; 
    
    yRn2=awgn(H2,SNR(i),'measured');
    yR2=qamdemod(yRn2,M2);     
    [bit_R2,~]=biterr(x2,yR2);
    QAM8_Ray(i)=bit_R2/N; 
    
    yRn3=awgn(H3,SNR(i),'measured');
    yR3=qamdemod(yRn3,M3);     
    [bit_R3,~]=biterr(x3,yR3);
    QAM16_Ray(i)=bit_R3/N; 
    
end
% QPSK_t_AWGN=1/2*erfc(sqrt(10.^(SNR/10)/2));   %AWGN信道下QPSK理论误码率
% QPSK_t_Ray= -(1/4)*(1-sqrt(SNR1./(SNR1+1))).^2+(1-sqrt(SNR1./(SNR1+1)));%Rayleigh信道下QPSK理论误码率

%绘制图形
figure
semilogy(SNR,QAM4_AWGN,'r*');hold on;
semilogy(SNR,QAM8_AWGN,'yo');
semilogy(SNR,QAM16_AWGN,'c+');
semilogy(SNR,QAM4_Ray,':b*');
semilogy(SNR,QAM8_Ray,':go'); 
semilogy(SNR,QAM16_Ray,'m+');

grid on;
axis([-1 20 10^-4 1]);
legend('4QAM-AWGN仿真','8QAM-AWGN仿真','16QAM-AWGN仿真',...
    '4QAM-Rayleigh仿真','8QAM-Rayleigh仿真','16QAM-Rayleigh仿真');
title('PSK误码性能分析');
xlabel('信噪比（dB）');ylabel('BER');
