% sacc_task

% This task rewards animals for making eye movements to displayed targets
% after holding their gaze steady at fixation.

editable( 'fix_radius', 'reward_val', 'hold_fix_time', 'aquire_target_time', 'hold_target_time' );


% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
target = 2;

% define time intervals (in ms):
wait_for_fix = 1000;
hold_fix_time = 100;
max_reaction_time = 500;
aquire_target_time = 150;
hold_target_time = 100;

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


% response
toggleobject([fixation_point target]); % simultaneously turns off fix point and displays target
[ontarget rt] = eyejoytrack('holdfix', fixation_point, fix_radius, max_reaction_time); % rt will be used to update the graph on the control screen
if ontarget, % max_reaction_time has elapsed and is still on fix spot
    trialerror(1); % no response
    toggleobject(target);
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

ontarget = eyejoytrack('acquirefix', target, fix_radius, aquire_target_time);
if ~ontarget,
    trialerror(2); % no or late response (did not land on the target)
    toggleobject(target);
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% hold target then reward
ontarget = eyejoytrack('holdfix', target, fix_radius, hold_target_time);
if ~ontarget,
    trialerror(5); % broke fixation
    toggleobject(target);
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end
trialerror(0); % correct
goodmonkey(reward_val); % juice

toggleobject(target); %turn off target