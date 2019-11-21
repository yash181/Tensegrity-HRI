%% FSR Comparison
% Andrew Barkan, 11/3/2019
% --------------------------
% This script will plot all 12 FSR signals over time for an easy visual
% comparison for a given experiment.

% TO RUN: Make sure that this script has access to the data file you want
% to simulate. Change the data_filename and run this script. You should
% also set the custom plot interval (what time span you want to plot). If
% desired, you can highlight specific node signals to make them more clear.

close all
clc

data_filename = 'TEST1A1.CSV';

% Parameters
% Model
true_model = false;

% Custom plot interval
ind = [1, 30];

% Highlight node signals
nodes = [5, 6, 7, 8];

%% Load and process data -------------------

% load data
data_array = table2array(readtable(data_filename));
% process time
data_time = (data_array(:,2)-data_array(1,2))./(1000000);
% FSR data
data_fsr = data_array(:, 3:14);
data_fsr = data_fsr.*(5/1023);    % 5V / digital resolution
% acc data
data_acc = data_array(:, 15:17);

% Find time interval
ind_t_1 = find(abs(data_time - ind(1)) < 0.01);
ind_t_2 = find(abs(data_time - ind(2)) < 0.01);
ind_t = [ind_t_1(1), ind_t_2(1)];

% cypher
cypher = cypher_TEST2();
data_cypher = zeros(numel(data_time), 12);
for i = 1:12
    data_cypher(:, cypher(i)) = data_fsr(:, i);
end
data_fsr = data_cypher;

% convert to actual force via model
if true_model
    for i = 1:12
        data_fsr(:, i) = 42.55.*exp(1.6.*data_fsr(:, i))./1000;
        data_fsr(:, i) = force_divider(data_fsr(:, i));
    end
else
    for i = 1:12
        data_fsr(:, i) = 131.2.*exp(0.7801.*data_fsr(:, i))./1000;
        data_fsr(:, i) = force_divider(data_fsr(:, i));
    end
end


%% Plot fsr signals

f1 = figure('Position', [600, 100, 1200, 600]);
hold on
grid on
ax = gca;
ax.LineStyleOrder = {'-', '--', ':'};
ax.ColorOrder = [235, 52, 52; 25, 156, 53; 25, 34, 156; 255, 130, 20]./256;
title('FSR Signal Comparison', 'FontSize', 20);
set(gca, 'FontSize', 20);
xlabel('Time (s)', 'FontSize', 20);
ylabel('Force (N)', 'FontSize', 20);
xlim(ind);

for i = 1:12
    p = plot(data_time(ind_t(1):ind_t(2)), data_fsr(ind_t(1):ind_t(2), i));
    p.LineWidth = 2;
    if any(i == nodes)
        p.LineWidth = 3;
    end
end

legend({'FSR 1', 'FSR 2', 'FSR 3', 'FSR 4', 'FSR 5', 'FSR 6', 'FSR 7', ...
    'FSR 8', 'FSR 9', 'FSR 10', 'FSR 11', 'FSR 12'}, 'FontSize', 16);

