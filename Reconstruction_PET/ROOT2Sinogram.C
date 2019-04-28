// Read all z from the raw data file.
// The root file is the output of GATE simulation of the SIEMENS biograph 16 HR PET scanner
// Only for Biograph 16.

// HOW TO COMPILE:
// * should have a 'main' function.
// 1) Compile using this command line in the terminal:                                #
//       g++ (name of file) `root-config --cflags --libs`                             #
//                                                                                    #
// HOW TO RUN:                                                                        #
// 1) After compiling the code type the following command line:                       #
//       ./a.out $inputfiledir $outputfiledir

#include <fstream>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <sstream>
#include <string>
#include <vector>
#include <math.h>

#include "TROOT.h"
#include "TChain.h"
#include "TDirectory.h"
#include "TList.h"
#include "Rtypes.h"
#include "TChainElement.h"
#include "TTree.h"
#include "TFile.h"
#include "TStyle.h"


using namespace std;

int bin_num = 624;
int number_of_rings = 39;
int max_ring_difference = 24;
int rsector_num = 48;
int module_num = 3;
int crystal_num = 13;
int number_of_detectors_per_ring = 624;	
int span = 7 ;
float delta_s = 1;

int crystal_per_ring = rsector_num*crystal_num;
//int half_ring = crystal_per_ring/2;
int span_h = span/2;
int number_of_slice = number_of_rings*2-1;
int half_ring = number_of_detectors_per_ring/2;
int view = number_of_detectors_per_ring/2;
int tangential_coordinate = bin_num;

string inputfiledir;
string outputfiledir;
string inputfile_name = "*.root";

// #define min_crystal_difference 13

void compress2michelogram(string fin,string fout);
void root2position(string fin ,string fout);
void SSRB (string fin, string fout);
void count_each_slice(string fin, string fout);

int main(int argc, char** argv){

	// the first  argumet argv[1] is the directory of the input  file
	// the second argumet argv[2] is the directory of the output file

  	if(argc<2) {
    		std::cout<<" Right number of input argument please !! "<<std::endl ;
    		return 1;
	}
	
	inputfiledir  = argv[1];
	outputfiledir = argv[2];

	// input GATE ROOT raw file
	string inputfile      = inputfiledir + inputfile_name;

	// output position file
	string positionfile_name = "pos.root";
	string positionfile      = outputfiledir + positionfile_name;

	// output michelogram file
	string michelogram_name = "michelogram.s";
	string michelogram      = outputfiledir + michelogram_name;

	// output ssrb sinogram file
	string ssrbgram_name = "user_ssrb.s";
	string ssrbgram      = outputfiledir + ssrbgram_name;

	// output count data in each slice
	string counthistogram_name = "counts.s";
	string counthistogram      = outputfiledir + counthistogram_name;

	int reload_root = 0;
	cout << ":: Reload root file? No[0]/ Yes[1] ";
	cin  >> reload_root;
	cout << endl;
	if (reload_root == 1){
		root2position(inputfile,positionfile);
	}
	
	// compress the root file to a michelogram
	compress2michelogram(positionfile,michelogram);
	cout << endl;
	// rebin the coincidence to sinogrma using Single-Slice Rebinning Algorithm	
	SSRB (positionfile, ssrbgram);
	cout << endl;
	// caluculate the counts in each slice after SSRB
	count_each_slice(positionfile, counthistogram);
	cout << endl;
	cout << ":: The end" << endl;
	return(0);
}

void root2position(string fin ,string fout){

	// input GATE ROOT raw file
	string anotherfiledir;
	string anotherfile;

	cout << ":: Open " << fin <<" to load GATE root data " << endl;

	TChain* fChain = new TChain("Coincidences","Chain for coincidences");
	fChain->Add(fin.c_str());
	int another=1;
	while(another == 1){
		cout << ":: Other root file ? Yes[1]/No[0] ";
		cin >> another;
		cout << endl;
		if (another == 1){
			cout << ":: Input another file direction to load ROOT data:"<<endl;
			cin >> anotherfiledir;
			anotherfile = anotherfiledir +inputfile_name;
			fChain->Add(anotherfile.c_str());
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
	cout << ":: Connect the leaves" << endl;

	TFile *pos = new TFile(fout.c_str(),"RECREATE");  
	TTree *position = new TTree("position","The tree for position");

	int phi, s, ring1, ring2;
	position->Branch("Phi",&phi,"Phi/I");
	position->Branch("S",&s,"S/I");
	position->Branch("Ring1",&ring1,"Ring1/I");
   	position->Branch("Ring2",&ring2,"Ring2/I");

	int entry_num = fChain->GetEntries();

	// print useful information
	cout << ":: Specification Information :" << endl;
	cout << "   rsector number = " << rsector_num << "\t" << "module number : " << module_num << endl;
	cout << "   crystal number = " << crystal_num << endl;

	cout << ":: Start Loop, Locate Every Coincidence" << endl;
	for (int i = 0;i < entry_num; ++i){
		fChain->GetEntry(i);

		// calculate ring position
		ring1 = crystalID1/crystal_num + crystal_num*moduleID1 +1;
		ring2 = crystalID2/crystal_num + crystal_num*moduleID2 +1;
		
		// cout << ring1 << "\t" << ring2 << endl;
		// calculate crystal position
		int offset = floor(crystal_num/2); //adjust crystal position
		int abs_crystal1 = crystalID1%crystal_num+rsectorID1*crystal_num - offset;
		int abs_crystal2 = crystalID2%crystal_num+rsectorID2*crystal_num - offset;

		if (abs_crystal1<0) {
			abs_crystal1 = abs_crystal1+crystal_per_ring;
		}
		if (abs_crystal2<0) {
			abs_crystal2 = abs_crystal2+crystal_per_ring;
		}
		int crystal_diff = abs(abs_crystal1-abs_crystal2);

		if (crystal_diff>half_ring) {
			crystal_diff=crystal_per_ring-crystal_diff;
		}

		// calculate phi 
		int sum = (abs_crystal1+abs_crystal2)%crystal_per_ring;
		int p = sum/2;
		phi = 156 - p;
		float abs_s = abs(half_ring-abs(abs_crystal1-abs_crystal2))*delta_s;
		// check positive or negative
		int start=sum/2+1;
		int end = start + half_ring-1;
		int mid = start + crystal_per_ring/4-1;
		if ((abs_crystal1>=start&&abs_crystal1<=mid) || (abs_crystal2>=start&&abs_crystal2<=mid))
		{
			s = abs_s;
		}
		else{
			s =-abs_s;
		}

		// offset to 0
		s = (int)(s+312);
		phi = phi+155;
		// cout << ring1 << "\t" << ring2 << endl;
		position->Fill();
	}
	cout << ":: Loop Complete!" << endl;
	// print tree information
	position->Print();
	position->Write();
	delete position;
	pos->Close();
}


void compress2michelogram(string fin,string fout){
	// input file
	cout << ":: Open " << fin << endl;
	TChain * position = new TChain("position");
	position -> Add(fin.c_str());

	int s, phi;
	int ring1, ring2;
	position->SetBranchAddress("Phi",&phi);
	position->SetBranchAddress("S",&s);
	position->SetBranchAddress("Ring1",&ring1);
	position->SetBranchAddress("Ring2",&ring2);

	int entry_num = position->GetEntries();

	// Below are the calculation about the specification of michelogram, you can
	// check the " michelogram.sh " for more information.

	// calculate segment number and their ring range
	int segment = (2*max_ring_difference+1)/span;
	int* sino_range = (int*)malloc(sizeof(int)*(segment+1));
	sino_range[0]=1;
	sino_range[1]=1+span/2;
	for(int i = 1; i<(segment+1)/2;i++){
		sino_range[2*i] = sino_range[2*i-1]+1;
		sino_range[2*i+1] = sino_range[2*i]+span-1;
	}
	
	// calculate the number of axial coordinate in each segment 
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

	// calculate min/max rinf difference in each segment
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

	// calculate the real lowest axial coordinate in each segment
	int* axial_coordinate_range_low = (int*)malloc(sizeof(int)*segment);
	axial_coordinate_range_low[0] = 1;
	for(int i = 1; i<(segment/2)+1;i++){
		axial_coordinate_range_low[2*i-1] = (1+sino_range[2*i])/2; 
		axial_coordinate_range_low[2*i] = (1+sino_range[2*i])/2;
	}

	cout << ":: Data_matrix_size : " << endl;
	cout << "   Segment : " << segment << endl;
	cout << "   Axial_coordinate : " << axial_coordinate << endl;
	cout << "   View : " << view << endl;
	cout << "   Tangential_coordinate : " << tangential_coordinate << endl;

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
				data_matrix[x][y][z] = 0;
			}
		}
	}

	cout << ":: Start Loop, Fill the Michelogram" << endl;
	for (int n=0;n < entry_num; ++n){
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

		//cout << ring1 << endl << ring2 << endl;
		// calculate the axial coordinate of the coincidence
		int axial_coordinate_tag = 0;
		float axial_rebinned = 0;
		for(int i = 0; i<segment;i++){
			if(segment_tag==i){
				axial_rebinned = (ring1+ring2)/2.;
				axial_coordinate_tag = (int)((axial_rebinned- axial_coordinate_range_low[i])/0.5);
				break;
			}
		}
		//cout << axial_coordinate_tag << endl;
		// calculate offset in the data_matrix
		int axial_offset = 0;
		for(int i = 0;i<segment_tag;i++){
			axial_offset += axial_coordinate_matrix_size[i];
		}		
		axial_offset += axial_coordinate_tag;
		//cout << axial_offset << endl;
		data_matrix[axial_offset][phi][s]++ ;
	}
	cout << ":: Loop done" << endl;
	cout << ":: Save michelogram data to : " << fout << endl;
	FILE *f = fopen(fout.c_str(),"wb");
	if (f == NULL){
		cout << ":: File Open ERROR" << endl;
	}
	for(int x = 0;x<axial_coordinate;x++){
		for(int y = 0; y<view; y++){
			fwrite(data_matrix[x][y],sizeof(int),tangential_coordinate,f);
		}
	}
	cout << ":: Save Done." << endl;
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
}

void SSRB (string fin, string fout){
	// This function is used to rebin the position data 
	// using single slice rebinning.
	cout << ":: Open " << fin << endl;
	TChain * position = new TChain("position");
	position -> Add(fin.c_str());

	int s, phi;
	int ring1, ring2;
	position->SetBranchAddress("Phi",&phi);
	position->SetBranchAddress("S",&s);
	position->SetBranchAddress("Ring1",&ring1);
	position->SetBranchAddress("Ring2",&ring2);

	int entry_num = position->GetEntries();
	cout << ":: There are " << entry_num << " coincidences to be processed." << endl;
	
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


	cout << ":: Save SSRB sinograms data to : " << fout << endl;
	FILE *f = fopen(fout.c_str(),"wb");;
	if (f == NULL){
		cout << ":: File Open ERROR" << endl;
	}
	for(int x = 0;x < number_of_slice; x++){
		for(int y = 0; y < view; y++){
				fwrite(data_matrix[x][y],sizeof(int),tangential_coordinate,f);
		}
	}
	cout << ":: Save Done, the size of the SSRB sinograms data is" << '\t' << number_of_slice << '\t' << view << '\t' << tangential_coordinate << '\t' << endl;
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
		counts[axial_rebinned]++ ;
	}
	cout << ":: Save counts data to : " << fout << endl;
	FILE *f = fopen(fout.c_str(),"wb");;
	if (f == NULL){
		cout << ":: File Open ERROR" << endl;
	}
	// for(int i=0;i<number_of_slice;i++){
		// cout << counts[i] <<endl;
	// }
	fwrite(counts,sizeof(int),number_of_slice,f);
	cout << ":: Save Done" << endl;

	free(counts);	
}