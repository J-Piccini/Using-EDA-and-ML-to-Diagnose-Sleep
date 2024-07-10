function [Xes] = EventsandStormsSimple(raw, z, zStorm)

fs = 35;
Xes = zeros(1, 4);

n_events = length(find(z));
Xes(1) = n_events / (30 * fs);

if n_events ~= 0
    indices_events = find(z);
    raw_events = raw(indices_events);
    energy_events = norm(raw_events, 2);
    Xes(2) = energy_events / n_events;
end

n_storms = length(find(zStorm));
Xes(3) = n_storms / (30 * fs);

if n_storms ~= 0
    indices_storms = find(zStorm);
    raw_storms = raw(indices_storms);
    energy_storms = norm(raw_storms, 2);
    Xes(4) = energy_storms / n_storms;
end