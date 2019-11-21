%% Data Visualization Script
% Andrew Barkan, 10/14/2019
% --------------------------
% This script can be used to create a force sensor heat map that is useful
% for visualizing the spatial and temporal distribution of forces in the
% structure of the spherical force-sensing tensegrity structure

% TO RUN: Make sure that this script has access to the data file you want
% to simulate. Change the data_filename and run this script. You can also
% create a video. Leave the other parameters unless you know what you are
% doing!

close all
clc

data_filename = 'TEST1A1.CSV';

% Parameters
normalize_in_fsr = false;
subtract_bias = false;
true_model = false;

create_video = false;
video_name = 'fsr_id';

% sim speed scaling
speed = 1;
framerate = 120;
video_speed = 1;

%% Loading and processing data --------------------------
% load data
data_array = table2array(readtable(data_filename));
% process time
data_time = (data_array(:,2)-data_array(1,2))./(1000000);
% FSR data
data_fsr = data_array(:, 3:14);
data_fsr = data_fsr.*(5/1023);    % 5V / digital resolution
% acc data
data_acc = data_array(:, 15:17);

% cypher (depending on how the sensors are connected to the adapter, there
% might be multiple ways to associate sensors to the structure, thus we
% need a cypher to figure out which is which. NEED TO IMPROVE)
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

% subtract bias (TO TEMPORARILY REMOVE SOME BIAS FOR DISPLAY)
if subtract_bias
    for i = 1:12
        data_fsr(:, i) = data_fsr(:, i) - min(data_fsr(:, i));
    end
end

% normalize (TO TEMPORARILY REMOVE SOME BIAS FOR DISPLAY)
if normalize_in_fsr
    for i = 1:12
        data_fsr(:, i) = data_fsr(:, i)./(max(data_fsr(:, i)));
    end
end

data_fsr_color = zeros(12, 3, numel(data_time));
% for i = 1:12
%     data_hold = vals2colormap(data_fsr(:, i), 'jet');
%     for j = 1:numel(data_time)
%         data_fsr_color(i, :, j) = reshape(data_hold(j, :), [1, 3]);
%     end
% end

data_fsr_unwrap = data_fsr(:);
data_hold = vals2colormap(data_fsr_unwrap, 'jet');
for i = 1:12
    for j = 1:numel(data_time)
        data_fsr_color(i, :, j) = reshape(data_hold(j+(i-1)*(numel(data_time)), :), [1, 3]);
    end
end

%% Create visualization ----------------------------------------

% size ratio
%g_ratio = (sqrt(5)-1)/2;    % golden ratio
g_ratio = 0.5;

vertices_X = [1, -1, 1, -1, 0, 0, 0, 0, g_ratio, g_ratio, -g_ratio, -g_ratio];
vertices_Y = [0, 0, 0, 0, -g_ratio, -g_ratio, g_ratio, g_ratio, -1, 1, -1, 1];
vertices_Z = [-g_ratio, -g_ratio, g_ratio, g_ratio, 1, -1, 1, -1, 0, 0, 0, 0];
vertices = [vertices_X', vertices_Y', vertices_Z'];

% % full icosahedron
faces = [1, 3, 9; 1, 3, 10; 1, 6, 8; 1, 6, 9; 1, 8, 10; 2, 4, 11;
    2, 4, 12; 2, 6, 8; 2, 6, 11; 2, 8, 12; 3, 5, 7; 3, 5, 9; 3, 7, 10;
    4, 5, 7; 4, 5, 11; 4, 7, 12; 5, 9, 11; 6, 9, 11; 7, 10, 12;
    8, 10, 12];
% 6-bar faces
% faces = [3, 9, 10; 1, 9, 10; 1, 2, 8; 1, 6, 9; 1, 8, 10; 2, 11, 12;
%     4, 11, 12; 1, 2, 6; 2, 6, 11; 2, 8, 12; 3, 4, 7; 3, 5, 9; 3, 7, 10;
%     3, 4, 5; 4, 5, 11; 4, 7, 12; 5, 6, 9; 5, 6, 11; 7, 8, 10;
%     7, 8, 12];


f1 = figure('Position', [1000, 100, 1200, 1000]);
hold on

% draw nodes
plot3(vertices(:, 1), vertices(:, 2), vertices(:, 3), '.y', ...
    'MarkerSize', 30)

% draw initial grav acc vector
% scale = 1.2;
% data_max = max(data_acc(1, :));
% quiver3(0, 0, 0, data_acc(1, 1)*scale/data_max,...
%     data_acc(1, 2)*scale/data_max, data_acc(1, 3)*scale/data_max,...
%     'LineWidth', 2, 'Color', 'red');

% draw labels
for i = 1:12
    node_label = num2str(i);
    text_pos = 1.4.*vertices(i, :)./norm(vertices(i, :));
    text(text_pos(1), text_pos(2), text_pos(3), node_label, ...
        'FontSize', 20, 'color', 'k');
end

% draw members
line(vertices(1:2, 1), vertices(1:2, 2), vertices(1:2, 3),...
    'LineWidth', 4, 'Color', 'black')
line(vertices(3:4, 1), vertices(3:4, 2), vertices(3:4, 3),...
    'LineWidth', 4, 'Color', 'black')
line(vertices(5:6, 1), vertices(5:6, 2), vertices(5:6, 3),...
    'LineWidth', 4, 'Color', 'black')
line(vertices(7:8, 1), vertices(7:8, 2), vertices(7:8, 3),...
    'LineWidth', 4, 'Color', 'black')
line(vertices(9:10, 1), vertices(9:10, 2), vertices(9:10, 3),...
    'LineWidth', 4, 'Color', 'black')
line(vertices(11:12, 1), vertices(11:12, 2), vertices(11:12, 3),...
    'LineWidth', 4, 'Color', 'black')

grid on
axis vis3d equal
set(gca, 'Position', [.25, .20, .6, .6]);
set(gca, 'FontSize', 20);
xlim([-1.5, 1.5])
ylim([-1.5, 1.5])
zlim([-1.5, 1.5])
% plot info
title('Force Sensor Heat Map', 'FontSize', 20)
xlabel('X', 'FontSize', 20)
ylabel('Y', 'FontSize', 20)
zlabel('Z', 'FontSize', 20)
view(135, 20);
colormap('jet')
cb = colorbar;
caxis([0, max(max(data_fsr))])
cb_title = get(cb, 'Title');
set(cb_title, 'String', 'Force (N)', 'FontSize', 20);
set(cb, 'FontSize', 20);

% record video
if create_video
    plot_video = VideoWriter(video_name, 'MPEG-4');
    plot_video.FrameRate = framerate;
    open(plot_video);
end
set(gca,'nextplot','replacechildren');
set(gcf,'Renderer','zbuffer');

% print and draw
drawn = false;
printed = false;

% Simulation
p1 = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'interp',...
    'FaceVertexCData', data_fsr_color(:, :, 1));
for i = 1:speed:numel(data_fsr_color(1, 1, :))
    %patch('Vertices', vertices, 'Faces', faces, 'FaceVertexCData', fake_fsr_color(:, :, i),...
    p1.FaceVertexCData = data_fsr_color(:, :, i);
    p1.FaceVertexAlphaData = data_fsr(i, :)';
    p1.FaceAlpha = 'interp';
    % Plot in real time
    if (mod(data_time(i), 0.001)) < 0.0001 && ~drawn
        drawn = true;
        drawnow
    else
        drawn = false;
    end
    
    if create_video && ((mod(data_time(i), video_speed/framerate)) < 0.001)
        curr_frame = getframe(gcf);
        writeVideo(plot_video,curr_frame);
    end
    
    % Print progress
    if mod(data_time(i), 1) < 0.001 && ~printed
        printed = true;
        fprintf('Progress: %3.2f sec / %3.2f sec \n', data_time(i), data_time(end));
    elseif i == numel(data_time)
        disp('Done!')
    else
        printed = false;
    end
end

if create_video
    close(plot_video);
end
