## Goal

To get a neural network to predict whether a face is male or female based off just 5 measurements:

	- distance between eyes
	- distance from left eye to mouth
	- distance from right eye to mouth
	- face width
	- face height

Before starting this project I had no idea if it would work at all, but I thought that it'd be really cool to see if just basic measurements had any correlation to gender.


## Procedure
	
To collect the images of faces I went to the /r/rateme and /r/amiugly subreddits. Most of the images on there were close ups, but I had to pick them manually to make sure that they were good. I never used pictures of the same person twice even if they looked totally different, I wanted the images to be varied. Most of the images are of people ages 16-30. I collected 50 pictures of each gender, so that the data set is big enough to see trends. The neural network implementation that I used was written by my friend and fellow RIT student Stevie Hetelekides. He's the one that gave me the idea for the project. So to clarify, he is responsible for writing NeuralNet.swift, Sex.swift, and RandomNumberExtensions.swift. I wrote ViewController.swift. For facial feature recognition I used the built-in libraries written by Apple. The most difficult part of this whole project was figuring out which values to put in the neural network to seed it. In between the input and output are hidden layers which can drastically change the way that it analyzes the data. To start I asked Stevie which values to use and just kept changing them around until I got a result that I was satisfied with.

## Results

The best that I could get was about a 60% likelyhood that the neural network guessed the result correctly. To achieve this I used 1 hidden layer with 5 nodes and a learning rate of 0.0001