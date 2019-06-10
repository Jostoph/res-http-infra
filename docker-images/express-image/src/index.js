/**
 * @fileoverview Entrypoint of an Express Application
 * @author Rueff Christoph, Póvoa Tiago
 */

const express = require("express");
const app = express();

const { Animal } = require("./animal");

/**
 * Route : /test
 */
app.get("/test", (req, res) => {
  res.send("Hello - test is working\n");
});

/**
 * Route : /
 * Send an array of randomly generated Animals
 */
app.get("/", (req, res) => {
  res.send(Animal.generate());
});

app.listen(80, () => {
  console.log("Accepting HTTP requests on port 80");
});
