% 设置当前工作目录
currentFolder = pwd;

% 查找所有子文件夹和 WAV 文件
wavFiles = dir(fullfile(currentFolder, '**', '*.wav'));

% 遍历每个 WAV 文件
for k = 1:length(wavFiles)
    % 获取文件的完整路径
    filePath = fullfile(wavFiles(k).folder, wavFiles(k).name);
    
    % 读取音频文件
    [audioData, fs] = audioread(filePath);
    
    % 确保是立体声文件
    if size(audioData, 2) == 2
        % 找到所有通道的最大音量
        maxVolume = max(rms(audioData)); % RMS 为每个通道计算根均方值
        
        % 归一化
        if maxVolume > 0
            audioData = audioData / maxVolume; % 归一化
        end
        
        % 调整音量
        audioData = audioData * 0.6; % 乘以 0.6
        
        % 确保音频数据在合法范围内
        audioData = max(min(audioData, 1), -1);
        
        % 保存替换源文件
        audiowrite(filePath, audioData, fs);
        
        fprintf('Processed: %s\n', filePath); % 输出处理信息
    else
        fprintf('Skipping non-stereo file: %s\n', filePath); % 输出跳过信息
    end
end

disp('All WAV files processed successfully.');
