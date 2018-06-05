%% Main Stuff
clear all, close all,
addpath('./scripts/');

vid = VideoReader('proj2.avi');
firstFrame = 4635;%i=4635
lastFrame = 5895;%i=5895
a = {};
b = {};

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
    b{i} = blobsToShow;
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
TP = 0;
TN = 0;
while ischar(tline)
    arrayString = strsplit(tline);
    id = str2double(arrayString{1});
    Blobs = b{id};
    
    for i=1:1:length(Blobs)
        if(Blobs(i).BoundingBox(1)<str2double(arrayString{2}))
            if(Blobs(i).BoundingBox(2)<str2double(arrayString{3}))
                if(Blobs(i).BoundingBox(1)+Blobs(i).BoundingBox(3)>str2double(arrayString{2})+str2double(arrayString{4}))
                    if(Blobs(i).BoundingBox(2)+Blobs(i).BoundingBox(4)>str2double(arrayString{3})+str2double(arrayString{5}))
                        TP = TP +1;
                    end;
                end;
            end;
        else
            TN = TN +1;
        end;            
    end;
    tline = fgetl(fid);
end
fclose(fid);
