function [z, zPlot] = MLEDAdetect(maxframe, fs, start, stop, filteredEDA, maxamp, minamp, art_tol)

win = maxframe * fs;
z = zeros(1, length(filteredEDA));
df = 0.25;
a = (0.25 / df) + 1;
b = (3 / df) + 1;
c = (5/ df);
eventcounter_alg = 0;
i = start;
zPlot = zeros(1, length(filteredEDA));
while i <= stop - win
    i = i + 1;
    if i >= length(filteredEDA)
        break;
    end
    current = i : i + win - 1;
    y = fft(filteredEDA(current)) * 2 / win;
    P = abs(y);
    %     P(1) = 0;
    if(all(P(a : b) < maxamp) && any(P(a : b) > minamp))
        if(all(P(b : c) < art_tol))
            z(current) = ones(1, win);
            zPlot(current) = filteredEDA(current);
            eventcounter_alg = eventcounter_alg + 1;
            i = i + win - 1;
        else
            if(i > 4 * fs)
                z(i - 4 * fs : i) = zeros(1, 4 * fs + 1);
                i = i + 4 * fs;
            else
                z(1 : i) = zeros(1, i);
                i = i + 4 * fs;

            end
        end
    end

end
end