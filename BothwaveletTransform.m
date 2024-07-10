function [aa, dd] = BothwaveletTransform(signal, wmethod, level)

n = length(signal);
if nargin == 1
    wmethod = 'coif3';
    level = wmaxlev(n, wmethod);
elseif nargin == 2
    level = wmaxlev(n, wmethod);
end

[Lo_D, Hi_D] = wfilters('coif3');
res = n / (2 ^ level);

    if ~isinteger(res)
        rres = ceil(res);
        rlength = rres * (2 ^ level);
        exEDA = zeros(1, rlength);
        exEDA(1 : n) = signal;
        [aa, dd] = swt(exEDA, level, Lo_D, Hi_D);

        aa = aa(:, 1 : n);
        dd = dd(:, 1 : n);
    else
        [aa, dd] = swt(signal, level, wmethod);
    end
