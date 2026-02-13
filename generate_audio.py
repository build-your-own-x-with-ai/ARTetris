
import wave
import math
import struct
import os

SAMPLE_RATE = 44100

def generate_tone(filename, frequency, duration, volume=0.5):
    n_frames = int(SAMPLE_RATE * duration)
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(SAMPLE_RATE)
        
        for i in range(n_frames):
            value = int(volume * 32767.0 * math.sin(2.0 * math.pi * frequency * i / SAMPLE_RATE))
            data = struct.pack('<h', value)
            wav_file.writeframes(data)

def generate_noise(filename, duration, volume=0.5):
    import random
    n_frames = int(SAMPLE_RATE * duration)
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(SAMPLE_RATE)
        
        for i in range(n_frames):
            value = int(volume * 32767.0 * (random.random() * 2 - 1))
            data = struct.pack('<h', value)
            wav_file.writeframes(data)

def generate_slide(filename, start_freq, end_freq, duration, volume=0.5):
    n_frames = int(SAMPLE_RATE * duration)
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(SAMPLE_RATE)
        
        for i in range(n_frames):
            freq = start_freq + (end_freq - start_freq) * (i / n_frames)
            value = int(volume * 32767.0 * math.sin(2.0 * math.pi * freq * i / SAMPLE_RATE))
            data = struct.pack('<h', value)
            wav_file.writeframes(data)

def generate_bgm(filename, duration=10.0):
    # Simple sequence of notes
    notes = [261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25]
    beat_duration = 0.25
    n_frames = int(SAMPLE_RATE * duration)
    
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(SAMPLE_RATE)
        
        current_frame = 0
        note_index = 0
        while current_frame < n_frames:
            freq = notes[note_index % len(notes)]
            for i in range(int(SAMPLE_RATE * beat_duration)):
                if current_frame >= n_frames: break
                value = int(0.3 * 32767.0 * math.sin(2.0 * math.pi * freq * i / SAMPLE_RATE))
                data = struct.pack('<h', value)
                wav_file.writeframes(data)
                current_frame += 1
            note_index += 1

output_dir = "ARTetris"
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

print("Generating audio files...")
generate_tone(os.path.join(output_dir, "move.wav"), 440, 0.05)
generate_tone(os.path.join(output_dir, "rotate.wav"), 660, 0.05)
generate_tone(os.path.join(output_dir, "drop.wav"), 220, 0.1)
generate_slide(os.path.join(output_dir, "clear.wav"), 440, 880, 0.3)
generate_slide(os.path.join(output_dir, "gameover.wav"), 440, 110, 1.0)
generate_bgm(os.path.join(output_dir, "bgm.wav"), 4.0)
print("Done.")
