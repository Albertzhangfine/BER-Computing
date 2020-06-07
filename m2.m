clc
close all
clear
SNR=0:1:20;                 %����ȱ仯��Χ
SNR1=0.5*(10.^(SNR/10));    %�������ת����ֱ������
N=1000000;                  %�������
M1=4;                       %QPSK
M2=16;                      %16QAM
K=0.5;
x1=randi([0,M1-1],1,N);         %��������ź�
x2=randi([0,M2-1],1,N);
R=raylrnd(0.5,1,N);         %�����ŵ�
R_rice=sqrt(K/(K+1))+sqrt(1/(K+1))*R;%��˹�ŵ�
h1=pskmod(x1,M1);            %QPSK����
H1=h1.*R_rice;              %%QPSK�������ŵ�
h2=qammod(x2,M2);            %16QAM����
H2=h2.*R_rice;              %16QAM�������ŵ�
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
% QPSK_t_AWGN=1/2*erfc(sqrt(10.^(SNR/10)/2));   %AWGN�ŵ���QPSK����������
% QPSK_t_Ray= -(1/4)*(1-sqrt(SNR1./(SNR1+1))).^2+(1-sqrt(SNR1./(SNR1+1)));%Rayleigh�ŵ���QPSK����������

%����ͼ��
figure

figure
semilogy(SNR,QPSK_Rice,':b*');hold on;
semilogy(SNR,QAM_Rice,'yo');
grid on;
% axis([-1 20 10^-4 1]);
legend('QPSK','16QAM');
title('QPSK�������ܷ���');
xlabel('����ȣ�dB��');ylabel('BER');

