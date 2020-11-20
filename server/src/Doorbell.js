const { Gpio } = require('onoff');

class Doorbell {
  constructor(options) {
    this.gpioPin = options.gpioPin;
    this.actions = options.actions;
    this.executeActions = this.executeActions.bind(this);
    this.clickTimeout = null;
  }

  executeActions() {
    this.clickTimeout = null;
    this.actions.forEach((action) => {
      action.execute();
    });
  }

  start() {
    this.gpio = new Gpio(this.gpioPin, 'in', 'rising', { debounceTimeout: 10 });
    this.gpio.watch(this.executeActions);
  }
}

module.exports = Doorbell;
