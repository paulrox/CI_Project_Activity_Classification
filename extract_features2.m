function [ret] = extract_features2(  sensor, SampleRate )

for i = 1: 1: 3
    for j = 1: 1: 3
        for k = 1: 1: (20*2^i)
             
            y = sensor{i, j}(:, k);
           
            y = y - mean(y);
            
            FFT_Signal = fft(y);
            
            sumA = sum(FFT_Signal);
           
          
            [P,f] = periodogram(y,[],[], SampleRate,'power');
            [~,lc] = findpeaks(P,'SortStr','descend');
            numPeaks = length(lc); % Freq. feature 3, number of peaks
            
            
            % Feat1: Sum of amplitude spectrum components
            temp{1}{i, j}(1, k) = sumA;
            
            % Feat2: Max freq amplitude componentd
            %temp{2}{i, j}(1, k) = maxFreq;
            
            % Feat3: Number of Peaks Power Spectrum
            temp{3}{i, j}(1, k) = numPeaks;
            
            % Feat4: Bandwidth Signal
            temp{4}{i, j}(1, k) = obw(y, SampleRate);
            
            % Feat5: Average distance power peak frequency
            [P, f] = periodogram(y,[],[],SampleRate,'power');
            [~, lc] = findpeaks(P);
            temp{5}{i, j}(1, k) = mean(diff(f(lc)));
            
            % Feat6: Ratio of the largest absolute value in the signal  to 
            %        the root-mean-square (RMS) value of the signal.
            temp{6}{i, j}(1, k) = peak2rms(y);
            
            % Feat7: The difference between the maximum and minimum values 
            %        in the signal.
            temp{7}{i, j}(1, k) = peak2peak(y);
            
            % Feat8: Mean of the signal
            temp{8}{i, j}(1, k) = mean(y);
            
            % Feat9: std of the signal
            temp{9}{i, j}(1, k) = std(y);
            
            % Feat 10 and Feat 11: They are the mean of the upper and lower
            % envelopes of the signal
            [yh,yl] = envelope(y);
            temp{10}{i, j}(1, k) = mean(yh);
            temp{11}{i, j}(1, k) = mean(yl);
            
            
            % Feat13: Average power of the signal
            temp{13}{i, j}(1, k) = bandpower(y);
            
            
            %compute percentiles
            p25 = prctile(max(y), 25);
            p75 = prctile(max(y), 75);
            
            mag = y;
            
            %compute squared sum of data below certain percentile (25, 75)
            sumsq25 = sum(mag(mag < p25) .^ 2);
            sumsq75 = sum(mag(mag < p75) .^ 2);
            
            % Feat 14: Sum amplitude signal below 25%
            temp{14}{i, j}(1, k) = sumsq25;
            
            % Feat 15: Sum amplitude signal below 75%
            temp{15}{i, j}(1, k) = sumsq75;
            
           % temp{16}{i, j}(1, k) = mean(findchangepts(mag, 'Statistic','rms','MaxNumChanges', 5));
            
            [P, f] = pwelch(y);
            [~, lc] = findpeaks(P);
            
            % Feat 16: Average frequency peaks for the power density signal
            temp{16}{i, j}(1, k) = mean(diff((lc)));
            
            [~,lc] = findpeaks(P,'SortStr','descend', 'NPeaks',3);
            
            % Feat 17: Average frequency of the 3 peaks with more amplitude
            %          for the power density signal
            temp{17}{i, j}(1, k) = mean(f(lc));
            
            % Feat 18: Sum amplitude power density
            temp{18}{i, j}(1, k) = sum(P);
            
            % Feat 19: the root-sum-of-squares of the signal
            temp{19}{i, j}(1, k) = rssq(y);
        end
    end
end

ret = temp;

end
