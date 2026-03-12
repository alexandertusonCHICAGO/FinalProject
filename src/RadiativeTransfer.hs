module RadiativeTransfer where

import Types
import Spectrum

-- | Extinction cross-section for particle at wavelength.
crossSection :: Particle -> Wavelength -> Double
crossSection p λ =
  extinctionEfficiency p λ * pi * r * r
  where
    r = radius p

-- | Optical depth of atmosphere at wavelength.
opticalDepth :: Atmosphere -> Wavelength -> OpticalDepth
opticalDepth atm λ =
  OpticalDepth (σ * n)
  where
    σ = crossSection (particle atm) λ
    n = columnDensity atm

-- | Apply extinction law to flux.
applyExtinction :: OpticalDepth -> Flux -> Flux
applyExtinction (OpticalDepth τ) (Flux f) =
  Flux (f * exp (-τ))

-- | Compute transmitted spectrum after atmospheric extinction.
computeTransmittedSpectrum :: SimulationConfig -> Spectrum -> Spectrum
computeTransmittedSpectrum config spectrum =
  Spectrum [(λ, applyExtinction (opticalDepth atm λ) f) | (λ, f) <- xs]
  where
    atm = atmosphereConfig config
    xs = spectrumToList spectrum

-- | Compute absorbed spectrum.
computeAbsorbedSpectrum :: Spectrum -> Spectrum -> Spectrum
computeAbsorbedSpectrum incoming transmitted =
  zipSpectrumWith subtractFlux incoming transmitted

-- | Total absorbed power.
totalAbsorbedPower :: Spectrum -> Spectrum -> Double
totalAbsorbedPower incoming transmitted =
  integrateSpectrum absorbed
  where
    absorbed = computeAbsorbedSpectrum incoming transmitted

-- | Flux subtraction helper.
subtractFlux :: Flux -> Flux -> Flux
subtractFlux (Flux a) (Flux b) =
  Flux (a - b)