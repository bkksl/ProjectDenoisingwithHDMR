clear all;
close all;
clc;

z=0;
V = niftiread('sub-18_func_sub-18_task-expo_run-3_bold.nii');
[aa, bb, cc, dd] = size(V);

for i=1:4:cc
    Fmri = V(:,:,i); 
    figure;
    subplot(2,2,1);
    imshow(Fmri,[]);
    title('Ground-truth');
    J = imnoise(V,'gaussian',0.001,0.001); % noise added
    NoisyData = J(:,:,i);
    subplot(2,2,2);
    imshow(NoisyData,[]);
    title('Noisy Data');


    %%% Saving the nii file to which we added noise, in nifti format
    niftiwrite(J, 'NoisyData(J)_filename.nii'); 
    
    %%% HDMR CODE PART
    %denoising
    %"Recdreccons" is the end of the HDMR Part
    %%%

    result(:,:,:)=Recdreccons(:,:,:,1);
    after = result(:,:,i); 
    
    %%% The result denoising with HDMR
    subplot(2,2,3);
    imshow(after,[]);
    title('HDMR Denoising');

    %%% Saving the nii file to which we -denoised with HDMR-, in nifti format
    niftiwrite(result, 'HDMRDenoised(result)_filename.nii'); 
    
    %%% The result denoising with Gauss Filter
    N=imgaussfilt(J);
    e = N(:,:,i);
    subplot(2,2,4);
    imshow(e,[]);
    title('Gauss Filtering');

    %%% SSIM method is used to compare denoising methods.
    z = z+1;
    [ssimval_HDMR,ssimmap2] = ssim(int16(result),V(:,:,:,i));
    HDMR(z) = ssimval_HDMR
    [ssimval_GaussFilter,ssimmap] = ssim(N(:,:,:,i),V(:,:,:,i));
    GF(z) = ssimval_GaussFilter
    
end

%%% Plotting the SSIM results for comparing the HDMR and Gauss Filter
%%% Method
x=1:1:z;
y1=HDMR;
y2=GF;
figure;
subplot(2,1,1);
plot(x,y1,'.b');
title('HDMR SSIM Results');
xlabel('Slice Value','FontWeight','bold');
ylabel('SSIM Value','FontWeight','bold');
subplot(2,1,2);
plot(x,y2,'.b');
title('Gauss Filter SSIM Results');
xlabel('Slice Value','FontWeight','bold');
ylabel('SSIM Value','FontWeight','bold');
%%%%