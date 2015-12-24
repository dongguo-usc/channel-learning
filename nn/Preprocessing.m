function [X,y] = Preprocessing(File)
% Preprocess GSCM Simulated Channel Response
%% version:  V3.0.0 
%���������������ȩЩة�
%=============================================================
% Changes:
%  ��reshape input 
%=============================================================
% Todos:  

File = '../channelGen/2D_data_with_2150+-50MHz_11_samples_20_antennas_fixed_10_SBSs_10_scatterers_2000_MSs.mat';

load(File);  % Load from dataset

%% Different feature generation methods
% F = fft(H_MBS,[],2);
% X = abs(F);

% X = [abs(F),angle(F)];


% %  MS locations as input
% X = [MS_locations(:,1)/max(abs(MS_locations(:,1))),MS_locations(:,2)/max(abs(MS_locations(:,2)))];
%F = fft2(H_MBS);
F = fft(H_MBS,[],2);%fre-anglef
% for i=1:N_MS
%     f1=reshape(F(i,:,:),N_MBS,N_frequency);
%     F(i,:,:)=fft(f1,[],2);
% end
Temp = log(abs(F));
cod = lloyds(Temp(:),20);
q = reshape(quantiz(Temp(:),cod),N_MS,N_MBS*N_frequency);
X = q;
X = (X-4.5)/4.5;

% % quantiz for MS_locations
% N = 5;
% [px,~] = lloyds(MS_locations(:,1),2^N);
% [py,~] = lloyds(MS_locations(:,2),2^N);
% index_x = quantiz(MS_locations(:,1),px);
% index_y = quantiz(MS_locations(:,2),py);
% sx = dec2bin(index_x,N);
% sy = dec2bin(index_y,N);
% X = zeros(size(MS_locations,1),2*N);
% for i = 1:N
%     X(:,i) = str2num(sx(:,i));
%     X(:,i+N) = str2num(sy(:,i));
% end
    % 2*2^N length
% X = zeros(size(MS_locations,1),2*(2^N));
% for i = 1:size(MS_locations,1)
%     X(i,index_x(i)+1)=1;
%     X(i,index_y(i)+N+1)=1;
% end

%% generate y
H_SBSr=reshape(H_SBS,N_MS*N_frequency,N_SBS);
[~,y] = max(abs(H_SBSr),[],2);                  % Connect to the SBS with largest SNR
end