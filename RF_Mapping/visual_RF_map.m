%visual_RF_map

% Presents a target at fixed screen positions while the animal fixates.

% Naming for TaskObjects defined in the conditions file:
start_spot = 1;
targ1 = 2;

editable( 'reward', 'fix_radius', 'hold_time', 'flash_duration');

% Define Time Intervals (in ms):
wait_for_fix = 1000;
hold_time = 200;
flash_duration = 300;
fix_radius = 1;

% Define Reward Duration
reward = 80;


% Reposition Objects to New Locations
x_positions = [-6 -4 -2 0 2 4 6];
% These correspond to EventMarkers 140, 142, 144, 146, 148, 150, 152;

y_positions = [-6 -4 -2 2 4 6];
% These correspond to EventMarkers 140, 142, 144, 148, 150, 152;


new_xpos = randsample(x_positions,1);
new_ypos = randsample(y_positions,1);

xposEM = new_xpos + 146; % For EventMarkers
yposEM = new_ypos + 146; % For EventMarkers

bhv_variable( 'xpos', new_xpos );
bhv_variable( 'ypos', new_ypos );

if isfield(TrialRecord, 'xpos')
    xposes = TrialRecord.xpos;
    xposes = [xposes new_xpos];
else
    TrialRecord.xpos = [];
end

if isfield(TrialRecord, 'ypos')
    yposes = TrialRecord.ypos;
    yposes = [yposes new_ypos];
else
    TrialRecord.ypos = [];
end

success = reposition_object(targ1, new_xpos, new_ypos);

%%% Trial Errors %%%
% 0   No Error
% 1   Did not acquire fixation
% 2   Did not press down lever
% 3   Broke fixation or released lever prematurely


%%%%%%%%% TASK %%%%%%%%

% Show Fixation Spot, Cues the Beginning of a Trial:
toggleobject(start_spot, 'eventmarker', 120) % Fixation Spot Shown
fixated = eyejoytrack('acquirefix', start_spot, fix_radius, wait_for_fix);
disp('Made it here.');
if ~fixated
    trialerror(1); % no fixation
    toggleobject(start_spot, 'eventmarker', 121)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Briefly Maintain Fixation
fixated = eyejoytrack('holdfix', start_spot, fix_radius, hold_time);
disp('And here.');
if ~fixated
    toggleobject(start_spot, 'eventmarker', 123); %Turn off fixation spot and targets
    trialerror(3); % Released too soon or broke fix
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Turn on Target
toggleobject(targ1, 'eventmarker', [124 xposEM yposEM]);

% Tests continued fixation during Stimulus (=Target) Presentation
fixated = eyejoytrack('holdfix', start_spot, fix_radius, flash_duration);
if ~fixated
    toggleobject([start_spot targ1], 'eventmarker', 125); %Turn off fixation spot and targets
    trialerror(3); % Released too soon or broke fix
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end


toggleobject([start_spot, targ1], 'eventmarker', 132); %Turn off fixation spot and targets
trialerror(0); % Correct

% Reward
goodmonkey(reward);

