% target_test

% This is not a task, but a tool for measuring the positioning of targets.

editable( 'fix_radius', 'hold_fix_time' );


% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
target = 2;

% define time intervals (in ms):
wait_for_fix = 1000;
hold_fix_time = 30000;
max_reaction_time = 500;

% fixation window (in degrees):
fix_radius = 2;


% TASK:

% initial fixation:
toggleobject([fixation_point target]);
ontarget = eyejoytrack('acquirefix', fixation_point, fix_radius, wait_for_fix);
if ~ontarget,
    trialerror(4); % no fixation
    toggleobject([fixation_point target])
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, hold_fix_time);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject([fixation_point target])
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

trialerror(0); % correct

toggleobject([fixation_point target]); %turn off target