basedir = 'data/imgnet_webcam_1ex';
matfiles = {'fc6.mat', 'fc7.mat', 'fc8.mat'};

a_dist = [1.279, 1.233, 1.160];

means = zeros(length(matfiles), 1);
errs = zeros(length(matfiles), 1);

for i = 1:length(matfiles)
  data = load(fullfile(basedir, matfiles{i}));
  accs = data.accuracies.daume;
  means(i) = mean(accs);
  errs(i) = 1.96 * std(accs) / sqrt(length(accs));
end

X = 1:3;

figure;
p1 = errorbar(X, means, errs, 'Color', 'r', 'LineWidth', 3);
haxes1 = gca;
set(haxes1, 'YColor', 'r', 'XColor', 'k', 'XTick', X, 'XTickLabel', {'FC6', 'FC7', 'FC8'});
ylabel('DFE Multiclass Accuracy', 'FontSize', 20);
xlabel('Feature Representation', 'FontSize', 20);
xlim([0.5, 3.5]);
set(gca, 'FontSize', 18);
haxes1_pos = get(haxes1, 'Position');
haxes1_pos(3) = haxes1_pos(3) - 0.08;
set(haxes1, 'Position', haxes1_pos);

haxes2 = axes('Position', haxes1_pos, ...
              'YAxisLocation', 'right', ...
              'XAxisLocation', 'top', ...
              'XTick', X, ...
              'XTickLabel', [], ...
              'YColor', 'b', ...
              'Color', 'none');
ylabel('Imagenet-Webcam A-Distance', 'FontSize', 20);
linkaxes([haxes1, haxes2], 'x');
hold on;
p2 = plot(X, a_dist, 'Parent', haxes2, 'LineWidth', 3);

%legend([p1, p2], 'test1', 'test2', 'Location', 'NorthWest');
%legend boxoff;
set(gca, 'FontSize', 18);
