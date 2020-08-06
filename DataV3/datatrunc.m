
%import data: change file name as needed
data = csvread('test51.csv');
export = 0; 
index = [1:length(data)];
data(:,1) = index;
data = data(:,:);  %change the indices as needed
%currently doing 1000 datasteps



%gather data into individual variables
index = data(:,1);
time = data(:,2);
fsr1 = data(:,3);
fsr2 = data(:,4);
fsr3 = data(:,5);
fsr4 = data(:,6);
fsr5 = data(:,7);
fsr6 = data(:,8);
fsr7 = data(:,9);
fsr8 = data(:,10);
fsr9 = data(:,11);
fsr10 = data(:,12);
fsr11 = data(:,13);
fsr12 = data(:,14);
acc_x = data(:,15);
acc_y = data(:,16);
acc_z = data(:,17);

%plot fsr data
subplot(2,1,1)
hold on;
plot(index, fsr1);
plot(index, fsr2);
plot(index, fsr3);
plot(index, fsr4);
plot(index, fsr5);
plot(index, fsr6);
plot(index, fsr7);
plot(index, fsr8);
plot(index, fsr9);
plot(index, fsr10);
plot(index, fsr11);
plot(index, fsr12);
legend('FSR1', 'FSR2', 'FSR3', 'FSR4', 'FSR5', 'FSR6', 'FSR7', 'FSR8', 'FSR9', 'FSR10', 'FSR11', 'FSR12');
hold off;

subplot(2,1,2);
hold on;
plot(index, acc_x);
plot(index, acc_y);
plot(index, acc_z);
legend('x', 'y', 'z');
hold off;

%decide whether to export the truncated data or not 
if export == 1
    writematrix(data, 'nothing15.csv');
end


