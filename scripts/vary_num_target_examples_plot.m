data = load('vary_num_target_examples_webcam.mat');

%% gfk statistics
gfk_pts = [0];
gfk_mean = [mean(data.gfk)];
gfk_err = [1.96 * std(data.gfk) / sqrt(length(data.gfk))];

%% svm_t statistics
num_pts = length(data.svm_t);
svm_t_pts = (1:num_pts) * 31;
svm_t_mean = zeros(1, num_pts);
svm_t_err = zeros(1, num_pts);
for i = 1:num_pts
  svm_t_mean(i) = mean(data.svm_t{i});
  svm_t_err(i) = 1.96 * std(data.svm_t{i}) / length(data.svm_t{i});
end

%% daume statistics
num_pts = length(data.daume);
daume_pts = (1:num_pts) * 31;
daume_mean = zeros(1, num_pts);
daume_err = zeros(1, num_pts);
for i = 1:num_pts
  daume_mean(i) = mean(data.daume{i});
  daume_err(i) = 1.96 * std(data.daume{i}) / length(data.daume{i});
end

%% svm_s statistics (ha)
svm_s_x = [1, 8] * 31;
svm_s_y = [55.6, 55.6];

figure; grid on;
hold on;
%errorbar(gfk_pts, gfk_mean, gfk_err, 'LineWidth', 3);
plot(svm_s_x, svm_s_y, 'm--', 'LineWidth', 3);
errorbar(svm_t_pts, svm_t_mean, svm_t_err, 'b', 'LineWidth', 3);
errorbar(daume_pts, daume_mean, daume_err, 'r', 'LineWidth', 3);
axes = gca;
set(axes, 'XTick', svm_t_pts);
xlabel('Number of Labeled Target Examples', 'FontSize', 20);
xlim([0.5, 8.5] * 31);
ylabel('Multiclass Accuracy', 'FontSize', 20);
legend('source only', 'target only', 'DFE', 'Location', 'NorthWest');
legend BOXOFF
set(gca, 'FontSize', 18);
