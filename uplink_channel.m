function obj = uplink_channel(aUE,n_RB,num_streams,delay)
           % zero-delay is implemented as zero delay for CQI feedback BUT
           % one-TTI delay for the ACK/NACK, as it is not possible to
           % implement the reception before the scheduling.
           % This is treated in the eNodeBsector.receive_UE_feedback
           % function (CQI is taken directly from the UE and not from the UL channel).
           if delay==0
               delay = 1;
           end
           
           obj.attached_UE    = aUE;
           obj.retrieve_index = 1;
           obj.insert_index   = delay; % Since the feedback is introduced
                                       % buffer AFTER the eNodeB retrieves
                                       % it, this is delay. IF you would
                                       % introduce the feedback BEFORE the
                                       % eNodeB reads it, change this to be
                                       % delay + 1
           obj.feedback_delay = delay;
           
           % Define the feedback message structure. TTI 0 represents an invalid value
           sample_feedback_structure.TTI_idx      = 0;                         % TTI index
           sample_feedback_structure.tx_mode      = 0;                         % TX mode
           sample_feedback_structure.nCodewords   = 0;                         % Number of codewords used
           sample_feedback_structure.CQI          = -1*ones(num_streams,n_RB); % CQI report
           sample_feedback_structure.ACK          = false(1,num_streams);      % ACK/NACK report
           sample_feedback_structure.PMI          = ones(1,n_RB);              % PMI (CLSM)
           sample_feedback_structure.RI           = 0;                         % Rank Indicator
           sample_feedback_structure.TB_size      = zeros(1,num_streams);      % TB size
           sample_feedback_structure.UE_scheduled = false(1,num_streams);      % Whether the UE was scheduled or not
           
           % Allocate and initialise the feedback buffer
           obj.feedback_buffer = repmat(sample_feedback_structure,1,delay+1);
end