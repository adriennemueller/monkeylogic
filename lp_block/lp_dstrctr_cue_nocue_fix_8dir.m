%lp_dstrctr_cue_nocue_blank_fix_8dir

% Presents two opposing targets, one of which may flip. Cue is
% presented. Subject must fixate on a central fixation spot with the lever
% pressed down and then release the lever if one if the cued target flips -
% all the while, maintaining fixation. Targets will blank briefly in
% between initial presentation and potential flip. This version of the task
% allows the user to set the position of the targets (and the cue).


% Naming for TaskObjects defined in the conditions file:
start_spot = 1;
targ1 = 2;
targ1new = 3;
targ2 = 4;
targ2new = 5;
cue = 6;
neutcue = 7;


editable( 'reward', 'fix_radius', 'wait_release', 'hold_time', 'pre_hold_time', 'blank_time', 'spec_radius', 'neut_cue', 'invalid_cue');

% Define Time Intervals (in ms):
wait_for_fix = 1000;
wait_press = 1000;
pre_hold_time = 300;
hold_time = 300;
cue_time = 500;
blank_time = 300;
wait_release = 1000;

fix_radius = 0.7;
spec_theta = 0; % No movie frame / angle specified by default.
spec_radius = 4.5; % Default radius for target presentations.
neut_cue = 5; % 5% of trials are neutrally cued by default. Up to 40% should be doable.
invalid_cue = 0; % 0% of trials are invalidly cued by default. Between 7 and 20% would be good.
eight_dir = 1;

% Define Reward Duration
reward = 225;

tmpstruct = TrialRecord.CurrentConditionStimulusInfo;

% Identify from conditions files whether the target changes or stays the same.
if strcmp(tmpstruct{2}.Name, tmpstruct{3}.Name)
	comb = 1; eventmarker(142); %No Change
elseif ~strcmp(tmpstruct{2}.Name, tmpstruct{3}.Name) 
	comb = 2; eventmarker(143); %First Target Change
end
bhv_variable( 'comb', comb );

%Probability of the being a Neutral Trial
prob1 = neut_cue / 100;
prob2 = 1 - prob1;

nocue = [0 1];
nocue_prob = [prob2 prob1];
rand_nocueidx = sum( rand >= cumsum([0,nocue_prob]) ); 
rand_nocue = nocue( rand_nocueidx );
bhv_variable( 'nocue', rand_nocue );
if rand_nocue
    cue = neutcue;
end

%Probability of being an Invalidly Cued Trial 
% Not Additive with Neutral Cue Trials
cue_shift = 0;
if ( invalid_cue > 0 ) %&& ( neut_cue == 0 )
    disp(num2str(invalid_cue));
    iv_prob1 = invalid_cue / 100;
    iv_prob2 = 1 - iv_prob1;

    iv_cue = [0 1];
    iv_cue_prob = [iv_prob2 iv_prob1];
    rand_iv_cueidx = sum( rand >= cumsum([0,iv_cue_prob]) ); 
    rand_iv_cue = iv_cue( rand_iv_cueidx );
    bhv_variable( 'iv_cue', rand_iv_cue );
    if rand_iv_cue % Switch targ1 with targ2. Targ1 is the only one that will ever change. So half of these trials will still be validly cued.
        cue_shift = 180;
    end
end

% %Reposition Objects to New Locations

Orig_XPos = tmpstruct{2}.XPos;
Orig_YPos = tmpstruct{2}.YPos;
theta = cart2pol( Orig_XPos, Orig_YPos )
thetaDeg = theta * 180 / pi
if thetaDeg < 0
    thetaDeg = 360 + thetaDeg
end
    
if thetaDeg + cue_shift > 360
    cue_theta = thetaDeg - cue_shift;
else
    cue_theta = thetaDeg + cue_shift;
end

cue_theta
cue_frame = round( cue_theta / 10 ) + 1 %While still in degrees.
bhv_variable( 'theta', theta );



[new_targ_xpos, new_targ_ypos] = pol2cart(theta, spec_radius); %Convert to polar coordinates
bhv_variable( 'radius', spec_radius );

if isfield(TrialRecord, 'theta')
    thetas = TrialRecord.theta;
    thetas = [thetas theta];
else
    TrialRecord.theta = [];
end

if isfield(TrialRecord, 'radius')
    radii = TrialRecord.radius;
    radii = [radii spec_radius];
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

% Mirror Distractor to Opposing Coordinates
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
    toggleobject(start_spot, 'eventmarker', 123); %Turn off fixation spot and targets
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

% Turn on Cue
toggleobject(cue, 'MovieStartFrame', cue_frame, 'MovieStep', 0, 'eventmarker', 133);


% Tests lever remains pressed while fixating
state = eyejoytrack('holdtouch', 1, [], 'holdfix', start_spot, fix_radius, cue_time);
held = state(1); fixated = state(2);
if (~held) || (~fixated)
    toggleobject([start_spot cue targ1 targ2], 'eventmarker', 125); %Turn off fixation spot and targets
    trialerror(3); % Released too soon or broke fix
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

toggleobject([targ1 targ2], 'eventmarker',126);
% state = eyejoytrack('holdtouch', 1, [], 'holdfix', start_spot, fix_radius, blank_time);
% held = state(1); fixated = state(2);
% if (~held) || (~fixated)
%     toggleobject([start_spot, cue], 'eventmarker', 127); % Turn off fix spot
%     trialerror(3); % Released too early or broke fix
%     idle(200, [1, 0, 0]); % Red Error Screen
%     return
% end




% Change targets or distractors (different or the same)
toggleobject([targ1new targ2new], 'eventmarker', 128);

% Wait for release
state = eyejoytrack('holdtouch', 1, [], 'holdfix', start_spot, fix_radius, wait_release);
not_released = state(1);
fixated = state(2);

if (~fixated)
    toggleobject([start_spot, cue, targ1new targ2new], 'eventmarker', 129); %Turn off fixation spot and targets
    trialerror(3); %Did not maintain fixation
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end


if (~not_released && (comb == 1))
    toggleobject([start_spot, cue, targ1new targ2new], 'eventmarker', 130); %Turn off fixation spot and targets
    trialerror(4); % Released when should not have
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end

if (not_released && (comb == 2))
    toggleobject([start_spot, cue, targ1new targ2new], 'eventmarker', 131); %Turn off fixation spot and targets
    trialerror(5); % Did not release in time
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end

toggleobject([start_spot, cue, targ1new targ2new], 'eventmarker', 132); %Turn off fixation spot and targets
trialerror(0); % Correct

% Reward
goodmonkey(reward);

