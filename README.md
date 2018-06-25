# Hilbert-Huang transform in Matlab
A light version of the Hilbert-Huang Transform for Matlab. This version uses the Normalized Hilbert Transform to define and calculate the amplitude and phase. 

## How to use this software?

There are two essential functions to the hht code. It is the `emd(·)` and the `hilbertSpectrum(·)`. The `emd(·)` function decomposes a one-dimensional array down to the fewest monocomponents *c*<sub>*i*</sub>(*t*) and one monotonic function *r*(*t*) that is needed to describe it. 

## Example

Lets considering the equation

  *v(t)* = sin(*ω<sub>0</sub> t*) + 0.5 cos(*ω<sub>1</sub> t*<sup>2</sup>)

It is shown in the figure below

<img src="fig/examples/raw.png" width="400">

### Empirical Mode Decomposition
As shown in the example code, we can decompose the voltage waveform *v(t)* using

```c
[intrinsicModeFunctions, res] = emd(voltageWaveform);
```

This will decompose the voltage waveform _v(t)_ down to two intrinsic mode functions (IMFs) and a residue so that

_v(t)_ = Σ_c<sub>i</sub>(t)_ + _r(t)_

where _c<sub>i</sub>(t)_ is IMF number _i_ and _r(t)_ is the residue. The IMFs and residue of the example waveform are shown in the figure below.

<img src="fig/examples/imf.png" width="400">

### Hilbert Spectrum
The IMFs can be visualized using a Hilbert Spectrum. In the Hilbert Spectrum shows the instantaneous frequency _f(t)_ the frequency components power (amplitude squared) as a function of time. To use the Hilbert Spectrum function write
```c
medianFilterLength = 0.02 * samplingFrequency;
hilbertSpectrum(intrinsicModeFunctions, samplingFrequency, medianFilterLength)
```
where the `medianFilterLength` is the length of a median filter used to remove artifacts. In this example, the filter length is 2 % of the sampling rate. The figure below shows the Hilbert Spectrum of the example waveform _v(t)_.

<img src="fig/examples/hs.png" width="400">

# TODO:
- [ ] Argument for fixed EMD
- [ ] Ensure that residue output is correct

## License

Copyright © 2015-2018 Geir Kulia

Licensor: Geir Kulia

Use Limitation: 1 user

License Grant. Licensor hereby grants to each recipient of the Software (“you”) a non-exclusive, non-transferable, royalty-free and fully-paid-up license, under all of the Licensor’s copyright and patent rights, to use, copy, distribute, prepare derivative works of, publicly perform and display the Software, subject to the Use Limitation and the conditions set forth below.

Use Limitation. The license granted above allows use by up to the number of users per entity set forth above (the “Use Limitation”). For determining the number of users, “you” includes all affiliates, meaning legal entities controlling, controlled by, or under common control with you. If you exceed the Use Limitation, your use is subject to payment of Licensor’s then-current list price for licenses.

Conditions. Redistribution in source code or other forms must include a copy of this license document to be provided in a reasonable manner. Any redistribution of the Software is only allowed subject to this license.

Trademarks. This license does not grant you any right in the trademarks, service marks, brand names or logos of Licensor.

DISCLAIMER. THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OR CONDITION, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. LICENSORS HEREBY DISCLAIM ALL LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE.

Termination. If you violate the terms of this license, your rights will terminate automatically and will not be reinstated without the prior written consent of Licensor. Any such termination will not affect the right of others who may have received copies of the Software from you.
