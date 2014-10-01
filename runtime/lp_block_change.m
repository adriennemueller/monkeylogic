function NewBlock = lp_block_change(TrialRecord)

NewBlock = 0; % default = continue current block
minTrials = 10; % the number of correct trials in-a-row to reach criterion
thresh = 0.75;
t = TrialRecord.CurrentTrialWithinBlock; % t is the ordinal number of the current trial within the current block
errs = TrialRecord.TrialErrors; % vector of trial errors; each element = 0 when a trial is correct
b = TrialRecord.CurrentBlock; % b is the current Block being played (not ordinal block number)
B = TrialRecord.BlocksSelected; % the vector of blocks available to be played, as selected in the Main Menu

disp('Initialized.' );

if t < minTrials,
  return
end

disp('Made it past minTrials test.' );

recentvec = errs(end-minTrials+1:end);
disp(['Length recentvec: ' num2str(length(recentvec)) ]);

frac = length(find(recentvec==0)) / minTrials;
disp('Calculated frac.');
disp(['Frac: ' num2str(frac) ]);

if frac <= thresh,
  return 
end
disp( 'Compared Frac with thresh.' );

% criterion has been reached, so select a new block
highestBlock = max(B);

if b == highestBlock,
    return
end

disp( 'Selected New Block.' );

NewBlock = b+1;
