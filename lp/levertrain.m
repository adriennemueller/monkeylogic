%garf (timing script)

% This task requires the animal to hold a lever down for a specific length of time.

% give names to the TaskObjects defined in the conditions file:
start_spot = 1;
targ1 = 2;

% define time intervals (in ms):
wait_press = 1000;
wait_release = 1000;

% TASK:

% show fix spot:
toggleobject(start_spot);
eventmarker(120) % Fixation Spot Shown

% Here '1' refers to the button/lever index, and not the target
pressed = eyejoytrack('acquiretouch', 1, [], wait_press);
if ~pressed
    trialerror(1); % didn't press in time
    toggleobject(start_spot)
    eventmarker(125) %Didn't press  by end of fixation cue
    idle(200, [1, 0, 0]);
    return
end

toggleobject(start_spot);
toggleobject(targ1);
eventmarker(121); %Targ 1 On

released = ~eyejoytrack('holdtouch', 1, [], wait_release);
if (~released)
    toggleobject(targ1);
    % flip red
    trialerror(4); % didn't release in time
    eventmarker(128); % Did not release when should have
    idle(200, [1, 0, 0]);
    return
end



toggleobject(targ1);
eventmarker(124); %Performed Correctly

trialerror(0); % correct
goodmonkey(50);
