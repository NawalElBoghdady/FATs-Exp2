function calibrate()


%load calibration matrices:
calib_mat_dir = '/Users/nawalelboghdady/Library/Matlab/Frequency Table Experiment 2/calibration mats/';

load(strcat(calib_mat_dir,'options'));
load(strcat(calib_mat_dir,'trial_d.mat'));
load(strcat(calib_mat_dir,'trial_sh.mat'));

trial = trial_d;
%trial{2} = trial_sh;

tic();
for voc = 1:8 %Loop on all vocoder conditions
    for direction = [5,7] %Loop on speaker direction
        
        trial.dir_voice = direction;
        trial.vocoder = voc;
        
        % Prepare unitary vector for this voice direction
        u_f0  = 12*log2(options.test.voices(trial.dir_voice).f0 / options.test.voices(trial.ref_voice).f0);
        u_ser = 12*log2(options.test.voices(trial.dir_voice).ser / options.test.voices(trial.ref_voice).ser);
        u = [u_f0, u_ser];
        u = u / sqrt(sum(u.^2));

        difference = options.test.starting_difference;
        
        new_voice_st = difference*u;
        trial.f0 = options.test.voices(trial.ref_voice).f0 * [1, 2^(new_voice_st(1)/12)];
        trial.ser = options.test.voices(trial.ref_voice).ser * [1, 2^(new_voice_st(2)/12)];
        
        ifc = randperm(size(options.f0_contours, 1)); 
        trial.f0_contours = options.f0_contours(ifc(1:3), :);
        
    

        switch direction
            case 5
                target = 'male';
            case 7
                target = 'child';
            otherwise
                target = 'other';
        end
        
        [xOut, fs] = calib_make_stim(options, trial);
        player = {};

        disp('----------------');
        fprintf('Vocoder %s %s\n, Voice %s\n',options.vocoder(voc).label,options.vocoder(voc).parameters.analysis_filters.type,target);
        fprintf('Unitary vector: %s\n', num2str(u));
        disp('----------------');
        for i=1:length(xOut)
            x = xOut{i}*10^(-options.attenuation_dB/20);
            player{i} = audioplayer([zeros(1024*3, 2); x; zeros(1024*3, 2)], fs, 16);
            %fprintf('Interval %d max: %.2f\n', i, max(abs(x(:))));
        end

        isi = audioplayer(zeros(floor(.005*fs), 2), fs);

        pause(.5);

        % Play the stimuli
        for i=1:length(xOut)
            playblocking(player{i});
            if i~=length(xOut)
                playblocking(isi);
                % pause(.2);
            end
        end
    end
end

toc();
    
end