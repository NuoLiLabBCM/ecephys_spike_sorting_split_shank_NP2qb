function compute_drift(nidq_path, binName, ksdir, XA_channels, save_path)            
    [onset, offset] = extractEventTimeFromNeuropixel_lite(binName, nidq_path, XA_channels, save_path); % runbo defined function, make sure located in the same folder as this m file
    tb = QC_metrics(ksdir, onset, offset); % runbo defined runction, make sure located in the same folder as this m file
    tb.spk_time = [];
    tb.avg_fr_per_trial = [];
    tb.fr_per_trial = [];
    writetable(tb, [ksdir, '\metrics.csv']);
end   

