function finalBlobs = time_validation(outputBlobs,a,frame)
    finalBlobs = [];
    for i=1:1:length(outputBlobs)
        if(blobs(outputBlobs(i),a,frame))
            finalBlobs = [finalBlobs; outputBlobs(i)];
        end;
    end;
end

function bool = blobs(actualBlob,a,frame)
    R = 50;
    AreaDiff = 10;
    bool = false;
    xC = actualBlob.Centroid(1);
    yC = actualBlob.Centroid(2);
    areaC = actualBlob.Area;
    for i=frame-10:1:frame
        if(~isempty(a{i}))
            for j=1:1:length(a{i})
                b = a{i};
                xA = b(j).Centroid(1);
                yA = b(j).Centroid(2);
                areaA = b(j).Area;
                distance = num2str(sqrt((xC-xA)^2+(yC-yA)^2));
                if(distance<R)
                    bool = true;
                    return;
                end;
            end;
        end;
    end;
end