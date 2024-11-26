function [score, TPR, TNR] = f1_score_test(label, predict)
   M = confusionmat(label, predict);
   TPR = M(2,2) / (M(2,1) + M(2,2)); 
   % SE: TP/(TP+FN)
   TNR = M(1,1) / (M(1,1) + M(1,2)); 
   % SP: TN/(TN+FP)
   M = M';
   precision = diag(M)./(sum(M,2) + 0.0001);  
   % TP/(TP+FP)
   recall = diag(M)./(sum(M,1)+0.0001)'; 
   % TP/(TP+FN)
   precision = mean(precision);
   recall = mean(recall);
   score = 2*precision*recall/(precision + recall);
end