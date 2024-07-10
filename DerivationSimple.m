withfunction [dSegment, DSegment, delay] = DerivationSimple(segment, fs)

Nf = 50;     % 2.5 [s] of transient
d = designfilt('differentiatorfir', 'FilterOrder', Nf,...
    'PassbandFrequency', 10, 'StopbandFrequency', 12.5, ...
    'SampleRate', fs);

dt = 1 / fs;
dSegment = dt * filter(d, segment);
DSegment = dt * filter(d, dSegment);

delay = mean(grpdelay(d));

end