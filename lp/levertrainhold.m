%levertrainhold (timing script)
% This task requires the animal to hold a lever down for a specific length
% of time. Once the animal presses the lever, the target will appear. The
% animal must not release the lever until the target changes, and is not
% rewarded if it is released too early.

% Naming for TaskObjects defined in the conditions file:
start_spot = 1;
targ1 = 2;
targ2 = 3;

% Define Time Intervals (in ms):
wait_press = 1000;
hold_time = 400; %250 when initially training
wait_release = 1000;

%%%%%%%%% TASK %%%%%%%%

% Show Fixation Spot, Cues the Beginning of a Trial:
toggleobject(start_spot, 'eventmarker', 120); % Fixation Spot Shown

% Waits for press
pressed = eyejoytrack('acquiretouch', 1, [], wait_press); % Here '1' =button/lever index, not the target
if ~pressed
    toggleobject(start_spot, 'eventmarker', 125) % Didn't press by end of fixation cue
    trialerror(1); % Didn't press in time
    idle(200, [1, 0, 0]); % Red Error Screen
    return % END OF TRIAL
end

% Switch 'fixation spot' for Target
toggleobject([start_spot targ1], 'eventmarker', 121); %Targ 1 On

% Tests lever remains pressed
held = eyejoytrack('holdtouch', 1, [], hold_time);
if ~held,
    toggleobject(targ1, 'eventmarker', 126); %Turn off target
    trialerror(2); % Released too soon
    idle(200, [1, 0, 0]); % Red Error Screen
    return % END OF TRIAL
end

% Target Changes
toggleobject([targ1 targ2], 'eventmarker', 123); % Target 1 off, Target 2 on

% Waits for release
released = ~eyejoytrack('holdtouch', 1, [], wait_release);
if (~released)
    toggleobject(targ2, 'eventmarker', 128); %Turn off target
    trialerror(4); % Did not release in time
    idle(200, [1, 0, 0]); % Red Error Screen
    return % END OF TRIAL
end

toggleobject(targ2, 'eventmarker', 124); %Turn off target
trialerror(0); % Correct
goodmonkey(50); % Reward
% END OF TRIAL
