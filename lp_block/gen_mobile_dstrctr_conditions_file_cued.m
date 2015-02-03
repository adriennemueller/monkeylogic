% Generates a condition file for a cued lever-press distractor-choice task.
% Conditions will be allocated to different blocks, based on difficulty.
% The b_span variable determines how many degrees of visual angle should
% fall within a single block. b_overlap determines how many degrees of
% visual angle should overlap between blocks. The angles in question are
% with regard to the orientaion change of the target and the distractor.

% In this task the target positions are also randomly generated.

function gen_mobile_dstrctr_conditions_file_cued( filename, b_span, b_overlap, nTrials )
    path( path, '../' );

    fid = fopen(filename, 'w');
    
    textline = generate_condition('Header', 6, 'FID', fid);
    fprintf(fid,  '%s\n');

	cond = 0;


	for i = 1:nTrials
		tar1_start = randi(36)*5;
		tar1_end   = randi(36)*5;
		tar2       = randi(36)*5;
		
		if tar1_start == tar1_end
			continue
        end
        
        tposes = gen_target_positions();
        t1x = tposes(1); t1y = tposes(2);
        t2x = tposes(3); t2y = tposes(4);
        cue_angle = tposes(5);
        
		cond = cond + 1;
		blocks = get_blocks( b_span, b_overlap, tar1_start, tar1_end );
		s.t_info = 'T1 Change';
		make_condition(tar1_start, tar1_end, tar2, tar2, t1x, t1y, t2x, t2y, cue_angle, cond, blocks, 1, s, fid);
		
		cond = cond + 1;
		%blocks = get_blocks( b_span, b_overlap, tar1_start, tar1_start );
		s.t_info = 'Same';
		make_condition(tar1_start, tar1_start, tar2, tar2, t1x, t1y, t2x, t2y, cue_angle, cond, blocks, 1, s, fid);
	
    end


    fclose(fid);

end

% This function determines what block a given condition should fall into,
% based on the orientation change.
function blocks = get_blocks( span, overlap, t_s, t_e )

%  |-- span --|
%  {------[---}------]------------
%         |---|
%        overlap

    change = abs(t_s - t_e);
    change = min([change (180 - change)]);
    
        
    num_blocks = ceil(90/(span - overlap));

    if change == 0
        blocks = [1:num_blocks];
        return
    end
    
    blocks = [];
    for i = num_blocks:-1:1
        block_start = (span - overlap) * (i - 1);
        block_end = block_start + span;
        if (block_start <= change) && (change <= block_end)
            blocks = [blocks (num_blocks +1 - i)];
        end
    end
   
    %disp( ['Change: ' num2str(change) ' Blocks: ' num2str(blocks)] );
end

function make_condition(t1_s, t1_e, t2_s, t2_e, t1x, t1y, t2x, t2y, cue_angle, cond, block, freq, s, fid)

    TaskObject(1).Type = 'Fix';
    TaskObject(1).Arg{1} = 0;
    TaskObject(1).Arg{2} = 0;

    TaskObject(2).Type = 'Pic';
    TaskObject(2).Arg{1} = ['rect_' num2str(t1_s)];
    TaskObject(2).Arg{2} = t1x;
    TaskObject(2).Arg{3} = t1y;
    TaskObject(2).Arg{4} = 150;
    TaskObject(2).Arg{5} = 150;

    TaskObject(3).Type = 'Pic';
    TaskObject(3).Arg{1} = ['rect_' num2str(t1_e)];
    TaskObject(3).Arg{2} = t1x;
    TaskObject(3).Arg{3} = t1y;
    TaskObject(3).Arg{4} = 150;
    TaskObject(3).Arg{5} = 150;

    TaskObject(4).Type = 'Pic';
    TaskObject(4).Arg{1} = ['rect_' num2str(t2_s)];
    TaskObject(4).Arg{2} = t2x;
    TaskObject(4).Arg{3} = t2y;
    TaskObject(4).Arg{4} = 150;
    TaskObject(4).Arg{5} = 150;

    TaskObject(5).Type = 'Pic';
    TaskObject(5).Arg{1} = ['rect_' num2str(t2_e)];
    TaskObject(5).Arg{2} = t2x;
    TaskObject(5).Arg{3} = t2y;
    TaskObject(5).Arg{4} = 150;
    TaskObject(5).Arg{5} = 150;
    
    TaskObject(6).Type = 'Pic';
    TaskObject(6).Arg{1} = ['cue_' num2str(cue_angle)];
    TaskObject(6).Arg{2} = 0;
    TaskObject(6).Arg{3} = 0;
    TaskObject(6).Arg{4} = 200;
    TaskObject(6).Arg{5} = 200;

    %disp(['T1: ' num2str(t1_s) ' -> ' num2str(t1_e) '    T2: ' num2str(t2_s) ' -> ' num2str(t2_e) ]);
    
    generate_condition(...
        'Condition', cond, ...
        'Block', block, ...
        'Frequency', freq, ...
        'TimingFile', 'lp_dstrctr_cued_mobile_blank', ...
        'Info', s, ...
        'TaskObject', TaskObject, ...
        'FID', fid);

end


function rslt = gen_target_positions()
    anglelist = [0:45:315];

    %Generate New Positions for Targets
    angle_selection = randi(8); %Get Random Angle
    theta = anglelist(angle_selection);
    cueangle = theta;
    theta = theta * pi/180;

    radius = 3; %randi(5); %Get Randum Radius between 1 and 5
    [t1x, t1y] = pol2cart(theta, radius); %Convert to polar coordinates
    t2x = -t1x; t2y = -t1y;

    rslt = [t1x t1y t2x t2y cueangle];
end



