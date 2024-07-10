function X_n = FeatureNormalization(X, mm, featurestbn)

if nargin < 3
    featurestbn = min(size(X)) - 1;     % Assuming the last feature is sex
end

% fs = 35;
% win = 30 * fs;
X_n = X;

for j = 1 : length(mm)
    if j == 1
        first = 1;
        last = mm(j);
    else
        first = sum(mm(1 : j - 1)) + 1;
        last = sum(mm(1 : j));
    end

    X_i = X(first : last, 1 : featurestbn);
    X_n_i = normalize(X_i);
%     X_n_i(:, 36) = X_i(:, 36);
    X_n(first : last, 1 : featurestbn) = X_n_i;
end