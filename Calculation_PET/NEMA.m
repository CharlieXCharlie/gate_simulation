% ====================================================================
% Main function to process sinogram and reconstructed image and 
% calculate the NEMA test. Only can calculate one parameter each time,
% because the input file is different. This function calculate the 
% Spatial Resolution, Scatter Fraction and Sensitivity.
% Only for Siemens Biograph 16 HR PET scanner.
% ====================================================================
%% Initialzation
% The 'filedir' is the direction of the data folder. 
% The folder save the rebinned sinogram and reconstructed image, 
% which contains 'image' and 'sinogram'.
filedir 		= 'E:\Database\GATE_simulation_data\PET\ROOT16\'; 
para 			= input(':: Input the parameter of test Spatial ( Resolution[1]/ Scatter Fraction[2] /Sensitivity[3] ) : ');
input_bin_size 	= 2.05; % The bin size of the sinogram.
%%
switch para
	case 1
        %%
        disp ':: Calculate Spatial Resolution'
		% read data
		reload = input(':: Reload file? Yes[1]/No[0]  : ');
		if reload == 1
		    filefolder 	= input(':: Input folder name to load file : ','s');
			filepath 	= [filedir, filefolder];
		    type_recon 	= input(':: Input reconstruction type      : ','s');		    
			% read interfile
			[info,img] 	= read_interfile(filepath,type_recon);
		end

		img = flip(img,3);
		[res1,res10,p] 	= SpaResCal(img,info.ScalingFactorMmPixel1,info.ScalingFactorMmPixel3);

		disp  ':: The Spatial Resolution of the Scanner:'
		disp(['   Transverse FWHM        : ',num2str(res1(1)), ' Axial FWHM                 : ',num2str(res1(2))]);
		disp(['   Transverse FWTM        : ',num2str(res1(3)), ' Axial FWTM                 : ',num2str(res1(4))]);
		disp(['   Transverse radial FWHM : ',num2str(res10(1)),' Transverse tangential FWHM : ', num2str(res10(2)),' Axial FWHM : ',num2str(res10(3))]);
		disp(['   Transverse radial FWTM : ',num2str(res10(4)),' Transverse tangential FWTM : ', num2str(res10(5)),' Axial FWTM : ',num2str(res10(6))]);
	case 2
		%%
		disp ':: Calculate the Scatter Fraction'
		% read data
		reload = input(':: Reload file? ( Yes[1]/No[0] ) : ');

		if reload == 1
		    filefolder 	= input(':: Input folder name to load file : ','s');
			filepath 	= [filedir,filefolder];% path for win for bio16
		    type_recon 	= input(':: Input reconstruction type      : ','s');
		    % read interfile
			[info,img] 	= read_interfile(filepath,type_recon);
        end
%         Calculate bin position after correct
        bin_number 	= size(img,1);
        delta_phi 	= 90/12;
        delta_r 	= 0:12;
        delta_r 	= input_bin_size*2*cos(delta_phi/180*pi*delta_r);
        ind 		= 0:0.5:bin_number/4;
        half_pos 	= zeros(1,bin_number/2+1);
        ini 		= 0;
        for i=2:size(ind,2)
            if ind(i)<=7
                ini = ini+delta_r(1)/2;
            else
                ini = ini+delta_r(floor((ind(i)-7)/13)+2)/2;
            end
            half_pos(i) = ini;
        end
        xp_corr = zeros(bin_number,1);
        xp_corr(1:bin_number/2+1) 	= -flip(half_pos);
        xp_corr(bin_number/2+2:end) = half_pos(2:bin_number/2);
        
		% Calculate Scatter Fraction
		[SF,SFi] = SFCal(img,input_bin_size,xp_corr);

		disp ':: Scatter Fraction Calculation is over '
	case 3
		%%
		% Calculate Sensitivity
		disp ':: Calculate Sensitivity'
		sleeve_num 	= 5;
		slice_num 	= 77;
        Tj 			= [0,0,0,0,0];
		Tacq 		= 5; % s
		Tcal 		= 0; % s
        % volume 		= 0.05*0.05*1; % mm^3
        % voxel_num 	= 955139;
        voxel_num 	= 3339123;
		Acal 		= 10*voxel_num; % Bq
		
		Acal 		= Acal/1000000; % MBq
		
		
		% Read all five sleeves' data
		disp ':: Calculate the Sensitivity'
		reload = input(':: Reload file? Yes[1]/No[0] : ');
		if reload == 1
            Cji = zeros(sleeve_num,slice_num);
            for i = 1:sleeve_num
				sleeve_filename = input([':: Input the sleeve ',num2str(i),' filename : '],'s');
	            filepath 		= [filedir, sleeve_filename];
			    [~,C] = read_interfile(filepath,'counts');
				Cji(i,:) = C;
            end
        end
		
			[Stot,Si] = SenCal(Cji,Tacq,Tcal,Acal,sleeve_num,Tj);
		disp ':: Sensitivity Calculation is over'
	otherwise
		disp ':: ERROR : Wrong Number.'
end
