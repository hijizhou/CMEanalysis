# Clathrin-Mediated Endocytosis (CME) Analysis Codes 

## References
- Aguet, Francois, Costin N. Antonescu, Marcel Mettlen, Sandra L. Schmid, and Gaudenz Danuser, Advances in Analysis of Low Signal-to-Noise Images Link Dynamin and AP2 to the Functions of an Endocytic Checkpoint, Developmental Cell, 26 (2013), 279?91
- Danuser lab [cmeAnalysisPackage](http://www.utsouthwestern.edu/labs/danuser/software/#cme-anchor)

## What's inside?
**Updated cmeAnalysisPackage** for newer version Matlab (Tested: Matlab R2016a).

**Tracks To TrackMate**
>cmeAnalysisPackage provides a very mature tool for the CME analysis. However, the visualization in Matlab is not very convenient. This function is to transfer the tracking results in cmeAnalysisPackage to TrackMate file format (.xml), so that it can be directly imported to ImageJ/Icy.

_Example_: 
``tracks2TrackMate(['/' parentpath,path], ['testImg.tif'], tracks, '/Users/Desktop/test.xml')``
