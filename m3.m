clc
close all
clear
%%
SNR=0:1:25;                 %信噪比变化范围
carrier_count=200;          % 子载波数
symbol_count=100;
bit_per_symbol=4;           %调制方式决定
M=2^bit_per_symbol;         %16QAM
%% 产生随机序列
N=carrier_count*symbol_count*bit_per_symbol;
x=round(rand(1,N))';
%% 子载波调制方式
% 1-28置零 29-228有效 229-285置零 286-485共轭 486-512置零
carrier_position=29:228;
conj_position=485:-1:286;
h=qammod(x,M,'InputType','bit');
%%
for i=1:length(SNR)
    [QAM_sig_AWGN(i),QAM_mut_AWGN(i)]=ofdm_awgn(SNR(i),M,N,h,x);
    [QAM_sig_Ray(i),QAM_mut_Ray(i)]=ofdm_ray(SNR(i),M,N,h,x);
end


%% 绘制图形

figure
semilogy(SNR,QAM_sig_AWGN,'r*');hold on;
semilogy(SNR,QAM_mut_AWGN,'yo');
semilogy(SNR,QAM_sig_Ray,':b*');
semilogy(SNR,QAM_mut_Ray,':go'); grid on;
axis([-1 20 10^-4 1]);
legend('16QAM-AWGN-单径','16QAM-AWGN-多径','16QAM-Rayleigh-单径','16QAM-Rayleigh-多径');
title('OFDM/16QAM误码性能分析');
xlabel('信噪比（dB）');ylabel('BER');

