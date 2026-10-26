# Vietnamese Banknote Authenticity Classification Using CNN and Verilog

## 1. Project Overview

This project explores the classification of Vietnamese banknote images using a Convolutional Neural Network (CNN) and a Verilog-based hardware inference implementation.

The project focuses on two denominations:

- 20,000 VND
- 50,000 VND

The model is designed to classify input images into two classes: genuine and counterfeit, based on the available training dataset.

**Important:** This is an experimental image-classification project, not a certified banknote authentication system.

## 2. Project Objectives

- Preprocess banknote images using Python.
- Train and evaluate a CNN model.
- Convert trained model parameters into fixed-point representation.
- Implement CNN inference modules in Verilog.
- Verify the RTL design through simulation and testbenches.

## 3. System Architecture

Banknote Images  
→ Image Preprocessing  
→ CNN Training in Python  
→ Fixed-Point Weight Export  
→ Verilog CNN Inference  
→ ModelSim Simulation and Verification

## 4. Technologies Used

- Python and Jupyter Notebook
- TensorFlow/Keras
- Verilog HDL
- ModelSim Intel FPGA Edition
- Fixed-point arithmetic (Q8.8, subject to implementation verification)

## 5. CNN Architecture

The intended CNN pipeline consists of:

1. Convolution layer 1
2. ReLU activation
3. Convolution layer 2
4. ReLU activation
5. Max pooling
6. Flatten
7. Dense layer
8. Sigmoid output

The exact layer dimensions and numerical formats should be confirmed against the final model and RTL implementation.

## 6. Repository Structure

- `python/notebooks/` — preprocessing, training, evaluation, and weight-export notebooks
- `verilog/` — CNN RTL modules
- `testbench/` — Verilog testbenches and simulation input vectors
- `weights/` — exported model parameters
- `models/` — trained model files
- `data/` — dataset preparation notes and optional processed data
- `results/waveform/` — simulation waveform screenshots
- `results/metrics/` — model evaluation results

## 7. Verification and Results

Results will be documented after running the final RTL testbench and comparing the hardware-oriented implementation with the Python reference model.

Planned evaluation items:

- Classification accuracy on a held-out test set
- Confusion matrix
- Python versus Verilog output comparison
- Fixed-point quantization error
- RTL simulation results

## 8. How to Run

### Python

Open the relevant notebook in `python/notebooks/` and follow the documented preprocessing, training, and evaluation steps.

Install the required Python packages according to the project's environment and notebook dependencies.

### Verilog / ModelSim

1. Open ModelSim.
2. Create or open a simulation project.
3. Add the RTL source files and testbench files.
4. Ensure the weight and input-memory file paths match the simulation working directory.
5. Compile the design and run the top-level testbench.
6. Record the transcript, waveform, and output values.

Detailed commands and verified results will be added after the final simulation setup is confirmed.

## 9. Limitations

- Performance depends on the dataset size, image quality, and training distribution.
- Results on a limited dataset do not establish reliable real-world counterfeit detection.
- Fixed-point arithmetic may introduce numerical differences compared with Python inference.
- FPGA hardware deployment is not claimed unless actual hardware testing has been completed.

## 10. Author

Add your name and contact information here.
