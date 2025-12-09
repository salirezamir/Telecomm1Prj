A = struct;
A.time = transpose(0:1/44100:974063/44100);
A.signals.values = importdata("Avaz on Rumi Sonnet (96).mp3").data;