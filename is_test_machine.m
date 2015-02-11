function b = is_test_machine()

[c, s] = system('hostname');
s = strtrim(s);
switch s
    case {'hoogglans', 'Nawals-MacBook-Pro.local'}
        b = 0;
    otherwise
        b = 1;
end 