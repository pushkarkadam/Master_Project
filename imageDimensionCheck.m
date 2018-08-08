function imageDimensionCheck(train_image,val_image)
    
    [m_train, n_train] = size(train_image.Labels);
    [m_val, n_val] = size(val_image.Labels);
    for i = 1:m_train
        I_train = train_image.readimage(i);
        [x,y,z] = size(I_train);
        assert(x == 227 && y == 227,'Image not of same dimension');
    end
    
    for i = 1:m_val
        I_val = val_image.readimage(i);
        [x,y,z] = size(I_val);
        assert(x == 227 && y == 227,'Image not of same dimension');
    end
end