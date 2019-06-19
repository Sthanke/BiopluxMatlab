Fnorm = 10/(200/2);           % Normalized frequency
df = designfilt('highpassfir','FilterOrder',70,'CutoffFrequency',Fnorm);

ECG_neu = filtfilt(df, ecgsig);