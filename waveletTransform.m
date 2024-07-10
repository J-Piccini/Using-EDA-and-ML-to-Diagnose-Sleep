function swc = waveletTransform(signal, wmethod, level)

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
        swc = swt(exEDA, level, Lo_D, Hi_D);

        swc = swc(:, 1 : n);
    else
        swc = swt(signal, level, wmethod);
    end
