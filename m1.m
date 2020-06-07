clc
close all
clear
SNR=0:1:20;                 %����ȱ仯��Χ
SNR1=0.5*(10.^(SNR/10));    %�������ת����ֱ������
N=1000000;                  %�������
M1=2;                       %BPSK
M2=4;                       %QPSK
x1=randi([0,1],1,N);         %��������ź�
x2=randi([0,3],1,N);
R=raylrnd(0.5,1,N);         %���������ź�
h1=pskmod(x1,M1);            %BPSK����
h2=pskmod(x2,M2);            %QPSK����
H1=h1.*R;                   %BPSK�������ŵ�
H2=h2.*R;                   %QPSK�������ŵ�
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
% QPSK_t_AWGN=1/2*erfc(sqrt(10.^(SNR/10)/2));   %AWGN�ŵ���QPSK����������
% QPSK_t_Ray= -(1/4)*(1-sqrt(SNR1./(SNR1+1))).^2+(1-sqrt(SNR1./(SNR1+1)));%Rayleigh�ŵ���QPSK����������

%����ͼ��
figure
semilogy(SNR,BPSK_AWGN,'r*');hold on;
semilogy(SNR,QPSK_AWGN,'yo');
semilogy(SNR,BPSK_Ray,':b*');
semilogy(SNR,QPSK_Ray,':go'); grid on;
axis([-1 20 10^-4 1]);
legend('BPSK-AWGN����','QPSK-AWGN����','BPSK-Rayleigh����','QPSK-Rayleigh����');
title('PSK�������ܷ���');
xlabel('����ȣ�dB��');ylabel('BER');