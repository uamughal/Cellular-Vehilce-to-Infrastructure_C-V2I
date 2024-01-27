function [c,user_ind,N_UE] = get_efficiency(N_RB,UE_feedback,k,d)
            N_UE = size(UE_feedback.CQI,3);
            c                   = zeros(N_UE,N_RB);
            nCodewords_feedback = size(UE_feedback.CQI,2);
            CQIs_per_UE = reshape(UE_feedback.CQI,[],N_UE);
            max_UE_CQI  = max(CQIs_per_UE,[],1);
            CQI_bars    = max_UE_CQI+1;
            
            % Assumes that the CQIs in both codewords will be similar
            a = k(CQI_bars)';
            b = d(CQI_bars)';
            
            RI          = UE_feedback.RI;
            RI(~UE_feedback.feedback_received)         = 1;

            % Begin permuted part
            user_ind      = randperm(N_UE);
            a_vector      = a(user_ind);
            b_vector      = b(user_ind);
            a_matrix      = a_vector(:,ones(1,nCodewords_feedback));
            b_matrix      = b_vector(:,ones(1,nCodewords_feedback));
            permuted_CQIs = UE_feedback.CQI(:,:,user_ind);
            for u_=1:N_UE
                UE_idx = user_ind(u_);
                UE_RI  = RI(UE_idx);
                
                % Assuming always a maximum possible number of codewords
                % i.e., min(2,nLayers)
                switch UE_RI
                    case {0,1} % SISO sends RI of 0
                        a_matrix(u_,2) = 0;
                        b_matrix(u_,2) = 0;
                end
            end
            for rb = 1:N_RB
                % c(:,rb) = a_vector.*reshape(permuted_CQIs(rb,1,:),[],1)+b_vector;
                c(:,rb) = sum(a_matrix .* reshape(reshape(permuted_CQIs(rb,:,:),[],1),2,[])' + b_matrix,2);
            end
            end
            