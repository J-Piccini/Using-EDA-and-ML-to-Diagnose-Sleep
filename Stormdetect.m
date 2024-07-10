function storm = Stormdetect(z, fs, signal)
  
zChanges = find(diff(z) ~= 0);
zN = 0.5 * length(zChanges);

zStart = zeros(1, length(zChanges));
zFinal = zStart;
zDuration = zStart;
for i =  1 : zN
    zStart(i) = zChanges(2 * (i - 1) + 1);
    zFinal(i) = zChanges(2 * i);
    zDuration(i) = zFinal(i) - zStart(i);
end

%%
id = 1;
minocc = 2 * 1.5 * fs;
if signal == 1     % Automatic score
    id = 1;
    minocc = 2 * (4 * fs);
end
minute = 60 * fs; % 60 * fs;

storm = zeros(1, length(z));

rres = round(length(z) / minute);

loop = true;
i = 1;
while loop
    if i == 1
        start_i = zStart(i);
    else
        start_i = final_i + 1;
    end
    final_i = start_i + minute;
    if final_i > length(z)
        return;
    end
    current = start_i : final_i;
    zc = z(current);
    dz = diff(zc);
    if length(find(dz == 1)) >= 2 || length(nonzeros(zc)) >= minocc
        storm(current) = ones(1, length(current));
    end
    v = find(final_i < zStart);
    if ~isempty(v)
        i = v(1);
    else
        loop = false;
    end
end

end