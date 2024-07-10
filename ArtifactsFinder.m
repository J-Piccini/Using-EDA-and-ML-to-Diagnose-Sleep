function [proximity, index, proximityPlot] = ArtifactsFinder(signal, fs)

% if fs > 10
%     signal = resample(signal, 10, fs);
%     fs = 10;
% end

[swa, swd] = BothwaveletTransform(signal, 'coif3', 5);
s3 = swd(3, :);

% s3_threshold = 5e-4;     % s3_threshold = Amax
s3_threshold = std(s3) * sqrt(2 * log(length(s3)));
f_a3 = find(abs(s3) > s3_threshold);
aa3 = zeros(length(signal), 1);
for i = 1 : length(f_a3)
    id = f_a3(i);
    aa3(id) = 1;
end

proximity = aa3;
for i = 1 : length(f_a3) - 1
    first = f_a3(i);
    last = f_a3(i + 1);

    if last - first <= fs
        proximity(first : last) = ones(last - first + 1, 1);
    end
end

index = find(proximity);
proximityPlot = zeros(1, length(signal));
for i = 1 : length(index)
    proximityPlot(index) = signal(index);
end