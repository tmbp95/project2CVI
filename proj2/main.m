%% Main Stuff
clear all, close all,
addpath('./scripts/');

vid = VideoReader('proj2.avi');
firstFrame = 5000;
lastFrame = 5010;
imgbk = read(vid, firstFrame);

%i=4635:step:5895

for i=firstFrame:1:5010
    imgfr = read(vid, i);
    
    blocks = vessel_detection(imgbk,imgfr);
    
end;