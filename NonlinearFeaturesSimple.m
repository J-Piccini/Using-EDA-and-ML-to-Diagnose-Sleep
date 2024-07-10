function [Xnl] = NonlinearFeaturesSimple(segment)

Xnl = zeros(1, 3);

Xnl(1)= lyapunovExponent(segment, 35);
[up, low] = envelope(segment);
Xnl(2) = max(up);
Xnl(3) = min(low);
