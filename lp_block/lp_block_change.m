function NewBlock = lp_block_change(TrialRecord)

NewBlock = 0; % default = continue current block
minTrials = 30; % the number of correct trials in-a-row to reach criterion
thresh = 0.75;
t = TrialRecord.CurrentTrialWithinBlock; % t is the ordinal number of the current trial within the current block
errs = TrialRecord.TrialErrors; % vector of trial errors; each element = 0 when a trial is correct
b = TrialRecord.CurrentBlock; % b is the current Block being played (not ordinal block number)
B = TrialRecord.BlocksSelected; % the vector of blocks available to be played, as selected in the Main Menu

if t < minTrials,
  return
end

recentvec = errs(end-minTrials+1:end);

frac = length(find(recentvec==0)) / minTrials;

if frac <= thresh,
	if b == 1
		NewBlock = 0;
	else
		NewBlock = b-1;
	end
	return 
end
disp( 'Compared Frac with thresh.' );

% criterion has been reached, so select a new block
highestBlock = max(B);

if b == highestBlock,
    return
end

NewBlock = b+1;
