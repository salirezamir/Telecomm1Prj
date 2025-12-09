# Telecommunication I Course Project

**Course:** Telecommunication I (IUST)  
**Semester:** 402-2  
**Student:** Seyed Alireza Mirabedini

## 📋 Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Part 1: Audio Signal Analysis](#part-1-audio-signal-analysis)
  - [Audio Signal Spectrum](#audio-signal-spectrum)
  - [White Noise Analysis](#white-noise-analysis)
  - [Quadrature Noise Component](#quadrature-noise-component)
  - [Noise and Phase Shift Combination](#noise-and-phase-shift-combination)
  - [Phase Compensation](#phase-compensation)
  - [Filtering Analysis](#filtering-analysis)
- [Part 2: Simulink AM Modulation](#part-2-simulink-am-modulation)
  - [AM Modulator](#am-modulator)
  - [AM Detector](#am-detector)
- [Files Description](#files-description)
- [Requirements](#requirements)
- [Usage](#usage)
- [Results](#results)

## 🎯 Overview

This project investigates the effects of noise, phase shift, and filtering on audio signals, and implements AM (Amplitude Modulation) modulator and detector systems using MATLAB/Simulink. The project consists of two main parts:

1. **Audio Signal Processing**: Analysis of audio signals with noise, phase shifts, and various filtering techniques
2. **AM Modulation System**: Design and simulation of AM modulator and detector circuits

## 📁 Project Structure

```
.
├── Main.m                              # Main MATLAB script for Part 1
├── A.m                                 # Script to create structure A for AM modulator
├── B.m                                 # Script to create structure B for AM detector
├── Am.slx                              # Simulink model: AM Modulator
├── AmDet.slx                           # Simulink model: AM Detector
├── Avaz on Rumi Sonnet.mp3            # Input audio file (Rumi sonnet)
├── Am_032.wav, Am_100.wav, Am_150.wav # AM modulated outputs (m=0.32, 1.0, 1.5)
├── Det_032.wav, Det_100.wav, Det_150.wav # AM detector outputs (before filter)
├── Det_F_032.wav, Det_F_100.wav, Det_F_150.wav # AM detector outputs (after filter)
├── Channel.wav                         # Phase compensated signal
├── Channel_Filtered.wav               # Filtered before phase compensation
├── Channel_After_Filtered.wav         # Filtered after phase compensation
├── shifted_audio.wav                  # Phase-shifted audio
├── shifted_audio_with_noise.wav       # Phase-shifted audio with noise
├── Compare_1.png, Compare_2.png       # Comparison plots
├── doc.pdf                            # Project documentation (PDF)
└── doc.docx                           # Project documentation (DOCX)
```

## 🔊 Part 1: Audio Signal Analysis

### Audio Signal Spectrum

The project begins by analyzing an audio file containing a segment of Rumi's poetry recitation. The audio signal is loaded and its Fourier transform is computed to visualize the frequency spectrum.

```matlab
message = importdata("Avaz on Rumi Sonnet.mp3");
F = linspace(0, message.fs, nfft);
msg_ft_data = fft(message.data, nfft);
msg_absft_data = abs(msg_ft_data);

plot(F(1:nfft/2), msg_absft_data(1:nfft/2));
xlabel("Frequency");
ylabel("Domain");
title("Frequency - Domain Plot")
```

**Observation:** The spectrum analysis shows that the audio signal is a baseband signal.

### White Noise Analysis

White Gaussian noise is generated and added to the signal to study its effects:

```matlab
white_noise = wgn(length(message.data), 2, -20);
white_noise_ft = fft(white_noise, nfft);
white_noise_ftabs = abs(white_noise_ft);
```

**Observation:** The spectrum shows that white noise contains all frequency components uniformly distributed.

### Quadrature Noise Component

The quadrature component of noise is extracted using the Hilbert transform:

```matlab
white_noise_Qd = imag(hilbert(white_noise, nfft));
```

**Observation:** The imaginary part of the Hilbert transform represents the quadrature component of the noise.

### Noise and Phase Shift Combination

Phase shift is applied to the signal along with noise addition:

```matlab
signal_ft_shifted = msg_ft_data .* exp(4i*pi/9);
signal_ft_shifted_WithNoise = signal_ft_shifted + white_noise_ft;
signal_ft_WithNoise = msg_ft_data + white_noise_ft;
signal_shifted = real(ifft(signal_ft_WithNoise));
audiowrite('shifted_audio_with_noise.wav', signal_shifted, message.fs);
```

**Observation:** While white noise is audible, phase shift alone is not perceptible. However, when combined, the changes become noticeable.

### Phase Compensation

Phase compensation is performed to restore the original signal:

```matlab
channel_ft = signal_ft_WithNoise .* exp(-4i*pi/9);
channel_phase = angle(channel_ft);
channel_abs = abs(channel_ft);
audiowrite('Channel.wav', real(ifft(channel_ft)), message.fs);
```

### Filtering Analysis

Two filtering approaches are compared:

#### 1. Filtering Before Phase Compensation

```matlab
Filtered = lowpass(ifft(signal_ft_WithNoise), 16000, 44100);
Filtered_ft = fft(Filtered, nfft);
Filtered_channel = Filtered_ft .* exp(-4i*pi/9);
audiowrite('Channel_Filtered.wav', real(ifft(Filtered_channel)), message.fs);
```

#### 2. Filtering After Phase Compensation

```matlab
Filtered_After = lowpass(real(ifft(channel_ft)), 16000, 44100);
Filtered_After_ft = fft(Filtered_After, nfft);
audiowrite('Channel_After_Filtered.wav', real(ifft(Filtered_After_ft)), message.fs);
```

**Observation:** Analysis shows that the first 16 kHz is the most important frequency range. Filtering before phase compensation produces better results with reduced noise.

## 📡 Part 2: Simulink AM Modulation

### AM Modulator

The AM modulator is implemented in Simulink (`Am.slx`) with modulation index calculated as:

```
μ = 0.2 + (24/200) = 0.32
```

The modulator is tested with three different modulation indices:
- m = 0.32
- m = 1.0
- m = 1.5

**Observation:** The modulated output is an unintelligible sound where only the beat patterns are distinguishable.

**Output Files:** `Am_032.wav`, `Am_100.wav`, `Am_150.wav`

### AM Detector

The AM detector circuit is implemented using SimScape in Simulink (`AmDet.slx`). It demodulates the AM signal and includes filtering for noise reduction.

**Key Findings:**
- The output signal is successfully converted back to baseband
- Some noise is present in the output
- A low-pass filter significantly improves output quality
- Higher modulation index (m) results in better signal-to-noise ratio

**Output Files:**
- Before filtering: `Det_032.wav`, `Det_100.wav`, `Det_150.wav`
- After filtering: `Det_F_032.wav`, `Det_F_100.wav`, `Det_F_150.wav`

## 📋 Files Description

| File | Description |
|------|-------------|
| `Main.m` | Main MATLAB script implementing audio signal processing |
| `A.m` | Creates structure A for AM modulator input |
| `B.m` | Creates structure B for AM detector analysis |
| `Am.slx` | Simulink model for AM modulator |
| `AmDet.slx` | Simulink model for AM detector |
| `Avaz on Rumi Sonnet.mp3` | Input audio file |
| `Am_*.wav` | AM modulated signals at different modulation indices |
| `Det_*.wav` | Demodulated signals (before filter) |
| `Det_F_*.wav` | Demodulated signals (after filter) |
| `Channel*.wav` | Various filtered and phase-compensated signals |
| `shifted_audio*.wav` | Phase-shifted audio signals |
| `Compare_*.png` | Comparison plots |

## 🔧 Requirements

- MATLAB (R2019b or later recommended)
- Simulink
- Signal Processing Toolbox
- SimScape (for AM detector circuit simulation)
- Audio System Toolbox

## 🚀 Usage

### Running Part 1 (Audio Signal Processing)

```matlab
% Run the main script
run('Main.m')
```

This will generate various plots and audio files showing the effects of noise, phase shift, and filtering.

### Running Part 2 (Simulink AM Modulation)

1. Open MATLAB and navigate to the project directory
2. Run `A.m` to create input structure for the modulator:
   ```matlab
   run('A.m')
   ```
3. Open and run the AM modulator model:
   ```matlab
   open('Am.slx')
   ```
4. Run `B.m` to create structure for detector analysis:
   ```matlab
   run('B.m')
   ```
5. Open and run the AM detector model:
   ```matlab
   open('AmDet.slx')
   ```

## 📊 Results

### Part 1 Conclusions

- The input audio signal is confirmed to be a baseband signal
- White noise uniformly affects all frequency components
- Phase shift alone is not audible but becomes noticeable when combined with noise
- Lowpass filtering at 16 kHz cutoff effectively reduces noise
- Filtering before phase compensation produces superior results compared to filtering after

### Part 2 Conclusions

- AM modulation successfully implemented for three different modulation indices
- Higher modulation index (m) results in better signal quality and SNR
- The detector circuit successfully demodulates the AM signal
- Post-detection lowpass filtering significantly improves audio quality
- The modulation index of 1.5 provides the best output signal relative to noise

## 👨‍🎓 Author

**Seyed Alireza Mirabedini**  
Student ID: 401414024  
Iran University of Science and Technology (IUST)

## 📄 License

This project is part of academic coursework. See [LICENSE](LICENSE) for details.
