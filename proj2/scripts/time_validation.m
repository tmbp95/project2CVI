function [finalBlobs, blobsToShow] = time_validation(outputBlobs,a,frame)
    finalBlobs = [];
    blobsToShow = [];
    for i=1:1:length(outputBlobs)
        [bool, numOcc] = blobs(outputBlobs(i),a,frame);
        s = struct('Area',outputBlobs(i).Area,'Centroid',outputBlobs(i).Centroid,'Numb',numOcc,'BoundingBox',outputBlobs(i).BoundingBox);
        finalBlobs = [finalBlobs; s];
        if(bool)
            blobsToShow = [blobsToShow, s];
            
        end;
    end;
end

function [bool,numOcc] = blobs(actualBlob,a,frame)
    R = 50;
    D = 4635; %diff
    treshD = 0.5;
    %AreaDiff = 10;
    bool = false;
    xC = actualBlob.Centroid(1);
    yC = actualBlob.Centroid(2);
   % areaC = actualBlob.Area;  
    numOcc = 0;
    i = frame-1;
    if(~isempty(a{i}))
        for j=1:1:length(a{i})
            b = a{i};
            xA = b(j).Centroid(1);
            yA = b(j).Centroid(2);
            %areaA = b(j).Area;
            distance = sqrt((xC-xA)^2+(yC-yA)^2);
            if(distance<R)
                numOcc = numOcc + b(j).Numb + 1;
            end;
        end;
    end;

    val = numOcc/(frame-D);
    if(val >= treshD)
        bool = true;
        return;
    end;
end