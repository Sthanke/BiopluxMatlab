clear all;

load mit200


figure(1)
plot(tm,ecgsig)
hold on
plot(tm(ann),ecgsig(ann),'ro')
xlabel('Seconds')
ylabel('Amplitude')
title('Subject - MIT-BIH 200')



wt = modwt(ecgsig,5);
wtrec = zeros(size(wt));
wtrec(4:5,:) = wt(4:5,:);
y = imodwt(wtrec,'sym4');

y = abs(y).^2;
[qrspeaks,locs] = findpeaks(y,tm,'MinPeakHeight',0.35,...
    'MinPeakDistance',0.150);


figure(2)
plot(tm,y)
hold on
plot(locs,qrspeaks,'ro')
xlabel('Seconds')
ylabel('Amplitude')
title('Subject - MIT-BIH 200')

figure(3)
plot(tm,ecgsig)
hold on
plot(locs,qrspeaks,'ro')
xlabel('Seconds')
ylabel('Amplitude')
title('Subject - MIT-BIH 200')