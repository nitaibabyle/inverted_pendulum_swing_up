The simplest nonlinear programming exmaple.

"solving" runs the solving process, including the objective and constraints.

The objective is defined in "opt_objective.m" file, the constraint is defined in "opt_nlconstraint.m".

The nlconstraint include inequality constraint and the equality constraint.

Inequality constraint is defined at the "aaa_budengshi.m" file.

Equality constraint contains the "dynamic_constraint.m", the "discrete_constraint.m" and the "boundary_constraint.m" files.

After solving the problem, the visualization program can display the solver's result.

As the result, the generated trajectory is implemented at the dynamic environment.

"dynamic_simulation.m" can run the simulation

Here is the result:

<img src="https://github.com/user-attachments/assets/a7733afb-b96d-4150-a240-dc72e0faecb5" width="600px" />
