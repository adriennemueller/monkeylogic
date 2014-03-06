%dms (timing script)

% This task requires that either an "eye" input or joystick (attached to the
% eye input channels) is available to perform the necessary responses.
%
% During a real experiment, a task such as this should make use of the
% "eventmarker" command to keep track of key actions and state changes (for
% instance, displaying or extinguishing an object, initiating a movement, etc).

% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
sample = 2;
target = 3;
distractor = 4;

% define time intervals (in ms):
wait_for_fix = 1000;
initial_fix = 1000;
sample_time = 500;
delay = 1500;
max_reaction_time = 500;
saccade_time = 80;
hold_target_time = 300;

% fixation window (in degrees):
fix_radius = 1;

% TASK:

% initial fixation:
toggleobject(fixation_point);
ontarget = eyejoytrack('acquirefix', fixation_point, fix_radius, wait_for_fix);
if ~ontarget,
    trialerror(4); % no fixation
    toggleobject(fixation_point)
    return
end
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, initial_fix);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(fixation_point)
    return
end


% sample epoch
toggleobject(sample); % turn on sample
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, sample_time);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject([fixation_point sample])
    return
end
toggleobject(sample); % turn off sample

% delay epoch
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, delay);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(fixation_point)
    return
end

% choice presentation and response
toggleobject([fixation_point target distractor]); % simultaneously turns of fix point and displays target & distractor
[ontarget rt] = eyejoytrack('holdfix', fixation_point, fix_radius, max_reaction_time); % rt will be used to update the graph on the control screen
if ontarget, % max_reaction_time has elapsed and is still on fix spot
    trialerror(1); % no response
    toggleobject([target distractor])
    return
end
ontarget = eyejoytrack('acquirefix', [target distractor], fix_radius, saccade_time);
if ~ontarget,
    trialerror(2); % no or late response (did not land on either the target or distractor)
    toggleobject([target distractor])
    return
elseif ontarget == 2,
    trialerror(6); % chose the wrong (second) object among the options [target distractor]
    toggleobject([target distractor])
    return
end

% hold target then reward
ontarget = eyejoytrack('holdfix', target, fix_radius, hold_target_time);
if ~ontarget,
    trialerror(5); % broke fixation
    toggleobject([target distractor])
    return
end
trialerror(0); % correct
goodmonkey(50); % 50ms of juice x 3

toggleobject([target distractor]); %turn off remaining objects