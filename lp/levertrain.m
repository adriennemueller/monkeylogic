%levertrain (timing script)
% This task trains the animal to associate pushing the lever down with a
% target on the screen. The animal needs to push the lever within a certain
% interval of time. Then the target will appear and as soon as they should
% release the lever within a second interval of time. As soon as they
% release the lever, the target will disappear.

% Naming for TaskObjects defined in the conditions file:
start_spot = 1;
targ1 = 2;

% Define Time Intervals (in ms):
wait_press = 1000;
wait_release = 1000;

%%%%%%%%% TASK %%%%%%%%%

% Show Fixation Spot, Cues the Beginning of a Trial:
toggleobject(start_spot, 'eventmarker', 120); % Fixation Spot Shown

% Waits for press
pressed = eyejoytrack('acquiretouch', 1, [], wait_press); % Here '1' =button/lever index, not the target
if ~pressed
    toggleobject(start_spot, 'eventmarker', 125) % Turn off target
    trialerror(1); % Didn't press in time
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Switch 'fixation spot' for Target
toggleobject([start_spot targ1], 'eventmarker', 121);

% Waits for release
released = ~eyejoytrack('holdtouch', 1, [], wait_release); % Eyejoytrack 'holdtouch' returns a 0 when 'holding' fails (release)
if (~released)
    toggleobject(targ1, 'eventmarker', 128); % Turn off target
    trialerror(4); % Did not release in time
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end


toggleobject(targ1, 'eventmarker', 124); % Turn off target
trialerror(0); 
goodmonkey(50); % Reward
