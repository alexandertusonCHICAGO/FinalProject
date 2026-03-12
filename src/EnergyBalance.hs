module EnergyBalance where

import Types
import RadiativeTransfer

-- | Stefan–Boltzmann constant.
stefanBoltzmann :: Double
stefanBoltzmann = 5.670374419e-8

-- | Compute emission power at temperature.
emissionPower :: Temperature -> Double
emissionPower (Temperature t) =
  stefanBoltzmann * t**4

-- | Compute equilibrium temperature from absorbed power.
equilibriumTemperatureFromPower :: Double -> Temperature
equilibriumTemperatureFromPower power =
  Temperature ((power / stefanBoltzmann) ** 0.25)

-- | Compute particle column mass.
particleColumnMass :: Atmosphere -> Double
particleColumnMass atm =
  n * volume * ρ
  where
    p = particle atm
    r = radius p
    ρ = density p
    n = columnDensity atm
    volume = (4/3) * pi * r**3

-- | Run full simulation.
runSimulation :: SimulationConfig -> SimulationResult
runSimulation config =
  SimulationResult
    { equilibriumTemperature = temp
    , absorbedPower = absorbed
    , particleMass = mass
    }
  where
    incoming = solarSpectrum config
    transmitted = computeTransmittedSpectrum config incoming
    absorbed = totalAbsorbedPower incoming transmitted
    temp = equilibriumTemperatureFromPower absorbed
    mass = particleColumnMass (atmosphereConfig config)