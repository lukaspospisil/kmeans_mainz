T = 10;
p.NumWorkers = 4;

opt_nmb = floor(T/p.NumWorkers);
rest_nmb = mod(T,p.NumWorkers);
local_Tidx = cell(1,p.NumWorkers);
for proc_id=1:p.NumWorkers
    if proc_id == 1
        my_begin = 1;
    else
        my_begin = my_end+1;
    end
    
    my_end = my_begin + opt_nmb - 1;
    if proc_id <= rest_nmb
        my_end = my_end + 1;
    end
    
    local_Tidx{proc_id} = my_begin:my_end;
    
end
