values = [1, 2, 3, 4, 5];
probabilities = [0.05, 0.4, 0.15, 0.3, 0.1];
sample_size = [5, 10, 20, 50, 100, 200, 500, 1000, 5000, 10000];
emp_size = 10000;
m = 5;
n = 2;
MAD = zeros(1,length(sample_size));
figure(1);
figure(2);
for i = 1:length(sample_size) 
    average = zeros(1,emp_size);
    for k = 1:emp_size
        rand_index = rand(1,sample_size(i));
        result = discretize(rand_index, [0, cumsum(probabilities)]);
        rand_values = values(result);
        avg = mean(rand_values);
        average(k) = avg;
    end
    %figure;
    figure(1);  
    subplot(m, n, i);
    histogram(average,50); 
    title(['Sample Size is ', num2str(sample_size(i))]);
    
    [emperical_value, data_value] = ecdf(average);

    average_data = mean(average);
    std_dev = std(average);
    gaussian = normcdf(data_value, average_data, std_dev);
    max_diff = 0;
    for j=1:length(data_value)
        diff = abs(gaussian(j) - emperical_value(j));
        if diff > max_diff
            max_diff = diff;
        end
    end
    MAD(i) = max_diff;
    %figure;
    figure(2);
    subplot(m,n,i);
    plot(data_value,emperical_value,'DisplayName','cdf');
    title(['Sample size is' , num2str(sample_size(i))]);
    xlabel('')
    grid on;
    hold on;
    plot(data_value,gaussian,'DisplayName','gaussian');
    legend('location','best');
    hold off;
end
figure;
plot(sample_size,MAD);
grid on;
legend('location','best');
