module Main where

import Types
import Spectrum
import EnergyBalance
import Output
import ParameterSweep
import Text.Read (readMaybe)

main :: IO ()
main = do
  putStrLn "=== Mars Aerosol Simulation ===\n"
  putStrLn "This program models how tiny particles in a thin atmosphere can"
  putStrLn "affect the temperature of a planet like Mars."
  putStrLn "You can experiment with particle size, density, and column density."
  putStrLn "Particle radius is in nanometers (nm). Typical values: 50-300 nm."
  putStrLn "Column density is in billions of particles per square meter (1 = 1e9).\n"

  -- Base config
  let baseParticle = Particle
        { radius = 100e-9
        , density = 5000
        , extinctionEfficiency = \_ -> 1.0
        }
      baseAtmosphere = Atmosphere { particle = baseParticle, columnDensity = 1e9 }
      baseSolarSpectrum = generateSpectrum 200e-9 2500e-9 1000 (const (Flux 1361))
      baseConfig = SimulationConfig
        { solarSpectrum = baseSolarSpectrum
        , atmosphereConfig = baseAtmosphere
        , planetaryAlbedo = 0.25
        }

  putStrLn "Let's run a simulation! You can select preset values or enter your own."
  tuiLoop baseConfig

tuiLoop :: SimulationConfig -> IO ()
tuiLoop config = do
  -- Particle radius
  putStrLn "\nChoose particle radius (enter a number 1-4):"
  putStrLn "1) 50 nm - about the size of very fine combustion aerosols or smaller than many viruses."
  putStrLn "2) 100 nm - similar to fine smoke or secondary aerosol particles known to affect Earth's climate."
  putStrLn "3) 200 nm - around the size where particles efficiently interact with visible sunlight and remain suspended longest."
  putStrLn "4) Enter your own value in nanometers"
  rChoice <- getLine
  config' <- case rChoice of
    "1" -> return $ setParticleRadius (50e-9) config
    "2" -> return $ setParticleRadius (100e-9) config
    "3" -> return $ setParticleRadius (200e-9) config
    "4" -> do
      putStrLn "Enter radius in nanometers (e.g., 150):"
      input <- getLine
      case readMaybe input of
        Just r_nm -> return $ setParticleRadius (r_nm * 1e-9) config
        Nothing -> do
          putStrLn "Invalid input, using previous value."
          return config
    _ -> do
      putStrLn "Invalid choice, using previous value."
      return config

  -- Column density
  putStrLn "\nChoose particle column density in billions of particles per m² (1 = 1e9):"
  putStrLn "1) Low (0.5 billion) - sparse, minimal warming effect"
  putStrLn "2) Medium (1 billion) - typical proposed value for engineered aerosols"
  putStrLn "3) High (2 billion) - dense, strong radiative effect"
  putStrLn "4) Enter your own value (in billions)"
  nChoice <- getLine
  config'' <- case nChoice of
    "1" -> return $ setColumnDensity (0.5e9) config'
    "2" -> return $ setColumnDensity (1e9) config'
    "3" -> return $ setColumnDensity (2e9) config'
    "4" -> do
      putStrLn "Enter column density in billions (e.g., 1 = 1e9):"
      input <- getLine
      case readMaybe input of
        Just n_billion -> return $ setColumnDensity (n_billion * 1e9) config'
        Nothing -> do
          putStrLn "Invalid input, using previous value."
          return config'
    _ -> do
      putStrLn "Invalid choice, using previous value."
      return config'

  putStrLn "\nRunning simulation..."
  let result = runSimulation config''

  -- Explain results
  putStrLn "\n=== Simulation Result ==="
  putStrLn $ formatResult result
  putStrLn "Explanation:"
  putStrLn "- Equilibrium Temperature: temperature the planet would settle at with these particles."
  putStrLn "- Absorbed Power: amount of solar energy absorbed by the particles."
  putStrLn "- Particle Mass: total mass of particles in the atmospheric column."
  putStrLn "- Efficiency: warming effect per unit mass (higher = more effective)."

  putStrLn "\nRun another simulation? (y/n)"
  again <- getLine
  if again == "y" || again == "Y"
    then tuiLoop config''
    else putStrLn "Exiting TUI. Goodbye."