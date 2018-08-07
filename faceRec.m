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

%% Train Network
options = trainingOptions('sgdm',...
    'MiniBatchSize',10, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',1e-4, ...
    'Verbose',true, ...
    'Shuffle','once');

faceNet = trainNetwork(imdsTrain, layers, options);

%% Save trained CNN
save faceNet

%% Classify Validation Images

YPred = classify(faceNet, imdsValidation);
accuracy = mean(YPred == imdsValidation.Labels)