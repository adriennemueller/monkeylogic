% RF_hold_fix_task

% This task rewards animals for maintaining fixation while a distractor
% (target) is flashed on the screen.

editable( 'fix_radius', 'reward_val', 'pre_flash_dur', 'flash_dur', 'post_flash_dur', 'spec_theta', 'spec_radius' );


% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
target = 2;

% define time intervals (in ms):
wait_for_fix = 1000;
pre_flash_dur = 400;
post_flash_dur = 300;
flash_dur = 100;

% fixation window (in degrees):
fix_radius = 1;
reward_val = 100;

% Target Positioning
spec_theta = 0; % No movie frame / angle specified by default.
spec_radius = 0; % Default radius for target presentations - > results in random radii.

span = 360;
Preferred = randi([0, 1], 1, 1); % Decide whether it will be a preferred or non-preferred direction trial.
 
if spec_theta
	if Preferred
		theta = spec_theta;
 	elseif ~Preferred
		if spec_theta < 180
			theta = spec_theta + 180;
		elseif spec_theta > 180
			theta = spec_theta - 180;
		end
	end
else
	theta = randi(span); %Get Random Angle
    theta = round(theta*10^(-1))/(10^(-1)); %Round to the nearest 10
end
 
cue_frame = round(theta/10) + 1; %While still in degrees.
theta = theta * pi/180;
bhv_variable( 'theta', theta );
 

if spec_radius
    radius = spec_radius;
else
    radius = randi(4); %Get Randum Radius between 1 and 5
end
bhv_variable( 'radius', radius );

[new_targ_xpos, new_targ_ypos] = pol2cart(theta, radius); %Convert to polar coordinates
 
success = reposition_object(target, new_targ_xpos, new_targ_ypos);

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

ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, pre_flash_dur);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(fixation_point)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% flash distractor
toggleobject(target); % display target
[ontarget rt] = eyejoytrack('holdfix', fixation_point, fix_radius, flash_dur); % rt will be used to update the graph on the control screen
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject([target, fixation_point]);
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

toggleobject(target); % turn off target
ontarget = eyejoytrack('holdfix', fixation_point, fix_radius, post_flash_dur);
if ~ontarget,
    trialerror(3); % broke fixation
    toggleobject(fixation_point)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end


trialerror(0); % correct
goodmonkey(reward_val); % juice

toggleobject(fixation_point); %turn off target