function  [before,during, after,meanbefore, meanduring, meanafter] = aroundscanning (averageneuralsignal, vs, smoothTime)
vsstart = [];
vsend =[];
window = []; 
for i = 2:length(vs)-1
if vs(i)>0 && vs(i-1)<1
    vsstart  = [vsstart i];
end
if vs(i)>0 && vs(i+1)<1
    vsend  = [vsend i];
end
end
idx = [];
idxend = [];
for i = 1 :length(vsstart) 
   a=  find (smoothTime > vsstart(i));
    idx = [idx a(1)];
end

for i = 1 :length(vsend) 
   a=  find (smoothTime > vsend(i));
    idxend = [idxend a(1)];
end

%allaround = [];
after = [zeros(window+1,length(idx))];
%before = zeros(window+1,length(idx)); 
%during = zeros(20,length(idx));
beforeindecies = [1 2];% [1 3 6] 192 heights%[1 2]heights 205%[1 2 4 5 6 8 10 12 14 15 16 17]%205 shark%[1 2 3 4 5 8 9 10 11 12 13 14]% 192 sharks %[1 3 6]% 192 heights [1 2]205 heights; 
afterindecies = [1 2]; %[2 5 8]192 heights; %[1 2]heights 205%[1 3 4 5 7 9 11 13 14 15 16 17]%205shark%[1 2 3 4 7 8 9 10 11 12 13 14]%[2 5 8]; %192; 
for i = beforeindecies
    if idx(i) < window
    before(window-idx(i)+2:window,i) = averageneuralsignal(idx(i)-(idx(i)-1):idx(i)-1); %-5 normally
    else
  % before(:,i) = averageneuralsignal(idx(i)-window-2:idx(i)-3);%-5 normally
   before(:,i) = averageneuralsignal(idx(i)-3:idx(i)-1);

    %allaround(:,i) = averageneuralsignal(idx(i)-5:idx(i)+5);
    end
end

for i = afterindecies
    if idxend(i)+window > length(averageneuralsignal)
       lengthafter(i) = length (idxend(i): length(averageneuralsignal));
       after(1:lengthafter(i),i)  = averageneuralsignal(idxend(i):length(averageneuralsignal));
    else
    after(:,i) = averageneuralsignal(idxend(i):idxend(i)+window);
    %allaround(:,i) = averageneuralsignal(idx(i)-5:idx(i)+5);
    end
end

after(:, ~any(after,1)) = [];
before(:, ~any(before,1)) = [];
%during1(:, ~any(during1,1)) = [];

for i = beforeindecies
    lengthduring(i) = length (averageneuralsignal(idx(i)-2:idxend(i)));
   % during = averageneuralsignal(idx(beforeindecies(i))-2:idxend(afterindecies(i))+2);
   during(1:lengthduring(i),i) = averageneuralsignal(idx(i)-2:idxend(i));%2 and 3 for heights
   %during1(1:length(during),i) = during; 
end

    %allaround(:,i) = averageneuralsignal(idx(i)-5:idx(i)+5);


during(:, ~any(during,1)) = [];
before (before == 0) = NaN;
during (during ==0) = NaN;
after (after == 0) = NaN;

meanbefore = nanmean(before); 
meanduring = nanmean(during);
meanafter = nanmean(after);


figure; 
plot (before);hold on; plot (mean(before'), '-ko')
title ('before');
%lowerylim = min(min(horzcat(before, after)));
%upperylim = max(max(horzcat(before, after)));
%ylim ([lowerylim upperylim]);
box off
figure;
plot(after); hold on; plot (mean(after'), '-ko')
title ('after')
%ylim ([lowerylim upperylim]);
box off
figure;
plot(during); hold on; plot (mean(during'), '-ko')
title ('during')
%ylim ([lowerylim upperylim]);
box off
%figure; 
%for i = 1:length(before)
%plot ([mean(before(i)) mean(after(i))], '-o'); hold on
% %end
% figure; 
%  for i = 1:12%12%:length(mean21_before)
%   plot ([mean16_before(i) mean16_during(i)], 'ok-');hold on;    
%   end
% box off
% xlim ([0.5 2.5])
% 
% %plot (allaround); hold on; plot(avg);
% 
% mean16_before = nanmean(before_21_shark)

