# Set the tempo to 105 BPM
use_bpm 105

# Define two bars of music with notes
firstBar = [:B2, :Gb3, :B3, :G3, :Gb3, :B3, :D3, :G3]
secondBar = [:G2, :Gb3, :B3, :G3, :Gb3, :B3, :D3, :G3]

# Initialize a counter for bars
bar_counter = 0

# Create a ring of all notes to be used in the track
allNotes = (firstBar + secondBar).ring

# Use the 'pretty_bell' synth for the melody
use_synth :pretty_bell

# Create a live loop for the first track
live_loop :track1 do
  with_fx :reverb, room: 0.75, mix: 0.6 do
    note = allNotes.tick
    
    # Play notes with special conditions
    if note == firstBar[0] || note == secondBar[0]
      play note, release: 4, amp: 1.4
    elsif bar_counter < 16 || bar_counter > 48
      play note
    end
    
    sleep 1
  end
  
  # Increment the bar counter
  bar_counter += 1
  
  # Start the drums loop after 48 bars
  if bar_counter == 48
    cue :start_drums
  end
end

# Create a live loop for the drums, synced with 'start_drums' cue
live_loop :drums, sync: :start_drums do
  pattern = "- x xxxxoxxxx xx--xxx xxox xx x " # Drum pattern
  beat = pattern.ring.tick
  
  # Play different drum samples based on the pattern
  if beat == "x"
    sample :drum_cymbal_closed
  elsif beat == "-"
    sample :drum_bass_hard
  elsif beat == "o"
    sample :drum_snare_hard
  end
  
  sleep 0.25
end

# Create a live loop for the second track (guitar-like notes)
live_loop :track2 do
  sleep 2.5
  play :B2
  sleep 1
  play :B2
  sleep 4.5
end
