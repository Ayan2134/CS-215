im1 = double(imread('T1.jpg'));
im2 = double(imread('T2.jpg'));
t = -10:10;
bin_width = 10;
corr_org = zeros(1, length(t));
qmi_org = zeros(1, length(t));
dimension = floor(256/bin_width) + 1;

for idx = 1:length(t)
    tx = t(idx);
    shifted_im2 = imtranslate(im2, [tx, 0]);
    joint_histogram = zeros(dimension, dimension);
    x = floor(double(im1) / bin_width) + 1;
    y = floor(double(shifted_im2) / bin_width) + 1;
    x(x < 1) = 1;
    x(x > size(joint_histogram, 1)) = size(joint_histogram, 1);
    y(y < 1) = 1;
    y(y > size(joint_histogram, 2)) = size(joint_histogram, 2);
    joint_histogram = accumarray([x(:), y(:)], 1, [size(joint_histogram, 1), size(joint_histogram, 2)]);
    m1 = sum(joint_histogram, 2);
    m2 = sum(joint_histogram, 1);
    joint_histogram = joint_histogram / sum(joint_histogram(:));
    m1 = m1 / sum(m1(:));
    m2 = m2 / sum(m2(:));
    mean_m1 = m1 - mean(m1);
    mean_m2 = m2 - mean(m2);
    corr_matrix = corrcoef(im1, shifted_im2);
    disp(corr_matrix);
    corr_org(idx) = corr_matrix(1, 2);
    qmi_org(idx) =  sum(sum((joint_histogram - (m1 * m2)).^2));
end

im2_inverted = 255 - im1;
corr_inv = zeros(1, length(t));
qmi_inv = zeros(1, length(t));
for idx = 1:length(t)
    tx = t(idx);
    shifted_im2 = imtranslate(im2_inverted, [tx, 0]);
    joint_histogram = zeros(dimension,dimension);
    for i = 1:size(im1, 1)
        for j = 1:size(im1, 2)
            x = floor(double(im1(i, j)) / bin_width) + 1;
            y = floor(double(shifted_im2(i, j)) / bin_width) + 1;
            joint_histogram(x, y) = joint_histogram(x, y) + 1;
        end
    end
    m1 = sum(joint_histogram, 2);
    m2 = sum(joint_histogram, 1);    
    joint_histogram = joint_histogram / sum(joint_histogram(:));
    m1 = m1 / sum(m1());
    m2 = m2 / sum(m2());    
    mean_m1 = m1 - mean(m1);
    mean_m2 = m2 - mean(m2);    
    corr_matrix = corrcoef(im1, shifted_im2);
    display(corr_matrix);
    corr_inv(idx) = corr_matrix(1, 2);
    qmi_inv(idx) =  sum(sum((joint_histogram - (m1 * m2)).^2));
end

figure(1);
subplot(2,1,1);
plot(t, corr_org);
xlabel('tx');
ylabel('ρ');
title('Original : Correlation Coefficient vs. Shift');
subplot(2,1,2);
plot(t, qmi_org);
xlabel('tx');
ylabel('QMI');
title('Original : QMI vs. Shift');

figure(2);
subplot(2,1,1);
plot(t, corr_inv);
xlabel('tx');
ylabel('ρ');
title('Inverted : Correlation Coefficient vs. Shift');
subplot(2,1,2);
plot(t, qmi_inv);
xlabel('tx');
ylabel('QMI');
title('Inverted : QMI vs. Shift (Inverted)');