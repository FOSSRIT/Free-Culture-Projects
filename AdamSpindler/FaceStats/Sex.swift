//
//  Sex.swift
//  BestColor
//
//  Created by Stevie Hetelekides on 9/15/15.
//  Copyright (c) 2015 Expetelek. All rights reserved.
//

import Foundation

class Genome : Comparable
{
    var fitness: Double = 0
    private(set) var weights: [Double]
    private(set) var inputs: Int?
    private(set) var outputs: Int?
    private(set) var hiddenLayers: Int?
    private(set) var neuronsPerHiddenLayer: Int?
    
    init(weights: [Double])
    {
        self.weights = weights
    }
    
    convenience init(inputs: Int, outputs: Int, hiddenLayers: Int, neuronsPerHiddenLayer: Int)
    {
        var numberOfWeights = 0
        var neuronsInPreviousLayer = inputs
        for _ in 0..<hiddenLayers
        {
            numberOfWeights += (neuronsPerHiddenLayer + 1) * (neuronsInPreviousLayer + 1)
            neuronsInPreviousLayer = neuronsPerHiddenLayer
        }
        
        numberOfWeights += (neuronsPerHiddenLayer + 1) * outputs
        
        self.init(numberOfWeights: numberOfWeights)
        
        self.inputs = inputs
        self.outputs = outputs
        self.hiddenLayers = hiddenLayers
        self.neuronsPerHiddenLayer = neuronsPerHiddenLayer
    }

    init(numberOfWeights: Int)
    {
        self.weights = [ ]
        
        for _ in 0..<numberOfWeights
        {
            self.weights.append(Double.random(min: -1, max: 1))
        }
    }
}

class Population
{
    var crossOverProbability: Double = 0.7
    var mutatationProbability: Double = 0.05
    var mutationAmount: Double = 10
    var fittestCopies = 1
    
    private(set) var generation: Int = 1
    private(set) var genomes: [Genome] = [ ]
    
    init(size: Int, numberOfWeightsPerGenome: Int)
    {
        for _ in 0..<size
        {
            // generate a new genome
            let genome = Genome(numberOfWeights: numberOfWeightsPerGenome)
            self.genomes.append(genome)
        }
    }
    
    init(genomes: [Genome])
    {
        self.genomes = genomes
    }
    
    func computeWorstAverageBest() -> (worst: Double, average: Double, best: Double)
    {
        var best: Double = 0
        var worst: Double = 0xFFFFFFFFFFFFFFFF
        var sum: Double = 0
        
        // calculate worst, best, average
        for genome in self.genomes
        {
            if genome.fitness < worst
            {
                worst = genome.fitness
            }
            
            if genome.fitness > best
            {
                best = genome.fitness
            }
            
            sum += genome.fitness
        }
        
        let average = sum / Double(self.genomes.count)
        return (worst, average, best)
    }
    
    private func rouletteSelectGenome() -> Genome
    {
        let maxFitness = self.genomes.maxElement()!.fitness
        
        while true
        {
            // generate threshold
            let randomIndex = Int.random(self.genomes.count)
            let threshold = self.genomes[randomIndex].fitness / maxFitness
            
            // if the random value is greater than the threshold, return
            if (Double.random() < threshold)
            {
                return self.genomes[randomIndex]
            }
        }
    }
    
    private func crossOver(parent1: Genome, parent2: Genome) -> [Genome]
    {
        // check pre conditions
        let sameParent = parent1 == parent2
        let amountOfWeightsDontMatch = parent1.weights.count != parent2.weights.count
        let shouldPerformCrossOver = Double.random() <= self.crossOverProbability
        
        if (sameParent || amountOfWeightsDontMatch || shouldPerformCrossOver)
        {
            return [ Genome(weights: parent1.weights), Genome(weights: parent2.weights) ]
        }
        
        // get number of weights (both parents are the same), get random point
        let numberOfWeights = parent1.weights.count
        let crossOverPoint = Int.random(min: 1, max: numberOfWeights - 1)
        
        // execute cross over
        var babies = [ Genome(numberOfWeights: numberOfWeights), Genome(numberOfWeights: numberOfWeights) ]
        for i in 0..<crossOverPoint
        {
            babies[0].weights[i] = parent1.weights[i]
            babies[1].weights[i] = parent2.weights[i]
        }
        
        for i in crossOverPoint..<numberOfWeights
        {
            babies[0].weights[i] = parent2.weights[i]
            babies[1].weights[i] = parent1.weights[i]
        }
        
        return babies
    }
    
    private func mutateGenome(genome: Genome)
    {
        for index in 0..<genome.weights.count
        {
            // see if we should mutate this chromosome
            if (Double.random() <= self.mutatationProbability)
            {
                // mutate it +- mutationAmount * random
                genome.weights[index] += Double.random(min: -1, max: 1) * self.mutationAmount
            }
        }
    }
    
    func mutatePopulation()
    {
        let originalGenomeCount = self.genomes.count
        
        // copy the fittest genome
        let fittestGenome = self.genomes.maxElement()!
        if fittestGenome.fitness == 0
        {
            let weightsPerGenome = self.genomes[0].weights.count
            self.genomes.removeAll(keepCapacity: true)
            
            for _ in 0..<originalGenomeCount
            {
                // generate a new genome
                let genome = Genome(numberOfWeights: weightsPerGenome)
                self.genomes.append(genome)
            }
            
            ++self.generation
        }
        else
        {
            for _ in 0..<self.fittestCopies
            {
                self.genomes.append(fittestGenome)
            }
            
            // create new genome
            var newGenomes: [Genome] = [ ]
            while newGenomes.count < originalGenomeCount
            {
                // select parents
                let parent1 = self.rouletteSelectGenome()
                let parent2 = self.rouletteSelectGenome()
                
                // make babies
                let babies = self.crossOver(parent1, parent2: parent2)
                
                // mutate babies
                self.mutateGenome(babies[0])
                self.mutateGenome(babies[1])
                
                newGenomes.append(babies[0])
                newGenomes.append(babies[1])
            }
            
            // update current genome
            self.genomes = newGenomes
            ++self.generation
        }
    }
}

func ==(left: Genome, right: Genome) -> Bool
{
    return left.fitness == right.fitness
}

func <=(left: Genome, right: Genome) -> Bool
{
    return left.fitness <= right.fitness
}

func >=(left: Genome, right: Genome) -> Bool
{
    return left.fitness >= right.fitness
}

func >(left: Genome, right: Genome) -> Bool
{
    return left.fitness > right.fitness
}

func <(left: Genome, right: Genome) -> Bool
{
    return left.fitness < right.fitness
}