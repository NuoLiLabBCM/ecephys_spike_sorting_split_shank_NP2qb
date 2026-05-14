
function driftmap(ksdir) 
    addpath(genpath('C:\BCM_pipeline\SpikeSorting_Kilosort_Lilab_server\PreProcessing\setups\spikes-master'))
    % probably dont need to add npy-matlab to path. Should have been added for SpikeGLX pipeline anyway.
    addpath(genpath('C:\BCM_pipeline\SpikeSorting_Kilosort_Lilab_server\PreProcessing\setups\npy-matlab-master')) 
    % Plotting a driftmap
    [spikeTimes, spikeAmps, spikeDepths, spikeSites] = ksDriftmap(ksdir);
    f = figure('visible', 'off','units','normalized','outerposition',[0 0 1 1]); 
    plotDriftmap(spikeTimes, spikeAmps, spikeDepths);
    %saving driftmap as PNG in ksdir
    saveas(f, strcat(ksdir, '\driftmap_plot.png'))
end