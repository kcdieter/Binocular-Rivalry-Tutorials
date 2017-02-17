%% Lab Curriculum, Course 1 - The Basics of Binocular Rivalry (BR intro)

% at the start of any code, close any open windows, clear all Matlab variables, and clear the
% command window
clear all; close all; clc;

% these commands hide the mouse cursor, and prevent keypresses from
% displaying in the command window
HideCursor; ListenChar(2);

% now, predefine any important variables
imsize = 100; % imsize of image. For now, in pixels
sf = .25; % spatial frequency of grating. For now, in pixels
orientations = [-45 45]; % orientations for gratings - for BR, make sure they are orthogonal
contrast = 0.3;
background = 0;

% now use psychtoolbox to open a window on the screen where you will draw
% stimuli
[w, rect] = Screen('OpenWindow', 1, background);

% define the x and y center coordinates
xc = rect(3)/2; yc = rect(4)/2;

% create a grid that is the imsize of your stimulus so you can draw the
% pattern you want
[x,y] = meshgrid(-imsize/2:imsize/2,-imsize/2:imsize/2);

% these lines create a matrix with a sin wave grating based on parameters
% defined above. Values between -1 and 1
green_grating = contrast*(sin(cos(orientations(1)*pi/180)*sf*x+sin(orientations(1)*pi/180)*sf*y));
red_grating = contrast*(sin(cos(orientations(2)*pi/180)*sf*x+sin(orientations(2)*pi/180)*sf*y));

% converts the values above to appropriate display values (0 to 256). Note
% that the mean luminance for green (64) is set lower than that for red (128)
% because green typically displays much brighter on most monitors. In a real 
% experiment you would want to measure the equiluminance point to ensure that 
% these values are equivalent.
green_grating = 64*green_grating+64;
red_grating = 128*red_grating+128;

% this "trims" the outside of the gratings so that a circular grating will
% display
green_grating = green_grating.*Ellipse(size(x,1)/2);
red_grating = red_grating.*Ellipse(size(x,1)/2);
grating_inv = abs(Ellipse(size(x,1)/2)-1).*background;

% moves the gratings created above into a imsize x imsize x 3 matrix so that it
% will draw in the RGB channels. Note that the grating itself is drawn into
% only the green or red channel and background luminance in the other
% channels
greenimg(:,:,2) = green_grating+grating_inv;
greenimg(:,:,1) = background; greenimg(:,:,3) = background; 
redimg(:,:,1) = red_grating+grating_inv;
redimg(:,:,2) = background; redimg(:,:,3) = background;


% this is a psychtoolbox command that converts these matrices to textures
% that can be drawn on the screen
grating_texG = Screen('MakeTexture', w, greenimg);
grating_texR = Screen('MakeTexture', w, redimg);

%% SCREEN 1 - gratings
Screen('TextFont', w, 'Helvetica'); Screen('TextSize',w, 28);
DrawFormattedText(w, ['Anaglyphs OFF'], 0, 0, 255, 0);
DrawFormattedText(w, ['To produce binocular rivalry, incompatible images are shown to each eye.'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['Sine wave gratings are commonly used as stimuli - here are two examples.'], 'center', rect(4)/3+35, 255, 0);
DrawFormattedText(w, ['On each screen, press the space bar to advance when you are ready.'], 'center', rect(4)-150, 255, 0);

Screen('DrawTexture',w,grating_texR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc-rect(3)/8, yc));
Screen('DrawTexture',w,grating_texG,[], CenterRectOnPoint([0 0 size(greenimg,2) size(greenimg,1)], xc+rect(3)/8, yc));
Screen('Flip',w);

% Wait until a key is pressed (instructions say space bar, here it can
% actually be any key)
KbWait([],2);

%% SCREEN 2 - anaglyphs 1
DrawFormattedText(w, ['Anaglyphs ON'], 0, 0, 255, 0);
DrawFormattedText(w, ['What happens if you put on red/green anaglyphs with the red lens over your left eye?'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['Try looking through only your left, then only your right, eye.'], 'center', rect(4)/3+35, 255, 0);
DrawFormattedText(w, ['On each screen, press the space bar to advance when you are ready.'], 'center', rect(4)-150, 255, 0);

Screen('DrawTexture',w,grating_texR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc-rect(3)/8, yc));
Screen('DrawTexture',w,grating_texG,[], CenterRectOnPoint([0 0 size(greenimg,2) size(greenimg,1)], xc+rect(3)/8, yc));
Screen('Flip',w);
KbWait([],2);

%% SCREEN 3 - anaglyphs 2
DrawFormattedText(w, ['Anaglyphs ON'], 0, 0, 255, 0);
DrawFormattedText(w, ['The color filters allow only images of one color to pass through.'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['So, your left eye sees only the red grating, while your right eye sees only the green grating.'], 'center', rect(4)/3+35, 255, 0);
DrawFormattedText(w, ['On each screen, press the space bar to advance when you are ready.'], 'center', rect(4)-150, 255, 0);

Screen('DrawTexture',w,grating_texR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc-rect(3)/8, yc));
Screen('DrawTexture',w,grating_texG,[], CenterRectOnPoint([0 0 size(greenimg,2) size(greenimg,1)], xc+rect(3)/8, yc));
Screen('Flip',w);
KbWait([],2);

% For the next screen, create a binocular rivalry image. Here, both the red and green images 
% are drawn into the same image matrix
BRimg(:,:,1) = red_grating+grating_inv;
BRimg(:,:,2) = green_grating+grating_inv;
BRimg(:,:,3) = background;
grating_texBR = Screen('MakeTexture', w, BRimg);

%% SCREEN 4 - binocular rivalry
DrawFormattedText(w, ['Anaglyphs ON'], 0, 0, 255, 0);
DrawFormattedText(w, ['Binocular rivalry (BR) occurs when incompatible images are presented at corresponding retinal locations.'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['So, you will experience BR if these images are placed at the same location on the screen.'], 'center', rect(4)/3+35, 255, 0);
DrawFormattedText(w, ['Look at BR for a while to see what happens. Press space when you are ready to move on.'], 'center', rect(4)-150, 255, 0);

Screen('DrawTexture',w,grating_texBR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc, yc));
Screen('Flip',w);
KbWait([],2);

%% SCREEN 5 - alternations
DrawFormattedText(w, ['Anaglyphs OFF'], 0, 0, 255, 0);
DrawFormattedText(w, ['What did you see? Did your perception change over time?'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['BR is typically characterized by perceptual alternations between the left eye and right eye image.'], 'center', rect(4)/3+35, 255, 0);

Screen('DrawTexture',w,grating_texR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc-rect(3)/4, yc));
Screen('DrawTexture',w,grating_texG,[], CenterRectOnPoint([0 0 size(greenimg,2) size(greenimg,1)], xc-rect(3)/8, yc));
Screen('DrawTexture',w,grating_texR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc, yc));
Screen('DrawTexture',w,grating_texG,[], CenterRectOnPoint([0 0 size(greenimg,2) size(greenimg,1)], xc+rect(3)/8, yc));
Screen('DrawTexture',w,grating_texR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc+rect(3)/4, yc));
DrawFormattedText(w, ['---------------------------------------------TIME--------------------------------------------->'], 'center', yc+imsize, 255, 0);

Screen('Flip',w);
KbWait([],2);

%% SCREEN 6 - exclusive percepts
DrawFormattedText(w, ['Anaglyphs OFF'], 0, 0, 255, 0);
DrawFormattedText(w, ['Periods for which one image is entirely visible while the other image is entirely suppressed are called'], 'center', rect(4)/3-35, 255, 0);
DrawFormattedText(w, ['periods of exclusive perceptual dominance. Note that the suppressed image is still entering the visual '], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['system. However, it can remain completely invisible for several seconds at a time!'], 'center', rect(4)/3+35, 255, 0);

Screen('DrawTexture',w,grating_texR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc-rect(3)/4, yc));
Screen('DrawTexture',w,grating_texG,[], CenterRectOnPoint([0 0 size(greenimg,2) size(greenimg,1)], xc-rect(3)/8, yc));
Screen('DrawTexture',w,grating_texR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc, yc));
Screen('DrawTexture',w,grating_texG,[], CenterRectOnPoint([0 0 size(greenimg,2) size(greenimg,1)], xc+rect(3)/8, yc));
Screen('DrawTexture',w,grating_texR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc+rect(3)/4, yc));
DrawFormattedText(w, ['---------------------------------------------TIME--------------------------------------------->'], 'center', yc+imsize, 255, 0);

Screen('Flip',w);
KbWait([],2);

%% SCREEN 7 - mixtures
DrawFormattedText(w, ['Anaglyphs OFF'], 0, 0, 255, 0);
DrawFormattedText(w, ['Sometimes you may see parts of both images at once, or even a fused crosshatch pattern.'], 'center', rect(4)/3-35, 255, 0);
DrawFormattedText(w, ['These are referred to as "Mixed" or "Piecemeal" percepts. They are often experienced'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['during transitions from one eye to the other.'], 'center', rect(4)/3+35, 255, 0);

mixed_grating = (green_grating+red_grating)/2;
mixedimg(:,:,1) = mixed_grating+grating_inv; mixedimg(:,:,2) = mixed_grating+grating_inv; mixedimg(:,:,3) = background;
grating_texMIX = Screen('MakeTexture', w, mixedimg);

Screen('DrawTexture',w,grating_texR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc-rect(3)/4, yc));
Screen('DrawTexture',w,grating_texMIX,[], CenterRectOnPoint([0 0 size(greenimg,2) size(greenimg,1)], xc-rect(3)/8, yc));
Screen('DrawTexture',w,grating_texG,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc, yc));
Screen('DrawTexture',w,grating_texMIX,[], CenterRectOnPoint([0 0 size(greenimg,2) size(greenimg,1)], xc+rect(3)/8, yc));
Screen('DrawTexture',w,grating_texR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc+rect(3)/4, yc));
DrawFormattedText(w, ['---------------------------------------------TIME--------------------------------------------->'], 'center', yc+imsize, 255, 0);

Screen('Flip',w);
KbWait([],2);

%% SCREEN 8 - summary
DrawFormattedText(w, ['Anaglyphs ON'], 0, 0, 255, 0);
DrawFormattedText(w, ['Summary'], 'center', rect(4)/3-90, 255, 0);
DrawFormattedText(w, ['Binocular rivalry (BR) occurs when corresponding points on our left and right retinae are stimulated'], 'center', rect(4)/3-35, 255, 0);
DrawFormattedText(w, ['by incompatible images. When this occurs, an observer will typically witness alternating periods during'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['which one or the other image is exclusively visible, with occassional periods of "mixed" percepts.'], 'center', rect(4)/3+35, 255, 0);

mixed_grating = (green_grating+red_grating)/2;
mixedimg(:,:,1) = mixed_grating+grating_inv; mixedimg(:,:,2) = mixed_grating+grating_inv; mixedimg(:,:,3) = background;
grating_texMIX = Screen('MakeTexture', w, mixedimg);

Screen('DrawTexture',w,grating_texBR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc, yc));
DrawFormattedText(w, ['This is the end of Course 1.'], 'center', rect(4)-150, 255, 0);
DrawFormattedText(w, ['Keep looking at BR for a little while until you feel familiar with the different perceptual states.'], 'center', rect(4)-115, 255, 0);

Screen('Flip',w);
KbWait([],2);


% now show the mouse again, and allow keypresses to display in the command
% window again
ShowCursor; ListenChar(1);

% close all windows and textures that were opened
Screen('CloseAll');
