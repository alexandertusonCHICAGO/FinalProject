module Output where

import Types
import Optimization

-- | Format temperature in Kelvin.
formatTemperature :: Temperature -> String
formatTemperature (Temperature t) =
  show t ++ " K"

-- | Format mass in kg.
formatMass :: Double -> String
formatMass m =
  show m ++ " kg"

-- | Format power in W/m^2.
formatPower :: Double -> String
formatPower p =
  show p ++ " W/m^2"

-- | Format full simulation result.
formatResult :: SimulationResult -> String
formatResult result =
  unlines
    [ "Equilibrium Temperature: " ++ formatTemperature temp
    , "Absorbed Power: " ++ formatPower power
    , "Particle Mass: " ++ formatMass mass
    , "Efficiency: " ++ show efficiency
    ]
  where
    temp = equilibriumTemperature result
    power = absorbedPower result
    mass = particleMass result
    efficiency = warmingEfficiency result

-- | Format list of results.
formatResults :: [SimulationResult] -> String
formatResults results =
  concatMap formatResult results

-- | CSV header.
csvHeader :: String
csvHeader =
  "temperature,absorbed_power,particle_mass,efficiency\n"

-- | Format single result as CSV row.
formatCSVRow :: SimulationResult -> String
formatCSVRow result =
  show t ++ "," ++ show p ++ "," ++ show m ++ "," ++ show e ++ "\n"
  where
    t = temperatureValue (equilibriumTemperature result)
    p = absorbedPower result
    m = particleMass result
    e = warmingEfficiency result

-- | Format multiple results as CSV.
formatCSV :: [SimulationResult] -> String
formatCSV results =
  csvHeader ++ concatMap formatCSVRow results

-- | Format optimal result.
formatOptimalResult :: SimulationResult -> String
formatOptimalResult result =
  "Optimal Configuration:\n" ++ formatResult result