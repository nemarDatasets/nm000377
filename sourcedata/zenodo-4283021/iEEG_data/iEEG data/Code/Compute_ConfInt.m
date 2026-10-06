function CI = Compute_ConfInt(x)


SEM = std(x)/sqrt(length(x));               % Standard Error
% ts = tinv([0.025  0.975],length(x)-1);      % T-Score
ts = tinv([0.005  0.995],length(x)-1);      % T-Score

CI = mean(x) + ts*SEM; 