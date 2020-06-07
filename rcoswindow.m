function window=rcoswindow(alpha,bit_length)
    warning off;
    window = zeros(1,bit_length/2);
    t = 1:bit_length/2;
    T = bit_length/(2*(1+alpha));
    window(t) = 0.5*(1 - sin(pi/(2*alpha*T)*(t-T)));
    window(1:(1-alpha)*T) = 1;
    window=[fliplr(window) window]';
end