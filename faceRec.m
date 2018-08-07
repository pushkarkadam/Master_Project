%% Classify training and test set
imds = imageDatastore('Face_Data',...
    'IncludeSubFolders',true,...
    'labelSource','foldernames');

[imdsTrain, imdsValidation] = splitEachLabel(imds,0.7,'randomized');

%% Load Pretrained Network
net = alexnet;


%% Replace final layers
layersTransfer = net.Layers(1:end-3);
numClasses = numel(categories(imdsTrain.Labels));
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

%% Training parameters
options = trainingOptions('sgdm',...
    'MiniBatchSize',10, ...
    'MaxEpochs',10, ...
    'InitialLearnRate',1e-4, ...
    'Verbose',true, ...
    'Shuffle','once');

%% Train network
newNet = trainNetwork(imdsTrain, layers, options);

%% Save trained CNN
save newNet

%% Classify Validation Images

YPred = classify(newNet, imdsValidation);
accuracy = mean(YPred == imdsValidation.Labels)