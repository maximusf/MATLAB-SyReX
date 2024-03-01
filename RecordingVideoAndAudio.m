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

% preview(mycam) % displays webcam

%_____________________
% Prompt user to enter duration for video recording
videoDuration = input('Enter the duration for video recording (in seconds): ');

% Prompt user to enter duration for audio recording
audioDuration = input('Enter the duration for audio recording (in seconds): ');

% Check if durations are valid
    if videoDuration <= 0 || audioDuration <= 0
        error('Invalid duration. Both durations must be positive.');
    end
%_____________________

recordVideoAndAudio(videoDuration,audioDuration); % calls the function for recording video and audio

disp('Recordings are done.');

%_____________________
% function that records both video and audio using
% parameters of videoDuration and audioDuration
function recordVideoAndAudio(videoDuration, audioDuration)
    % Perform video recording
    recordVideoFunction(videoDuration);
    
    % Perform audio recording
    recordAudioFunction(audioDuration);
    
end

% records video for given amount of time
function recordVideoFunction(videoDuration)
    
    % Set up webcam
    cam = webcam;
   
    % Set up video writer to create an mp4 file
    videoFile = VideoWriter('video.avi');
    videoFile.FrameRate = 30; % sets to 30 fps
    %videoFile.FrameRate
    % Open the video file for writing
    open(videoFile);
    
    % Display message of webcam recording
    disp('Webcam is recording..');
    
    % Displays the webcam
    preview(cam);
    
    % calculate number of frames to capture
    numFrames = videoDuration * videoFile.FrameRate;
    a = 0;
    for frameIdx = 1:numFrames
        frame = snapshot(cam);
        a = a + 1;
        
        writeVideo(videoFile,frame)

    end
    closePreview(cam);
    

    %nFrames = videoDuration * videoFile.FrameRate
    
    % Display message of webcam recording completion
    disp('Webcam recording completed.')

    % Release webcam and close video file
    clear cam;
    close (videoFile);
    
end

% records audio for given amount of time
function recordAudioFunction(audioDuration)
    
    % variables for audio recording
    Fs = 48000; % 48 kHz sampling rate
    nbits = 16; % 16 bits per sample
    ch = 1; % num of channels (2 options) 1 mono or 2 stereo
    
    % Set up microphone
    audio = audiorecorder(Fs,nbits,ch);
    
    % Display message to start speaking
    disp('You may speak now'); 
    
    % records for the given duration
    recordblocking(audio,audioDuration);
    
    % Get the recorded audio data
    audioData = getaudiodata(audio);
    
    % Save the audio to a file
    audiowrite('audioRecording.wav', audioData, Fs);
    
    % Display successful audio recording
    disp('Microphone recording completed.');

end
