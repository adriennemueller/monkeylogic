function gen_mobile_dstrctr_conditions_file_New( filename, b_span, b_overlap )
    path( path, '../' );

    fid = fopen(filename, 'w');
    
    textline = generate_condition('Header', 5, 'FID', fid);
    fprintf(fid,  '%s\n');

	cond = 0;
	
    
    step = 5;
    N = 175;
    
    for tar1_start = 0:step:N
        for tar1_end = 0:step:N
            if tar1_start == tar1_end
                continue
            end
            
            for tar2_start = 0:step:N
				
				cond = cond + 1;
				block = get_blocks( b_span, b_overlap, tar1_start, tar1_start );
				s.t_info = 'Same';
				make_condition(tar1_start, tar1_start, tar2_start, tar2_start, cond, 1, 2, s, fid);
				
				cond = cond + 1;
				blocks = get_blocks( b_span, b_overlap, tar1_start, tar1_end );
				s.t_info = 'T1 Change';
				make_condition(tar1_start, tar1_end, tar2_start, tar2_start, cond, blocks, 1, s, fid);
                
                
            
            end
        end
    end

    fclose(fid);

end

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

function make_condition(t1_s, t1_e, t2_s, t2_e, cond, block, freq, s, fid)

    TaskObject(1).Type = 'Fix';
    TaskObject(1).Arg{1} = 0;
    TaskObject(1).Arg{2} = 0;

    TaskObject(2).Type = 'Pic';
    TaskObject(2).Arg{1} = ['rect_' num2str(t1_s)];
    TaskObject(2).Arg{2} = 1;
    TaskObject(2).Arg{3} = 3;
    TaskObject(2).Arg{4} = 150;
    TaskObject(2).Arg{5} = 150;

    TaskObject(3).Type = 'Pic';
    TaskObject(3).Arg{1} = ['rect_' num2str(t1_e)];
    TaskObject(3).Arg{2} = 1;
    TaskObject(3).Arg{3} = 3;
    TaskObject(3).Arg{4} = 150;
    TaskObject(3).Arg{5} = 150;

    TaskObject(4).Type = 'Pic';
    TaskObject(4).Arg{1} = ['rect_' num2str(t2_s)];
    TaskObject(4).Arg{2} = 1;
    TaskObject(4).Arg{3} = -3;
    TaskObject(4).Arg{4} = 150;
    TaskObject(4).Arg{5} = 150;

    TaskObject(5).Type = 'Pic';
    TaskObject(5).Arg{1} = ['rect_' num2str(t2_e)];
    TaskObject(5).Arg{2} = 1;
    TaskObject(5).Arg{3} = -3;
    TaskObject(5).Arg{4} = 150;
    TaskObject(5).Arg{5} = 150;

    %disp(['T1: ' num2str(t1_s) ' -> ' num2str(t1_e) '    T2: ' num2str(t2_s) ' -> ' num2str(t2_e) ]);
    
    generate_condition(...
        'Condition', cond, ...
        'Block', block, ...
        'Frequency', freq, ...
        'TimingFile', 'lp_dstrctr_nocue_mobile_blank', ...
        'Info', s, ...
        'TaskObject', TaskObject, ...
        'FID', fid);

end




