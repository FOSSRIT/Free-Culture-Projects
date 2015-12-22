//
//  NeuralNet.swift
//  BestColor
//
//  Created by Stevie Hetelekides on 9/15/15.
//  Copyright (c) 2015 Expetelek. All rights reserved.
//

import Foundation

enum NeuralError: ErrorType
{
    case InputWeightMismatch
}

class Neuron
{
    var bias: Double = 0
    var weights: [Double] = [ ]
    
    init(weights: [Double])
    {
        self.weights = weights
    }
    
    init(inputs: Int, bias: Double = 0)
    {
        // initialize random weights
        for _ in 0..<inputs
        {
            self.weights.append(Double.random(min: -1, max: 1))
        }
        
        self.bias = bias
    }
    
    func computeOutput(inputs: [Double]) throws -> Double
    {
        // make sure inputs (+1 for bias) == number of weights
        if inputs.count != self.weights.count
        {
            throw NeuralError.InputWeightMismatch
        }
        
        // compute sum
        var sum: Double = 0
        for (index, input) in inputs.enumerate()
        {
            sum += input * self.weights[index]
        }
        
        // add bias
        sum += self.bias
        
        // return sigmoid of sum
        return sigmoid(sum)
    }
}

class NeuronLayer
{
    private(set) var neurons: [Neuron] = [ ]
    
    init(neurons: Int, inputsPerNeuron: Int)
    {
        for _ in 0..<neurons
        {
            self.neurons.append(Neuron(inputs: inputsPerNeuron))
        }
    }
    
    func getWeights() -> [[Double]]
    {
        var weights: [[Double]] = [ ]
        for neuron in self.neurons
        {
            weights.append(neuron.weights)
        }
        
        return weights
    }
    
    func updateWeight(newWeights: [[Double]])
    {
        for (neuronIndex, newNeuronWeights) in newWeights.enumerate()
        {
            self.neurons[neuronIndex].weights = newNeuronWeights
        }
    }
}

class NeuralNetwork
{
    private typealias BackpropagationValues = (gradients: [Double], neuronError: Double)
    
    private(set) var numberOfInputs: Int
    private(set) var numberOfOutputs: Int
    
    private(set) var layers: [NeuronLayer] = [ ]
    
    init(inputs: Int, outputs: Int, hiddenLayers: Int, neuronsPerHiddenLayer: Int)
    {
        self.numberOfInputs = inputs
        self.numberOfOutputs = outputs
        
        // create layers
        if (hiddenLayers < 1)
        {
            let singleLayer = NeuronLayer(neurons: self.numberOfOutputs, inputsPerNeuron: self.numberOfInputs)
            self.layers.append(singleLayer)
        }
        else
        {
            for i in 0..<hiddenLayers
            {
                let inputNeurons = (i > 0) ? self.layers[i - 1].neurons.count : self.numberOfInputs
                let layer = NeuronLayer(neurons: neuronsPerHiddenLayer, inputsPerNeuron: inputNeurons)
                self.layers.append(layer)
            }
            
            let outputLayer = NeuronLayer(neurons: self.numberOfOutputs, inputsPerNeuron: self.layers.last!.neurons.count)
            self.layers.append(outputLayer)
        }
    }
    
    func updateWeights(newWeights: [[[Double]]])
    {
        for (layerIndex, newLayerWeights) in newWeights.enumerate()
        {
            self.layers[layerIndex].updateWeight(newLayerWeights)
        }
    }
    
    func compute(inputs: [Double]) throws -> [Double]
    {
        return try forwardPropogate(inputs: inputs).last!
    }
    
    func compute(inputs: [Double], expectedOutputs: [Double]) throws -> (outputs: [Double], cost: Double)
    {
        let outputs = try self.compute(inputs)
        
        var cost: Double = 0
        
        // calculate cost
        // cost function = (1/2n) * sum of all (expected - actual)^2)
        for (index, expectedOutput) in expectedOutputs.enumerate()
        {
            cost += pow(expectedOutput - outputs[index], 2)
        }
        cost *= 1 / (2 * Double(outputs.count))
        
        return (outputs: outputs, cost: cost)
    }
    
    func compute(inputs: [[Double]], expectedOutputs: [[Double]]) throws -> (outputs: [[Double]], cost: Double)
    {
        var totalCost: Double = 0
        var outputs: [[Double]] = [ ]
        
        for (index, miniBatchInputs) in inputs.enumerate()
        {
            // compute this batch's output
            let miniBatchResult = try self.compute(miniBatchInputs, expectedOutputs: expectedOutputs[index])
            
            // add to our outputs array, update the cost
            outputs.append(miniBatchResult.outputs)
            totalCost += miniBatchResult.cost
        }
        
        return (outputs: outputs, cost: totalCost)
    }
    
    private func forwardPropogate(inputs startingInputs: [Double]) throws -> [[Double]]
    {
        var inputs: [Double] = startingInputs
        var outputs: [[Double]] = [ ]
        
        for layer in self.layers
        {
            // create array for new outputs
            var currentLayerOutputs: [Double] = [ ]
            
            // for each neuron, compute the output
            for neuron in layer.neurons
            {
                let neuronOutput = try neuron.computeOutput(inputs)
                currentLayerOutputs.append(neuronOutput)
            }
            
            // add current layer outputs to outputs
            outputs.append(currentLayerOutputs)
            
            // update inputs for next iteration
            inputs = currentLayerOutputs
        }
        
        return outputs
    }
    
    private func computeErrors(inputs: [Double], outputs: [[Double]], desiredOutputs: [Double]) throws -> [[Double]]
    {
        // array to hold errors for each layer
        var layerErrors: [[Double]] = [ ]
        
        // compute output layer errors
        // output error = cost function derivative * activation function derivative = (desired - computed) * (computed * (1 - computed))
        var outputErrors: [Double] = [ ]
        for (neuronIndex, output) in outputs.last!.enumerate()
        {
            let desired = desiredOutputs[neuronIndex]
            let outputError = (desired - output) * sigmoid_derivative(output)
            
            outputErrors.append(outputError)
        }
        
        // add to output layer error to errors array
        layerErrors.insert(outputErrors, atIndex: 0)
        
        // compute hidden layer errors
        for layerIndex in (outputs.count - 2).stride(through: 0, by: -1)
        {
            var currentLayerErrors: [Double] = [ ]
            for neuronIndex in 0..<self.layers[layerIndex].neurons.count
            {
                var error: Double = 0
                
                // this looks tricky but really isn't. It's just getting the weights that go FROM the current neuron TO the next layer
                // it's not setup well (structurally), that's why this looks so hacky
                for (nextLayerNeuronIndex, weights) in self.layers[layerIndex + 1].getWeights().enumerate()
                {
                    error += weights[neuronIndex] * layerErrors[0][nextLayerNeuronIndex]
                }
                
                // compute error
                let output = outputs[layerIndex][neuronIndex]
                error *= sigmoid_derivative(output) * (1 - sigmoid_derivative(output))
                
                // add to this layers errors
                currentLayerErrors.append(error)
            }
            
            // add to errors array
            layerErrors.insert(currentLayerErrors, atIndex: 0)
        }
        
        return layerErrors
    }
    
    private func computeGradient(inputs: [Double], desiredOutputs: [Double]) throws -> [[BackpropagationValues]]
    {
        // compute all outputs
        var outputs = try forwardPropogate(inputs: inputs)
        
        // compute all errors
        let layerErrors = try computeErrors(inputs, outputs: outputs, desiredOutputs: desiredOutputs)
        
        // insert inputs into output layer
        outputs.insert(inputs, atIndex: 0)
        
        // represents the gradients of every weight for every neuron for every layer in the network
        /* structure:
            [
                // LAYER 1
                [
                    [ NEURON 1 GRADIENTS ],
                    [ NEURON 2 GRADIENTS ],
                    etc...
                ],

                // LAYER 2
                [
                    [ NEURON 1 GRADIENTS ],
                    [ NEURON 2 GRADIENTS ],
                    etc...
                ],

                etc...
            ]
        */
        var networkGradients: [[BackpropagationValues]] = [ ]
        
        // compute layers' neurons' decents
        for (layerIndex, errors) in layerErrors.enumerate()
        {
            let layer = self.layers[layerIndex]
            
            // represents the gradients of every weight for every neuron in this layer
            /* structure:
                [
                    [ NEURON 1 GRADIENTS],
                    [ NEURON 2 GRADIENTS],
                    etc...
                ]
            */
            var layerGradients: [BackpropagationValues] = [ ]
            
            // loop through each neuron
            for (neuronIndex, neuron) in layer.neurons.enumerate()
            {
                // get the error for this neuron
                let neuronError = errors[neuronIndex]
                
                // represents the gradients of every weight for this neuron
                /* structure:
                    [ WEIGHT 1 GRADIENT, WEIGHT 2 GRADIENT, etc... ]
                */
                var neuronGradients: [Double] = [ ]
                
                // go through each weight
                for weightIndex in 0..<neuron.weights.count
                {
                    // get the input for this weight
                    let inputToThisWeight = outputs[layerIndex][weightIndex]
                    
                    // calculate the gradient (error * the activation of the neuron pointing to this neuron of the previous layer)
                    // the activation is also the "input to this weight", which is easier for me to grasp, so that's what
                    // the variable will be anmed
                    let weightGradient = inputToThisWeight * neuronError
                    
                    // add to our neuron gradient array
                    neuronGradients.append(weightGradient)
                }
                
                // add this neuron to the layer gradients array
                layerGradients.append(BackpropagationValues(gradients: neuronGradients, neuronError: neuronError))
            }
            
            // add this layer to the network gradients array
            networkGradients.append(layerGradients)
        }
        
        return networkGradients
    }
    
    func train(inputs: [[Double]], desiredOutputs: [[Double]], learningRate: Double = 1) throws
    {
        // holds all the gradients
        // I know an array in an array in an array in an array is probably bad programming practice, but whatever
        // to comprehend what's happening here, see the "computeGradient" function's comments
        var allNetworkGradients: [[[BackpropagationValues]]] = [ ]
        
        // loop through ever "mini batch" (set of inputs with desired outputs)
        for miniBatchIndex in 0..<inputs.count
        {
            let batchInputs = inputs[miniBatchIndex]
            let batchDesiredOutputs = desiredOutputs[miniBatchIndex]
            
            let miniBatchNetworkGradient = try computeGradient(batchInputs, desiredOutputs: batchDesiredOutputs)
            allNetworkGradients.append(miniBatchNetworkGradient)
        }
        
        // start with the first batch
        var networkGradientsSums = allNetworkGradients[0]
        
        // loop through every batch
        for (networkIndex, networkGradients) in allNetworkGradients.enumerate()
        {
            // see if it's our first / last
            let firstNetwork = networkIndex == 0
            let lastNetwork = networkIndex == allNetworkGradients.count - 1
            
            // loop through each neuron / weight
            for (layerIndex, layerGradients) in networkGradients.enumerate()
            {
                for (neuronIndex, backpropValues) in layerGradients.enumerate()
                {
                    // if it's not the first network, add it to the sum
                    // (the first is already included)
                    if !firstNetwork
                    {
                        networkGradientsSums[layerIndex][neuronIndex].neuronError += backpropValues.neuronError
                    }
                    
                    // if it's the last network, update the bias
                    if lastNetwork
                    {
                        let averageError = networkGradientsSums[layerIndex][neuronIndex].neuronError / Double(layerGradients.count)
                        self.layers[layerIndex].neurons[neuronIndex].bias += learningRate * averageError
                    }
                    
                    // sum / update weight gradients
                    for (weightIndex, gradient) in backpropValues.gradients.enumerate()
                    {
                        // if it's not the first network, add it to the sum
                        // (the first is already included)
                        if !firstNetwork
                        {
                            networkGradientsSums[layerIndex][neuronIndex].gradients[weightIndex] += gradient
                        }
                        
                        // if this is the last network, update the weight
                        if lastNetwork
                        {
                            // compute the average (by dividing by the total number of networks)
                            let averageGradient = networkGradientsSums[layerIndex][neuronIndex].gradients[weightIndex] / Double(allNetworkGradients.count)
                            
                            // update the weight
                            self.layers[layerIndex].neurons[neuronIndex].weights[weightIndex] += learningRate * averageGradient
                        }
                    }
                }
            }
        }
    }
}

func sigmoid(input: Double) -> Double
{
    return 1 / (1 + exp(-input))
}

func sigmoid_derivative(input: Double) -> Double
{
    let sigmoidOuput = sigmoid(input)
    return sigmoidOuput - pow(sigmoidOuput, 2)
}