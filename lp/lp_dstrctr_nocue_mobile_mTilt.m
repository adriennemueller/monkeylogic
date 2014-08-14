%lp_dstrctr_nocue_mobile_mTilt (timing script)

% Naming for TaskObjects defined in the conditions file:
start_spot = 1;
targ1 = 2; targ1new = 3;
targ2 = 4; targ2new = 5;

editable( 'span', 'reward' );

% Define Time Intervals (in ms):
wait_press = 1000;
hold_time = 400;
wait_release = 1000;

% Define Reward Duration
reward = 200;

% Generate 'start frames' for initial target presentations
%t1_tilt1 = randi(360);
%t2_tilt1 = randi(360);
t1_tilt1 = randi(10);
t2_tilt1 = randi(10);

% Generate 'tilted frames' for target
%tilt1 = randi(90); valence1 = randi(2);
tilt1 = 50 + randi(40); valence1 = randi(2);
if valence1 == 1
    t1_tilt2 = t1_tilt1 + tilt1;
else
    t1_tilt2 = t1_tilt1 - tilt1;
end

%tilt2 = randi(90); valence2 = randi(2);
tilt2 = 50 + randi(40); valence2 = randi(2);
if valence2 == 1
    t2_tilt2 = t2_tilt1 + tilt2;
else
    t2_tilt2 = t2_tilt1 - tilt2;
end


if t1_tilt2 > 359
    t1_tilt2 = t1_tilt2 - 359;
elseif t1_tilt2 < 0
    t1_tilt2 = 359 + t1_tilt2;
end

if t2_tilt2 > 359
    t2_tilt2 = t2_tilt2 - 359;
elseif t2_tilt2 < 0
    t2_tilt2 = 359 + t2_tilt2;
end


%Select which of the four combinations the two targets will display as
% 1-2 - neither changes, 3 - 1 changes, 4 - the other changes
comb = randi(4);
if comb <= 2
    t1_tilt2 = t1_tilt1; t2_tilt2 = t2_tilt1; eventmarker(132); % No Change
elseif comb == 3
    t2_tilt2 = t2_tilt1; eventmarker(133); % First Change
elseif comb == 4 
    t1_tilt2 = t1_tilt1; eventmarker(134); % Second Change
end

disp( ['<<< MonkeyLogic >>> Decision (1,2 = SAME), 3 = T1 CHANGE, 4 T2 Change: ' num2str(comb)]);
disp( ['<<< MonkeyLogic >>> Targ1 Tilt1 Post-Decision: ' num2str(t1_tilt1)]);
disp( ['<<< MonkeyLogic >>> Targ2 Tilt1 Post-Decision: ' num2str(t2_tilt1)]);
disp( ['<<< MonkeyLogic >>> Targ1 Tilt2 Post-Decision: ' num2str(t1_tilt2)]);
disp( ['<<< MonkeyLogic >>> Targ2 Tilt2 Post-Decision: ' num2str(t2_tilt2)]);

bhv_variable( 'targ1_tilt1', t1_tilt1 );
bhv_variable( 'targ1_tilt2', t1_tilt2 );
bhv_variable( 'targ2_tilt1', t2_tilt1 );
bhv_variable( 'targ2_tilt2', t2_tilt2 );


%Reposition Objects to New Locations
span = 180; 
shift = span/2;

theta = randi(span)-shift; %Get Random Angle
if theta < 0
     theta = 360 + theta;
end

theta = theta * pi/180;
bhv_variable( 'theta', theta );

%radius = randi(5); %Get Randum Radius between 1 and 5
radius = 1 + randi(3); %Radius between 2 and 4;
bhv_variable( 'radius', radius );

[new_targ_xpos, new_targ_ypos] = pol2cart(theta, radius); %Convert to cartesian coordinates

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

% Waits for press
pressed = eyejoytrack('acquiretouch', 1, [], wait_press); % Here '1' =button/lever index, not the target
if ~pressed
    toggleobject(start_spot, 'eventmarker', 125) % Didn't press by end of fixation cue
    trialerror(1); % Didn't press in time
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Turn on Targets
toggleobject([targ1 targ2], 'MovieStartFrame', [t1_tilt1 t2_tilt1], 'MovieStep', 0, 'eventmarker', 121);

% Tests lever remains pressed
held = eyejoytrack('holdtouch', 1, [], hold_time);
if ~held,
    toggleobject([start_spot targ1 targ2], 'eventmarker', 126); %Turn off fixation spot and targets
    trialerror(2); % Released too soon
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Change targets or distractors (different or the same)
toggleobject([targ1 targ2]);
toggleobject([targ1new targ2new], 'MovieStartFrame', [t1_tilt2 t2_tilt2], 'MovieStep', 0);

% Wait for release
released = ~eyejoytrack('holdtouch', 1, [], wait_release);

if (released && (comb <= 2))
    toggleobject([start_spot targ1new targ2new], 'eventmarker', 127); %Turn off fixation spot and targets
    trialerror(3); % Released when should not have
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end

if (~released && (comb >= 3))
    toggleobject([start_spot targ1new targ2new], 'eventmarker', 128); %Turn off fixation spot and targets
    trialerror(4); % Did not release in time
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end

toggleobject([start_spot targ1new targ2new], 'eventmarker', 124); %Turn off fixation spot and targets
trialerror(0); % Correct
goodmonkey(reward); % Reward
