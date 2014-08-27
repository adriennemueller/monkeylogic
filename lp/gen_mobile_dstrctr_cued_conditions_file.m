function gen_mobile_dstrctr_cued_conditions_file( numTrials, filename )
    path( path, '../' );

    fid = fopen(filename, 'w');
    
    textline = generate_condition('Header', 6, 'FID', fid);
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
        TaskObject(3).Arg{1} = ['rect_' num2str(t2)];
        TaskObject(3).Arg{2} = 1;
        TaskObject(3).Arg{3} = 3;
        TaskObject(3).Arg{4} = 150;
        TaskObject(3).Arg{5} = 150;

        TaskObject(4).Type = 'Pic';
        TaskObject(4).Arg{1} = ['rect_' num2str(t3)];
        TaskObject(4).Arg{2} = 1;
        TaskObject(4).Arg{3} = -3;
        TaskObject(4).Arg{4} = 150;
        TaskObject(4).Arg{5} = 150;

        TaskObject(5).Type = 'Pic';
        TaskObject(5).Arg{1} = ['rect_' num2str(t4)];
        TaskObject(5).Arg{2} = 1;
        TaskObject(5).Arg{3} = -3;
        TaskObject(5).Arg{4} = 150;
        TaskObject(5).Arg{5} = 150;

        TaskObject(6).Type = 'Mov';
        TaskObject(6).Arg{1} = 'cue';
        TaskObject(6).Arg{2} = 0;
        TaskObject(6).Arg{3} = 0;
        
        textline = generate_condition('Condition', i, 'Block', 1, 'Frequency', 1, 'TimingFile', 'lp_dstrctr_cued_mobile', 'TaskObject', TaskObject, 'FID', fid);
    end
    
    fclose(fid);

end