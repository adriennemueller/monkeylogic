function gen_mobile_dstrctr_conditions_file( filename )
    path( path, '../' );

    fid = fopen(filename, 'w');
    
    textline = generate_condition('Header', 5, 'FID', fid);
    fprintf(fid,  '%s\n');

		
	row = [1:36];
	tmat = repmat( row, 36, 1);
	tmat = tmat .* 5;	
	
	cond = 0;
	
    for i = 1:5
		t1 = tmat(1,i);
		
		for j = 1:5
			if (j == i)
			continue
			end

			t1new = tmat(i,j);

			for k = 1:5
				t2 = tmat(1,k);
				
				for l = 1:5
					if (l == k)
					continue
					end
					
					t2new = tmat(k,l);
					
					%disp( ['T1: ' num2str(tmat(1,i)) ' T1new: ' num2str(tmat(i,j)) ' T2: ' num2str(tmat(1,k)) ' T2new: ' num2str(tmat(1,k)) ] );
					disp( ['T1: ' num2str(t1) ' T1new: ' num2str(t1new) ' T2: ' num2str(t2) ' T2new: ' num2str(t2new) ] );
					
					for m = 1:3
						if m == 1
							t1new = t1; t2new = t2; % No Change
							s.t_info = 'Same';
							freq = 2;
							%disp( ['SAME: T1: ' num2str(t1) ' T1new: ' num2str(t1new) ' T2: ' num2str(t2) ' T2new: ' num2str(t2new) ] );

						elseif m == 2
							t2new = t2; % First Change
							s.t_info = 'T1 Change';
							freq = 1;
							%disp( ['T1 CHANGE: T1: ' num2str(t1) ' T1new: ' num2str(t1new) ' T2: ' num2str(t2) ' T2new: ' num2str(t2new) ] );
						
						elseif m == 3
							t1new = t1; % Second Change
							s.t_info = 'T2 Change';
							freq = 1;
							%disp( ['T2 CHANGE: T1: ' num2str(t1) ' T1new: ' num2str(t1new) ' T2: ' num2str(t2) ' T2new: ' num2str(t2new) ] );

						end
						
						cond = cond+1;

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

						textline = generate_condition('Condition', cond, 'Block', 1, 'Frequency', freq, 'TimingFile', 'lp_dstrctr_nocue_mobile_blank', 'Info', s, 'TaskObject', TaskObject, 'FID', fid);

						
					end
					
				end
				
			end
					
		end
			
	end

    fclose(fid);

end