%% Main Stuff
clear all, close all,
addpath('./scripts/');

vid = VideoReader('proj2.avi');
firstFrame = 4635;%i=4635
lastFrame = 4735;%i=5895
a = {};

for i=firstFrame:1:lastFrame
    imgbg = read(vid, i-15);
    imgfr = read(vid, i);
    binaryImage = vessel_detection(imgbg,imgfr);
    %imshow(binaryImage);
    outputBlobs = spatial_validation(binaryImage);
    if(firstFrame~=i)
        [finalBlobs, blobsToShow] = time_validation(outputBlobs,a,i);
    else
        finalBlobs = [];
        blobsToShow = [];
        for j=1:1:length(outputBlobs)
            s = struct('Area',outputBlobs(j).Area,'Centroid',outputBlobs(j).Centroid,'Numb',1,'BoundingBox',outputBlobs(j).BoundingBox);
            finalBlobs = [finalBlobs; s];
            blobsToShow = [blobsToShow, s];
        end;
    end;
    a{i} = finalBlobs;
    disp(i);
%     imshow(imgfr);
%     if(~isempty(blobsToShow))
%         for j=1:length(blobsToShow)
%             rectangle('Position',blobsToShow(j).BoundingBox,'EdgeColor',[1 1 0],'linewidth',2);
%         end;
%     end;
%     drawnow;
end;


%% READ TXT
fid = fopen('movie.txt');

tline = fgetl(fid);
while ischar(tline)
    arrayString = str2num(strsplit(tline));
    Blobs = a{arrayString(1)};
    for i=1:1:length(Blobs)
        diffCentroidX = abs(Blobs(i).Centroid(1)-(arrayString(2)+(arrayString(4)/2)));
        diffCentroidY = abs(Blobs(i).Centroid(2)-(arrayString(3)+(arrayString(5)/2)));
        if(diffCentroidX>=0 || diffCentroidX<=5)
            if(diffCentroidY>=0 || diffCentroidY<=5)
                disp('boas pessoal');
            end;
        end;
            
    end;
    tline = fgetl(fid);
end
fclose(fid);
