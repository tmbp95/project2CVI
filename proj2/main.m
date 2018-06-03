%% Main Stuff
clear all, close all,
addpath('./scripts/');

vid = VideoReader('proj2.avi');
firstFrame = 4835;%i=4635
lastFrame = 5000;%i=5895



for i=firstFrame:1:lastFrame
    imgbg = read(vid, i-15);
    imgfr = read(vid, i);
    binaryImage = vessel_detection(imgbg,imgfr);
    %imshow(binaryImage);
    outputBlobs = spatial_validation(binaryImage);
    array(i) = outputBlobs;
    finalBlobs = time_validation(outputBlobs,a,i);
    array(i) = finalBlobs;
    imshow(imgfr);
    if(~isempty(finalBlobs))
        for j=1:length(finalBlobs)
            rectangle('Position',finalBlobs(j).BoundingBox,'EdgeColor',[1 1 0],'linewidth',2);
        end;
    end;
    drawnow;
end;
