%lp_dstrctr_nocue_mobile_blank_fix (timing script)

% Naming for TaskObjects defined in the conditions file:
start_spot = 1;
targ1 = 2;
targ1new = 3;
targ2 = 4;
targ2new = 5;

editable( 'span', 'reward', 'fix_radius', 'wait_release', 'hold_time', 'pre_hold_time', 'blank_time' );

% Define Time Intervals (in ms):
wait_for_fix = 1000;
wait_press = 1000;
pre_hold_time = 300;
hold_time = 300;
blank_time = 20;
wait_release = 1000;

fix_radius = 1.3;

% Define Reward Duration
reward = 300;

tmpstruct = TrialRecord.CurrentConditionStimulusInfo;

% Identify from conditions files whether the target changes or stays the same.
if strcmp(tmpstruct{2}.Name, tmpstruct{3}.Name)
	comb = 1; eventmarker(142); %No Change
elseif ~strcmp(tmpstruct{2}.Name, tmpstruct{3}.Name) 
	comb = 2; eventmarker(143); %First Target Change
end
bhv_variable( 'comb', comb );

%Reposition Objects to New Locations
span = 360; 
shift = span/2;

theta = randi(span)-shift; %Get Random Angle
if theta < 0
     theta = 360 + theta;
end

theta = theta * pi/180;
bhv_variable( 'theta', theta );


radius = 3; %randi(5); %Get Randum Radius between 1 and 5
[new_targ_xpos, new_targ_ypos] = pol2cart(theta, radius); %Convert to polar coordinates
bhv_variable( 'radius', radius );

if isfield(TrialRecord, 'theta')
    thetas = TrialRecord.theta;
    thetas = [thetas theta];
else
    TrialRecord.theta = [];
end

if isfield(TrialRecord, 'radius')
    radii = TrialRecord.radius;
    radii = [radii radius];
else
    TrialRecord.radius = [];
end

if isfield(TrialRecord, 'comb')
    combs = TrialRecord.comb;
    combs = [combs comb];
else
    TrialRecord.comb = [];
end

success = reposition_object(targ1, new_targ_xpos, new_targ_ypos);
success = reposition_object(targ1new, new_targ_xpos, new_targ_ypos);

%Mirror Distractor to Opposing Coordinates
success = reposition_object(targ2, (-1 * new_targ_xpos), (-1 * new_targ_ypos));
success = reposition_object(targ2new, (-1 * new_targ_xpos), (-1 * new_targ_ypos));


%%% Trial Errors %%%
% 0   No Error
% 1   Did not acquire fixation
% 2   Did not press down lever
% 3   Broke fixation or released lever prematurely
% 4   Released when should not have
% 5   Did not release in time
   



%%%%%%%%% TASK %%%%%%%%

% Show Fixation Spot, Cues the Beginning of a Trial:
toggleobject(start_spot, 'eventmarker', 120) % Fixation Spot Shown
ontarget = eyejoytrack('acquirefix', start_spot, fix_radius, wait_for_fix);
if ~ontarget,
    trialerror(1); % no fixation
    toggleobject(start_spot, 'eventmarker', 121)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Waits for press
state = eyejoytrack('holdfix', start_spot, fix_radius, 'acquiretouch', 1, [], wait_press); % Here '1' =button/lever index, not the target
fixated = state(1); pressed = state(2);
if (~pressed) || (~fixated)
    toggleobject(start_spot, 'eventmarker', 122) % Didn't press by end of fixation cue, or broke fixation
    trialerror(2); % Didn't press in time or broke fix
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

state = eyejoytrack('holdtouch', 1, [], 'holdfix', start_spot, fix_radius, pre_hold_time);
held = state(1); fixated = state(2);
if (~held) || (~fixated)
    toggleobject([start_spot targ1 targ2], 'eventmarker', 123); %Turn off fixation spot and targets
    trialerror(3); % Released too soon or broke fix
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Turn on Targets
toggleobject([targ1 targ2], 'eventmarker', 124);

% Tests lever remains pressed while fixating
state = eyejoytrack('holdtouch', 1, [], 'holdfix', start_spot, fix_radius, hold_time);
held = state(1); fixated = state(2);
if (~held) || (~fixated)
    toggleobject([start_spot targ1 targ2], 'eventmarker', 125); %Turn off fixation spot and targets
    trialerror(3); % Released too soon or broke fix
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

toggleobject([targ1 targ2], 'eventmarker',126);
state = eyejoytrack('holdtouch', 1, [], 'holdfix', start_spot, fix_radius, blank_time);
held = state(1); fixated = state(2);
if (~held) || (~fixated)
    toggleobject([start_spot], 'eventmarker', 127); % Turn off fix spot
    trialerror(3); % Released too early or broke fix
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Change targets or distractors (different or the same)
toggleobject([targ1new targ2new], 'eventmarker', 128);

% Wait for release
state = eyejoytrack('holdtouch', 1, [], 'holdfix', start_spot, fix_radius, wait_release);
not_released = state(1);
fixated = state(2);

if (~fixated)
    toggleobject([start_spot targ1new targ2new], 'eventmarker', 129); %Turn off fixation spot and targets
    trialerror(3); %Did not maintain fixation
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end


if (~not_released && (comb == 1))
    toggleobject([start_spot targ1new targ2new], 'eventmarker', 130); %Turn off fixation spot and targets
    trialerror(4); % Released when should not have
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end

if (not_released && (comb == 2))
    toggleobject([start_spot targ1new targ2new], 'eventmarker', 131); %Turn off fixation spot and targets
    trialerror(5); % Did not release in time
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end

toggleobject([start_spot targ1new targ2new], 'eventmarker', 132); %Turn off fixation spot and targets
trialerror(0); % Correct

% Reward
goodmonkey(reward);


