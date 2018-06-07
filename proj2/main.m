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
    imshow(imgfr);
    if(~isempty(blobsToShow))
        for j=1:length(blobsToShow)
            rectangle('Position',blobsToShow(j).BoundingBox,'EdgeColor',[1 1 0],'linewidth',2);
        end;
    end;
    drawnow;
end;


%% READ TXT
fid = fopen('movie.gt.txt');

tline = fgetl(fid);
precision = [];
recall = [];
nrLines = [];
id = 0;
while ischar(tline)
    arrayString = strsplit(tline);
    oldid = id;
    if(id~=str2double(arrayString{1})) 
        TP = 0;
    end;
    id = str2double(arrayString{1});
    Blobs = b{id};
    
    for i=1:1:length(Blobs) 
        if(Blobs(i).BoundingBox(1)<str2double(arrayString{2}))
            if(Blobs(i).BoundingBox(2)<str2double(arrayString{3}))
                if(Blobs(i).BoundingBox(1)+Blobs(i).BoundingBox(3)>str2double(arrayString{2})+str2double(arrayString{4}))
                    if(Blobs(i).BoundingBox(2)+Blobs(i).BoundingBox(4)>str2double(arrayString{3})+str2double(arrayString{5}))
                        TP = TP + 1; %True positive
                    end;
                end;
            end;
        end;  
    end;
    
    if(oldid~=str2double(arrayString{1})) 
        precision = [precision; TP];
        nrLines = [nrLines; 1];
    else 
        precision(id-4644) = TP; %true positives + false positives
        nrLines(id-4644) = nrLines(id-4644) + 1; %true positives + false negatives
    end;
    tline = fgetl(fid);
end
totalCases = [];

for i=4645:1:5895
    if(~isempty(b{i}))
        totalCases = [totalCases; length(b{i})];
    else
        totalCases = [totalCases; 0];
    end;
    
end;
array = [];
array1 = [];
TPsum = 0;
totalCasesSum = 0;
nrLinesSum = 0;
for i=1:1:length(totalCases)
    TPsum = TPsum + precision(i);
    totalCasesSum = totalCasesSum + totalCases(i);
    nrLinesSum = nrLinesSum + nrLines(i);
    array = [array; TPsum/totalCasesSum];
    array1 = [array1; TPsum/nrLinesSum]; 
end;
fclose(fid);


%%
figure;

plot(array1,array);
xlabel("Recall")
ylabel("Precision")


