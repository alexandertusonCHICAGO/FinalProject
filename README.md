What this project is...

This project is a small simulation that explores how aerosol particles suspended
in a thin atmosphere could affect the temperature of a planet like Mars. The 
basic idea is that aerosols can interact with sunlight by absorbing or 
scattering radiation. Depending on their size and abundance, these particles can
change how much solar energy the planet absorbs and therefore change the 
planet’s equilibrium temperature.

The simulation lets a user experiment with a few of these parameters and see how 
they influence the planet’s energy balance. It’s not meant to be a high-fidelity 
climate model or anything close to a real planetary simulator, but it does 
capture the basic physical idea. Incoming solar radiation has to balance 
outgoing thermal radiation, and particles in the atmosphere can shift that 
balance.

The program runs in a simple terminal interface where the user chooses particle 
sizes and atmospheric particle densities, runs the simulation, and then sees 
what happens to the temperature and energy balance.

To run the program...
- cabal build
- cabal run FinalProject
- The tui will prompt you to enter values for aerosols

The Modules...

Main.hs
This file contains implements the terminal interface. It introduces the 
simulation to the user, collects parameter inputs such as particle size and 
column density, runs the simulation, and displays the results in a readable 
format.

Types.hs
This module defines the core data structures used throughout the project. It 
includes types representing particles, atmospheres, spectra, and simulation 
configurations, which allow the rest of the program to pass around well 
structured data rather than loose numerical values.

Spectrum.hs
This module represents and generates the solar radiation spectrum used by the 
simulation. It creates a range of wavelengths and associated energy flux values 
that the model integrates over when calculating how particles interact with 
incoming sunlight.

EnergyBalance.hs
This module contains the main physics calculations of the project. It computes 
particle cross-sections, absorbed solar power, and the equilibrium temperature
of the planet given the aerosol information.

ParameterSweep.hs
This module provides tools for running multiple simulations across different
parameter values. It allows the program to explore how outputs change as 
particle sizes or atmospheric densities vary.

Output.hs
This module formats simulation results for display in the terminal.

PadiativeTransfer.hs
This module calculates how much radiation is absorbed by the aerosols and how
much passes through the atmosphere.

How it meets project requirements...
The program defines several custom data types in Types.hs that represent the
core physical objects in the model, including particles, atmospheres, spectra,
and simulation configurations.

The simulation itself is composed of multiple interacting modules. The spectrum
module generates the incoming radiation, the radiative transfer module models
how particles absorb radiation, and the energy balance module determines the
equilibrium temperature of the planet based on absorbed and emitted energy.

Higher-level modules coordinate the simulation and user interaction. The main
module implements a terminal interface that allows users to experiment with
different atmospheric conditions, while the output module formats simulation
results for display.

By organizing the program into independent modules with clearly defined roles,
the project demonstrates modular design, functional decomposition, and the use
of custom data types to model a physical system

My contact information for further questions...
email - alexandertuson@uchicago.edu