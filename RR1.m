load mit200

[~,locs_Rwave] = findpeaks(ecgsig,'MinPeakHeight',0.27,...
                                    'MinPeakDistance',200);

figure
plot(tm,ecgsig)
hold on
plot(tm(locs_Rwave),ecgsig(locs_Rwave),'ro')
xlabel('Seconds')
ylabel('Amplitude')
title('Subject - MIT-BIH 200')