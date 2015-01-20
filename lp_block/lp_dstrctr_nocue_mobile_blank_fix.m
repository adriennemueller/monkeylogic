%lp_dstrctr_nocue_mobile_blank_fix (timing script)

% Naming for TaskObjects defined in the conditions file:
start_spot = 1;
targ1 = 2;
targ1new = 3;
targ2 = 4;
targ2new = 5;

editable( 'span', 'reward', 'fix_radius', 'wait_release', 'hold_time', 'pre_hold_time', 'blank_time' );

% Define Time Intervals (in ms):
wait_press = 1000;
hold_time = 300;
pre_hold_time = 300;
blank_time = 20;
wait_release = 1000;

wait_for_fix = 1000;

fix_radius = 1.5;

% Define Reward Duration
reward = 300;

tmpstruct = TrialRecord.CurrentConditionStimulusInfo;

if strcmp(tmpstruct{2}.Name, tmpstruct{3}.Name)
	comb = 1; eventmarker(132); %No Change
	%disp('Comb = 1, ' 'T1: ' [tmpstruct{2}.Name] ' T1 New: ' [tmpstruct{3}.Name] ' T2: ' [tmpstruct{4}.Name] ' T2 New: ' [tmpstruct{5}.Name] );
elseif ~strcmp(tmpstruct{2}.Name, tmpstruct{3}.Name) 
	comb = 2; eventmarker(133); %First Change
	%disp('Comb = 2, ' 'T1: ' [tmpstruct{2}.Name] ' T1 New: ' [tmpstruct{3}.Name] ' T2: ' [tmpstruct{4}.Name] ' T2 New: ' [tmpstruct{5}.Name]);
end


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

success = reposition_object(targ1, new_targ_xpos, new_targ_ypos);
success = reposition_object(targ1new, new_targ_xpos, new_targ_ypos);

%Mirror Distractor to Opposing Coordinates
success = reposition_object(targ2, (-1 * new_targ_xpos), (-1 * new_targ_ypos));
success = reposition_object(targ2new, (-1 * new_targ_xpos), (-1 * new_targ_ypos));



%%%%%%%%% TASK %%%%%%%%

% Show Fixation Spot, Cues the Beginning of a Trial:
toggleobject(start_spot, 'eventmarker', 120) % Fixation Spot Shown
ontarget = eyejoytrack('acquirefix', start_spot, fix_radius, wait_for_fix);
if ~ontarget,
    trialerror(4); % no fixation
    toggleobject(start_spot)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Waits for press
state = eyejoytrack('holdfix', start_spot, fix_radius, 'acquiretouch', 1, [], wait_press); % Here '1' =button/lever index, not the target
fixated = state(1); pressed = state(2);
if (~pressed) || (~fixated)
    toggleobject(start_spot, 'eventmarker', 125) % Didn't press by end of fixation cue
    trialerror(1); % Didn't press in time
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

state = eyejoytrack('holdtouch', 1, [], 'holdfix', start_spot, fix_radius, pre_hold_time);
held = state(1); fixated = state(2);
if (~held) || (~fixated)
    toggleobject([start_spot targ1 targ2], 'eventmarker', 126); %Turn off fixation spot and targets
    trialerror(2); % Released too soon
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Turn on Targets
toggleobject([targ1 targ2], 'eventmarker', 121);

% Tests lever remains pressed while fixating
state = eyejoytrack('holdtouch', 1, [], 'holdfix', start_spot, fix_radius, hold_time);
held = state(1); fixated = state(2);
if (~held) || (~fixated)
    toggleobject([start_spot targ1 targ2], 'eventmarker', 126); %Turn off fixation spot and targets
    trialerror(2); % Released too soon
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

toggleobject([targ1 targ2], 'eventmarker',134);
state = eyejoytrack('holdtouch', 1, [], 'holdfix', start_spot, fix_radius, blank_time);
held = state(1); fixated = state(2);
if (~held) || (~fixated)
    toggleobject([start_spot], 'eventmarker', 135); % Turn off fix spot
    trialerror(2); % Released too early
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Change targets or distractors (different or the same)
toggleobject([targ1new targ2new]);

% Wait for release
state = eyejoytrack('holdtouch', 1, [], 'holdfix', start_spot, fix_radius, wait_release);
not_released = state(1);
fixated = state(2);

if (~fixated)
    toggleobject([start_spot targ1new targ2new], 'eventmarker', 120); %Turn off fixation spot and targets
    trialerror(1); % Need a new number here
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end


if (~not_released && (comb == 1))
    toggleobject([start_spot targ1new targ2new], 'eventmarker', 127); %Turn off fixation spot and targets
    trialerror(3); % Released when should not have
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end

if (not_released && (comb == 2))
    toggleobject([start_spot targ1new targ2new], 'eventmarker', 128); %Turn off fixation spot and targets
    trialerror(4); % Did not release in time
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end

toggleobject([start_spot targ1new targ2new], 'eventmarker', 124); %Turn off fixation spot and targets
trialerror(0); % Correct

% Reward
goodmonkey(reward);
