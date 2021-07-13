# 2D Projection of a 3D volume 

This is a Matlab implementation for taking 2D projection of a 3D object/volume at different angle without using any built-in Matlab functions. 

## What is a projection ?
Taking projection of 3d object/volume means passing a set of parallel X-ray beam at a specific angle and calculate the attenuation of the X-ray beams on a detector plane. So at each angle the 3d object has a 2d projection. 

There are different ways of taking 2D projections from a 3D object/volume. I used the most fundamental approach which is known as Radon transform. In mathematics, Radon transform means taking the line integrals of all the parallel lines which pass over a 2D plane/space on a 1D function. Read more about Radon transform at https://en.wikipedia.org/wiki/Radon_transform. So, projection of a 2D plane/space is a 1D. As a digital 3D object/volume is nothing but a combination of 2D slices, I used Radon transform for each slice of the volume. 1D projection of each slice becomes a 2D plane which can be referd as 2D projection of the given 3D object/volume at an specific angle. The rotation the object along  


Matlab built-in function "radon" does
