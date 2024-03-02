% Written by Maximus Fernandez
% 2/23/2024

%{
 Clears the command window
 & workspace variables
 & any relevant windows
%}

clc
close all
warning off

% Initialize counter for video and audio files
counter = 1;

% Perform recording until user chooses to stop
while true
    % Prompt user to enter duration for video recording
    videoDuration = input('Enter the duration for video recording (in seconds): ');

    % Prompt user to enter duration for audio recording
    audioDuration = input('Enter the duration for audio recording (in seconds): ');

    % Check if durations are valid
    if videoDuration <= 0 || audioDuration <= 0
        error('Invalid duration. Both durations must be positive.');
    end

    % Call function to record video and audio
    recordVideoAndAudio(videoDuration, audioDuration, counter);

    % Prompt user if they want to record again
    prompt = 'Do you want to record again? (yes/no): ';
    repeat = input(prompt, 's');

    % Check if user wants to repeat recording
    if strcmpi(repeat, 'no')
        break; % Exit loop if user does not want to repeat recording
    else
        % Increment counter for next set of recordings
        counter = counter + 1;
    end
end

disp('All recordings are done.');

% Function to record both video and audio
function recordVideoAndAudio(videoDuration, audioDuration, counter)
    % Record video
    recordVideoFunction(videoDuration, counter);

    % Record audio
    recordAudioFunction(audioDuration, counter);
end

% Function to record video for given duration
function recordVideoFunction(videoDuration, counter)
    % Set up webcam
    cam = webcam;

    % Set up video writer to create an avi file
    videoFilename = sprintf('video_%d.avi', counter);
    videoFile = VideoWriter(videoFilename);
    videoFile.FrameRate = 30; % sets to 30 fps
    open(videoFile);

    % Display message of webcam recording
    disp('Webcam is recording...');

    % Display the webcam preview
    preview(cam);

    % Calculate number of frames to capture
    numFrames = videoDuration * videoFile.FrameRate;
    for frameIdx = 1:numFrames
        frame = snapshot(cam);
        writeVideo(videoFile, frame);
    end

    % Close webcam preview
    closePreview(cam);

    % Display message of webcam recording completion
    disp('Webcam recording completed.');

    % Release webcam and close video file
    clear cam;
    close(videoFile);
end

% Function to record audio for given duration
function recordAudioFunction(audioDuration, counter)

    % variables for audio quality
    Fs = 48000; % 48 kHz sampling rate
    nbits = 16; % 16 bits per sample
    ch = 1; % num of channels (2 options) 1 mono or 2 stereo

    % Set up microphone
    audio = audiorecorder(Fs,nbits,ch);

    % Display message to start speaking
    disp('You may speak now');

    % Record audio for the given duration
    recordblocking(audio, audioDuration);

    % Get the recorded audio data
    audioData = getaudiodata(audio);

    % Generate audio filename
    audioFilename = sprintf('audio_%d.wav', counter);

    % Save the audio to a file
    audiowrite(audioFilename, audioData, Fs);

    % Display successful audio recording
    disp('Microphone recording completed.');
end
