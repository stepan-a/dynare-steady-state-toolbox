[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.819975.svg)](https://doi.org/10.5281/zenodo.819975)

# Dynare Steady State Toolbox

This toolbox provides a set of matlab routines that translate a matlab
routine computing the steady state of a DSGE model into something
readable by dynare (i.e. conforming to what is expected in a
`*_steadystate2.m` file generated by Dynare from the equations in the
`steady_state_model` model block). Examples are provided in the tests
subfolder. Assuming that the `dynare/matlab` folder is in the
Matab/Octave's path, you just need to add the `src` subfolder in the
path:

```matlab
>> addpath TOOLBOXES_PATH/dynare-steadystate-toolbox/src
```

where `TOOLBOXES_PATH` is the path to the folder where you unziped the
steadystate toolbox.

Compared to what Dynare does with the `steady_state_model`, this
toolbox is far less efficient than Dynare in producing the
`*_steadystate2.m` routine. The advantage is the additional
flexibility. The user can use any matlab statement in the source file
(loops, conditional constructs, fixed point routines, ...), add traps
and/or return custom error flags. Note that the routine produced by
this toolbox is as efficient as the one produced by Dynare from the
`steady_state_model` block (only the generation of the
`*_steadystate2.m` is slower, because this is done in Matlab/Octave
rather than by the C++ preprocessor). The relative cost associated to
the generation of the `*_steadystate2.m` is generally very marginal,
when the model has to be estimated, or when one performs Monte Carlo
analysis to elicite the prior distributions.

The source files are covered by the GNU General Public Licence version
3 or later, see [here](LICENSE.md).
