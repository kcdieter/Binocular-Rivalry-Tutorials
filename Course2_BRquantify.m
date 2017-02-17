%% Lab Curriculum, Course 2 - Quantifying Binocular Rivalry

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
[w, rect] = Screen('OpenWindow', 0, background);

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
BRimg(:,:,1) = red_grating+grating_inv;
BRimg(:,:,2) = green_grating+grating_inv;
BRimg(:,:,3) = background;
mixed_grating = (green_grating+red_grating)/2;
mixedimg(:,:,1) = mixed_grating+grating_inv; mixedimg(:,:,2) = mixed_grating+grating_inv; mixedimg(:,:,3) = background;

% this is a psychtoolbox command that converts these matrices to textures
% that can be drawn on the screen
grating_texG = Screen('MakeTexture', w, greenimg);
grating_texR = Screen('MakeTexture', w, redimg);
grating_texBR = Screen('MakeTexture', w, BRimg);
grating_texMIX = Screen('MakeTexture', w, mixedimg);

%% SCREEN 1 - binocular rivalry intro
Screen('TextFont', w, 'Helvetica'); Screen('TextSize',w, 28);
DrawFormattedText(w, ['Anaglyphs ON'], 0, 0, 255, 0);
DrawFormattedText(w, ['Remember from course 1 that the experience of binocular rivalry (BR) is characterized by'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['alternating exlusive percepts as well as "mixed" percepts.'], 'center', rect(4)/3+35, 255, 0);
DrawFormattedText(w, ['Look at BR for a while to remind yourself of these states. Press space when you are ready to move on.'], 'center', rect(4)-150, 255, 0);

Screen('DrawTexture',w,grating_texBR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc, yc));
Screen('Flip',w);
KbWait([],2);


%% SCREEN 2 - data collection
DrawFormattedText(w, ['To collect data during BR tracking experiments, the observer is typically asked to press (and hold) a'], 'center', rect(4)/3-35, 255, 0);
DrawFormattedText(w, ['different key on the keyboard to indicate which of the two images is currently dominant. Sometimes a third'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['key is used to report mixtures, but more commonly the observer simply releases the other keys.'], 'center', rect(4)/3+35, 255, 0);
DrawFormattedText(w, ['Try reporting your BR experience with keypresses. Press and hold the left arrow key when the green'], 'center', rect(4)-210, 255, 0);
DrawFormattedText(w, ['image is dominant, and the right arrow key when the red image is dominant. Let go of both if you see'], 'center', rect(4)-175, 255, 0);
DrawFormattedText(w, ['a mixed percept. Put anaglyphs on and then press space bar to begin tracking for 2 minutes.'], 'center', rect(4)-140, 255, 0);
Screen('Flip',w);
KbWait([],2);


Screen('DrawTexture',w,grating_texBR,[], CenterRectOnPoint([0 0 size(redimg,2) size(redimg,1)], xc, yc));
Screen('Flip',w);

% This "while" loop continues to run as long as its conditions are met.
% Here, Matlab will continue checking keypresses until the 2 minutes have
% elapsed. Until then, at each frame it keeps track of keypresses in a 3
% row matrix. If the observer is pressing the left arrow, the value "1" is
% entered for that frame in row one. Likewise for the right arrow with row
% 2. If no key is pressed on that frame, it enters a "1" in row 3.

rivalryresponse = [0;0;0;]; frame = 1;
timestart = GetSecs; % this gets the current time at the beginning of the loop
while GetSecs - timestart < 120 % keep running this loop until 120s after the start time
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        theresponse = KbName(find(keyCode));
        if strcmp(theresponse, 'LeftArrow');
            rivalryresponse(1,frame) = 1;
        elseif strcmp(theresponse, 'RightArrow');
            rivalryresponse(2,frame) = 1;
        end
    else
        rivalryresponse(3,frame) = 1;
    end
    frame = frame + 1;
    WaitSecs(0.05); % check every 50 ms - would not do this in real experiment, just makes the demo run smoother
end


%% SCREEN 3 - exclusive percepts vs. mixtures
mixed_prop = sum(rivalryresponse(3,:))/size(rivalryresponse,2); % calculates proportion of mixed percepts
tot_excl = 1-mixed_prop; % calculates proportion of exclusive percepts

DrawFormattedText(w, ['Anaglyphs OFF'], 0, 0, 255, 0);
DrawFormattedText(w, ['Exclusive percepts vs. mixtures'], 'center', rect(4)/3-100, 255, 0);
DrawFormattedText(w, ['After an observer has tracked BR for a while, we would like to know how often "exclusive percepts"'], 'center', rect(4)/3-35, 255, 0);
DrawFormattedText(w, ['were seen, and how often "mixed percepts" were seen. We can compute the proportion of the total'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['viewing time that the observer pressed down either arrow key vs. released both keys.'], 'center', rect(4)/3+35, 255, 0);

DrawFormattedText(w, ['Your Data:'], xc-rect(3)/4, rect(4)-210, 255, 0);
DrawFormattedText(w, ['Proportion Exclusive Percepts:  ', num2str(tot_excl,'%0.3f')], xc-rect(3)/4, rect(4)-175, 255, 0);
DrawFormattedText(w, ['Proportion Mixed Percepts:      ', num2str(mixed_prop,'%0.3f')], xc-rect(3)/4, rect(4)-140, 255, 0);
Screen('Flip',w);
KbWait([],2);


%% SCREEN 4 - breaking down exclusive percepts
green_prop = sum(rivalryresponse(1,:))/size(rivalryresponse,2);
red_prop = sum(rivalryresponse(2,:))/size(rivalryresponse,2);

DrawFormattedText(w, ['Breaking down exclusive percepts'], 'center', rect(4)/3-100, 255, 0);
DrawFormattedText(w, ['We also want to break down "exclusive percepts" even further. We want to know the proportion'], 'center', rect(4)/3-35, 255, 0);
DrawFormattedText(w, ['of time that each image (the red and green grating) were exclusively dominant.'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['Which image did you see more often, or did you see each about the same amount?'], 'center', rect(4)/3+35, 255, 0);

DrawFormattedText(w, ['Your Data:'], xc-rect(3)/4, rect(4)-210, 255, 0);
DrawFormattedText(w, ['Proportion Green Image:  ', num2str(green_prop,'%0.3f')], xc-rect(3)/4, rect(4)-175, 255, 0);
DrawFormattedText(w, ['Proportion Red Image:      ', num2str(red_prop,'%0.3f')], xc-rect(3)/4, rect(4)-140, 255, 0);
Screen('Flip',w);
KbWait([],2);


%% SCREEN 5 - breaking down exclusive percepts
green_prop = sum(rivalryresponse(1,:))/size(rivalryresponse,2);
red_prop = sum(rivalryresponse(2,:))/size(rivalryresponse,2);

DrawFormattedText(w, ['Breaking down exclusive percepts'], 'center', rect(4)/3-100, 255, 0);
DrawFormattedText(w, ['We also want to know the proportion of time that each eye was perceived dominant.'], 'center', rect(4)/3-35, 255, 0);
DrawFormattedText(w, ['In the experiment that we just did, the red image was always presented to your right eye'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['but in a real experiment we would counterbalance the eye/stimulus pairing.'], 'center', rect(4)/3+35, 255, 0);

DrawFormattedText(w, ['Your Data:'], xc-rect(3)/4, rect(4)-210, 255, 0);
DrawFormattedText(w, ['Proportion Left Eye:  ', num2str(green_prop,'%0.3f')], xc-rect(3)/4, rect(4)-175, 255, 0);
DrawFormattedText(w, ['Proportion Right Eye: ', num2str(red_prop,'%0.3f')], xc-rect(3)/4, rect(4)-140, 255, 0);
Screen('Flip',w);
KbWait([],2);




% now show the mouse again, and allow keypresses to display in the command
% window again
ShowCursor; ListenChar(1);

% close all windows and textures that were opened
Screen('CloseAll');
