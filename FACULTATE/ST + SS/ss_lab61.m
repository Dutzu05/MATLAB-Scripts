x = randn(1,100);
function [r, lags] = my_autocorr(x)
    M = length(x);
    lags = -(M-1):(M-1);
    r = zeros(size(lags));

    for i = 1:length(lags)
        n = lags(i);
        s = 0;

        for k = 1:M
            if (k-n >= 1) && (k-n <= M)
                s = s + x(k) * x(k-n);
            end
        end

        r(i) = s / M;
    end
end