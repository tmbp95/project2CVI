function outputBlobs = spatial_validation(binaryImage)
    Amax = 10000;
    outputBlobs = [];
    
    %confirms that blob doesn't touch image boundary
    dilatedImg = imdilate(binaryImage,strel('disk',6));
    dilatedImg = imclose(dilatedImg, strel('disk',6));
    
    %imshow(dilatedImg);
    
    [lb, num]=bwlabel(dilatedImg);
    Blob = regionprops(lb,'area','FilledImage','Centroid','BoundingBox','Eccentricity');
    
    for i=1:1:num
        if(Blob(i).Area < Amax)
            if(distanceObject(i,Blob,num))
                outputBlobs = [outputBlobs, Blob(i)];
            end;
        end;
    end;
end

function distanceBool = distanceObject(i,Blob,num)
    R = 30;
    distanceBool = true;
    for x=1:1:num
        if(i~=x)
            x1 = Blob(i).Centroid(1);
            x2 = Blob(x).Centroid(1);
            y1 = Blob(i).Centroid(2);
            y2 = Blob(x).Centroid(2);
            distance = num2str(sqrt((x2-x1)^2+(y2-y1)^2));
            if (distance<R)
                distanceBool = false;
                return;
            end
        end;
    end;
end