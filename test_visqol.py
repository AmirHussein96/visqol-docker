from audiotools import AudioSignal
from audiotools import metrics

signal_path = "/data/test.wav"
recons_path = "/data/test.wav"
signal = AudioSignal(signal_path)
recons = AudioSignal(recons_path)
visqol_score = metrics.quality.visqol(signal, recons, 'speech')
print(f"testing visqol: {visqol_score}")
