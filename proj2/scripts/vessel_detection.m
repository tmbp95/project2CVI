%imgbk -> standard image
%imgfr -> actual frame image
function blocks = vessel_detection(imgbk,imgfr)
    
    imgdif = (abs(double(imgbk(:,:,1))-double(imgfr(:,:,1)))>thr) | ...
             (abs(double(imgbk(:,:,2))-double(imgfr(:,:,2)))>thr) | ...
             (abs(double(imgbk(:,:,3))-double(imgfr(:,:,3)))>thr);

end