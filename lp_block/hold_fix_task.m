% hold_fix_task

% This task rewards animals for maintaining fixation while a distractor
% (target) is flashed on the screen.

editable( 'fix_radius', 'reward_val', 'pre_flash_dur', 'flash_dur', 'post_flash_dur' );


% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
target = 2;

% define time intervals (in ms):
wait_for_fix = 1000;
pre_flash_dur = 400;
post_flash_dur = 300;
flash_dur = 60;

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

ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, pre_flash_dur);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(fixation_point)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% flash distractor
toggleobject(target); % display target
[ontarget rt] = eyejoytrack('holdfix', fixation_point, fix_radius, flash_dur); % rt will be used to update the graph on the control screen
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject([target, fixation_point]);
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

toggleobject(target); % turn off target
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, post_flash_dur);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(fixation_point)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end


trialerror(0); % correct
goodmonkey(reward_val); % juice

toggleobject(fixation_point); %turn off target