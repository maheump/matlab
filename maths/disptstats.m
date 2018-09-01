function disptstats( pval, ci, stats )
%DISPTSTATS displays the results of Student t-test(s) (as computed e.g.
%with ttest.m) in the MATLAB command window.
%
%Inputs:
%   - "pval": a 1xN array specifying the p-values.
%   - "ci": a 2xN matrix specifying the confidence intervals.
%   - "stats": a 1xN cell array specifying several metrics from the t-test.
%
%Copyright 2016 Maxime Maheu

% Get the number of tests' results to display
n = numel(pval);

% Define significiance thresholds
lima  = [0.001 0.01 0.05 1];
stars = {'***' '**' '*' 'ns'};

% Display statistical results in the command windo
for i = 1:n
    idx = find(pval(i) < lima, 1, 'first');
    fprintf('- t(%2.0f) = %1.2f%s, [%1.2f,%1.2f], p = %f\n', ...
        stats.df(i), stats.tstat(i), stars{idx}, ci(1,i), ci(2,i), pval(i));
end

end