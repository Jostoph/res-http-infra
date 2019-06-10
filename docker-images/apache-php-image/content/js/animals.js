/**
 * @fileoverview This file uses JQuery to update dynamically
 * the content of <p class="animal">. It fetches the data
 * from an API
 * @author Rueff Christoph, Póvoa Tiago
 */
$(function() {
  console.log("Loading animals");

  function loadAnimals() {
    $.getJSON("/api/animals/", animals => {
      console.log(animals);

      let message = "No animal available";

      if (animals.length > 0) {
        let animal = animals[0];

        message = `Hello there! 
        I'm ${animal.name}, a ${animal.species}
        currently working as ${animal.profession}
        in ${animal.country}`;
      }
      $(".animal").text(message);
    });
  }

  loadAnimals();
  setInterval(loadAnimals, 6000);
  // Should get updated every 6 seconds
});

/*
    Here is an example of the payload
    we are loading with JQuery function getJSON

        "species": "Vaquita",
        "gender": "Male",
        "name": "Mr. Douglas Edwards",
        "profession": "Lead EEO Compliance Manager",
        "country": "Botswana"

*/
