# Electromagetic time reversal (EMTR) and Machie Learning (ML)
Implementation of the hybrid EMTR/ML methods for a range of applications including electromagnetic source localization, source recunstruction, and microwave imaging. 

## 1. Single sensor EM Source localization using EMTR and deep transfer learning
Please refer to this [paper](https://rdcu.be/b345w) for detailed explanation of the method.
### Getting started

Clone this repository:
```
git clone git@github.com:fanfeum/EMTR_ML.git
cd EMTR_ML
```

### Loadig the dataset, extracting the feature vectors, and training the model
* Open jupyter notebook in the current directory:
```
jupyer notebook
```
* Open and run '1sesnor.ipynb':

    1. Specify the path to the source images and how many images to use for training and evaluation.
    2. Specify which coordinante of the source to estimate (whether x- or y- coordinante).
    3. Re-run the code for the other source coordiante.
    4. The model's estimation for the source coordiantes along with the ground truth source positions will be automatically saved for further inference.
    

### Visualizing the evaluation results

Run 'figureMaker.m' in Matlab:
* Using the saved model's outputs and the target positions, this code will generate the followig plots:
    1. Estimation of the x- and y-coordinate of the randomly selected source locations.
    2. Histogram of the location error
    3. Average location error presented as a heatmap chart inside the detection region 
