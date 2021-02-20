clc;
close all;
clear all;
%% Creating a datastore for my images

folder_name = fullfile(pwd, 'data', 'full', 'data');
labels = cellstr(repmat('F', 1052, 1));
imds = imageDatastore(folder_name,'Labels', categorical(labels));
preprocessed_imds = imds;
preprocessed_imds = transform(preprocessed_imds, @(x) gray_as_rgb(x));
%%
net = resnet18;
inputSize = net.Layers(1).InputSize;
%%
% analyzeNetwork(net);
%%
% augimds = augmentedImageDatastore(inputSize(1:2), preprocessed_imds);
preprocessed_imds = transform(preprocessed_imds, @(x) imresize(x, [224, 224]));
%%

layer = 'pool5';
features = activations(net,preprocessed_imds,layer,'OutputAs',"channels");
features = double(features);


%%
% features_mean = mean(features, [1, 2]);
% features_mean = reshape(features_mean, 128, 1052)';
choosen_features = reshape(features, 512, 1052);
%%

[coeff,~,~,~,explained,~] = pca(choosen_features');
explained;
num_features = 20;
sum(explained(1:num_features))
A = coeff(:, 1:num_features);

features_reduced = A' * choosen_features;

%%
% idx = kmeans(features_reduced', 2) - 1
% gm = fitgmdist(features_reduced', 2);
% idx = cluster(gm,features_reduced') - 1;
% idx = (dbscan(features_reduced,110000,5) + 1) / 2
sum(idx)
%%
close all;
for i  = 1:10
    rand_index = randi(length(idx));
    img = readimage(imds, rand_index);
    figure
    imshow(img)
    title(idx(rand_index))
    set(gcf,'Visible','on')
end