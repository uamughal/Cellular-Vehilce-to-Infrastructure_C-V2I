function RBGrid = resourceBlockGrid(n_RB,sym_per_RB_nosync,sym_per_RB_sync)
           max_codewords = 2;
           
           % "Dynamic" information
           RBGrid.user_allocation  = zeros(n_RB,1,'uint16'); % We will assume that the streams cannot be scheduled to different UEs.
           RBGrid.power_allocation = zeros(n_RB,1); % TTI-based power allocation. No slot-based power allocation
           RBGrid.power_allocation_signaling = zeros(n_RB,1); % Simplification: equal for each RB
           RBGrid.size_bits         = zeros(1,max_codewords);
           RBGrid.PMI               = nan(n_RB,1,'single'); % so that I can use NaNs and the such also
           
           % "Static" information
           RBGrid.n_RB              = n_RB;
           RBGrid.sym_per_RB_nosync = sym_per_RB_nosync;
           RBGrid.sym_per_RB_sync   = sym_per_RB_sync;
end