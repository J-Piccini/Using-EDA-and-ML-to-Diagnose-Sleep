function Xf = FrequencyDomainSimple(segment)

[pxx, f] = periodogram(segment);
Xf = zeros(1, 3);
[Xf(1), id] = max(pxx);       % Xf(1) = max periodogram value
Xf(2) = f(id);                % Max frequency of interest
Xf(3) = Xf(1) / sum(pxx);     % Fisher's g
