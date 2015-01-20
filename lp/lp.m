%lp (timing script)
% This task requires the animal to hold a lever down for a specific length
% of time. If the target changes, the animal must release the lever within
% a certain time window of the change to be rewarded. If the target does
% not change, the animal must keep the lever held to be rewarded.

% Naming for TaskObjects defined in the conditions file:
start_spot = 1;
targ1 = 2;
targ2 = randi([2 3],1); %Target either changes (3) or stays the same (2) with equal probability.

% Define Time Intervals (in ms):
wait_press = 1000;
hold_time = 400;
wait_release = 800;

%%%%%%%%% TASK %%%%%%%%

% Show Fixation Spot, Cues the Beginning of a Trial:
toggleobject(start_spot, 'eventmarker', 120) % Fixation Spot Shown

% Waits for press
pressed = eyejoytrack('acquiretouch', 1, [], wait_press); % Here '1' =button/lever index, not the target
if ~pressed
    toggleobject(start_spot, 'eventmarker', 125) % Didn't press by end of fixation cue
    trialerror(1); % Didn't press in time
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Switch 'fixation spot' for Target
toggleobject([start_spot targ1], 'eventmarker', 121); %Targ 1 On

% Tests lever remains pressed
held = eyejoytrack('holdtouch', 1, [], hold_time);
if ~held,
    toggleobject(targ1, 'eventmarker', 126); %Turn off target
    trialerror(2); % Released too soon
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Switch first target to second target (which is either the same or different)
toggleobject([targ1 targ2]);
if (targ2 == 2)
    eventmarker(122); % Target stays the same
elseif (targ2 == 3)
    eventmarker(123); % Target changes
end

% Waits for release
released = ~eyejoytrack('holdtouch', 1, [], wait_release);

if (released && targ1 == targ2)
    toggleobject(targ2, 'eventmarker', 127); % Turn off Target
    trialerror(3); % Released when should not have
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

if (~released && targ1 ~= targ2)
    toggleobject(targ2, 'eventmarker', 128); %Turn off target
    trialerror(4); % Did not release in time
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

toggleobject(targ2, 'eventmarker', 124); %Turn off target
trialerror(0); % Correct
goodmonkey(500); % Reward

