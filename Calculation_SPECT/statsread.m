function stats = statsread(filename)

if nargin<1
    filename = 'stats.txt';
end

fid = fopen(filename,'r');
statsr = textscan(fid,'%s %s %s %f');

stats.NumberOfRun=statsr{1,4}(1);
stats.NumberOfEvents=statsr{1,4}(2);
stats.NumberOfTracks=statsr{1,4}(3);
stats.NumberOfSteps=statsr{1,4}(4);
stats.NumberOfGeometricalSteps=statsr{1,4}(5);
stats.NumberOfPhysicalSteps=statsr{1,4}(6);
stats.ElapsedTime=statsr{1,4}(7);
stats.ElapsedTimeWoInit=statsr{1,4}(8);

fclose(fid);