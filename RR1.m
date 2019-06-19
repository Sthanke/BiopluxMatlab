load mit200

[~,locs_Rwave] = findpeaks(ecgsig,'MinPeakHeight',0.27,...
                                    'MinPeakDistance',200);

Fnorm = 10/(200/2);           % Normalized frequency
df = designfilt('highpassfir','FilterOrder',70,'CutoffFrequency',Fnorm);

ECG_neu = filtfilt(df, ecgsig);                               
                                
figure (1)
plot(tm,ecgsig)
hold on
plot(tm(locs_Rwave),ecgsig(locs_Rwave),'ro')
xlabel('Seconds')
ylabel('Amplitude')
title('Subject - MIT-BIH 200')


figure(2)
plot(tm, ECG_neu)
