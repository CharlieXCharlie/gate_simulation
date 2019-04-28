// This program are used to compress ROOT file and rebin it to sinograms.
// The root file is the output of GATE simulation of the SIEMENS biograph 16 HR PET 
// scanner.
// Only for Biograph 16 HR.

// This file need modification before compiling
// ====================================================================================
// HOW TO COMPILE:
// * should have a 'main' function.
// 1) Compile using this command line in the terminal:                                #
//       g++ (name of file) `root-config --cflags --libs`                             #
//                                                                                    #
// HOW TO RUN:                                                                        #
// 1) After compiling the code type the following command line:                       #
//       ./a.out 
// ====================================================================================

#include <fstream>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <sstream>
#include <string>
#include <vector>
#include <math.h>
// ROOT header file
#include "TROOT.h"
#include "TSystem.h"
#include "TChain.h"
#include "TH2D.h" 
#include "TDirectory.h"
#include "TList.h"
#include "Rtypes.h"
#include "TChainElement.h"
#include "TTree.h"
#include "TFile.h"
#include "TStyle.h"
#include "TH2.h"
#include "TH2F.h"
#include "TCanvas.h"
#include "TRandom.h"

using namespace std;

#define bin_num 624
string filefolder;

// #define min_crystal_difference 13

void compress2michelogram(string fin,string fout);
void root2position(string fin ,string fout);
void SSRB (string fin, string fout);
void count_each_slice(string fin, string fout);
void root2miche(){

	// string filefolder;
	cout << "Input file folder to load ROOT data:"<<endl;
	cin >> filefolder;

	// input GATE ROOT raw file
	string filename_raw = "\\out\\root_out.root";
   	string filepath_raw = "E:\\Database\\GATE_simulation_data\\PET\\";
   	string fileall_raw = filepath_raw + filefolder + filename_raw;

   	// output position file
	string filename_pos = "\\pos.root";
	string filepath_pos = "E:\\Database\\GATE_simulation_data\\PET\\ROOT16\\";
	string fileall_pos = filepath_pos + filefolder + filename_pos;

	// output michelogram file
	string michelogram_name="\\michelogram.s";
	string michelogram = filepath_pos + filefolder + michelogram_name;

	// output ssrb sinogram file
	string ssrbgram_name="\\user_ssrb.s";
	string ssrbgram = filepath_pos + filefolder + ssrbgram_name;

	// output count data in each slice
	string counthistogram_name="\\counts.s";
	string counthistogram = filepath_pos + filefolder + counthistogram_name;

	int reload_root = 0;
	cout << "  Reload root file? No[0]/ Yes[1] ";
	cin >> reload_root;
	cout << endl;
	if (reload_root == 1){
		root2position(fileall_raw,fileall_pos);
	}
	int check = 0;
	cout << "  Recreate michelogram ? No[0]/ Yes[1] ";
	cin >> check;
	cout << endl;
	if (check == 1){
		compress2michelogram(fileall_pos,michelogram);
	}

	check = 0;
	cout << "  Recreate user_ssrb file ? No[0]/ Yes[1] ";
	cin >> check;
	cout << endl;
	if (check == 1){
		SSRB (fileall_pos, ssrbgram);
	}
	
	check = 0;
	cout << "  Recreate counts file ? No[0]/ Yes[1] ";
	cin >> check;
	cout << endl;
	if (check == 1){
		count_each_slice(fileall_pos, counthistogram);
	}
	
	cout << ":: The end" << endl;
}

void root2position(string fin ,string fout){

	// input GATE ROOT raw file
	string filename_raw = "\\out\\root_out.root";
   	string filepath_raw = "E:\\Database\\GATE_simulation_data\\PET\\";

	string fileall_raw = fin;
	string fileall_pos = fout;
	string filefolder_another;
	string fileall_another;

	cout << ":: Open " << fileall_raw <<" to load GATE root data " << endl;

	TChain* fChain = new TChain("Coincidences","Chain for coincidences");
	fChain->Add(fileall_raw.c_str());
	int another=1;
	while(another == 1){
		cout << "  Other root file ? Yes[1]/No[0] ";
		cin >> another;
		cout << endl;
		if (another == 1){
			cout << "  Input file folder to load ROOT data:"<<endl;
			cin >> filefolder_another;
			fileall_another = filepath_raw + filefolder_another +filename_raw;
			fChain->Add(fileall_another.c_str());
		}
	}


	double time1, time2;
	float energy1, energy2;
	int gantryID1, rsectorID1, moduleID1,submoduleID1,crystalID1,layerID1;
	int gantryID2, rsectorID2, moduleID2,submoduleID2,crystalID2,layerID2;
	
	fChain->SetBranchAddress("time1", &time1);
	fChain->SetBranchAddress("energy1", &energy1);
	fChain->SetBranchAddress("gantryID1", &gantryID1);
	fChain->SetBranchAddress("rsectorID1", &rsectorID1);
	fChain->SetBranchAddress("moduleID1", &moduleID1);
	fChain->SetBranchAddress("submoduleID1", &submoduleID1);
	fChain->SetBranchAddress("crystalID1", &crystalID1);
	fChain->SetBranchAddress("layerID1", &layerID1);

	fChain->SetBranchAddress("time2", &time2);
	fChain->SetBranchAddress("energy2", &energy2);
	fChain->SetBranchAddress("gantryID1", &gantryID2);
	fChain->SetBranchAddress("rsectorID2", &rsectorID2);
	fChain->SetBranchAddress("moduleID2", &moduleID2);
	fChain->SetBranchAddress("submoduleID2", &submoduleID2);
	fChain->SetBranchAddress("crystalID2", &crystalID2);
	fChain->SetBranchAddress("layerID2", &layerID2);
	cout << ":: Connect the leaf" << endl;

	TFile *pos = new TFile(fileall_pos.c_str(),"RECREATE");  
	TTree *position = new TTree("position","The tree for position");

	int phi, s, ring1, ring2;
	position->Branch("Phi",&phi,"Phi/I");
	position->Branch("S",&s,"S/I");
	position->Branch("Ring1",&ring1,"Ring1/I");
   	position->Branch("Ring2",&ring2,"Ring2/I");

	int entry_num = fChain->GetEntries();

	int rsector_num = 48, module_num = 3, crystal_num = 13;
	// float dia_ring = 824.,block_z = 38.7;

	// // print useful information
	cout << endl << ":: Specification Information";
	cout << endl << "  rsector number = " << rsector_num << "\t" << "module number : " << module_num;
	cout << endl << "  crystal number = " << crystal_num << endl;

  	int crystal_per_ring = rsector_num*crystal_num;
  	int half_ring = crystal_per_ring/2;
	// float delta_phi = 180./half_ring;
	// float delta_phi = 0.576923;
	// float delta_s = 1;

	cout << ":: Start loop, locate each coincidece" << endl;
	for (int i=0;i<entry_num;++i){
		fChain->GetEntry(i);

		// ring position
		ring1 = crystalID1/crystal_num + crystal_num*moduleID1 +1;
		ring2 = crystalID2/crystal_num + crystal_num*moduleID2 +1;

		// crystal position
		int offset 		 = crystal_num/2; // adjust crystal position
		int abs_crystal1 = crystalID1%crystal_num+rsectorID1*crystal_num - offset;
		int abs_crystal2 = crystalID2%crystal_num+rsectorID2*crystal_num - offset;

		if (abs_crystal1<0) {
			abs_crystal1 = abs_crystal1+crystal_per_ring;
		}
		if (abs_crystal2<0) {
			abs_crystal2 = abs_crystal2+crystal_per_ring;
		}
		// int crystal_diff = abs(abs_crystal1-abs_crystal2);
		// if (crystal_diff>half_ring) {
		// 	crystal_diff=crystal_per_ring-crystal_diff;
		// }

		// calculate phi 
		int sum = (abs_crystal1 + abs_crystal2)%crystal_per_ring;
		phi = crystal_per_ring/2/2 - sum/2;
		if (phi < 0) {
			phi = phi+ (crystal_per_ring/2);
		}
		// cout << phi<< endl;
		// calculate r
		int abs_s = abs(crystal_per_ring/2-abs(abs_crystal1-abs_crystal2));
		// check positive or negative
		// int start = (abs_crystal1+abs_crystal2)/2;
		int start = sum /2;
		// int end   = start + crystal_per_ring/2;
		int mid   = start + crystal_per_ring/4;
		if (start <= crystal_per_ring/4)
		{
			if ((abs_crystal1>=start&&abs_crystal1<=mid) || (abs_crystal2>=start&&abs_crystal2<=mid))
			{
				s =  abs_s;
			}
			else{
				s = -abs_s;
			}

		}
		else{
			if ((abs_crystal1>=start&&abs_crystal1<=mid) || (abs_crystal2>=start&&abs_crystal2<=mid))
			{
				s = -abs_s;
			}
			else{
				s =  abs_s;
			}
		}
		

		// offset
		s = (int)(s+312);
		// phi = phi+155;
		// cout << s << '\t' << phi << endl;
		position->Fill();
	}
	cout << ":: Complete " << endl;
	// postion->Draw("Ring1:Ring2");
	// print tree information
	position->Print();
	position->Write();

   	cout << endl;
	delete position;
	pos->Close();
}


void compress2michelogram(string fin,string fout){
	// input file
	cout << ":: Open " << fin << endl;
	TChain * position = new TChain("position");
	position -> Add(fin.c_str());

	cout << ":: Open file succeed." << endl;

	int s, phi;
	int ring1, ring2;
	position->SetBranchAddress("Phi",&phi);
	position->SetBranchAddress("S",&s);
	position->SetBranchAddress("Ring1",&ring1);
	position->SetBranchAddress("Ring2",&ring2);

	int number_of_detectors_per_ring = 624;	
	int half_ring = number_of_detectors_per_ring/2;
	int number_of_rings = 39;
	int max_ring_difference = 24;
	int span = 7 ;
	int span_h = span/2;
	int segment = (2*max_ring_difference+1)/span;
	// int sino_range[] = {1,1+span_h,1+span_h+1,1+span_h*2+1,}
	// int min_ring_diff_per_segment[] = {}
	int entry_num = position->GetEntries();

	int max_ring_difference = 24;
	int span = 7 ;
	int number_of_rings = 39;

	cout << ":: Ininitialization finished." << endl;

	int segment = (2*max_ring_difference+1)/span;

	int* sino_range = (int*)malloc(sizeof(int)*(segment+1));
	sino_range[0]=1;
	sino_range[1]=1+span/2;
	for(int i = 1; i<(segment+1)/2;i++){
		sino_range[2*i] = sino_range[2*i-1]+1;
		sino_range[2*i+1] = sino_range[2*i]+span-1;
	}

	int* axial_coordinate_matrix_size = (int*)malloc(sizeof(int)*segment);
	int axial_coordinate = 0;
	axial_coordinate_matrix_size[0] = number_of_rings*2-1;
	for(int i = 1 ;i<(segment+1)/2;i++){
		axial_coordinate_matrix_size[2*i-1]=((number_of_rings- sino_range[2*i-1])*2)-1;
		axial_coordinate_matrix_size[2*i]=((number_of_rings- sino_range[2*i-1])*2)-1;
	}
	for(int i = 0; i<segment;i++){
		axial_coordinate += axial_coordinate_matrix_size[i];
	}

	int* min_ring_diff_per_segment = (int*)malloc(sizeof(int)*segment);
	int* max_ring_diff_per_segment = (int*)malloc(sizeof(int)*segment);
	min_ring_diff_per_segment[0]=1-sino_range[1];
	max_ring_diff_per_segment[0]=sino_range[1]-1;
	for(int i = 1 ;i<(segment+1)/2;i++){
		min_ring_diff_per_segment[2*i-1] = 1-sino_range[2*i+1];
		min_ring_diff_per_segment[2*i] = sino_range[2*i]-1;
		max_ring_diff_per_segment[2*i-1] = 1-sino_range[2*i];
		max_ring_diff_per_segment[2*i] = sino_range[2*i+1]-1;
	}

	int* axial_coordinate_range_low = (int*)malloc(sizeof(int)*segment);
	axial_coordinate_range_low[0] = 1;
	for(int i = 1; i<(segment/2)+1;i++){
		axial_coordinate_range_low[2*i-1] = (1+sino_range[2*i])/2; 
		axial_coordinate_range_low[2*i] = (1+sino_range[2*i])/2;
	}

	int view = number_of_detectors_per_ring/2;
	int tangential_coordinate = bin_num;

	cout << "   Data matrix size : " << endl;
	cout << "    Segment : " << segment << endl;
	cout << "    Axial coordinate : " << axial_coordinate << endl;
	cout << "    View : " << view << endl;
	cout << "    Tangential coordinate : " << tangential_coordinate << endl;

	// int* data_matrix = (int*)malloc(sizeof(int)*(axial_coordinate*view*tangential_coordinate));
	// int data_matrix[axial_coordinate][view][tangential_coordinate] = {0};

	// allocate 3D matrix
	int*** data_matrix = (int***)malloc(axial_coordinate*sizeof(int**));

	for(int i=0;i<axial_coordinate;i++){
		data_matrix[i] = (int**)malloc(view*sizeof(int*));
	}
	for(int i=0;i<axial_coordinate;i++){
		for(int j = 0; j<view;j++){
			data_matrix[i][j] = (int*)malloc(tangential_coordinate*sizeof(int));
		}
	}

	for(int x = 0;x<axial_coordinate;x++){
		for(int y = 0; y<view; y++){
			for(int z = 0; z< tangential_coordinate; z++){
				data_matrix[x][y][z] =0;
			}
		}
	}

	

	for (int n=0;n<entry_num;++n){
		position->GetEntry(n);
		// calculate which segment the coincidence belongs to, => segment_tag
		int ring_difference = ring1-ring2;
		if(abs(ring_difference)>max_ring_difference){
		 	continue;
		}
		int segment_tag = 0;
		for(int i = 0; i<segment;i++){
			if(ring_difference >= min_ring_diff_per_segment[i] && ring_difference <= max_ring_diff_per_segment[i]){
				segment_tag = i;
				break;
			}
		}
		// calculate the axial coordinate of the coincidence
		int axial_coordinate_tag = 0;
		float axial_rebinned = 0;
		for(int i = 0; i<segment;i++){
			if(segment_tag==i){
				axial_rebinned = (ring1+ring2)/2.;
				axial_coordinate_tag = (int)((axial_rebinned- axial_coordinate_range_low[i])/0.5);
				// cout << axial_rebinned << '\t'<< axial_coordinate_range_low[i]<<'\t'<< axial_coordinate_tag <<endl;
				break;
			}
		}
		// calculate offset in the data_matrix
		int axial_offset = 0;
		for(int i = 0;i<segment_tag;i++){
			axial_offset += axial_coordinate_matrix_size[i];
		}		
		axial_offset += axial_coordinate_tag;
		data_matrix[axial_offset][phi][s]++ ;
	}


	cout << ":: Save sinograms data to : " << fout << endl;
	FILE *f;
	f = fopen(fout.c_str(),"wb");
	// fclose(f);
	// f = fopen(fout.c_str(),"ab+");
	if (f == NULL){
		cout << ":: File Open ERROR" << endl;
	}
	else{
		cout << ":: Open File"<<endl;
	}
	cout << ":: Write sinogram." << endl;
	// fwrite(data_matrix,sizeof(int),(axial_coordinate*view*tangential_coordinate),fout);
	for(int x = 0;x<axial_coordinate;x++){
		for(int y = 0; y<view; y++){
			// for(int z = 0; z< tangential_coordinate; z++){
				// cout<< data_matrix[x][y][z]<<endl;
				fwrite(data_matrix[x][y],sizeof(int),tangential_coordinate,f);
			// }
		}
	}
	cout << ":: Write finishied." << endl;
	// free memory
	fclose(f);
	free(sino_range);
	free(axial_coordinate_matrix_size);
	free(min_ring_diff_per_segment);
	free(max_ring_diff_per_segment);
	free(axial_coordinate_range_low);
	// free data matrix
	for(int i = 0;i<axial_coordinate;i++){
		for(int j=0;j<view;j++){
			free(data_matrix[i][j]);
		}
	}
	for(int i=0; i<axial_coordinate;i++){
		free(data_matrix[i]);
	}
	free(data_matrix);
	cout << ":: Free all memory" << endl;
}

void SSRB (string fin, string fout){
	// This function is used to rebin the position data 
	// using single slice rebinning.
	cout << ":: Open " << fin << endl;
	TChain * position = new TChain("position");
	position -> Add(fin.c_str());

	cout << ":: Open file succeed." << endl;

	int s, phi;
	int ring1, ring2;
	position->SetBranchAddress("Phi",&phi);
	position->SetBranchAddress("S",&s);
	position->SetBranchAddress("Ring1",&ring1);
	position->SetBranchAddress("Ring2",&ring2);

	int entry_num = position->GetEntries();
	cout << ":: There are " << entry_num << " coincidences to be processed." << endl;
	int number_of_detectors_per_ring = 624;	
	// int half_ring = number_of_detectors_per_ring/2;
	int number_of_rings = 39;
	int max_ring_difference = 24;
	int number_of_slice = number_of_rings*2-1;
	int view = number_of_detectors_per_ring/2;
	int tangential_coordinate = bin_num;

	int*** data_matrix = (int***)malloc(number_of_slice*sizeof(int**));
	for(int i=0;i<number_of_slice;i++){
		data_matrix[i] = (int**)malloc(view*sizeof(int*));
	}
	for(int i=0;i<number_of_slice;i++){
		for(int j = 0; j<view;j++){
			data_matrix[i][j] = (int*)malloc(tangential_coordinate*sizeof(int));
		}
	}
	for(int z = 0; z < number_of_slice;z++){
		for(int y = 0; y<view; y++){
			for(int x = 0; x< tangential_coordinate; x++){
				data_matrix[z][y][x] =0;
			}
		}
	}

	for (int n=0;n<entry_num;++n){
		position->GetEntry(n);
		// calculate which segment the coincidence belongs to, => segment_tag
		int ring_difference = ring1-ring2;
		if(abs(ring_difference)>max_ring_difference){
		 	continue;
		}
		// calculate the axial coordinate of the coincidence
		int axial_rebinned = (int)(((ring1+ring2)/2.-0.5)/0.5)-1;
		// cout << axial_rebinned<<endl;
		data_matrix[axial_rebinned][phi][s]++ ;
	}


	cout << ":: Save sinograms data to : " << fout << endl;
	FILE *f = fopen(fout.c_str(),"wb");;
	if (f == NULL){
		cout << ":: File Open ERROR" << endl;
	}
	else{
		cout << ":: Open File"<<endl;
	}
	cout << ":: Write sinogram" << endl;
	for(int x = 0;x < number_of_slice; x++){
		for(int y = 0; y < view; y++){
				fwrite(data_matrix[x][y],sizeof(int),tangential_coordinate,f);
		}
	}
	cout << ":: Write finishied, the size of the SSRB sinogram data is " << number_of_slice << '\t' << view << '\t' << tangential_coordinate << '\t' << endl;
	cout << ":: For ImageJ, Image type : 32-bit Signed." << endl;
	// close file
	fclose(f);
	// free data matrix
	for(int i = 0;i<number_of_slice;i++){
		for(int j=0;j<view;j++){
			free(data_matrix[i][j]);
		}
	}
	for(int i=0; i<number_of_slice;i++){
		free(data_matrix[i]);
	}
	free(data_matrix);	
	cout << ":: Free all memory" << endl;

}

void count_each_slice(string fin, string fout){
	// This function is uaed to calculate the counts in each slice 
	// for the calculation of the sensitivity.
	cout << ":: Open " << fin << endl;
	TChain * position = new TChain("position");
	position -> Add(fin.c_str());

	int ring1, ring2;
	position->SetBranchAddress("Ring1",&ring1);
	position->SetBranchAddress("Ring2",&ring2);

	int number_of_rings = 39;
	int number_of_slice = number_of_rings*2-1;
	int max_ring_difference = 24;


	int entry_num = position->GetEntries();
	cout << ":: There are " << entry_num << " coincidences to be processed." << endl;

	int* counts = (int*)malloc(number_of_slice*sizeof(int));
	for (int i=0;i<number_of_slice;i++){
		counts[i]=0;
	}

	for (int n=0;n<entry_num;++n){
		position->GetEntry(n);
		// calculate which segment the coincidence belongs to, => segment_tag
		int ring_difference = ring1-ring2;
		if(abs(ring_difference)>max_ring_difference){
		 	continue;
		}
		// calculate the axial coordinate of the coincidence
		int axial_rebinned = (int)(((ring1+ring2)/2.-0.5)/0.5)-1;
		// cout << axial_rebinned<<endl;
		counts[axial_rebinned]++ ;
	}
	cout << ":: Save sinograms data to : " << fout << endl;
	FILE *f = fopen(fout.c_str(),"wb");;
	if (f == NULL){
		cout << ":: File Open ERROR" << endl;
	}
	else{
		cout << ":: Open File"<<endl;
	}
	cout << ":: Write sinogram" << endl;
	for(int i=0;i<number_of_slice;i++){
		cout << counts[i] <<endl;
	}
	fwrite(counts,sizeof(int),number_of_slice,f);
	cout << ":: Write finishied" << endl;


	free(counts);	
	cout << ":: Free all memory" << endl;
}