%mgs (timing script)

% This task requires the animal to hold their gaze steady on a central
% fixation spot while a peripheral cue is flashed; then maintain fixation
% during a delay period; then make an eye movement to the remembered
% location.

editable( 'fix_win', 'reward_value', 'initial_fix', 'cue_time', 'delay', 'saccade_time', 'hold_target_time', 'targ_win', 'radius', 'spec_theta' );

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

% fixation windows (in MLUs):
fix_win = 1.3;
targ_win = 2;

spec_theta = 0; %Not Ideal. What if want to have preferred direction == 0?

reward_value = 300;

%%% Trial Errors %%%
% 0   Correct.
% 1   No initial fixation.
% 2   Broke fixation.
% 3   Did not react.
% 4  Reacted but did not capture target.



%Reposition Objects to New Locations
span = 360; 
shift = span/2;
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
	disp( ['Spec_theta: ' num2str(spec_theta)] );
else
	theta = randi(span)-shift; %Get Random Angle
end

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

success = reposition_object(cue, new_targ_xpos, new_targ_ypos);
success = reposition_object(target, new_targ_xpos, new_targ_ypos);


% TASK:

% initial fixation:
toggleobject(fixation_point, 'eventmarker', 120);
ontarget = eyejoytrack('acquirefix', fixation_point, fix_win, wait_for_fix);
if ~ontarget,
    trialerror(1); % no fixation
    toggleobject(fixation_point, 'eventmarker', 121)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end
ontarget = eyejoytrack('holdfix', fixation_point, fix_win, initial_fix);
if ~ontarget,
    trialerror(2); % broke fixation
    toggleobject(fixation_point, 'eventmarker', 122)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end


% cue epoch
toggleobject(cue, 'eventmarker', 123); % turn on cue
ontarget = eyejoytrack('holdfix', fixation_point, fix_win, cue_time);
if ~ontarget,
    trialerror(2); % broke fixation
    toggleobject([fixation_point cue], 'eventmarker', 124)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end
toggleobject(cue, 'eventmarker', 125); % turn off sample

% delay epoch
ontarget = eyejoytrack('holdfix', fixation_point, fix_win, delay);
if ~ontarget,
    trialerror(2); % broke fixation
    toggleobject(fixation_point, 'eventmarker', 126)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% choice presentation and response
toggleobject(fixation_point, 'eventmarker', 127); % turns off fixation point
[ontarget rt] = eyejoytrack('holdfix', fixation_point, fix_win, max_reaction_time); % rt will be used to update the graph on the control screen
if ontarget, % max_reaction_time has elapsed and is still on fix spot
    trialerror(3); % no response
    %toggleobject(target, 'eventmarker', 128)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

ontarget = eyejoytrack('acquirefix', target, targ_win, saccade_time);
if ~ontarget,
    trialerror(4); % no or late response (did not land on the target)
    %toggleobject(target, 'eventmarker', 129)
    idle(200, [1, 0, 0]); % Red Error Screen
    return

end

% hold target then reward
ontarget = eyejoytrack('holdfix', target, targ_win, hold_target_time);
if ~ontarget,
    trialerror(2); % broke fixation
    %toggleobject(target, 'eventmarker', 130)
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

trialerror(0); % correct
%toggleobject(target, 'eventmarker', 131); %turn off remaining object
goodmonkey(reward_value); % juice

