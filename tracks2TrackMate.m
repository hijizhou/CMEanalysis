function tracks2TrackMate(path, file, filteredTracks, filename)
% transfer tracks in Matlab from cmeAnalysis Package to the TrackMate format
% By Jizhou Li (hijizhou@gmail.com)
% Updated: July 13, 2017

folder = [pwd path];
imgsize = [512 512];
nframes = 300;

% read a template
Traj = xml2struct('TrackMate_template.xml');

% Settings
Traj.TrackMate.Settings.ImageData.Attributes.filename = file;
Traj.TrackMate.Settings.ImageData.Attributes.folder = folder;
Traj.TrackMate.Settings.ImageData.Attributes.width = num2str(imgsize(1));
Traj.TrackMate.Settings.ImageData.Attributes.height = num2str(imgsize(2));
Traj.TrackMate.Settings.ImageData.Attributes.nframes = num2str(nframes);

spotID = 0;
%tracks
for ti=1:numel(filteredTracks)
    obj = filteredTracks(ti);
    % filtered track
    Traj.TrackMate.Model.FilteredTracks.TrackID{ti}.Attributes.TRACK_ID = num2str(ti);
    Traj.TrackMate.Model.AllTracks.Track{ti}.Attributes.TRACK_INDEX = num2str(ti);
    Traj.TrackMate.Model.AllTracks.Track{ti}.Attributes.name = ['Track_' num2str(ti)];
    Traj.TrackMate.Model.AllTracks.Track{ti}.Attributes.TRACK_ID = num2str(ti);
    Traj.TrackMate.Model.AllTracks.Track{ti}.Attributes.NUMBER_SPOTS = num2str(obj.lifetime_s);
    Traj.TrackMate.Model.AllTracks.Track{ti}.Attributes.TRACK_START = num2str(obj.start);
    Traj.TrackMate.Model.AllTracks.Track{ti}.Attributes.TRACK_STOP = num2str(obj.end);
    %     Traj.TrackMate.Model.AllTracks.Track{ti}.Attributes.DISPLACEMENT = num2str(obj.MotionAnalysis.totalDisplacement);
    
    for j = 1:obj.lifetime_s-1
        
        
        ID = spotID;
        IDnext = spotID+1;
        
        Traj.TrackMate.Model.AllTracks.Track{ti}.Edge{j}.Attributes.SPOT_SOURCE_ID = num2str(ID);
        Traj.TrackMate.Model.AllTracks.Track{ti}.Edge{j}.Attributes.SPOT_TARGET_ID = num2str(IDnext);
        Traj.TrackMate.Model.AllTracks.Track{ti}.Edge{j}.Attributes.EDGE_X_LOCATION = num2str(obj.x(j));
        Traj.TrackMate.Model.AllTracks.Track{ti}.Edge{j}.Attributes.EDGE_Y_LOCATION = num2str(obj.y(j));
        Traj.TrackMate.Model.AllTracks.Track{ti}.Edge{j}.Attributes.EDGE_Z_LOCATION = num2str(0);
        
        tmp.ID = spotID;
        spotID = spotID + 1;
        tmp.x = obj.x(j);
        tmp.y = obj.y(j);
        tmp.z = 0;
        
        if ti==1
            Spot{obj.t(j)}{1} = {tmp};
        else
            if numel(Spot)<obj.t(j)
                Spot{obj.t(j)}{1} = {tmp};
            else
                try
                    Spot{obj.t(j)}(end+1) = {tmp};
                catch
                    j
                end
            end
        end
    end
    
    j = obj.lifetime_s;
    tmp.ID = spotID;
    tmp.x = obj.x(j);
    tmp.y = obj.y(j);
    tmp.z = 0;
    
    if ti==1
        Spot{obj.t(j)}{1} = {tmp};
    else
        if numel(Spot)<obj.t(j)
            Spot{obj.t(j)}{1} = {tmp};
        else
            Spot{obj.t(j)}(end+1) = {tmp};
        end
    end
    spotID = spotID + 1;
    
end

Traj.TrackMate.Model.AllSpots.Attributes.nspots = num2str(spotID);
% Spot in frames

for frameindex=1:numel(Spot)
    Traj.TrackMate.Model.AllSpots.SpotsInFrame{frameindex}.Attributes.frame = num2str(frameindex);
    
    for si = 1:numel(Spot{frameindex})
        tmp2 = Spot{frameindex}{si};
        if iscell(tmp2)
            tmp2 = tmp2{1};
        end
        Traj.TrackMate.Model.AllSpots.SpotsInFrame{frameindex}.Spot{si}.Attributes.ID=num2str(tmp2.ID);
        Traj.TrackMate.Model.AllSpots.SpotsInFrame{frameindex}.Spot{si}.Attributes.FRAME=num2str(frameindex);
        Traj.TrackMate.Model.AllSpots.SpotsInFrame{frameindex}.Spot{si}.Attributes.POSITION_T=num2str(frameindex);
        Traj.TrackMate.Model.AllSpots.SpotsInFrame{frameindex}.Spot{si}.Attributes.VISIBILITY=num2str(1);
        Traj.TrackMate.Model.AllSpots.SpotsInFrame{frameindex}.Spot{si}.Attributes.RADIUS=num2str(5);
        Traj.TrackMate.Model.AllSpots.SpotsInFrame{frameindex}.Spot{si}.Attributes.POSITION_X=num2str(tmp2.x);
        Traj.TrackMate.Model.AllSpots.SpotsInFrame{frameindex}.Spot{si}.Attributes.POSITION_Y=num2str(tmp2.y);
        Traj.TrackMate.Model.AllSpots.SpotsInFrame{frameindex}.Spot{si}.Attributes.POSITION_Z=num2str(0);
        Traj.TrackMate.Model.AllSpots.SpotsInFrame{frameindex}.Spot{si}.Attributes.QUALITY=num2str(100);
        Traj.TrackMate.Model.AllSpots.SpotsInFrame{frameindex}.Spot{si}.Attributes.name=['ID' num2str(tmp2.ID)];
    end
end

struct2xml(Traj,filename);


