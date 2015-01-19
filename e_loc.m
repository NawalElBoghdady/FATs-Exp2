function x = e_loc(ins_depth,nchs,e_array_length,cochlear_length)


if ins_depth > e_array_length
    error('Insertion depth must be <= the total electrode array length');
end

a = 0.4; %the width of a single electrode is 0.4mm in an AB HiFocus electrode array.
b = 1.1; %the intra-electrode spacing is 1.1mm in an AB HiFocus electrode array.

c = e_array_length - (a*nchs + b*(nchs-1)); %the spacing from the beginning of the base till the first electrode.

x = zeros(nchs,1);
x(1) = c;

for i = 2:nchs
    x(i) = x(1) + (i-1)*(a+b);
end

dx = e_array_length - ins_depth; %the delta 'x' shift in mm resulting from partial electrode array insertion.

x_shifted = x-dx; %insert the electrode array

x_shifted(x_shifted < 0) = 0;

x = (cochlear_length - x_shifted)./cochlear_length; %the final electrode positions are output as a ratio of the total cochlear length apex to base.

%now we need to have our calculations go base-to-apex, since in the above the APEX location is fixed. We need the BASE location to be fixed. 

