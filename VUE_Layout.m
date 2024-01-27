 function [VUE_layout]=VUE_Layout(isplot,area_grid,cell_ind,VUE,Lane_width)
              
  ps_ISD = 500;
  elements_positions=zeros(VUE,4);
 
 
 %%   Spatial Poisson Distribution  
   %% For all vertical lanes (4)
    %i.e Simulation area for one-tier by Rel.14 (1299m * 750m)
    
    Lambda1 = 31;  % Lambda:Vehicle density
    u = unifrnd(0,1);
    M = 0;
   while u >= exp(-Lambda1)
        u = u*unifrnd(0,1);
        M=M+1;
   end 
   a = 0; b = 1299;
   Nall = M;
   while M > 0         %scatter in the [0,1299]
        M = M-1;
        u1 = unifrnd(0,1);
        A11(Nall-M) = ps_ISD/6-Lane_width*3/2;
        B11(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        A12(Nall-M) = ps_ISD/6-Lane_width/2;
        B12(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        A13(Nall-M) = ps_ISD/6+Lane_width/2;
        B13(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        A14(Nall-M) = ps_ISD/6+Lane_width*3/2;
        B14(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        
        A21(Nall-M) = 250+ps_ISD/6-Lane_width*3/2; 
        B21(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        A22(Nall-M) = 250+ps_ISD/6-Lane_width/2;
        B22(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        A23(Nall-M) = 250+ps_ISD/6+Lane_width/2;
        B23(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        A24(Nall-M) = 250+ps_ISD/6+Lane_width*3/2;
        B24(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        
        A31(Nall-M) = -250+ps_ISD/6-Lane_width*3/2;
        B31(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        A32(Nall-M) = -250+ps_ISD/6-Lane_width/2;
        B32(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        A33(Nall-M) = -250+ps_ISD/6+Lane_width/2;
        B33(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        A34(Nall-M) = -250+ps_ISD/6+Lane_width*3/2;
        B34(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        
        A41(Nall-M) = -2*250+ps_ISD/6-Lane_width*3/2;
        B41(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        A42(Nall-M) = -2*250+ps_ISD/6-Lane_width/2;
        B42(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        A43(Nall-M) = -2*250+ps_ISD/6+Lane_width/2;
        B43(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;
        A44(Nall-M) = -2*250+ps_ISD/6+Lane_width*3/2;
        B44(Nall-M) = -433-(ps_ISD/sqrt(3)/2)+(b-a)*u1;        
   end
   
   
 %% For all horizontal lanes(4)
    Lambda2 = 18;  % Lambda:Vehicle density
    u0 = unifrnd(0,1);
    M1 = 0;
   while u0 >= exp(-Lambda2)
        u0 = u0*unifrnd(0,1);
        M1=M1+1;
   end 
   c = 0; d = 750;
   Nall0 = M1;
   while M1 > 0         %scatter in the [0,750]
        M1 = M1-1;
        u2 = unifrnd(0,1);
        C11(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D11(Nall0-M1) = -433-(ps_ISD/sqrt(3)/2-3*Lane_width/2);
        C12(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D12(Nall0-M1) = -433-(ps_ISD/sqrt(3)/2-Lane_width/2);
        C13(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D13(Nall0-M1) = -433-(ps_ISD/sqrt(3)/2+Lane_width/2);
        C14(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D14(Nall0-M1) = -433-(ps_ISD/sqrt(3)/2+3*Lane_width/2);
        
        C21(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D21(Nall0-M1) = -(ps_ISD/sqrt(3)/2-3*Lane_width/2);
        C22(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D22(Nall0-M1) = -(ps_ISD/sqrt(3)/2-Lane_width/2);
        C23(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D23(Nall0-M1) = -(ps_ISD/sqrt(3)/2+Lane_width/2);
        C24(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D24(Nall0-M1) = -(ps_ISD/sqrt(3)/2+3*Lane_width/2);
        
        C31(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D31(Nall0-M1) = 433-(ps_ISD/sqrt(3)/2-3*Lane_width/2);
        C32(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D32(Nall0-M1) = 433-(ps_ISD/sqrt(3)/2-Lane_width/2);
        C33(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D33(Nall0-M1) = 433-(ps_ISD/sqrt(3)/2+Lane_width/2);
        C34(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D34(Nall0-M1) = 433-(ps_ISD/sqrt(3)/2+3*Lane_width/2);
        
        C41(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D41(Nall0-M1) = 2*433-(ps_ISD/sqrt(3)/2-3*Lane_width/2);
        C42(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D42(Nall0-M1) = 2*433-(ps_ISD/sqrt(3)/2-Lane_width/2);
        C43(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D43(Nall0-M1) = 2*433-(ps_ISD/sqrt(3)/2+Lane_width/2);
        C44(Nall0-M1) = -250-ps_ISD/3+(d-c)*u2;
        D44(Nall0-M1) = 2*433-(ps_ISD/sqrt(3)/2+3*Lane_width/2);        
   end     
   
      A=[A11,A12,A13,A14,A21,A22,A23,A24,A31,A32,A33,A34,A41,A42,A43,A44,...
          C11,C12,C13,C14,C21,C22,C23,C24,C31,C32,C33,C34,C41,C42,C43,C44];
      B=[B11,B12,B13,B14,B21,B22,B23,B24,B31,B32,B33,B34,B41,B42,B43,B44,...
          D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44];
      for i=1:length(A)
          elements_positions(i,:)=[A(i),B(i),0,0];
          
           plot( A(i), B(i),'--rs')                   
      end
      
       %% Set moving direction for each vehicle (vertical lanes)
       for j=1:length(A11)+length(A12)
           elements_positions(j,3)= -90;
       end
       for j=j+1:j+1+length(A13)+length(A14)
           elements_positions(j,3)= 90;
       end
       for j=j+1:j+1+length(A21)+length(A22)
           elements_positions(j,3)= -90;
       end
       for j=j+1:j+1+length(A23)+length(A24)
           elements_positions(j,3)= 90;
       end
       for j=j+1:j+1+length(A31)+length(A32)
           elements_positions(j,3)= -90;
       end
       for j=j+1:j+1+length(A33)+length(A34)
           elements_positions(j,3)= 90;
       end
       for j=j+1:j+1+length(A41)+length(A42)
           elements_positions(j,3)= -90;
       end
       for j=j+1:j+1+length(A43)+length(A44)
           elements_positions(j,3)= 90;
       end
       
        %% Set moving direction for each vehicle (horizontal lanes)
       for j=j+1:j+1+length(C11)+length(C12)
           elements_positions(j,3)= 180;
       end
       for j=j+1:j+1+length(C13)+length(C14)
           elements_positions(j,3)= 0;
       end
       for j=j+1:j+1+length(C21)+length(C22)
           elements_positions(j,3)= 180;
       end
       for j=j+1:j+1+length(C23)+length(C24)
           elements_positions(j,3)= 0;
       end
       for j=j+1:j+1+length(C31)+length(C32)
           elements_positions(j,3)= 180;
       end
       for j=j+1:j+1+length(C33)+length(C34)
           elements_positions(j,3)= 0;
       end
       for j=j+1:j+1+length(C41)+length(C42)
           elements_positions(j,3)= 180;
       end
       for j=j+1:j+1+length(C43)+length(C44)
           elements_positions(j,3)= 0;
       end
       
       VUE_layout =  elements_positions;
 end
 