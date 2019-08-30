function mod_str = capstr( str )
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

mod_str = lower(str);
idx = regexp([' ' mod_str],'(?<=\s+)\S','start')-1;
mod_str(idx) = upper(mod_str(idx));

end

