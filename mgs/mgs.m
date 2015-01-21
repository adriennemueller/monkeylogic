%mgs (timing script)

% This task requires the animal to hold their gaze steady on a central
% fixation spot while a peripheral cue is flashed, then maintain fixation
% during a delay period, then make an eye movement to the remembered
% location.

editable( 'fix_radius', 'reward_value', 'initial_fix', 'cue_time', 'delay', 'saccade_time', 'hold_target_time' );


% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
cue = 2;
target = 3;

% define time intervals (in ms):
wait_for_fix = 1000;
initial_fix = 250;
max_reaction_time = 500;
cue_time = 60;
delay = 300;
saccade_time = 80;
hold_target_time = 100;

% fixation window (in degrees):
fix_radius = 2;

reward_value = 300;

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
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, initial_fix);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(fixation_point)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end


% cue epoch
toggleobject(cue); % turn on cue
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, cue_time);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject([fixation_point cue])
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end
toggleobject(cue); % turn off sample

% delay epoch
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, delay);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(fixation_point)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% choice presentation and response
toggleobject([fixation_point target]); % simultaneously turns of fix point and displays target & distractor
[ontarget rt] = eyejoytrack('holdfix', fixation_point, fix_radius, max_reaction_time); % rt will be used to update the graph on the control screen
if ontarget, % max_reaction_time has elapsed and is still on fix spot
    trialerror(1); % no response
    toggleobject(target)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end
ontarget = eyejoytrack('acquirefix', target, fix_radius, saccade_time);
if ~ontarget,
    trialerror(2); % no or late response (did not land on either the target or distractor)
    toggleobject(target)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
elseif ontarget == 2,
    trialerror(6); % chose the wrong (second) object among the options [target distractor]
    toggleobject(target)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% hold target then reward
ontarget = eyejoytrack('holdfix', target, fix_radius, hold_target_time);
if ~ontarget,
    trialerror(5); % broke fixation
    toggleobject(target)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end
trialerror(0); % correct
goodmonkey(reward_value); % 50ms of juice x 3

toggleobject(target); %turn off remaining objects