%lp_dstrctr_cued_mobile_blank (timing script)

% Presents two opposing targets, one of which may flip. A cue is
% presented. Subject must hold a lever
% pressed down and then release the lever if one of the targets flips.
% Targets will blank briefly in
% between initial presentation and potential flip.

% Naming for TaskObjects defined in the conditions file:
start_spot = 1;
targ1 = 2;
targ1new = 3;
targ2 = 4;
targ2new = 5;
cue = 6;

editable( 'reward', 'blank_time' );

% Define Time Intervals (in ms):
wait_press = 1000;
hold_time = 300;
blank_time = 5;
hold_time_postcue = 400;
wait_release = 1000;

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


%%%%%%%%% TASK %%%%%%%%

% Show Fixation Spot, Cues the Beginning of a Trial:
toggleobject(start_spot, 'eventmarker', 120) % Fixation Spot Shown

% Waits for press
pressed = eyejoytrack('acquiretouch', 1, [], wait_press); % Here '1' =button/lever index, not the target
if ~pressed
    toggleobject(start_spot, 'eventmarker', 125) % Didn't press by end of fixation cue
    trialerror(1); % Didn't press in time
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Turn on Targets
toggleobject([targ1 targ2], 'eventmarker', 121);

% Tests lever remains pressed
held = eyejoytrack('holdtouch', 1, [], hold_time);
if ~held,
    toggleobject([start_spot targ1 targ2], 'eventmarker', 126); %Turn off fixation spot and targets
    trialerror(2); % Released too soon
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Turn on Cue
toggleobject(cue,'eventmarker', 131); % Cue on

% Keep Lever Pressed while Cue is on
held = eyejoytrack('holdtouch', 1, [], hold_time_postcue);
if ~held,
    toggleobject([start_spot cue targ1 targ2], 'eventmarker', 126); % Turn off cue
    trialerror(2); % Released too early
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

%Blank Targets
toggleobject([targ1 targ2], 'eventmarker',134);
held = eyejoytrack('holdtouch', 1, [], blank_time);
if ~held,
    toggleobject([start_spot cue], 'eventmarker', 135); % Turn off fix spot
    trialerror(2); % Released too early
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Change targets or distractors (different or the same)
toggleobject([targ1new targ2new]);

% Wait for release
released = ~eyejoytrack('holdtouch', 1, [], wait_release);

if (released && (comb == 1))
    toggleobject([start_spot cue targ1new targ2new], 'eventmarker', 127); %Turn off fixation spot and targets
    trialerror(3); % Released when should not have
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end

if (~released && (comb == 2))
    toggleobject([start_spot cue targ1new targ2new], 'eventmarker', 128); %Turn off fixation spot and targets
    trialerror(4); % Did not release in time
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end

toggleobject([start_spot cue targ1new targ2new], 'eventmarker', 124); %Turn off fixation spot and targets
trialerror(0); % Correct

% Reward
goodmonkey(reward);
