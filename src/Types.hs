module Types where

-- | Wavelength in meters.
newtype Wavelength = Wavelength Double
  deriving (Show, Eq, Ord)

-- | Spectral flux in W/m^2 per bin.
newtype Flux = Flux Double
  deriving (Show, Eq, Ord)

-- | Temperature in Kelvin.
newtype Temperature = Temperature Double
  deriving (Show, Eq, Ord)

-- | Optical depth, dimensionless extinction measure.
newtype OpticalDepth = OpticalDepth Double
  deriving (Show, Eq, Ord)

-- | Single particle species with size, density, and spectral extinction efficiency.
data Particle = Particle
  { radius :: Double
  , density :: Double
  , extinctionEfficiency :: Wavelength -> Double
  }

-- | Atmospheric column defined by particle type and number density per area.
data Atmosphere = Atmosphere
  { particle :: Particle
  , columnDensity :: Double
  }

-- | Discrete spectral distribution.
data Spectrum = Spectrum [(Wavelength, Flux)]
  deriving (Show)

-- | Complete simulation input state.
data SimulationConfig = SimulationConfig
  { solarSpectrum :: Spectrum
  , atmosphereConfig :: Atmosphere
  , planetaryAlbedo :: Double
  }

-- | Output state from a simulation run.
data SimulationResult = SimulationResult
  { equilibriumTemperature :: Temperature
  , absorbedPower :: Double
  , particleMass :: Double
  }
  deriving (Show)

-- | Extract numeric temperature.
temperatureValue :: Temperature -> Double
temperatureValue (Temperature t) = t

-- | Extract numeric flux.
fluxValue :: Flux -> Double
fluxValue (Flux f) = f

-- | Extract numeric wavelength.
wavelengthValue :: Wavelength -> Double
wavelengthValue (Wavelength λ) = λ

-- | Extract numeric optical depth.
opticalDepthValue :: OpticalDepth -> Double
opticalDepthValue (OpticalDepth τ) = τ