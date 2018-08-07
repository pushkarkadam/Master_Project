function resizeForAlex(folderName, imageName)
    folderName = "Face_Data/"+folderName;
    cd(char(folderName));
    
    first = imageName;
    
    for i = 1:10
       fileName = first + '-' +i +'.jpg';
       fileName = char(fileName);
       I = imread(fileName);
       I = imresize(I,[227 227]);
       imwrite(I,fileName);
    end
    
    cd ..
    cd ..
end