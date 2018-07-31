function faceDetection(minutes)
    faceDetector = vision.CascadeObjectDetector();

    %% Webcam integration
    cam = webcam();
    videoFrame = snapshot(cam);
    frameSize = size(videoFrame);
    videoPlayer = vision.VideoPlayer('Position',[100 100 [frameSize(2),frameSize(1)]+30]);

    runLoop = true;
    frameCount = 0;
    userTime = minutes * 60;
    timeCount = userTime;
    maxTime = 24*60*60;

    %% Entering the image directory
    cd('images')   
    %%
    tic; % Starts the timer
    while runLoop && timeCount < maxTime
       videoFrame = snapshot(cam);
       frameCount = frameCount + 1;
       fprintf("Frame Count: " + frameCount + "\n");

       bboxes = faceDetector.step(videoFrame);

       videoFrame = insertObjectAnnotation(videoFrame,'rectangle',bboxes, 'Face');

       step(videoPlayer,videoFrame);

       runLoop = isOpen(videoPlayer);

       %% Cropping the face detected in the image
       stopTime = uint16(toc);  % Calculating the time
       % Condition checks if the time since the program started has elapsed
       % as per the user defined time
       if(stopTime >= timeCount)
            %--------------------------------------
            % Creating a directory based upon time
            %--------------------------------------
            c = clock;
            % Clock creates an array of
            % [Year Month Date Hour Minute Seconds]
            %
            folderName = "" + c(1)+"-"+c(2)+"-"+c(3)+"-"+c(4)+"-"+c(5);
            folderName = char(folderName);

            mkdir(folderName);

            cd(folderName);
            %-----------------------------------------------
            % Cropping the images identified by bounding box
            %-----------------------------------------------
            for i = 1:size(bboxes,1)
               tempImage = imcrop(videoFrame, bboxes(i,:));
               figure(i+1);
               imshow(tempImage);
               fileName = "Image_" +frameCount + "_" + i + ".jpg";
               fileName = char(fileName); % Converts the string to character array
               imwrite(tempImage,fileName);
               faceCount = i;
            end
            frameName = "Frame_"+frameCount + ".jpg";
            frameName = char(frameName);
            imwrite(videoFrame,frameName);
            
            fprintf("\nFace Count at time: " + stopTime + " is " + faceCount + "\n")
            fprintf("\nFolder: " + folderName + " Created.\n")
            timeCount = timeCount + userTime;
            cd ..
       end
       fprintf("\nTime Elapsed: " + stopTime + "\n");
    end
    %%
    clear cam;
    release(videoPlayer);
    release(faceDetector);
    cd ..
end