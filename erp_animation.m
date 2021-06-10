epoch_duration = 0.5; % duration of a single epoch [s]
step = 0.001; % step [s]
fs = 1 / step; % 1 KHz
fcutlow = 0.016; % low-frequency cutoff
fcuthigh = 30; % upper frequency cutoff
time = 0:step:epoch_duration-step; % time vector 

common_erp =    0.2 * rand() * cos(2*pi*6.*time) + ...
                0.2 * rand() * cos(2*pi*10.*time) + ...
                0.2 * rand() * cos(2*pi*0.5.*time);
signal_length = length(time);
epochs = 120; % number of epochs
signal = zeros(epochs, signal_length); % signal matrix

[b, a] = butter(2, [fcutlow, fcuthigh]/(fs/2), 'bandpass');

figure;
subplot(3, 1, 1);
plot(time, common_erp);
title('ERP without EEG noise');
input('start?');

FILTERED_SIGNAL = 1;

for i=1:epochs
    % EEG signal: frequency band limited to 30 Hz
    random_signal = rand(1, signal_length); % random_signal (band of random signal is: fs [HZ])
    if ( FILTERED_SIGNAL == 1)
        signal(i, :) = filter(b, a, random_signal); % random_signal filtered
    else
        signal(i, :) = random_signal; % unfiltered
    end
    signal(i, :) = signal(i, :) + common_erp; % ci sommo il segnale ERP che è in comune tra tutti i segnali
    if ( mod(i, 1) == 0 )
        subplot(3, 1, 2);
        plot(time, signal(i,:));
        title("EEG signal " + i + " of " + epochs);
        
        subplot(3, 1, 3);
        plot(time, sum(signal)/i);
        title("ERP extracted from EEG with average method, epoch " + i + " of " + epochs);
        
        drawnow limitrate;
        delay(50);
    end
end
