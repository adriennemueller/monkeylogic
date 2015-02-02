%lp_dstrctr_3choice (timing script)
% This task requires the animal to hold a lever down for a specific length
% of time. A cued target and 2 distractors are presented simultaneously. If 
% the target changes, the animal must release the lever within a certain
% time window of the change to be rewarded. If the target does not change, 
% the animal must keep the lever held to be rewarded.

% Naming for TaskObjects defined in the conditions file:
start_spot = 1;
cue = 2;
targ1 = 3;
targ2 = randi([3 4],1); %Original 50/50 likelihood
dist1 = 5;
dist2 = randi([5 6],1); % Original 50/50 likelihood

dist3 = 7;
dist4 = randi([7 8], 1);

% Define Time Intervals (in ms):
wait_press = 1000;
cue_time = 400;
hold_time = 400;
wait_release = 1000;

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

% Turn on Cue
toggleobject([start_spot cue], 'eventmarker', 131); % Cue on

toggleobject(cue, 'eventmarker', 131); % Cue off
toggleobject(cue, 'eventmarker', 131); % Cue on
toggleobject(cue, 'eventmarker', 131); % Cue off
toggleobject(cue, 'eventmarker', 131); % Cue on
toggleobject(cue, 'eventmarker', 131); % Cue off
toggleobject(cue, 'eventmarker', 131); % Cue on


held = eyejoytrack('holdtouch', 1, [], cue_time);
if ~held,
    % flip red
    trialerror(2); % released too early
    toggleobject(cue, 'eventmarker', 126); %Released too soon
    idle(200, [1, 0, 0]);
    return
end

% Keep Lever Pressed while Cue is on
held = eyejoytrack('holdtouch', 1, [], cue_time);
if ~held,
    toggleobject(cue, 'eventmarker', 126); % Turn off cue
    trialerror(2); % Released too early
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Turn on Target and Distractors
toggleobject([targ1 dist1 dist3], 'eventmarker', 121);

% Tests lever remains pressed
held = eyejoytrack('holdtouch', 1, [], hold_time);
if ~held,
    toggleobject([cue targ1 dist1 dist3], 'eventmarker', 126); %Turn off cue, target and distractor
    trialerror(2); % Released too soon
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Change targets or distractors (different or the same)
toggleobject([targ1 dist1 targ2 dist2 dist3 dist4]);
if (targ2 == 3)
    eventmarker(122); % Targ Same
elseif (targ2 == 4)
    eventmarker(123); % Targ Change
end

if (dist2 == 5)
    eventmarker(129); % Distractor Same
elseif (dist2 == 6)
    eventmarker(130); % Distractor Change
end

% Wait for release
released = ~eyejoytrack('holdtouch', 1, [], wait_release);

if (released && targ1 == targ2)
    toggleobject([cue targ2 dist2 dist4], 'eventmarker', 127); %Turn off cue, target and distractor
    trialerror(3); % Released when should not have
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end

if (~released && targ1 ~= targ2)
    toggleobject([cue targ2 dist2 dist4], 'eventmarker', 128); %Turn off cue, target and distractor
    trialerror(4); % Did not release in time
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end

toggleobject([cue targ2 dist2 dist4], 'eventmarker', 124); %Turn off target and distractor
trialerror(0); % Correct
goodmonkey(200); % Reward
