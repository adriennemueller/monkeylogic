%lp_dstrctr_nocue_mobile_mTilt (timing script)

% Naming for TaskObjects defined in the conditions file:
start_spot = 1;
targ1 = 2;
targ1new = 3;
targ2 = 4;
targ2new = 5;

% Define Time Intervals (in ms):
idle_time = 750;

% Generate 'start frames' for initial target presentations
t1_tilt1 = 45;
t2_tilt1 = 45;


% Generate 'tilted frames' for target
t1_tilt2 = 90;
t2_tilt2 = 90;

%%%%%%%%% TASK %%%%%%%%

% Show Fixation Spot, Cues the Beginning of a Trial:
toggleobject(start_spot, 'eventmarker', 120) % Fixation Spot Shown

% Turn on Targets
toggleobject([targ1 targ2], 'MovieStartFrame', [t1_tilt1 t2_tilt1], 'MovieStep', 0, 'eventmarker', 121);

idle(idle_time);

% Change targets or distractors (different or the same)
toggleobject([targ1 targ2]);
toggleobject([targ1new targ2new], 'MovieStartFrame', [t1_tilt2 t2_tilt2], 'MovieStep', 0);

idle(idle_time);

trialerror(0); % Correct
