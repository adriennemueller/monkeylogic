function gen_mobile_dstrctr_conditions_file( numTrials, filename )
    path( path, '../' );

    fid = fopen(filename, 'w');
    
    textline = generate_condition('Header', 5, 'FID', fid);
    fprintf(fid,  '%s\n');
    
    
    
    
    for i = 1:numTrials

        t1 = randi(36)*5;
        t2 = randi(36)*5;
        t3 = randi(36)*5;
        t4 = randi(36)*5;
        
        if t1 == t2
            t2 = t2 -5;
        end
        if t3 == t4
            t4 = t4 -5;
        end
 
        %Select which of the four combinations the two targets will display as
        % 1-3 - neither changes, 4 - 1 changes, 5 - the other changes, 6 - both
        % change
        comb = randi(4);
        if comb <=2
            t1new = t1; t2new = t3; % No Change
            s.t_info = 'Same';
        elseif comb == 3
            t1new = t2; t2new = t3; % First Change
            s.t_info = 'T1 Change';
        elseif comb == 4 
            t1new = t1; t2new = t4; % Second Change
            s.t_info = 'T2 Change';
        end

       
        TaskObject(1).Type = 'Fix';
        TaskObject(1).Arg{1} = 0;
        TaskObject(1).Arg{2} = 0;

        TaskObject(2).Type = 'Pic';
        TaskObject(2).Arg{1} = ['rect_' num2str(t1)];
        TaskObject(2).Arg{2} = 1;
        TaskObject(2).Arg{3} = 3;
        TaskObject(2).Arg{4} = 150;
        TaskObject(2).Arg{5} = 150;

        TaskObject(3).Type = 'Pic';
        TaskObject(3).Arg{1} = ['rect_' num2str(t1new)];
        TaskObject(3).Arg{2} = 1;
        TaskObject(3).Arg{3} = 3;
        TaskObject(3).Arg{4} = 150;
        TaskObject(3).Arg{5} = 150;

        TaskObject(4).Type = 'Pic';
        TaskObject(4).Arg{1} = ['rect_' num2str(t2)];
        TaskObject(4).Arg{2} = 1;
        TaskObject(4).Arg{3} = -3;
        TaskObject(4).Arg{4} = 150;
        TaskObject(4).Arg{5} = 150;

        TaskObject(5).Type = 'Pic';
        TaskObject(5).Arg{1} = ['rect_' num2str(t2new)];
        TaskObject(5).Arg{2} = 1;
        TaskObject(5).Arg{3} = -3;
        TaskObject(5).Arg{4} = 150;
        TaskObject(5).Arg{5} = 150;

        textline = generate_condition('Condition', i, 'Block', 1, 'Frequency', 1, 'TimingFile', 'lp_dstrctr_nocue_mobile_blank', 'Info', s, 'TaskObject', TaskObject, 'FID', fid);
    end
    
    fclose(fid);

end