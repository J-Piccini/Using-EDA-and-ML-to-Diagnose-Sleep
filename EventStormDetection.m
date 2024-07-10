function [fEDA, z, zStorm] = EventStormDetection(EDA)

%% Parameters Setting

fs = 35;          % [Hz]
n = length(EDA);  % [-]
timewindow = 4;   % [s]
Amin = 5e-05;     % From literature
Atol = 1e-03;
Amax = 5e-04;     % From visual inspection, may be changed
%% Signal Pre-Processing

[dwa, dwd] = dwt(EDA, 'haar');
dwd = wthresh(dwd, 'h', std(dwd) * sqrt(2 * log(length(dwd))));
EDAt = idwt(dwa, dwd, 'haar');
iEDA = EDAt(1 : length(EDA));

fEDA = bandpass(iEDA, [0.25, 10], fs);
%% Artifacts Detection

swc = waveletTransform(EDA, 'coif3', 4);
ss = swc(3, :);
aa = wthresh(ss, 'h', Amax);

aindex = find(aa);
artifacts_vector = zeros(1, length(ss));
[~, index] = ArtifactsFinder(EDA, fs);
%%

[z, zPlot] = MLEDAdetect(timewindow, fs, 1, n, fEDA, Amax, Amin, Atol);
for i = 1 : length(aindex)
    id = aindex(i);
    artifacts_vector(id) = 1;
    z(id) = 0;
end

window = 10 * fs;
j = 1;
while j < length(index)
    jj = index(j);
    if jj <= window
        z(1 : jj + window) = zeros(jj + window, 1);
        zPlot(1 : jj + window) = zeros(jj + window, 1);
    elseif jj + window > length(ss)
        z(length(ss) - window : length(ss)) = zeros(window + 1, 1);
        zPlot(length(ss) - window : length(ss)) = zeros(window + 1, 1);
        break;
    else
        z(jj - window : jj + window) = zeros(2 * window + 1, 1);
        zPlot(jj - window : jj + window) = zeros(2 * window + 1, 1);
    end
    j = j + 1;
end
%% Storm Detection

zStorm = Stormdetect(z, fs, 1);
%% Plot Update

zPlot(zPlot == 0) = nan;