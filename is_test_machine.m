function b = is_test_machine()

[c, s] = system('hostname');
%if strcmp(strtrim(s), 'hoogglans')==0
if strcmp(strtrim(s), 'lt159107.med.rug.nl')==0
    b = 1;
else
    b = 0;
end 