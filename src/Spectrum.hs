module Spectrum where

import Types

-- | Construct spectrum from wavelength bounds and flux function.
generateSpectrum :: Double -> Double -> Int -> (Wavelength -> Flux) -> Spectrum
generateSpectrum λmin λmax n f =
  Spectrum [(Wavelength λ, f (Wavelength λ)) | λ <- grid]
  where
    step = (λmax - λmin) / fromIntegral n
    grid = [λmin + step * fromIntegral i | i <- [0..n]]

-- | Convert spectrum to raw list.
spectrumToList :: Spectrum -> [(Wavelength, Flux)]
spectrumToList (Spectrum xs) = xs

-- | Apply transformation to flux values.
mapSpectrum :: (Flux -> Flux) -> Spectrum -> Spectrum
mapSpectrum g (Spectrum xs) =
  Spectrum [(λ, g f) | (λ, f) <- xs]

-- | Combine two spectra pointwise.
zipSpectrumWith :: (Flux -> Flux -> Flux) -> Spectrum -> Spectrum -> Spectrum
zipSpectrumWith f (Spectrum xs) (Spectrum ys) =
  Spectrum [(λ, f fx fy) | ((λ, fx), (_, fy)) <- zip xs ys]

-- | Integrate spectrum by summing flux values.
integrateSpectrum :: Spectrum -> Double
integrateSpectrum (Spectrum xs) =
  sum [fluxValue f | (_, f) <- xs]