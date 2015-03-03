% stim_test

% This task test whether a stimulus signal can be sent while an animal attempts to fixate.

editable( 'fix_radius', 'reward_val', 'fix_dur1', 'fix_dur2' );

% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
stim = 2;

% define time intervals (in ms):
wait_for_fix = 1000;
fix_dur1 = 250;
fix_dur2 = 750;

% fixation window (in degrees):
fix_radius = 1.5;
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

ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, fix_dur1);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(fixation_point)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end
 
 toggleobject(stim, 'eventmarker', 144);
 %idle( 10 );
 toggleobject(stim, 'eventmarker', 145);
 
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, fix_dur2);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(fixation_point)
	goodmonkey(reward_val); % juice
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end


trialerror(0); % correct
goodmonkey(reward_val); % juice

toggleobject(fixation_point); %turn off target