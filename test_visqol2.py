import torch
from audiotools import AudioSignal
from audiotools import metrics
from dac.nn import loss

mel_loss = loss.MelSpectrogramLoss()
sisdr_loss = loss.SISDRLoss()

def add_gaussian_noise(signal: AudioSignal, snr_db: float = 20):
    audio = signal.samples  # (C, T)
    rms_signal = audio.pow(2).mean().sqrt()

    snr_linear = 10 ** (snr_db / 20)
    rms_noise = rms_signal / snr_linear

    noise = torch.randn_like(audio) * rms_noise
    noisy_audio = audio + noise

    return AudioSignal(noisy_audio, signal.sample_rate)

signal_path = "/data/test.wav"
signal = AudioSignal(signal_path)

# Add noise (20 dB SNR)
recons = add_gaussian_noise(signal, snr_db=20)

visqol_score = metrics.quality.visqol(signal, recons, 'speech')
sisdr = sisdr_loss(signal, recons)
mel = mel_loss(signal, recons)

print(f"testing visqol: {visqol_score}")
print(f"testing mel: {mel}")
print(f"testing sisdr: {sisdr}")
