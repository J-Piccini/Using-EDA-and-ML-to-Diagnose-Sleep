close all;
% clear;
clc;
%% 

load 3Mild.mat
fs = 35;
win = 30 * fs;
DL = 4;
mm = zeros(20, 1);
Mild_Sex = Mild.Sex(1 : 20);
mm= zeros(size(Mild_Sex));
XX = [];
Y3 = [];
Y4 = [];
Y5 = [];

for i = 1 : length(SignalCell35)
    fprintf('\n...Signal %d...\n', i)
    EDA = SignalCell35{i};
    events_column = StagesCell{i}.Event;
    detrend_EDA = zeros(size(EDA));
    info_sex = Mild_Sex(i);
    yy3 = 5 * ones(size(events_column));
    yy4 = yy3;
    yy5 = yy3;
    mm(i) = length(events_column);

    for k = 1 : length(events_column)     % Labels creation
        if isequal(events_column(k), {'Wake'})
            yy3(k) = 0;
            yy4(k) = 0;
            yy5(k) = 0;
        elseif isequal(events_column(k), {'N1'})
            yy3(k) = 1;
            yy4(k) = 1;
            yy5(k) = 1;
        elseif isequal(events_column(k), {'N2'})
            yy3(k) = 1;
            yy4(k) = 1;
            yy5(k) = 2;
        elseif isequal(events_column(k), {'N3'})
            yy3(k) = 1;
            yy4(k) = 2;
            yy5(k) = 3;
        elseif isequal(events_column(k), {'REM'})
            yy3(k) = 2;
            yy4(k) = 3;
            yy5(k) = 4;
        end
    end

    if any(yy3 == 5) || any(yy4 == 5) || any(yy5 == 5)
        error('Error in Label Creation')
    end

    Y3 = [Y3; yy3];
    Y4 = [Y4; yy4];
    Y5 = [Y5; yy5];
    %% Signal Pre-Processing

    win_detrend = 5 * fs;
    rres_detr = length(EDA) / win_detrend;
    x_range = 1 : win_detrend;
    x_range = x_range(:);
    XX_detrend = [ones(win_detrend, 1), x_range];
    
    detrend_EDA = detrend(EDA, 2);

    [dEDA_detrend, d2EDA_detrend] = DerivationSimple(detrend_EDA, fs);
    DL = 4;
    [AA, DD] = BothwaveletTransform(EDA, 'db44', DL);
    sgEDA = sgolayfilt(EDA, 7, win + 1);

    [dwa, dwd] = dwt(EDA, 'haar');
    dwd = wthresh(dwd, 's', std(dwd) * sqrt(2 * log(length(dwd))));
    EDAt = idwt(dwa, dwd, 'haar');
    wEDA = EDAt(1 : length(EDA));

    diffEDA = wEDA - sgEDA;     % wEDA accounts for noise, but not high frequencies
    [d_diffEDA, d2_diffEDA, delay] = DerivationSimple(diffEDA, fs);
    
    %     figure;
    %     grid on
    %     hold on
    %     plot(wEDA, 'LineWidth', 1.2)
    %     plot(EDA)

    [~, z, zStorm] = EventStormDetection(EDA);
    rres = length(EDA) / win;
    xx = zeros(rres, 77);
    for j = 1 : rres
        fprintf('\n...Epoch %d out of %d...\n', j, rres)
        % DD_segment contains the window detail coefficients
        curr_window = (j - 1) * win + 1 : j * win;
        if j > 1
            prec_window = (j - 2) * win + 1 : (j - 1) * win;
            diffEDA_prec = diffEDA(prec_window);
        end
        EDA_segment = EDA(curr_window);
        EDA_dnd_segment = detrend_EDA(curr_window);
        diffEDA_segment = diffEDA(curr_window);
        dEDA_dnd_segment = dEDA_detrend(curr_window);
        d2EDA_dnd_segment = d2EDA_detrend(curr_window);
        d_diffEDA_segment = d_diffEDA(curr_window); 
        d2_diffEDA_segment = d2_diffEDA(curr_window);
        z_segment = z(curr_window);
        zStorm_segment = zStorm(curr_window);

        [~, DD_segment] = BothwaveletTransform(EDA_segment, 'haar', DL);

        % Xt = [1 x 18], 2 [1 x 9] vectors
        Xt_raw = TimeDomainSimple(EDA_segment);
        Xt_detrend = TimeDomainSimple(EDA_dnd_segment);
        Xt = [Xt_raw, Xt_detrend];

        % Xd = [1 x 16], 2 [1 x 8] vectors
        Xd_detrend = DerivativeSimple(dEDA_dnd_segment, d2EDA_dnd_segment, j, delay); 
        Xd_filt = DerivativeSimple(d_diffEDA_segment, d2_diffEDA_segment, j, delay);
        Xd = [Xd_detrend, Xd_filt];

        % Xf = [1 x 6], 2 [1 x 3] vectors
        Xf_raw = FrequencyDomainSimple(EDA_segment);
        Xf_detrend = FrequencyDomainSimple(EDA_dnd_segment);
        Xf = [Xf_raw, Xf_detrend];

        % Xw = [1 x 24] features
        Xw = TimeFrequencySimple(DD_segment, DL);

        % Xnl = [1 x 6], 2 [1 x 3] vectors
        Xnl_raw = NonlinearFeaturesSimple(EDA_segment);
        Xnl_detrend = NonlinearFeaturesSimple(EDA_dnd_segment);
        Xnl = [Xnl_raw, Xnl_detrend];

        % Xtds = [1 x 2]
        if j == 1
            Xtds = [0, 0];
        else
            Xtds = [0, 0];
            Xtds(1) = sum(xcorr(diffEDA_prec, diffEDA_segment));
            Xtds(2) = max(conv(diffEDA_prec, diffEDA_segment));
        end

        % Xes = [1 x 4]
        Xes = EventsandStormsSimple(EDA_segment, z_segment, zStorm_segment);

        xx_i = [Xt, Xd, Xf, Xw, Xnl, Xtds, Xes];
        xx(j, :) = [xx_i, info_sex];
    end
    XX = [XX; xx];
end
