function [Xd] = DerivativeSimple(dSegment, d2Segment, index, delay)

if index == 1
    dSegment(1 : 2 * delay) = [];
    d2Segment(1 : 4 * delay) = [];
end

Xd = zeros(1, 8);
Xd(1) = mean(dSegment);
Xd(2) = var(dSegment);
Xd(3) = median(dSegment);

Xd(5) = mean(d2Segment);
Xd(6) = var(d2Segment);
Xd(7) = median(d2Segment);

dSign = sign(dSegment);
a = find(dSign == 0);
dfSign = diff(dSign);
if isempty(a)
    Xd(4) = sum(find(abs(dfSign) == 2));
else
    Xd(4) = sum(find(abs(dfSign) == 2)) + a;
end

d2Sign = sign(d2Segment);
a2 = find(d2Sign == 0);
df2Sign = diff(d2Sign);
if isempty(a2)
    Xd(8) = sum(find(abs(df2Sign) == 2));
else
    Xd(8) = sum(find(abs(df2Sign) == 2)) + a2;
end
