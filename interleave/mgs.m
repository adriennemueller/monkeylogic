%mgs (timing script)

% This task requires the animal to hold their gaze steady on a central
% fixation spot while a peripheral cue is flashed; then maintain fixation
% during a delay period; then make an eye movement to the remembered
% location.

editable( 'fix_radius', 'reward_value', 'initial_fix', 'cue_time', 'delay', 'saccade_time', 'hold_target_time' );

% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
cue = 2;
target = 3;

% define time intervals (in ms):
wait_for_fix = 1000;
initial_fix = 300;
cue_time = 80;
delay = 500;
max_reaction_time = 500;
saccade_time = 80;
hold_target_time = 200;

% fixation window (in degrees):
fix_radius = 1.3;

reward_value = 300;

%%% Trial Errors %%%
% 0   Correct.
% 1   No initial fixation.
% 2   Broke fixation.
% 3   Did not react.
% 4  Reacted but did not capture target.



% TASK:

% initial fixation:
toggleobject(fixation_point, 'eventmarker', 120);
ontarget = eyejoytrack('acquirefix', fixation_point, fix_radius, wait_for_fix);
if ~ontarget,
    trialerror(1); % no fixation
    toggleobject(fixation_point, 'eventmarker', 121)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, initial_fix);
if ~ontarget,
    trialerror(2); % broke fixation
    toggleobject(fixation_point, 'eventmarker', 122)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end


% cue epoch
toggleobject(cue, 'eventmarker', 123); % turn on cue
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, cue_time);
if ~ontarget,
    trialerror(2); % broke fixation
    toggleobject([fixation_point cue], 'eventmarker', 124)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end
toggleobject(cue, 'eventmarker', 125); % turn off sample

% delay epoch
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, delay);
if ~ontarget,
    trialerror(2); % broke fixation
    toggleobject(fixation_point, 'eventmarker', 126)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% choice presentation and response
toggleobject([fixation_point target], 'eventmarker', 127); % simultaneously turns of fix point and displays target & distractor
[ontarget rt] = eyejoytrack('holdfix', fixation_point, fix_radius, max_reaction_time); % rt will be used to update the graph on the control screen
if ontarget, % max_reaction_time has elapsed and is still on fix spot
    trialerror(3); % no response
    toggleobject(target, 'eventmarker', 128)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

ontarget = eyejoytrack('acquirefix', target, fix_radius, saccade_time);
if ~ontarget,
    trialerror(4); % no or late response (did not land on the target)
    toggleobject(target, 'eventmarker', 129)
    idle(200, [1, 0, 0]); % Red Error Screen
    return

end

% hold target then reward
ontarget = eyejoytrack('holdfix', target, fix_radius, hold_target_time);
if ~ontarget,
    trialerror(2); % broke fixation
    toggleobject(target, 'eventmarker', 130)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

trialerror(0); % correct
toggleobject(target, 'eventmarker', 131); %turn off remaining objects
goodmonkey(reward_value); % juice

