function install_steadystate_file(pathtosource)

% Calls the Matlab function transforming the Matlab script defining the steady state
% into a *_steadystate2.m file (readable by Dynare)
%
% INPUTS 
% - pathtosource   [string]  Path to the folder where the matlab script is to be found.
%
% OUTPUTS 
% none
%
% REMARKS 
% This function needs two Dynare's global structures (options_ and M_). The structure options_ is
% updated by this function (by setting a flag signaling the avaibility of *_steadystate2.m file).
    
% Copyright © 2017, 2025 Stéphane Adjemian
%
% This file is part of the Dynare Steady State Toolbox.
%
% Dynare Steady State Toolbox is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This toolbox is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare Steady State Toolbox.  If not, see <http://www.gnu.org/licenses/>.

global options_ M_

if ~nargin || isempty(pathtosource)
    pathtosource = [pwd() filesep()];
end

SOURCE_FILE_0 = [M_.fname '_steadystate.source'];
SOURCE_FILE_1 = [M_.fname '_steadystate_source.m'];

PATH_SOURCE_FILE_0 = pathtosource;
PATH_SOURCE_FILE_1 = [pwd() filesep()];

% Check if the source for the steady state needs to be parsed, and parse the .source file if needed.
if ~exist(SOURCE_FILE_1, 'file')
    write_steadystate_file(M_, PATH_SOURCE_FILE_0);
else
    if isnewer(SOURCE_FILE_0, SOURCE_FILE_1, PATH_SOURCE_FILE_0, PATH_SOURCE_FILE_1)
        write_steadystate_file(M_, PATH_SOURCE_FILE_0);
    end
end

% Create the steadystate2 file.
copyfile([M_.fname '_steadystate_source.m'], ['+' M_.fname filesep() 'steadystate.m']);
    
% Set steadystate_flag option.
options_.steadystate_flag = 2;