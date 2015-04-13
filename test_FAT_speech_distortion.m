current_dir = fileparts(mfilename('fullpath'));
added_path  = {};

added_path{end+1} = '~/Library/Matlab/vocoder_2015';
addpath(added_path{end});

options = expe_options();
[expe, options] = expe_build_conditions_freq_tables(options);
phase = 'test';
nfile = 0;

out_dir = '/Users/denizbaskent/Experiments/Nawal/FATs-Exp2/test_speech_distortion/';

while mean([expe.( phase ).conditions.done])~=1
    nfile = nfile+1;
% Find first condition not done
    i_condition = find([expe.( phase ).conditions.done]==0, 1);
    fprintf('\n============================ Testing condition %d / %d ==========\n', i_condition, length(expe.( phase ).conditions))
    condition = expe.( phase ).conditions(i_condition);

    if condition.vocoder==0
        fprintf('No vocoder\n\n');
    else
        if condition.dir_voice == 5
            target = 'male';
        elseif condition.dir_voice == 7
            target = 'child';
        else
            target = 'other';
        end
        fprintf('Vocoder: %s\n %s\n %s\n\n', options.vocoder(condition.vocoder).label, options.vocoder(condition.vocoder).parameters.analysis_filters.type,target);
    end
    
    % Prepare unitary vector for this voice direction
    u_f0  = 12*log2(options.test.voices(condition.dir_voice).f0 / options.test.voices(condition.ref_voice).f0);
    u_ser = 12*log2(options.test.voices(condition.dir_voice).ser / options.test.voices(condition.ref_voice).ser);
    u = [u_f0, u_ser];
    u = u / sqrt(sum(u.^2));
    
    %fprintf('----------\nUnitary vector: %s\n', num2str(u));
    
    difference = options.(phase).starting_difference;
    step_size  = options.(phase).initial_step_size;
    
    %response_correct = [];
    %decision_vector  = [];
    %steps = [];
    differences = [difference];
    
    % Prepare the trial
        trial = condition;
        
        % Compute test voice
        new_voice_st = difference*u;
        trial.f0 = options.test.voices(trial.ref_voice).f0 * [1, 2^(new_voice_st(1)/12)];
        trial.ser = options.test.voices(trial.ref_voice).ser * [1, 2^(new_voice_st(2)/12)];
        
        ifc = randperm(size(options.f0_contours, 1)); %%% Why is it an 8-by-3 matrix, where all 3 are different?
        trial.f0_contours = options.f0_contours(ifc(1:3), :);
        
        isyll = randperm(length(options.syllables));
        for i_int=1:3
            trial.syllables{i_int} = options.syllables(isyll(1:options.n_syll));
        end
        
        %%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%
        
        % Prepare the stimulus
        
            [xOut, fs, i_correct] = expe_make_stim(options, trial);
            player = {};
            for i=1:length(xOut)
                x = xOut{i}*10^(-options.attenuation_dB/20);
                player{i} = audioplayer([zeros(1024*3, 2); x; zeros(1024*3, 2)], fs, 16);
                %fprintf('Interval %d max: %.2f\n', i, max(abs(x(:))));
            end
            
            isi = audioplayer(zeros(floor(.2*fs), 2), fs);

            pause(.5);

            % Play the stimuli
%             for i=1:length(xOut)
%                 playblocking(player{i});
%                 if i~=length(xOut)
%                     playblocking(isi);
%                     % pause(.2);
%                 end
%             end
            
            out_file = [xOut{1,1}; zeros(floor(.2*fs),2);...
                xOut{1,2}; zeros(floor(.2*fs),2);...
                xOut{1,3};zeros(floor(.2*fs),2)];
            out_filename = strcat(out_dir,'12-smt-Vocoder:',num2str(condition.vocoder), '-sample_', num2str(nfile),'.wav');
            wavwrite(out_file,fs,out_filename);
            expe.( phase ).conditions(i_condition).done = 1;
       
end