function [ xbeg, ybeg, xend, yend ] = DisplayCenteredText( windowPtr, text, crossX, crossY, col )
%DISPLAYCENTEREDTEXT displays text centered on a particular point using
%Psychtoolbox functions.
%
%Inputs:
%   - "windowPtr": a PTB pointer to the window on which to display the
%     text.
%   - "text": the text to display.
%   - "crossX": the horizontal coordinated on which the text has to be
%     centered.
%   - "crossY": the vertical coordinated on which the text has to be
%     centered.
%   - "col": a RGB array specifying the text color.
%
%Output:
%   - "xbeg': a scalar specifying the horizontal coordinate of the left
%   limit of the text box.
%   - "ybeg': a scalar specifying the vertical coordinate of the bottom
%   limit of the text box.
%   - "xend': a scalar specifying the horizontal coordinate of the right
%   limit of the text box.
%   - "yend': a scalar specifying the vertical coordinate of the top
%   limit of the text box.
%
%Copyright 2015 Maxime Maheu


[w, h] = RectSize(Screen('TextBounds', windowPtr, text));
xbeg = round(crossX - w/2);
ybeg = round(crossY - h/2);
xend = round(crossX + w/2);
yend = round(crossY + h/2);
Screen('DrawText', windowPtr, text, xbeg, ybeg, col);

end