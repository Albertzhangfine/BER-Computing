function [error_rate_sig,error_rate_mut]=ofdm_awgn(SNR,M,bit_length,bit_moded,bit_sequence)

carrier_count = 200; % 子载波数
symbol_count = 100;
ifft_length = 512;
CP_length = 128;
CS_length = 20;
alpha = 1.5/32;
carrier_position = 29:228;
conj_position = 485:-1:286;
%% IFFT
% 串并转换
ifft_position = zeros(ifft_length,symbol_count);
bit_moded = reshape(bit_moded,carrier_count,symbol_count);
% figure('position',[400 0 400 400],'menubar','none');
% stem(abs(bit_moded(:,1)));
% grid on;
ifft_position(carrier_position,:)=bit_moded(:,:);
ifft_position(conj_position,:)=conj(bit_moded(:,:));
signal_time = ifft(ifft_position,ifft_length);

% 加循环前缀和后缀
signal_time_C = [signal_time(end-CP_length+1:end,:);signal_time];
signal_time_C = [signal_time_C; signal_time_C(1:CS_length,:)];

% 加窗
signal_window = zeros(size(signal_time_C));
% 通过矩阵点乘
signal_window = signal_time_C.*repmat(rcoswindow(alpha,size(signal_time_C,1)),1,symbol_count);

%% 发送信号，多径信道
signal_Tx = reshape(signal_window,1,[]); % 变成时域一个完整信号，待传输
signal_origin = reshape(signal_time_C,1,[]); % 未加窗完整信号
mult_path_am = [1 0.2 0.1]; %  多径幅度
mutt_path_time = [0 20 50]; % 多径时延
windowed_Tx = zeros(size(signal_Tx));
path2 = 0.2*[zeros(1,20) signal_Tx(1:end-20) ];
path3 = 0.1*[zeros(1,50) signal_Tx(1:end-50) ];
signal_Tx_mult = signal_Tx + path2 + path3; % 多径信号

% %% 加瑞利信道
% n1=length(signal_Tx_mult);
% R=raylrnd(0.5,1,n1);         %瑞利信道
% signal_Tx=signal_Tx.*signal_Tx;
% signal_Tx_mult=signal_Tx_mult.*signal_Tx_mult;
%% 加AWGN
signal_power_sig = var(signal_Tx); % 单径发送信号功率
signal_power_mut = var(signal_Tx_mult); % 多径发送信号功率
SNR_linear = 10^(SNR/10);
noise_power_mut = signal_power_mut/SNR_linear;
noise_power_sig = signal_power_sig/SNR_linear;
noise_sig = randn(size(signal_Tx))*sqrt(noise_power_sig);
noise_mut = randn(size(signal_Tx_mult))*sqrt(noise_power_mut);
% noise_sig=0;
% noise_mut=0;
Rx_data_sig = signal_Tx+noise_sig;
Rx_data_mut = signal_Tx_mult+noise_mut;
%% 串并转换
Rx_data_mut = reshape(Rx_data_mut,ifft_length+CS_length+CP_length,[]);
Rx_data_sig = reshape(Rx_data_sig,ifft_length+CS_length+CP_length,[]);
%% 去循环前缀和后缀
Rx_data_sig(1:CP_length,:) = [];
Rx_data_sig(end-CS_length+1:end,:) = [];
Rx_data_mut(1:CP_length,:) = [];
Rx_data_mut(end-CS_length+1:end,:) = [];
%% FFT
fft_sig = fft(Rx_data_sig);
fft_mut = fft(Rx_data_mut);
%% 降采样
data_sig = fft_sig(carrier_position,:);
data_mut = fft_mut(carrier_position,:);

%% 逆映射
bit_demod_sig = reshape(qamdemod(data_sig,M,'OutputType','bit'),[],1);
bit_demod_mut = reshape(qamdemod(data_mut,M,'OutputType','bit'),[],1);
%% 误码率
error_bit_sig = sum(bit_demod_sig~=bit_sequence);
error_bit_mut = sum(bit_demod_mut~=bit_sequence);
error_rate_sig = error_bit_sig/bit_length;
error_rate_mut = error_bit_mut/bit_length;





end