%lp_fix_test (timing script)

% Dummy Task to test how to simultaneously verify lever held and fixation
% held.


% Naming for TaskObjects defined in the conditions file:
start_spot = 1;
targ1 = 2;


editable( 'reward', 'fix_radius', 'wait_release', 'hold_time' );

% Define Time Intervals (in ms):
wait_for_fix = 1000;
hold_time = 400;

wait_press = 1000;
wait_release = 1000;


fix_radius = 1.5;

% Define Reward Duration
reward = 300;



%%%%%%%%% TASK %%%%%%%%

% Show Fixation Spot, Cues the Beginning of a Trial, Acquire Fixation:
toggleobject(start_spot, 'eventmarker', 120) % Fixation Spot Shown
ontarget = eyejoytrack('acquirefix', start_spot, fix_radius, wait_for_fix);
if ~ontarget,
    trialerror(4); % no fixation
    toggleobject(start_spot)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

disp('Made it 1.');

% Waits for press
pressed = eyejoytrack('holdfix', start_spot, fix_radius, 'acquiretouch', 1, [], wait_press); % Here '1' =button/lever index, not the target
if ~pressed
    toggleobject(start_spot, 'eventmarker', 125) % Didn't press by end of fixation cue
    trialerror(1); % Didn't press in time
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

disp('Made it 2.');
toggleobject(start_spot, 'eventmarker', 124); %Turn off fixation spot and targets
trialerror(0); % Correct

% Reward
goodmonkey(reward);
