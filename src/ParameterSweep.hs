module ParameterSweep where

import Types
import EnergyBalance

-- | Run simulation across many configs.
simulateParameterSweep :: [SimulationConfig] -> [SimulationResult]
simulateParameterSweep configs =
  map runSimulation configs

-- | Replace particle radius in config.
setParticleRadius :: Double -> SimulationConfig -> SimulationConfig
setParticleRadius r config =
  config
    { atmosphereConfig = atm'
    }
  where
    atm = atmosphereConfig config
    p = particle atm
    p' = p { radius = r }
    atm' = atm { particle = p' }

-- | Replace particle density in config.
setParticleDensity :: Double -> SimulationConfig -> SimulationConfig
setParticleDensity ρ config =
  config
    { atmosphereConfig = atm'
    }
  where
    atm = atmosphereConfig config
    p = particle atm
    p' = p { density = ρ }
    atm' = atm { particle = p' }

-- | Replace column density in config.
setColumnDensity :: Double -> SimulationConfig -> SimulationConfig
setColumnDensity n config =
  config
    { atmosphereConfig = atm' }
  where
    atm = atmosphereConfig config
    atm' = atm { columnDensity = n }

-- | Generate configs by varying radius.
sweepRadius :: [Double] -> SimulationConfig -> [SimulationConfig]
sweepRadius radii config =
  map (`setParticleRadius` config) radii

-- | Generate configs by varying density.
sweepDensity :: [Double] -> SimulationConfig -> [SimulationConfig]
sweepDensity densities config =
  map (`setParticleDensity` config) densities

-- | Generate configs by varying column density.
sweepColumnDensity :: [Double] -> SimulationConfig -> [SimulationConfig]
sweepColumnDensity ns config =
  map (`setColumnDensity` config) ns

-- | Full grid sweep of radius and column density.
gridSweepRadiusColumnDensity
  :: [Double]
  -> [Double]
  -> SimulationConfig
  -> [SimulationConfig]
gridSweepRadiusColumnDensity radii ns config =
  [ setColumnDensity n (setParticleRadius r config)
  | r <- radii
  , n <- ns
  ]