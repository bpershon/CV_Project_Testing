%Test bigbrother project
%Brad Pershon 
%Mohit Deshpande
%Dataset link: http://www.cvg.reading.ac.uk/PETS2016/SequencesOnBoardCameras/10_03/VideoSummary10_03.html

raw = VideoReader('summaryVid3.wmv');
%cmain -> c1
H1 = [0.310247171737401,0.659801593368095,-192.876952614640;0.132675981763542,-0.0724721592502843,2.54830184588473;0.00125068278093395,-0.00137031263770412,0.0440755459842476];
%cmain -> c2
H2 = [-1.21184334320667,-1.83837321143885,486.605124736204;-0.0765435921432201,0.0641083731302545,34.4520075302423;-0.00486718838016336,0.00159820148036998,0.406562762163586];

%Video vars
raw.Currenttime = 58;
splitY = 240;
splitX1 = 320;
splitX2 = 960;

%Mean-shift vars
p1 = [490 143];
bins = 16;
h = 25;
r = 6; %8 min for X1 1 run build
is_start = 1;

mkdir images
fc = 1;

while hasFrame(raw)
    img = readFrame(raw);
    [c1, c2, cmain, c3, c4] = splitFrame(img, splitY, splitX1, splitX2);
    img_new = double(cmain); 
    %Prime mean shift on first iteration
    if(is_start == 1)
        is_start = 0;
        img_old = img_new;
    end
    %Calculate next point
    p1 = meanShift(img_old, img_new, p1, r, h, bins);
    img_old = img_new;
    %Project the point into image2
    p2 = calcPoint(p1', H1);
    %Change cameras if we are outside image2's FOV
    if(~((p2(1) > 0 && p2(2) > 0) && (p2(1) <= size(c1, 2) && p2(2) <= size(c1, 1))))
        c1 = c2;
        p2 = calcPoint(p1', H2);
    end
    displayImages(cmain, c1, p1, p2, fc);
    fc = fc + 1;
end

imageNames = dir(fullfile('images','*.jpg'));
imageNames = {imageNames.name}';

outputVideo = VideoWriter(fullfile('van_out'));
outputVideo.FrameRate = vanRaw.FrameRate;
open(outputVideo)

for ii = 1:length(imageNames)
   img = imread(fullfile('images',imageNames{ii}));
   writeVideo(outputVideo,img)
end

close(outputVideo)