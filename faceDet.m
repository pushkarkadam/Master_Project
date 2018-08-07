faceDetector = vision.CascadeObjectDetector();

load newNet;

pause(3)
cam = webcam();

runloop = true;
maxTime = 100;
frameCount = 0;
name = 'unknown';

 
videoFrame = snapshot(cam);
frameSize = size(videoFrame);

videoPlayer = vision.VideoPlayer('Position',[100 100 [frameSize(2) frameSize(1)] + 30]);

while runloop && frameCount < 50
    frameCount = frameCount + 1;
    videoFrame = snapshot(cam);
    bboxes = faceDetector.step(videoFrame);
    
    if frameCount > 1 && ~isempty(bboxes)
        for i = 1:size(bboxes,1)
            tempImage = imcrop(videoFrame,bboxes(i,:));

            tempImage = imresize(tempImage, [227 227]);

            name = classify(newNet, tempImage);

            name = char(name);
            
            videoFrame = insertObjectAnnotation(videoFrame,'rectangle', bboxes(i,:), name);
        end
    end
    
    if (frameCount == 1)
        videoFrame = insertObjectAnnotation(videoFrame,'rectangle', bboxes, name);
    end

    step(videoPlayer,videoFrame);
end

clear cam;
release(videoPlayer);
release(faceDetector);