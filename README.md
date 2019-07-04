# Human-Action-Recognition
### Human Activity Recognition using Bag-of-Words
 
 For the Training:

	1. Download the Training Data from the KTH dataset on http://www.nada.kth.se/cvap/actions/
	2. change the Current directory to SSI_Project and place the Training Data in the Current directory
	3. Run the avi2matConvert.m to start Training and wait for a while before Training completes
	4. a trained data is stored "trainFeatures.mat"

 ##### NOTE: Training has been already performed and the result is stored  as "trainFeatures.mat"

 For the Testing

	1. Run the HAR_GUI.m
	2. Click "Load video" button and Select a test video
	3. Wait a while for the Video to process
	4. A label is displayed with the performed Action
