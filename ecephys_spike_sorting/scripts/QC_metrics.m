function tb =  QC_metrics(ksdir, onset, offset)
%% load data
spk_time = readNPY([ksdir, '\spike_times_sec_adj.npy']); %give full abs path
cluster = readNPY([ksdir, '\spike_clusters.npy']);
tb = readtable([ksdir, '\metrics.csv']);
%% find firing time, fr per trial, qc metric
for i = 1 : size(tb,1)
    cluster_id = tb.cluster_id(i);
    tb.spk_time{i} = spk_time(cluster == cluster_id);
    fr_per_trial = nan(length(onset.trial),1);
    for j = 1 : length(onset.trial)
        temp = cell2mat(tb.spk_time(i));
        trial_range = [onset.intan_trig(j) offset.intan_trig(j)];
        fr_per_trial(j) = sum(temp>=trial_range(1) & temp< trial_range(2)) / (trial_range(2)-trial_range(1));
    end
    tb.fr_per_trial{i} = fr_per_trial;
    tb.avg_fr_per_trial(i) = mean(fr_per_trial);
    movingMeanSpikeRate = movmean(fr_per_trial,6);
    spikeRate = downsample(movingMeanSpikeRate,6);
    poissDistr = poisscdf(spikeRate,tb.avg_fr_per_trial(i));
    tb.drift(i) = length(find(poissDistr > 0.95 | poissDistr < 0.05)) / length(poissDistr);
end
end