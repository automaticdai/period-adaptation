% prediction_bias_estimation
% Output: df_max_min, bias_min
% Description:
%   Estimate the bias based on the following criteria
%   a) ecdf(pi_1) is bounded by ecdf(pi_2)
%   b) the statistical distance is minimized

function [bias_min, df_max_min] = prediction_bias_estimation(pi_afbs, pi_mc_uni)

bias_min = inf;
df_max_min = inf;

BIAS_RANGE = max(abs(max(pi_afbs) - max(pi_mc_uni)), abs(min(pi_afbs) - min(pi_mc_uni))) * 1.5;

% find the best bias
for bias = -BIAS_RANGE:2 * BIAS_RANGE / 20:BIAS_RANGE
    [f1, x1] = ecdf(pi_afbs);
    [f2, x2] = ecdf(pi_mc_uni + bias);

    x_min = min([x1;x2]);
    x_max = max([x1;x2]);

    xx = [];
    df = [];
    
    for x = x_min:0.0001:x_max  
        f_d = ecdf_eval(f1, x1, x) - ecdf_eval(f2, x2, x);
        xx = [xx;x];
        df = [df;f_d];
    end
    
    if (max(abs(df)) < df_max_min && min(df) >= 0)
        df_max_min = max(abs(df));
        bias_min = bias;
    end
    
%     subplot(2,1,1)
%     plot(xx, df);
%     title('bias \beta v.s. d_n')
%     hold on;
%     
%     subplot(2,1,2)
%     scatter(bias, max(abs(df)), 'bx');
%     scatter(bias, min(df), 'gx');
%     title('bias \beta v.s. max(d_n) and min(d_n)')
%     hold on;
end

% didn't find a feasible bias
if (bias_min == inf)
    bias_min = 0;
end

end
