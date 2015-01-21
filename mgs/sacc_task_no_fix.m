% sacc_task_no_fix

% This task rewards animals for making eye movements to displayed targets.

editable( 'fix_radius', 'reward_val', 'wait_for_fix', 'hold_fix_time' );


% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;

% define time intervals (in ms):
wait_for_fix = 1000;
hold_fix_time = 100;

% fixation window (in degrees):
fix_radius = 2;
reward_val = 300;


% TASK:

% initial fixation:
toggleobject(fixation_point);
ontarget = eyejoytrack('acquirefix', fixation_point, fix_radius, wait_for_fix);
if ~ontarget,
    trialerror(4); % no fixation
    toggleobject(fixation_point)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, hold_fix_time);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(fixation_point)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end


trialerror(0); % correct
goodmonkey(reward_val); % juice

toggleobject(fixation_point); %turn off target