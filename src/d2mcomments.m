function str = d2mcomments(str)
% Convert Dynare-style comments to MATLAB-style comments
%
% INPUTS:
%  - str  [char]    1×n array, line of a .mod file with potentially Dynare-style comments.
% OUTPUTS:
%  - str  [char]    1×n array, updated line with MATLAB-style comments.

% Copyright © 2025 Stéphane Adjemian
%
% This file is part of the Dynare Steady State Toolbox.
%
% Dynare Steady State Toolbox is free software: you can redistribute it
% and/or modify it under the terms of the GNU General Public License as
% published by the Free Software Foundation, either version 3 of the
% License, or (at your option) any later version.
%
% This toolbox is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare Steady State Toolbox.  If not, see <http://www.gnu.org/licenses/>.

    convertcomments = @(x) slashpair2percentage(x); % local function handle

    str = strrep(str, '/*', '%{');
    str = strrep(str, '*/', '%}');
    str = regexprep(str, '/+', '${convertcomments($0)}');

end

function c = slashpair2percentage(str)
% Given a row char array '/', '//', '///', ... produce the replacement.
%
% INPUTS:
%  - str  [char]    1×n array, n≥1, consisting of n slashes.
% OUTPUTS:
%  - c    [char]    1×m array, m≤n, replacement string.

    n = numel(str);
    k = floor(n/2);
    if mod(n,2)==0
        % even: 2k slashes -> k percents
        c = repmat('%',1,k);
    else
        % odd: 2k+1 slashes -> 2k percents and trailing '/'
        if k==0
            c = '/';                     % single slash remains slash
        else
            c = [repmat('%',1,2*k) '/'];
        end
    end
end
