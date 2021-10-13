function out = capstr( str )
% CAPSTR capitalizes the first letter each word in the string str and sets
% all of the other ones to be lowercase.
%--------------------------------------------------------------------------
% ARGUMENTS
% str   a string of words
%--------------------------------------------------------------------------
% OUTPUT
% mod_str   the modified string
%--------------------------------------------------------------------------
% EXAMPLES
% capstr('this is a tEST')
%--------------------------------------------------------------------------
% AUTHOR: Azzi Abdelmalek and Sam Davenport, see https://tinyurl.com/yb2v523t. 


if strcmp(class(str), 'cell')
    for I = 1:length(str)
        mod_str = lower(str{I});
        idx = regexp([' ' mod_str],'(?<=\s+)\S','start')-1;
        mod_str(idx) = upper(mod_str(idx));
        out{I} = mod_str;
    end
else
    out = lower(str);
    idx = regexp([' ' out],'(?<=\s+)\S','start')-1;
    out(idx) = upper(out(idx));
end

end

