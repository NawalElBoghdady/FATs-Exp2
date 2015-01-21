function x = e_loc(e_array,cochlear_length)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function x = e_loc(e_array,cochlear_length)
%
%INPUT ARGUMENTS:
%
%e_array is a struct:
%                       type      => The commercial name for this electrode
%                                    array model
%                       ins_depth => electrode array insertion depth (in mm)
%                       length    => length of the electrode array (in mm)  
%                       nchs      => total number of electrodes
%                       e_width   => the width of a single electrode in the
%                                    model (in mm)
%                       e_spacing => intra-electrode spacing (in mm)
%
%cochlear_length:       The length of the cochlea implanted in mm
%
%OUTPUT ARGUMENTS:
%
%x:                     The electrode locations as a ratio of the total 
%                       cochlear_length. Numbers are given from BASE-to-APEX.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if e_array.ins_depth > e_array.length
    error('Insertion depth must be <= the total electrode array length');
end

a = e_array.e_width;  %the width of a single electrode is 0.4mm in an AB HiFocus electrode array.
b = e_array.e_spacing; %the intra-electrode spacing is 1.1mm in an AB HiFocus electrode array.
nchs = e_array.nchs;

% a = 0.4; 
% b = 1.1; 
c = e_array.length - (a*nchs + b*(nchs-1)); %the spacing from the beginning of the base till the first electrode.

x = zeros(nchs,1);
x(1) = c;

for i = 2:nchs
    x(i) = x(1) + (i-1)*(a+b); %electrode locations apex-to-base
end

x = cochlear_length - x;
dx = e_array.length - e_array.ins_depth; %the delta 'x' basalward shift in mm resulting from partial electrode array insertion.

x_shifted = x+dx; %insert the electrode array. We add the dx instead of subtracting it because the formula for the GW frequency goes apex-to-base

x_shifted = x_shifted(x_shifted <= cochlear_length); %discard electrodes that fall outside the cochlea.

x = x_shifted./cochlear_length; %the final electrode positions are output as a ratio of the total cochlear length BASE-to-APEX.






