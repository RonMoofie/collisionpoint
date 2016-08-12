Version 0.1 - 07/08/2016

This is the first uploaded version of "Collision Point" the final project as part requirement of the degree of MMus in Sonic Arts at the University of Aberdeen by Mark Dunsmore.

Currently many/most of the individual elements exist and work (mostly) separately from each other.  There are basic interfaces made in Processing that allow the user to record their voice sample that will be stored using an automatic file name incrementing system, and also to trigger the granulating-esque effect that will be triggered for when the tracked objects collide.  There is also a version of the motion tracking in Processing that has basic 4 channel volume outputs to be sent to PureData to allow for two dimensional panning.

Next steps...

1. Finish the recording interface in Processing
2. Create an interface to allow for callibration of certain colour/movement tolerances in Processing
3. Setup outputs from Processing to Pd that will be triggered by collisions and near misses and have these received by Pd in a meaningful way
4. Create an interface for users to choose sounds to be controlled by each tracked object
5. Make Processing stop sending locational data when neither ball is in view of camera
6. Make Processing stop sending locational data and stop the cycle when the ball disappears down the middle of the table

Version 0.1.1 - 12/08/2016

Added:  Timer on Processing showing when the recording has started and how the user has been recording for.  It then shows the file name for that sound file after it has stopped recording.
	Granulation on collision now can be altered in amount, rate, and depth.  It now also is adjusted to the length of the sample.


Fixed: Sending of data from Processing to Pd via Osc.  OscMessage now clears arguments before each send.
