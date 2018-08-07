function faceStorage(folderName)
    faceDetector = vision.CascadeObjectDetector();
    
    cam = webcam();
    
    runloop = true;
    frameCount = 0;
    
    videoFrame = snapshot(cam);
    frameSize = size(videoFrame);
    
    videoPlayer = vision.VideoPlayer('Position',[100 100 [frameSize(2) frameSize(1)] + 30]);
    
    while runloop && frameCount < 20
       videoFrame = snapshot(cam);
       bboxes = faceDetector.step(videoFrame);
       
       for i = 1:size(bboxes,1)
          tempImage = imcrop(videoFrame, bboxes(i,:));
          
          tempImage = imresize(tempImage, [227 227]);
          
          cd('Face_Data');
          
          mkdir(char(folderName));
          
          cd(char(folderName));
          
          imageName = string(folderName) + '-' + string(frameCount) + ".jpg";
          
          imwrite(tempImage,char(imageName));
          
          cd ..
          cd ..
          videoFrame = insertObjectAnnotation(videoFrame,'rectangle',bboxes, 'face');
       end   
       step(videoPlayer,videoFrame);
       frameCount = frameCount + 1;
    end
    
    clear cam;
    release(videoPlayer);
    release(faceDetector);
end