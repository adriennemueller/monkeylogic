%lp_dstrctr_choice (timing script)

% This task requires the animal to hold a lever down for a specific length of time.

% give names to the TaskObjects defined in the conditions file:
start_spot = 1;
cue = 2;
targ1 = 3;
targ2 = randi([3 4],1);
dist1 = 5;
dist2 = randi([5 6],1);

% define time intervals (in ms):
wait_press = 1000;
hold_time = 400;
wait_release = 1000;

% TASK:

% show fix spot:
toggleobject(start_spot, 'eventmarker', 120) % Fixation Spot Shown

% Here '1' refers to the button/lever index, and not the target
pressed = eyejoytrack('acquiretouch', 1, [], wait_press);
if ~pressed
    trialerror(1); % didn't press in time
    toggleobject(start_spot, 'eventmarker', 125)%Didn't press  by end of fixation cue
    idle(200, [1, 0, 0]);
    return
end

toggleobject(start_spot); %Off
toggleobject([cue targ1 dist1], 'eventmarker', 121);

held = eyejoytrack('holdtouch', 1, [], hold_time);
if ~held,
    % flip red
    trialerror(2); % released too early
    toggleobject([cue targ1 dist1], 'eventmarker', 126); %Released too soon
    idle(200, [1, 0, 0]);
    return
end

toggleobject([targ1 dist1 targ2 dist2]);

if (targ2 == 2)
    eventmarker(122); % Targ Same
elseif (targ2 == 3)
    eventmarker(123); % Targ Change
end

if (dist2 == 5)
    eventmarker(129); % Distractor Same
elseif (dist2 == 6)
    eventmarker(130); % Distractor Change
end

released = ~eyejoytrack('holdtouch', 1, [], wait_release);
if (released && targ1 == targ2)
    % flip red
    trialerror(3); 
    toggleobject([cue targ2 dist2], 'eventmarker', 127); % Released when should not have
    idle(200, [1, 0, 0]);
    return
end


if (~released && targ1 ~= targ2)
    toggleobject([cue targ2 dist2], 'eventmarker', 128 );
    % flip red
    trialerror(4); % didn't release in time
    idle(200, [1, 0, 0]);
    return
end

toggleobject( [cue targ2 dist2], 'eventmarker', 124); % Performed Correctly

trialerror(0); % correct
goodmonkey(50);
