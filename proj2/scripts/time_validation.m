function finalBlobs = time_validation(outputBlobs,a,frame)
    finalBlobs = [];
    for i=1:1:length(outputBlobs)
        if(blobs(outputBlobs(i),a,frame))
            finalBlobs = [finalBlobs; outputBlobs(i)];
        end;
    end;
end

function bool = blobs(actualBlob,a,frame)
    R = 10;
    D = 5; %diff
    treshD = 3;
    AreaDiff = 10;
    bool = false;
    xC = actualBlob.Centroid(1);
    yC = actualBlob.Centroid(2);
    areaC = actualBlob.Area;  
    numOcc = 0;
    for i=frame-D:1:frame-1
        if(~isempty(a{i}))
            for j=1:1:length(a{i})
                b = a{i};
                xA = b(j).Centroid(1);
                yA = b(j).Centroid(2);
                areaA = b(j).Area;
                distance = sqrt((xC-xA)^2+(yC-yA)^2);
                if(distance<R)
                    numOcc = numOcc + 1;
                end;
            end;
        end;
    end;
    if(numOcc >= treshD)
        bool = true;
        return;
    end;
end