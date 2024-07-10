function Xw = TimeFrequencySimple(detail_coefficients, DL)

fpl = 6;     % Number of features per level
Xw = zeros(1, DL * fpl);
Xw_k = zeros(1, fpl);
for k = 1 : DL
    Xw_k(1) = max(detail_coefficients(k, :));
    Xw_k(2) = mean(detail_coefficients(k, :));
    Xw_k(3) = std(detail_coefficients(k, :));
    Xw_k(4) = median(detail_coefficients(k, :));
    Xw_k(5) = norm(detail_coefficients(k, :), 2);
    Xw_k(6) = sum(detail_coefficients(k, :) > 0) / length(detail_coefficients);     % Normalization
    Xw((k - 1) * fpl + 1 : k * fpl) = Xw_k;
end
