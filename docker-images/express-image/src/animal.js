/**
 * @fileoverview The Class Animal lets you generate a random animal
 * having a species, name, gender, profession and country (using Chance.js)
 * @author Rueff Christoph, Póvoa Tiago
 */

const Chance = require("chance");
const chance = Chance();

class Animal {
  constructor() {
    this.species = chance.animal();
    this.gender = chance.gender();
    this.name = chance.name({ prefix: true, gender: this.gender });
    this.profession = chance.profession({ rank: true });
    this.country = chance.country({ full: true });
  }

  static generate() {
    let numberOfAnimals = chance.integer({
      min: 1,
      max: 10
    });

    let animals = [];

    for (let i = 0; i < numberOfAnimals; ++i) {
      animals.push(new Animal());
    }

    return animals;
  }
}

module.exports = {
  Animal
};
