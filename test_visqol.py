from audiotools import AudioSignal
from audiotools import metrics
from train import losses

mel_loss = losses.MelSpectrogramLoss()
sisdr_loss = losses.SISDRLoss()


signal_path = "/data/test.wav"
recons_path = "/data/test.wav"
signal = AudioSignal(signal_path)
recons = AudioSignal(recons_path)
visqol_score = metrics.quality.visqol(signal, recons, 'speech')
sisdr = sisdr_loss(signal, recons)
mel = mel_loss(signal, recons)
print(f"testing visqol: {visqol_score}")
print(f"testing mel: {mel}")
print(f"testing sisdr: {sisdr}")
