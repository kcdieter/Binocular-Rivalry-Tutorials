%% Lab Curriculum, Course 0 - The Basics of the Grating
% the psychophysicist's favorite image...

% at the start of any code, close any open windows, clear all Matlab variables, and clear the
% command window
clear all; close all; clc;

% these commands hide the mouse cursor, and prevent keypresses from
% displaying in the command window
HideCursor; ListenChar(2);

% now, predefine any important variables
imsize = 100; % imsize of image. For now, in pixels
sf = [.1 .18 .32 .56 1]; % spatial frequency of grating. For now, in pixels
orientations = [0 45 90 135 180]; % orientations for gratings, deg
contrast = [.1 .18 .32 .56 1]; % contrast of grating, 0-1
phase = [0 45 90 135 180]; % phase of grating, deg
background = 0; % background luminance for the window

% now use psychtoolbox to open a window on the screen where you will draw
% stimuli
[w, rect] = Screen('OpenWindow', 0, background);

% define the x and y center coordinates
xc = rect(3)/2; yc = rect(4)/2;

% create a grid that is the imsize of your stimulus so you can draw the
% pattern you want
[x,y] = meshgrid(-imsize/2:imsize/2,-imsize/2:imsize/2);

% these lines create a matrix with a sin wave grating based on parameters
% defined above. Values between -1 and 1.
first_grating = contrast(4)*(sin(cos(orientations(3)*pi/180)*sf(3)*x+sin(orientations(3)*pi/180)*sf(3)*y));

% converts the values above to appropriate display values (0 to 256). 
first_grating = 128*first_grating+128;

% this "trims" the outside of the gratings so that a circular grating will
% display
first_grating = first_grating.*Ellipse(size(x,1)/2);

% this is a psychtoolbox command that converts these matrices to textures
% that can be drawn on the screen
grating_tex1 = Screen('MakeTexture', w, first_grating);

%% SCREEN 1 - grating
Screen('TextFont', w, 'Helvetica'); Screen('TextSize',w, 28);
DrawFormattedText(w, ['Sine wave gratings are very commonly used images in studies of the human visual system.'], 'center', rect(4)/3-35, 255, 0);
DrawFormattedText(w, ['These are easy to program and manipulate, and relatively well tailored to known functional'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['properties of early visual areas of the brain.'], 'center', rect(4)/3+35, 255, 0);
DrawFormattedText(w, ['On each screen, press the space bar to advance when you are ready.'], 'center', rect(4)-150, 255, 0);

Screen('DrawTexture',w,grating_tex1,[], CenterRectOnPoint([0 0 size(first_grating,2) size(first_grating,1)], xc, yc));
Screen('Flip',w);

% Wait until a key is pressed (instructions say space bar, here it can
% actually be any key)
KbWait([],2);


%% SCREEN 2 - orientation
DrawFormattedText(w, ['Neurons in the early visual system respond selectively to the orientation of an illuminant patch.'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['Here are some sine wave gratings of different orientations.'], 'center', rect(4)/3+35, 255, 0);
DrawFormattedText(w, ['Press the space bar to advance when you are ready.'], 'center', rect(4)-150, 255, 0);

% Here is a loop to draw gratings of 5 orientations. A loop
% repeats the same operation as many times as specified - here the number
% times through the loop is defined by the number of elements in the "orientations"
% variable, set earlier in the script. The loop index (here, N) increases 
% with each run through the loop, and can be used to save out results into 
% a variable each time through.
x_loc = [xc-rect(3)/4 xc-rect(3)/8 xc xc+rect(3)/8 xc+rect(3)/4]; % this variable just defines 5 different x-coordinates on screen to specify where the gratings should be displayed
for N = 1:size(orientations,2)
    orient_gratings(:,:,N) = contrast(4)*(sin(cos(orientations(N)*pi/180)*sf(3)*x+sin(orientations(N)*pi/180)*sf(3)*y));
    orient_gratings(:,:,N) = 128*orient_gratings(:,:,N)+128;
    orient_gratings(:,:,N) = orient_gratings(:,:,N).*Ellipse(size(x,1)/2);
    grating_texOR(N) = Screen('MakeTexture', w, orient_gratings(:,:,N));
    Screen('DrawTexture',w,grating_texOR(N),[], CenterRectOnPoint([0 0 size(orient_gratings(:,:,N),2) size(orient_gratings(:,:,N),1)], x_loc(N), yc));
end
Screen('Flip',w);
KbWait([],2);

%% SCREEN 3 - spatial frequency
DrawFormattedText(w, ['Neurons in the early visual system also respond selectively to spatial frequency.'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['This refers to how broad or fine the stripes are, and is measured in cycles/degree.'], 'center', rect(4)/3+35, 255, 0);
DrawFormattedText(w, ['Press the space bar to advance when you are ready.'], 'center', rect(4)-150, 255, 0);

% Here is a loop to draw gratings of 5 different spatial frequencies.
x_loc = [xc-rect(3)/4 xc-rect(3)/8 xc xc+rect(3)/8 xc+rect(3)/4]; % this variable just defines 5 different x-coordinates on screen to specify where the gratings should be displayed
for N = 1:size(sf,2)
    sf_gratings(:,:,N) = contrast(4)*(sin(cos(orientations(3)*pi/180)*sf(N)*x+sin(orientations(3)*pi/180)*sf(N)*y));
    sf_gratings(:,:,N) = 128*sf_gratings(:,:,N)+128;
    sf_gratings(:,:,N) = sf_gratings(:,:,N).*Ellipse(size(x,1)/2);
    grating_texSF(N) = Screen('MakeTexture', w, sf_gratings(:,:,N));
    Screen('DrawTexture',w,grating_texSF(N),[], CenterRectOnPoint([0 0 size(sf_gratings(:,:,N),2) size(sf_gratings(:,:,N),1)], x_loc(N), yc));
end
DrawFormattedText(w, ['---------------------------------Increasing Spatial Frequency--------------------------------->'], 'center', yc+imsize, 255, 0);
Screen('Flip',w);
KbWait([],2);


%% SCREEN 4 - phase
DrawFormattedText(w, ['Another important property is the phase of the grating.'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['This refers to the specific placement of the light/dark stripes within the circular aperture.'], 'center', rect(4)/3+35, 255, 0);
DrawFormattedText(w, ['Press the space bar to advance when you are ready.'], 'center', rect(4)-150, 255, 0);

% Here is a loop to draw gratings of 5 phases.
x_loc = [xc-rect(3)/4 xc-rect(3)/8 xc xc+rect(3)/8 xc+rect(3)/4]; % this variable just defines 5 different x-coordinates on screen to specify where the gratings should be displayed
for N = 1:size(phase,2)
    phase_gratings(:,:,N) = contrast(4)*(sin(cos(orientations(3)*pi/180)*sf(1)*x+phase(N)+sin(orientations(3)*pi/180)*sf(1)*y+phase(N)));
    phase_gratings(:,:,N) = 128*phase_gratings(:,:,N)+128;
    phase_gratings(:,:,N) = phase_gratings(:,:,N).*Ellipse(size(x,1)/2);
    grating_texPH(N) = Screen('MakeTexture', w, phase_gratings(:,:,N));
    Screen('DrawTexture',w,grating_texPH(N),[], CenterRectOnPoint([0 0 size(phase_gratings(:,:,N),2) size(phase_gratings(:,:,N),1)], x_loc(N), yc));
end
Screen('Flip',w);
KbWait([],2);


%% SCREEN 5 - contrast
DrawFormattedText(w, ['Finally, neurons in early vision respond more to gratings of higher contrast.'], 'center', rect(4)/3-35, 255, 0);
DrawFormattedText(w, ['This refers to the luminance difference between the light and dark bars.'], 'center', rect(4)/3, 255, 0);
DrawFormattedText(w, ['Note that the mean luminance of each grating is identical.'], 'center', rect(4)/3+35, 255, 0);
DrawFormattedText(w, ['This is the end of the grating basics course. Press space when you are finished.'], 'center', rect(4)-150, 255, 0);

% Here is a loop to draw gratings of 5 phases.
x_loc = [xc-rect(3)/4 xc-rect(3)/8 xc xc+rect(3)/8 xc+rect(3)/4]; % this variable just defines 5 different x-coordinates on screen to specify where the gratings should be displayed
for N = 1:size(contrast,2)
    contrast_gratings(:,:,N) = contrast(N)*(sin(cos(orientations(3)*pi/180)*sf(3)*x+sin(orientations(3)*pi/180)*sf(3)*y));
    contrast_gratings(:,:,N) = 128*contrast_gratings(:,:,N)+128;
    contrast_gratings(:,:,N) = contrast_gratings(:,:,N).*Ellipse(size(x,1)/2);
    grating_texCON(N) = Screen('MakeTexture', w, contrast_gratings(:,:,N));
    Screen('DrawTexture',w,grating_texCON(N),[], CenterRectOnPoint([0 0 size(contrast_gratings(:,:,N),2) size(contrast_gratings(:,:,N),1)], x_loc(N), yc));
end
DrawFormattedText(w, ['---------------------------------Increasing Contrast--------------------------------->'], 'center', yc+imsize, 255, 0);
Screen('Flip',w);
KbWait([],2);


% now show the mouse again, and allow keypresses to display in the command
% window again
ShowCursor; ListenChar(1);

% close all windows and textures that were opened
Screen('CloseAll');
