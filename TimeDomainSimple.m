function [Xt] = TimeDomainSimple(raw)

Xt = zeros(1, 9);
fs = 35;

Xt(1) = mode(raw);
Xt(2) = median(raw);
Xt(3) = max(abs(raw));
Xt(4) = sum(abs(raw));     % Line length
Xt(5) = quantile(raw, 0.1);
Xt(6) = quantile(raw, 0.75);

win_svd = 5 * fs;
raw_SVD = zeros(win_svd, 6);

for j = 1 : 6
    raw_SVD(:, j) = raw((j - 1) * win_svd + 1 : j * win_svd);
end

S = svd(raw_SVD);
H = 0;

for jj = 1 : 6
    s_i = S(jj) / sum(S);
    hplus = - s_i * log2(s_i);
    H = H + hplus;
end

Xt(7) = H;

NE = 0;
for j = 2 : length(raw) - 1
    NE = NE + raw(j)^ 2 - raw(j - 1) * raw(j + 1);
end

Xt(8) = NE;
Xt(9) = wentropy(raw, 'shannon'); 